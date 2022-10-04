function fnMPC(block)
%% Run 2nd formulation of MPC to find Fpto which maximizes Force*Velocity

% Call the Setup Function
setup(block);

% Function: setup ===================================================
% Abstract:
%   Set up the S-function block's basic characteristics such as:
%   - Input ports
%   - Output ports
%   - Dialog parameters
%   - Options
% 
%   Required         : Yes
%   C-Mex counterpart: mdlInitializeSizes
%
function setup(block)

% Dynamically set port size using these globals
global mpc;
global wec;

  % Register the number of ports.
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 1;
  
  % Set up the port properties to be inherited or dynamic.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  
  % Fe Prediction
  block.InputPort(1).DatatypeID  = 0;  % double
  block.InputPort(1).Complexity  = 'Real';
  block.InputPort(1).Dimensions  = [wec.Slack*wec.numWECs*(1+mpc.HpInK)];
  
  % State matrix
  block.InputPort(2).DatatypeID  = 0;  % double
  block.InputPort(2).Complexity  = 'Real';
  block.InputPort(2).Dimensions  = [wec.numWECs*3*8+1 1];   
  
  % Output size set based on whether or not slack is on
  block.OutputPort(1).DatatypeID  = 0; % double
  block.OutputPort(1).Complexity  = 'Real';
  block.OutputPort(1).Dimensions  = [1]; % dFpto current (the one we use) 
  
  % Register the parameters.
  block.NumDialogPrms     = 0;     
  
  % Set up the continuous states.
  block.NumContStates = 0;

  % Register the sample times.
  %  [-1, 0]               : Inherited sample time
  block.SampleTimes = [-1 0];                           
  
  % -----------------------------------------------------------------
  % Options
  % -----------------------------------------------------------------
  % Specify if Accelerator should use TLC or call back to the 
  % MATLAB file
  block.SetAccelRunOnTLC(false);
  
  % Specify the block simStateCompliance. The allowed values are:
  %    'DefaultSimState', < Same SimState as a built-in block
  block.SimStateCompliance = 'DefaultSimState';
  
  % -----------------------------------------------------------------
  % The MATLAB S-function uses an internal registry for all
  % block methods. You should register all relevant methods
  % (optional and required) as illustrated below. You may choose
  % any suitable name for the methods and implement these methods
  % as local functions within the same file.
  %
  % Note from Mike: There were tons of these in the example file. I deleted
  % all but Outputs. Check the L2 example if you want all of them.
  %
  % -----------------------------------------------------------------
 
  % 
  % Outputs:
  %   Functionality    : Call to generate the block outputs during a
  %                      simulation step.
  %   C-Mex counterpart: mdlOutputs
  %
  block.RegBlockMethod('Outputs', @Outputs);
 
%endfunction

function Outputs(block)

%% This entire block is the setup and execution of MPC

global mpc;
global count;
global wec;
global prediction;

Sx = mpc.Sx;    % Coeff matrix for current state, x(k)
Su = mpc.Su;    % Coeff matrix for dFpto, u(k)
Sv = mpc.Sv;    % Coeff matrix for Fe, v(k)
Q = mpc.Q;
HpInK = mpc.HpInK;
x_k = block.InputPort(2).Data;
timeSamplesPerIteration = mpc.Ts/wec.dt;

v_arrow_k = block.InputPort(1).Data;



%% Create cost matrices for MPC objective function
H = mpc.H;
f = Su'*Q*(Sx*x_k+Sv*v_arrow_k);
mpc.f=f;
%% Setup slack variables
% To enable this to be parametric, we can sizeForSlack (i.e.,
% make the matrices huge) and then use either eye() or zeros() to
% effectively turn slack on or off, respectively
% If we just want to use the small matrices where the vector u solved for
% by MPC is just control action, we set sizeForSlack == no.
if strcmp(mpc.sizeForSlack,'yes') == 1 || strcmp(mpc.useSlackYN,'yes') == 1 % useSlackYN is here just in case sizeforslack is accidentally left set to no
    WuScale = mpc.WuScale;
    WyScale = mpc.WyScale;
    
    uSlackLength = (mpc.HpInK+1)*wec.numWECs; 
    ySlackLength = wec.yLen*mpc.HpInK*wec.numWECs; 
    
    if strcmp(mpc.useSlackYN,'yes') == 1
    %% Slack on U and Y
    H = [...
        H,zeros(uSlackLength,uSlackLength), zeros(uSlackLength,ySlackLength); ...
        zeros(uSlackLength,uSlackLength),WuScale*eye(uSlackLength), zeros(uSlackLength,ySlackLength); ...
        zeros(ySlackLength,uSlackLength), zeros(ySlackLength,uSlackLength), WyScale*eye(ySlackLength); ...
        ];

    elseif strcmp(mpc.useSlackYN,'no') == 1
         % Slack OFF by setting eye to zeros here AND in A
         H = [...
             H,zeros(uSlackLength,uSlackLength), zeros(uSlackLength,ySlackLength); ...
             zeros(uSlackLength,uSlackLength),WuScale*zeros(uSlackLength), zeros(uSlackLength,ySlackLength); ...
             zeros(ySlackLength,uSlackLength), zeros(ySlackLength,uSlackLength), WyScale*zeros(ySlackLength); ...
             ];
    end
    
    f = [...
    f; ...
    zeros(uSlackLength,1); ...
    zeros(ySlackLength,1); ...
    ];

end

%% Hessian check for convex solver after slack augmentation
if issymmetric(H) == 0
    H_Memory = H;
    checkH=(H+H')/2;
    if abs(H-H_Memory) < 1e-15
        %display('H was symetric to within a 1e-15 tolerance');
        H=(H+H')/2;
    else 
        hello = 1;
    end
end

if all(eig(H) >= 0) == 0
    eig(checkH)
    issymmetric(checkH)
    display('PSD Condition violated on checkH!')
end



%% Create constraint matrices for MPC

I = eye(mpc.HpInK+1);%length of prediction horizon
Zero = zeros(mpc.HpInK+1);

% Create y_max vector [dZb,max; Zb,max; Fpto,max] to Hp
iterationCounter = 1;
for i = 1:1:((HpInK)*wec.yLen*wec.numWECs)

   % Single pod
         if iterationCounter == 1
            y_arrow_upperbound(i,1) = mpc.vMax;
         elseif iterationCounter == 2
            y_arrow_upperbound(i,1) = mpc.zMax;
         elseif iterationCounter == 3 
             y_arrow_upperbound(i,1) = mpc.vMax;
         elseif iterationCounter == 4
            y_arrow_upperbound(i,1) = mpc.zMax;    
         elseif iterationCounter == 5
            y_arrow_upperbound(i,1) = mpc.FptoMax;
         end
    
    iterationCounter = iterationCounter + 1;
    if mod(i,wec.yLen*wec.numWECs) == 0
        iterationCounter = 1;
    end
end

% Simple dFpto max
u_arrow_upperbound = mpc.dFptoMax*ones((HpInK+1)*wec.numWECs,1); % dFpto upper limit

% REACTIVE POWER LIMIT: Determine the sign to limit the velocity at k+1
% based on what it is here at time k
if x_k(1) >= 0
    signOfReactivePowerLimit = -1; % If v is pos, Fpto must be negative
else 
    signOfReactivePowerLimit = 1;
end
mpc.y_arrow_upperbound = y_arrow_upperbound;

%% Same as we did for H/f, now need to size A/B to make parametric
if strcmp(mpc.sizeForSlack,'yes') == 1 || strcmp(mpc.useSlackYN,'yes') == 1
    if strcmp(mpc.useSlackYN,'yes') == 1
        
        % Constrain FULL with SLACK on U and Y
        A = [...
            I, -I,  zeros(uSlackLength,ySlackLength); ...
            -I, -I, zeros(uSlackLength,ySlackLength); ...
            Zero, -I, zeros(uSlackLength,ySlackLength); ...
            zeros(ySlackLength,uSlackLength), zeros(ySlackLength,uSlackLength), -eye(ySlackLength); ...
            Su, zeros(ySlackLength,uSlackLength), -eye(ySlackLength); ...
            -Su, zeros(ySlackLength,uSlackLength), -eye(ySlackLength); ...           
            ];
    elseif strcmp(mpc.useSlackYN,'no') == 1
         % Slack OFF by setting eye to zeros here and in H
         % This didn't seem neccessary, but after testing it I found that
         % it is
          A = [...
             I, zeros(uSlackLength,uSlackLength),  zeros(uSlackLength,ySlackLength); ...
             -I, zeros(uSlackLength,uSlackLength), zeros(uSlackLength,ySlackLength); ...
             Zero, -I, zeros(uSlackLength,ySlackLength); ...
             zeros(ySlackLength,uSlackLength), zeros(ySlackLength,uSlackLength), -eye(ySlackLength); ...
             Su, zeros(ySlackLength,uSlackLength), -zeros(ySlackLength); ...
             -Su, zeros(ySlackLength,uSlackLength), zeros(ySlackLength); ...           
             ];
    end
 
    B = [...
        u_arrow_upperbound; ...
        u_arrow_upperbound; ...
        zeros(uSlackLength,1); ...
        zeros(ySlackLength,1); ...
        y_arrow_upperbound-Sx*x_k-Sv*v_arrow_k; ...
        y_arrow_upperbound+Sx*x_k+Sv*v_arrow_k; ...
        ];

else 
    % Constrain FULL
    A = [...
        I; ...
        -I; ...
        Su; ...
        -Su; ...
        ];

    B = [...
        u_arrow_upperbound; ...
        u_arrow_upperbound; ...
        y_arrow_upperbound-Sx*x_k-Sv*v_arrow_k; ...
        y_arrow_upperbound+Sx*x_k+Sv*v_arrow_k];
end


%% Save actual H & A after dealing w/ slack if/else statements
mpc.H_used = H;
mpc.A_used = A;
mpc.B_used = B;
mpc.I_used = I;


%% Run quadprog

if mpc.CurrentIteration > prediction.Ho + prediction.order % Only run MPC after buffer is full, otherwise Fe predictions are not accurate
    options = optimoptions('quadprog','Algorithm','interior-point-convex','Display','off', 'MaxIter', 600); % Can't set x0 w/ interior-point-convex 
    [dFpto_cmd,FVAL,EXITFLAG, OUTPUT] = quadprog(H,f,A,B,[],[],[],[],[],options);
    if all(eig(H) >= 0) == 0
        eig(H)
        issymmetric(H)
        display('PSD Condition violated on H!')
    end
    if (EXITFLAG ~= 1) && (EXITFLAG ~= 2)
        display('!!!!!!!!!!!!!!!! START ERROR - Infeasible !!!!!!!!!!!!')
        EXITFLAG    % Display exit flag
        OUTPUT      % Display output - detailed info from this solution attempt
        OUTPUT.message
        dFpto_cmd = zeros(mpc.outputSize,1);
        TimeOfError = mpc.CurrentIteration*timeSamplesPerIteration % Show the time at which this happened
        count.Infeasible = count.Infeasible+1 % Keep track of how many times we couldn't get a solution
        totalRuns = mpc.CurrentIteration % Show how many iterations have run (to compare with the # of errors, above)
        display('-------------------END ERROR -  Infeasible -------------------')
    end

else
    dFpto_cmd = zeros(mpc.outputSize,1);
end


mpc.dFpto_cmd=dFpto_cmd;
block.OutputPort(1).Data = dFpto_cmd(1);
%display('end of iter');
mpc.CurrentIteration;
mpc.CurrentIteration = mpc.CurrentIteration + 1; 
%endfunction




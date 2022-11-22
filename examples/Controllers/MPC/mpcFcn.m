function mpcFcn(block)
%% Run 2nd formulation of mpcStruct to find Fpto which maximizes Force*Velocity

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
global mpcStruct;

  % Register the number of ports.
  block.NumInputPorts  = 2;
  block.NumOutputPorts = 1;
  
  % Set up the port properties to be inherited or dynamic.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  
    % State matrix
  block.InputPort(1).DatatypeID  = 0;  % double
  block.InputPort(1).Complexity  = 'Real';
  block.InputPort(1).Dimensions  = [8+1 1];   

  % Fe Prediction
  block.InputPort(2).DatatypeID  = 0;  % double
  block.InputPort(2).Complexity  = 'Real';
  block.InputPort(2).Dimensions  = [(1+mpcStruct.MPCSetup.HpInk)];
  
  % Output size set 
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

global mpcStruct;

% This entire block is the setup and execution of mpcStruct

Sx = mpcStruct.MPCSetup.Sx;    % Coeff matrix for current state, x(k)
Su = mpcStruct.MPCSetup.Su;    % Coeff matrix for dFpto, u(k)
Sv = mpcStruct.MPCSetup.Sv;    % Coeff matrix for Fe, v(k)
Q = mpcStruct.MPCSetup.Q;
HpInK = mpcStruct.MPCSetup.HpInk;
x_k = block.InputPort(1).Data;

v_arrow_k = block.InputPort(2).Data;

%% Create cost matrices for mpcStructStruct objective function
H = mpcStruct.MPCSetup.H;
f = Su'*Q*(Sx*x_k+Sv*v_arrow_k);
%mpcStruct.f=f;

%% Hessian check for convex solver 
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



%% Create constraint matrices for mpcStruct

I = eye(mpcStruct.MPCSetup.HpInk+1);%length of prediction horizon
Zero = zeros(mpcStruct.MPCSetup.HpInk+1);

% Create y_max vector [dZb,max; Zb,max; Fpto,max] to Hp
iterationCounter = 1;
for i = 1:1:((HpInK)*mpcStruct.modelPredictiveControl.yLen)

   % Single pod
         if iterationCounter == 1
            y_arrow_upperbound(i,1) = mpcStruct.modelPredictiveControl.maxVel;
         elseif iterationCounter == 2
            y_arrow_upperbound(i,1) = mpcStruct.modelPredictiveControl.maxPos;
         elseif iterationCounter == 3
            y_arrow_upperbound(i,1) = mpcStruct.modelPredictiveControl.maxPTOForce;
         end
    
    iterationCounter = iterationCounter + 1;
    if mod(i,mpcStruct.modelPredictiveControl.yLen) == 0
        iterationCounter = 1;
    end
end

% Simple dFpto max
u_arrow_upperbound = mpcStruct.modelPredictiveControl.maxPTOForceChange*ones(HpInK+1,1); % dFpto upper limit

% REACTIVE POWER LIMIT: Determine the sign to limit the velocity at k+1
% based on what it is here at time k
if x_k(1) >= 0
    signOfReactivePowerLimit = -1; % If v is pos, Fpto must be negative
else 
    signOfReactivePowerLimit = 1;
end
%mpcStruct.y_arrow_upperbound = y_arrow_upperbound;

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


%% Run quadprog

if mpcStruct.MPCSetup.currentIteration > mpcStruct.modelPredictiveControl.Ho + mpcStruct.modelPredictiveControl.order % Only run mpcStruct after buffer is full, otherwise Fe predictions are not accurate
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
        dFpto_cmd = zeros(mpcStruct.MPCSetup.outputSize,1);
        TimeOfError = mpcStruct.MPCSetup.currentIteration*mpcStruct.MPCSetup.timeSamplesPerIteration % Show the time at which this happened
        mpcStruct.MPCSetup.infeasibleCount = mpcStruct.MPCSetup.infeasibleCount+1 % Keep track of how many times we couldn't get a solution
        totalRuns = mpcStruct.MPCSetup.currentIteration % Show how many iterations have run (to compare with the # of errors, above)
        display('-------------------END ERROR -  Infeasible -------------------')
    end

else
    dFpto_cmd = zeros(mpcStruct.MPCSetup.outputSize,1);
end


%mpcStruct.dFpto_cmd=dFpto_cmd;
block.OutputPort(1).Data = dFpto_cmd(1);
%display('end of iter');
mpcStruct.MPCSetup.currentIteration;
mpcStruct.MPCSetup.currentIteration = mpcStruct.MPCSetup.currentIteration + 1; 
%endfunction




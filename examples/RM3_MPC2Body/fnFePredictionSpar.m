function fnFePredictionSpar(block)
%% Purpose: Prediction excitation force Fe from previous data

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
  global prediction;
  global wec;

  % Register the number of ports.
  block.NumInputPorts  = wec.numWECs;
  block.NumOutputPorts = 1;
  
  % Set up the port properties to be inherited or dynamic.
  block.SetPreCompInpPortInfoToDynamic;
  block.SetPreCompOutPortInfoToDynamic;
  
  for i = 1:wec.numWECs
     % Fe history for Pod 1
    block.InputPort(i).DatatypeID  = 0;  % double
    block.InputPort(i).Complexity  = 'Real';
    block.InputPort(i).Dimensions  = [1+prediction.order+prediction.Ho, 1];
  end
  
  % Override the output port properties.
  block.OutputPort(1).DatatypeID  = 0; % double
  block.OutputPort(1).Complexity  = 'Real';
  block.OutputPort(1).Dimensions  = [wec.numWECs*(1+mpc.HpInK)]; % Fe current to HpInK 

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
  % Specify if Accelerator sprediction.Hould use TLC or call back to the 
  % MATLAB file
  block.SetAccelRunOnTLC(false);
  
  % Specify the block simStateCompliance. The allowed values are:
  %    'DefaultSimState', < Same SimState as a built-in block
  block.SimStateCompliance = 'DefaultSimState';
  
  % -----------------------------------------------------------------
  % The MATLAB S-function uses an internal registry for all
  % block metprediction.Hods. You sprediction.Hould register all relevant metprediction.Hods
  % (optional and required) as illustrated below. You may cprediction.Hoose
  % any suitable name for the metprediction.Hods and implement these metprediction.Hods
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
global mpc;
global prediction;
global wec;
HpInK =mpc.HpInK;

pastAndCurrentFe = block.InputPort(1).Data;

% For single OR multipod, do Fe prediction one at a time and then combine
% later
for i = 1:wec.numWECs
    
    %% ADAPATIVE LEAST SQUARES LINEAR REGRESSION to calculate Alphas
    % Build matrices row by row in for loop, then feed to matlab function to
    % get linear alpha coefficients (the "B" matrix in Matlab's regression)

    for h = 0:prediction.Ho                                      % Each loop builds a row to Hp+1 total rows   %100
        Y(h+1,1) = pastAndCurrentFe(end-h);                              % Y Matrix: Fe(k) to Fe(K-h)
        X(h+1,:) = fliplr(pastAndCurrentFe(end-h-4:end-h-1)');
        %X(h+1,:) = fliplr(pastAndCurrentFe(end-h-prediction.order:end-h-1)'); % X Matrix: Ho-1 rows, prediction.order columns
    end
    
    alphas = regress(Y,X);

    %% FE PREDICTION using single set of alpha values
    % Fe(k+1|k) = alpha1*Fe(k) + alpha2*Fe(K-1),
    % Fe(k+2|k) = alpha1*Fe(k+1|k) + alpha2*Fe(K) ...
    % Have to build the pastCurrentAndFuture to accomodate that

    pastCurrentAndFuture = pastAndCurrentFe;
    indexForCurrentFe = size(pastCurrentAndFuture,1);

    for h = 1:HpInK  
    %for h = 1:mpc.HpSeconds/est.Ts     % Used if trying to run prediction @ %est.Ts instead of mpc.Ts
       pastCurrentAndFuture(indexForCurrentFe+h) = 0;                              
        for j = 1:prediction.order  
           pastCurrentAndFuture(indexForCurrentFe+h) = pastCurrentAndFuture(indexForCurrentFe+h) + alphas(j)*pastCurrentAndFuture(indexForCurrentFe+h-j); 
        end
    end

    currentAndFutureFe(:,i) = pastCurrentAndFuture(indexForCurrentFe:end); % Current = currentAndFutureFe(1). Biggest prediction = currentAndFutureFe(end)
    %currentAndFutureFe = pastCurrentAndFuture(indexForCurrentFe:mpc.Ts/est.Ts:end); % Used if trying to run prediction @ %est.Ts instead of mpc.Ts
end


block.OutputPort(1).Data = currentAndFutureFe;
%endfunction

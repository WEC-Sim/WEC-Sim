%% Declare Global Variables



global mpc;
global wec;
global prediction;
%global plant;
global count;

%% WEC Variables
%wec.numWECs = 1;                  % number of WECs (i.e., RM3 has a float and spar but it is one WEC.)
%wec.dt = simu.dt;
wec.yLen = 5;                     % yLen is the output length. For example, y = [z_dot_float, z_float, z_dot_spar, z_spar, Fpto]';
%wec.Slack = 2;                    % u_slack and y_slack


%% MPC Variables
%mpc.FptoMax = 4e6;                % Max PTO force
%mpc.dFptoMax = 1.5e6;             % Max rate of change of PTO force
%mpc.vMax = 1.5;                   % Max buoy velocity (pos & neg)
%mpc.zMax = 1;                   % Max buoy position (pos & neg)
%mpc.HpSeconds = 20;               % Prediction horizon in seconds
%mpc.Ts = 0.5;                     % MPC time step  
%mpc.HpInK = mpc.HpSeconds/mpc.Ts; % Number of prediction in discrete domain
%mpc.RScale =1e-7;                 % r=-(min(eig(mpc.Su'*mpc.Q*mpc.Su)))
%mpc.QScale = 0.5*mpc.Ts;
%mpc.sizeForSlack = 'no';          % 'yes' = expand H & A to use slack regardless of whether or not it's used. 'no' = use small matrices, no slack
%mpc.useSlackYN = 'no';            % 'yes' = soft constraints are used. 'no' = hard constraints are used
%mpc.WuScale = 2e-7;%1e-4;%1e2;    % If using slack, Wu places cost on exceeding constraint on control input u   
%mpc.WyScale = 2e-7;%1e-4;%1e2;    % If using slack, Wy places cost on exceeding constraint on states in y vector (dZ/Z/Fpto)
currentIteration = 1;         % Used to find starting point when cheating to find future Fe


%% Feasibility Study
innfeasibleCount = 0;                               % Tracks # of occurances of non-convergence      
count.numSamplesInEntireRun = simu.endTime/wec.dt;  % Total number of SIM iterations (not neccesarily MPC iterations)


%% Prediction
prediction.Ho = 100;
prediction.order = 4;
prediction.SimTimeToFullBuffer = (prediction.order+prediction.Ho)*mpc.Ts/wec.dt;  % 0.1 is the simulation time step


%% Curve Fitting

body(1).setNumber(1);
tmp_hydroData = readBEMIOH5(body(1).h5File, body(1).number, body(1).meanDrift);
body(1).loadHydroData(tmp_hydroData);

wec.AFloat = squeeze(body.hydroData.hydro_coeffs.added_mass.all(3,3,:)).*simu.rho;
wec.AinfFloat = body.hydroData.hydro_coeffs.added_mass.inf_freq(3,3)*simu.rho;
wec.mFloat = body.hydroData.properties.volume*simu.rho*simu.gravity;
wec.kFloat = body.hydroData.hydro_coeffs.linear_restoring_stiffness(3,3)*simu.rho*simu.gravity; 
wec.bFloat = squeeze(body.hydroData.hydro_coeffs.radiation_damping.all(3,3,:)).*simu.rho.*body.hydroData.simulation_parameters.w';

%% Pre Plant Model

[preDelta] = fnMakePlantAndPreDeltaModel(wec);


%% Plant Model
%plant.sys_c = ss(plant.A,[plant.Bu plant.Bv],plant.C,[plant.Du plant.Dv]); % still continuous


%% MPC
%[mpc.Sx,mpc.Su,mpc.Sv, mpc.Q, mpc.R] = fnMakePredictiveModel(plant.sys_c, mpc, wec); % Discretizes CT SS object and computes Sx, Su, & Sv. Wrapped up under shared global mpc for ease of access in L2 simulink block
%mpc.H = mpc.Su'*mpc.Q*mpc.Su+mpc.R;


%% Hard and Soft Contraints Option
if strcmp(mpc.sizeForSlack,'yes') == 1 || strcmp(mpc.useSlackYN,'yes') == 1
    mpc.outputSize = wec.Slack*wec.numWECs*(mpc.HpInK+1)+wec.numWECs*wec.yLen*(mpc.HpInK); 
else 
    mpc.outputSize = (mpc.HpInK+1)*wec.numWECs;
end
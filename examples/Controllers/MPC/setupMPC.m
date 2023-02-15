% This method sets up the variables to run model predictive control 

% Load hydrodynamic data for float from BEM
hydro = readBEMIOH5(body.h5File, 1, body.meanDrift);

disp('setting up MPC')
controller(1).bemData.a = squeeze(hydro.hydro_coeffs.added_mass.all(3,3,:)).*simu.rho;
controller(1).bemData.aInf = hydro.hydro_coeffs.added_mass.inf_freq(3,3)*simu.rho;
controller(1).bemData.m = hydro.properties.volume*1000;
controller(1).bemData.k = hydro.hydro_coeffs.linear_restoring_stiffness(3,3)*simu.rho*simu.gravity; 
controller(1).bemData.b = squeeze(hydro.hydro_coeffs.radiation_damping.all(3,3,:)).*simu.rho.*hydro.simulation_parameters.w';
controller(1).MPCSetup.HpInk = controller(1).modelPredictiveControl.predictionHorizon/controller(1).modelPredictiveControl.dt;
controller(1).MPCSetup.qScale = 0.5*controller(1).modelPredictiveControl.dt;
controller(1).MPCSetup.currentIteration = 0;
controller(1).MPCSetup.infeasibleCount = 0;

% Tracks # of occurances of non-convergence      
controller(1).MPCSetup.numSamplesInEntireRun = simu.endTime/simu.dt;  % Total number of SIM iterations (not neccesarily MPC iterations)
controller(1).MPCSetup.timeSamplesPerIteration = controller(1).modelPredictiveControl.dt/simu.dt;

% Prediction Start
controller(1).MPCSetup.SimTimeToFullBuffer = (controller(1).modelPredictiveControl.order+controller(1).modelPredictiveControl.Ho)*controller(1).modelPredictiveControl.dt/simu.dt;  % 0.1 is the simulation time step

load(controller(1).modelPredictiveControl.coeffFile);

% Make Plant Model    
run(controller(1).modelPredictiveControl.plantFile);
controller(1).plant.sys_c = ss(controller(1).plant.A,[controller(1).plant.Bu controller(1).plant.Bv],controller(1).plant.C,[controller(1).plant.Du controller(1).plant.Dv]); % still continuous

% Make predictive model for quadratic programming
run(controller(1).modelPredictiveControl.predictFile); % Discretizes CT SS object and computes Sx, Su, & Sv. Wrapped up under shared global mpc for ease of access in L2 simulink block
controller(1).MPCSetup.H = controller(1).MPCSetup.Su'*controller(1).MPCSetup.Q*controller(1).MPCSetup.Su + controller(1).MPCSetup.R;

if all(eig(controller(1).MPCSetup.H) >= 0) == 0
    eig(controller(1).MPCSetup.H);
    error('PSD Violated')
end

% Set output size
controller(1).MPCSetup.outputSize = (controller(1).MPCSetup.HpInk+1)*1;
%% Compressible Fluid Hydraulic PTO-Sim

ptosim = ptoSimClass('Compressible Fluid Hydraulic');

%% Valve 

ptosim.checkValve.Cd = 0.61;                                                % Discharge coefficient 
ptosim.checkValve.Amax = 0.002;                                             % Maximum valve area [m^2]
ptosim.checkValve.Amin = 1e-8;                                              % Minimum valve area [m^2]
ptosim.checkValve.pMax = 1.5e6;                                             % Maximum pressure difference across the valve [Pa]   
ptosim.checkValve.pMin = 0; % or 0.75*ptosim.checkValve.pMax 
ptosim.checkValve.rho = 850;                                                % Hydraulic fluid density [kg/m^3]
ptosim.checkValve.k1 = 200;

ptosim.checkValve.k2 = ...
    atanh((ptosim.checkValve.Amin-(ptosim.checkValve.Amax-ptosim.checkValve.Amin)/2)*...
    2/(ptosim.checkValve.Amax - ptosim.checkValve.Amin))*...
    1/(ptosim.checkValve.pMin-(ptosim.checkValve.pMax + ptosim.checkValve.pMin)/2);  


%% Low Pressure Accumulator

ptosim.accumulator(2).VI0 = 6;                                                           % Initial volume [m^3]
ptosim.accumulator(2).pIrated = 16e6;                                                    % Rated working pressure
ptosim.accumulator(2).pIupper_limit = (4/3)*ptosim.accumulator(2).pIrated;               % Upper working pressure
ptosim.accumulator(2).pIlower_limit = (0.5)*ptosim.accumulator(2).pIupper_limit;         % Lower working pressure
ptosim.accumulator(2).pIprecharge = 0.9*ptosim.accumulator(2).pIlower_limit;             % Precharge pressure
ptosim.accumulator(2).VImax = ptosim.accumulator(2).VI0*(1-(ptosim.accumulator(2).pIprecharge/ptosim.accumulator(2).pIupper_limit)^(1/1.4));
ptosim.accumulator(2).VImin = ptosim.accumulator(2).VI0*(1-(ptosim.accumulator(2).pIprecharge/ptosim.accumulator(2).pIlower_limit)^(1/1.4));
ptosim.accumulator(2).VIeq = ptosim.accumulator(2).VImax;
ptosim.accumulator(2).pIeq = ptosim.accumulator(2).pIprecharge/(1-ptosim.accumulator(2).VIeq/ptosim.accumulator(2).VI0)^(1.4);


%% High Pressure Accumulator

ptosim.accumulator(1).VI0 = 8.5;                                                                   % Initial volume                          
ptosim.accumulator(1).del_p_r = 15e6;                                         
ptosim.accumulator(1).pIrated = ptosim.accumulator(1).del_p_r + ptosim.accumulator(2).pIrated;     % Rated working pressure
ptosim.accumulator(1).pIeq = ptosim.accumulator(2).pIeq;
ptosim.accumulator(1).pIlower_limit = ptosim.accumulator(1).pIeq;
ptosim.accumulator(1).pIupper_limit = 1.5*ptosim.accumulator(1).pIlower_limit;
ptosim.accumulator(1).pIprecharge = 0.9*ptosim.accumulator(1).pIlower_limit;
ptosim.accumulator(1).VIeq = ptosim.accumulator(1).VI0*(1-(ptosim.accumulator(1).pIprecharge/ptosim.accumulator(1).pIeq)^(1/1.4));
ptosim.accumulator(1).VImax = ptosim.accumulator(1).VI0*(1-(ptosim.accumulator(1).pIprecharge/ptosim.accumulator(1).pIupper_limit)^(1/1.4));
ptosim.accumulator(1).VImin = ptosim.accumulator(1).VI0*(1-(ptosim.accumulator(1).pIprecharge/ptosim.accumulator(1).pIlower_limit)^(1/1.4));



%% Piston 

ptosim.pistonCF.Ap = 0.0378;                                                 % Piston area [m^2]           
ptosim.pistonCF.Vo = 15*ptosim.pistonCF.Ap;                                  % Piston volume [m^3]   
ptosim.pistonCF.Beta_e = 1.86e9;                                             % Effective bulk modulus [Pa]
ptosim.pistonCF.pAi = ptosim.accumulator(2).pIupper_limit;
ptosim.pistonCF.pBi = ptosim.pistonCF.pAi;


%% Hydraulic Motor

ptosim.hydraulicMotor.angVelInit = 0;                                        % Initial speed
ptosim.hydraulicMotor.J = 20;                                                % Total moment of inertia (motor & generator) [kg-m^2]
ptosim.hydraulicMotor.fric = 0.05;                                           % Fricton [kg-m^2/s]


%% Lookup Table Generator

load motorEff;
ptosim.rotaryGenerator.table = table;
ptosim.rotaryGenerator.TgenBase = 2000;                     
ptosim.rotaryGenerator.omegaBase = 300;
ptosim.rotaryGenerator.driveEff = 0.98;
ptosim.rotaryGenerator.desiredSpeed = 150;                                  % Angular velocity [rad/s]


%% Rotary to Linear Adjustable Rod

ptosim.motionMechanism.crank = 3;
ptosim.motionMechanism.offset = 1.3;
ptosim.motionMechanism.rodInit = 5;


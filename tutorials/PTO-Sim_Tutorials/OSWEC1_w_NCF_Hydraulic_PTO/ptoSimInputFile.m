%% Non-Compressible Fluid Hydraulic PTO-Sim

ptosim = ptoSimClass('Non-Compressible Fluid Hydraulic');

%% Piston 

ptosim.pistonNCF.topA = 0.0378;                                                      % Top piston area [m^2]
ptosim.pistonNCF.botA = 0.0378;                                                      % Bottom piston area [m^2]


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


%% Hydraulic Motor

ptosim.hydraulicMotor.angVelInit = 0;                       % Initial speed
ptosim.hydraulicMotor.J = 20;                               % Total moment of inertia (motor & generator) [kg-m^2]
ptosim.hydraulicMotor.fric = 0.05;                          % Fricton [kg-m^2/s]


%% Lookup Table Generator

load motorEff;
ptosim.rotaryGenerator.table = table;
ptosim.rotaryGenerator.TgenBase = 2000;                     
ptosim.rotaryGenerator.omegaBase = 300;
ptosim.rotaryGenerator.driveEff = 0.98;
ptosim.rotaryGenerator.desiredSpeed = 150;                                  % Angular velocity [rad/s]


%% Rotary to Linear Crank

ptosim.motionMechanism.crank = 3;
ptosim.motionMechanism.offset = 1.3;
ptosim.motionMechanism.rodLength = 5;


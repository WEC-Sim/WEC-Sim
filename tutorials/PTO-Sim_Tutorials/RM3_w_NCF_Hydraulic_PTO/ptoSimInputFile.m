%% Simple Hydraulic (Noncompressible option)

ptosim = ptoSimClass('Compressible Fluid Hydraulic');

%% Piston 

ptosim.pistonNCF.topA = 0.0378;    % Top piston area [m^2]
ptosim.pistonNCF.botA = 0.0378;    % Bottom piston area [m^2]


%% Low Pressure Accumulator

ptosim.accummulator(2).VI0 = 6;                                    
ptosim.accummulator(2).pIrated = 16e6;                                             % Rated working pressure
ptosim.accummulator(2).pIupper_limit = (4/3)*ptosim.accummulator(2).pIrated;              % Upper working pressure
ptosim.accummulator(2).pIlower_limit = (0.5)*ptosim.accummulator(2).pIupper_limit;        % Lower working pressure
ptosim.accummulator(2).pIprecharge = 0.9*ptosim.accummulator(2).pIlower_limit;            % Precharge pressure
ptosim.accummulator(2).VImax = ptosim.accummulator(2).VI0*(1-(ptosim.accummulator(2).pIprecharge/ptosim.accummulator(2).pIupper_limit)^(1/1.4));
ptosim.accummulator(2).VImin = ptosim.accummulator(2).VI0*(1-(ptosim.accummulator(2).pIprecharge/ptosim.accummulator(2).pIlower_limit)^(1/1.4));
ptosim.accummulator(2).VIeq = ptosim.accummulator(2).VImax;
ptosim.accummulator(2).pIeq = ptosim.accummulator(2).pIprecharge/(1-ptosim.accummulator(2).VIeq/ptosim.accummulator(2).VI0)^(1.4);


%% High Pressure Accumulator

ptosim.accummulator(1).VI0 = 8.5;                                 
ptosim.accummulator(1).del_p_r = 15e6;
ptosim.accummulator(1).pIrated = ptosim.accummulator(1).del_p_r + ptosim.accummulator(2).pIrated;
ptosim.accummulator(1).pIeq = ptosim.accummulator(2).pIeq;
ptosim.accummulator(1).pIlower_limit = ptosim.accummulator(1).pIeq;
ptosim.accummulator(1).pIupper_limit = 1.5*ptosim.accummulator(1).pIlower_limit;
ptosim.accummulator(1).pIprecharge = 0.9*ptosim.accummulator(1).pIlower_limit;
ptosim.accummulator(1).VIeq = ptosim.accummulator(1).VI0*(1-(ptosim.accummulator(1).pIprecharge/ptosim.accummulator(1).pIeq)^(1/1.4));
ptosim.accummulator(1).VImax = ptosim.accummulator(1).VI0*(1-(ptosim.accummulator(1).pIprecharge/ptosim.accummulator(1).pIupper_limit)^(1/1.4));
ptosim.accummulator(1).VImin = ptosim.accummulator(1).VI0*(1-(ptosim.accummulator(1).pIprecharge/ptosim.accummulator(1).pIlower_limit)^(1/1.4));


%% Hydraulic Motor

ptosim.hydraulicMotor.angVelInit = 0;
ptosim.hydraulicMotor.alpha = 1;
ptosim.hydraulicMotor.D = 0.6*1.28e-4;
ptosim.hydraulicMotor.J = 20;
ptosim.hydraulicMotor.bg = 3;%8;
ptosim.hydraulicMotor.bf = 0.05*ptosim.hydraulicMotor.bg;


%% Lookup Table Generator

ptosim.rotaryGenerator.TgenBase = 2000;
ptosim.rotaryGenerator.omegaBase = 251.3;
ptosim.rotaryGenerator.driveEff = 0.98;
load motorEff;
ptosim.rotaryGenerator.table = table;




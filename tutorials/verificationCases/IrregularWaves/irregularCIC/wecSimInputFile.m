%% Simulation Data
simu = simulationClass();               %Create the Simulation Variable
simu.simMechanicsFile = 'RM3.slx';      %Location of Simulink Model File
simu.endTime=200;                       %Simulation End Time [s]
simu.dt = 0.1;                          %Simulation Time-Step [s]
simu.rampT = 100;                       %Wave Ramp Time Length [s]
%simu.mode='rapid-accelerator';
simu.explorer = 'off';
simu.CITime = 20

%% Wave Information
%Regular Waves
% waves = waveClass('regular');
%                                  %Create the Wave Variable and Specify Type
% waves.H = 2.5;                          %Wave Height [m]
% waves.T = 8;                            %Wave Period [s]

% %Irregular Waves using PM Spectrum with Convolution Integral Calculation
% waves = waveClass('irregular');
%                                %Create the Wave Variable and Specify Type
% waves.H = 2.5;                        %Significant Wave Height [m]
% waves.T = 8;                          %Peak Period [s]
% waves.spectrumType = 'PM';

%Irregular Waves using BS Spectrum with State Space Calculation
waves = waveClass('irregular');
                               %Create the Wave Variable and Specify Type
waves.H = 2.5;                        %Significant Wave Height [m]
waves.T = 8;                          %Peak Period [s]
waves.spectrumType = 'BS';
waves.randPreDefined = 1;

% %Irregular Waves using User-Defined Spectrum
% waves = waveClass('irregularImport');
%                                %Create the Wave Variable and Specify Type
% waves.spectrumDataFile = 'ndbcBuoyData.txt';
%                                   %Location of User Defined Spectrum File

%% Body Data
body(1) = bodyClass('../../../RM3/hydroData/rm3.h5');
    %Create the body(1) Variable, Set Location of Hydrodynamic Data File
    %and Body Number Within this File.
body(1).mass = 'equilibrium';
    %Body Mass. The 'equilibrium' Option Sets it to the Displaced Water
    %Weight.
body(1).momOfInertia = [20907301 21306090.66 37085481.11];
    %Moment of Inertia [kg*m^2]
body(1).geometryFile = '../../../RM3/geometry/float.stl';    %Location of Geomtry File

body(2) = bodyClass('../../../RM3/hydroData/rm3.h5');
body(2).mass = 'equilibrium';
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82];
body(2).geometryFile = '../../../RM3/geometry/plate.stl';

%% PTO and Constraint Parameters
constraint(1) = constraintClass('Constraint1');
                        %Create Constraint Variable and Set Constraint Name
constraint(1).loc = [0 0 0];                    %Constraint Location [m]


pto(1) = ptoClass('PTO1');
                                      %Create PTO Variable and Set PTO Name
pto(1).k=0;                                     %PTO Stiffness [N/m]
pto(1).c=1200000;                               %PTO Daming [N/(m/s)]
pto(1).loc = [0 0 0];                           %PTO Location [m]





%%

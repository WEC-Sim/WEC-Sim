%% Simulation Data
simu = simulationClass();               %Create the Simulation Variable
simu.simMechanicsFile = 'RM3.slx';      %Location of Simulink Model File
simu.endTime=400;                       %Simulation End Time [s]
simu.dt = 0.1; 							%Simulation Time-Step [s]
simu.rampT = 100;                        %Wave Ramp Time Length [s]

%% Wave Information
waves = waveClass('regular'); 
waves.H = 2.5;                          %Wave Height [m]
waves.T = 8;                            %Wave Period [s]

%% Body Data
body(1) = bodyClass('../rm3.h5',1);      
body(1).mass = 'equilibrium';                   
body(1).momOfInertia = [20907301 21306090.66 37085481.11]; 
body(1).geometryFile = 'geometry/float.stl';    %Location of Geomtry File
body(1).bemioFlag = 0;

body(2) = bodyClass('../rm3.h5',2);     
body(2).mass = 'equilibrium';                   
body(2).momOfInertia = [94419614.57 94407091.24 28542224.82];
body(2).geometryFile = 'geometry/plate.stl'; 
body(2).bemioFlag = 0;

%% PTO and Constraint Parameters
constraint(1) = constraintClass('Constraint1'); 
constraint(1).loc = [0 0 0];                    %Constraint Location [m]

pto(1) = ptoClass('PTO1');                      
pto(1).k=0;                                     %PTO Stiffness [N/m]
pto(1).c=1200000;                               %PTO Daming [N/(m/s)]
pto(1).loc = [0 0 0];                           %PTO Location [m]


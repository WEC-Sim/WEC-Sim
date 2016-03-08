%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%                        Surge Decay                               %%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% Simulation Data
simu=simulationClass();
simu.simMechanicsFile = 'FOSWEC_Surge.slx';
simu.rampT = 0;
simu.endTime = 10;
simu.dt = 0.05;
simu.mode = 'normal';
simu.explorer = 'on';
simu.domainSize = 2;
simu.CITime = 50;
simu.mcrCaseFile = 'surgeDecayCase.mat';

%% Wave Information
waves = waveClass('noWaveCIC');

%% Body Data
%% Body 1: Back Flap
body(1) = bodyClass('../../../hydroData/Analysis.h5');                     
body(1).geometryFile = '../../../geometry/flap.stl';
body(1).mass = 23.1;      %[kg] from Hinsdale
body(1).momOfInertia = [1.58 1.62 1.25];  %[kg-m^2] from Hinsdale
body(1).viscDrag.cd(1) = 1.28;  %Of a flat plat https://www.grc.nasa.gov/www/k-12/airplane/shaped.html
body(1).viscDrag.characteristicArea(1) = 0.5; %0.402424;  %[m^2] h=0.5m w=0.7m 
body(1).linearDamping(1) = 0;  

%% Body 2: Front Flap
body(2) = bodyClass('../../../hydroData/Analysis.h5');                     
body(2).geometryFile = '../../../geometry/flap.stl';
body(2).mass = 23.1;      %[kg] from Hinsdale
body(2).momOfInertia = [1.42 1.19 1.99];  %[kg-m^2] from Hinsdale
body(2).viscDrag.cd(1) = 1.28;  %Of a flat plat https://www.grc.nasa.gov/www/k-12/airplane/shaped.html
body(2).viscDrag.characteristicArea(1) = 0.5; % 0.402424;  %[m^2] h=0.5m w=0.7m 
body(2).linearDamping(1) = 0;  

%% Body 3: Platform
body(3) = bodyClass('../../../hydroData/Analysis.h5');                     
body(3).geometryFile = '../../../geometry/platform.stl';
body(3).mass = 153.8;   %[kg] from Hinsdale
body(3).momOfInertia = [37.88 29.63 66.2529];  %[kg-m^2] from Hinsdale - UPDATE Izz
body(3).viz.color = [1 1 1];
body(3).viz.opacity = 0.25;

%% Arm Mass Properties 
%% Body 4: Arm - Rectangle Frame (attached to FOSWEC)
body(4) = bodyClass('');
body(4).nhBody = 1;
body(4).name = 'arm_rectangle';
body(4).mass = 47.7; %[kg] (from Pedro)
body(4).momOfInertia = [1.44 2.21 3.57]; %[kg-m^2]      %UPDATE THIS
body(4).cg = [0 0 -0.366]; %[m]                         %UPDATE THIS
body(4).dispVol = 0;
body(4).geometryFile = '../../../geometry/rectangle.stl';
body(4).viz.color = [1 0 0];
body(4).viz.opacity = 1;

%% Body 5: Arm - Pitching Squares
body(5) = bodyClass('');
body(5).nhBody = 1;
body(5).name = 'arm_squares';
body(5).mass = 4.47;  %[kg]                             %UPDATE THIS
body(5).momOfInertia = [0.29, 0.02, 0.30]; %[kg-m^2]    %UPDATE THIS
body(5).cg = [0 0 -0.366]; %[m]                         %UPDATE THIS
body(5).dispVol = 0;
body(5).geometryFile = '../../../geometry/squares.stl';
body(5).viz.color = [0 1 0];
body(5).viz.opacity = 1;

%% Body 6: Arm - Heaving Cylinder
body(6) = bodyClass('');
body(6).nhBody = 1;
body(6).name = 'arm_cylinder';
body(6).mass = 23.84;   %[kg] (from Pedro)
body(6).momOfInertia = [2.19 2.15 0.28]; %[kg-m^2]      %UPDATE THIS
body(6).cg = [0 0 -0.782]; %[m]                         %UPDATE THIS
body(6).dispVol = 0.009782;
body(6).geometryFile = '../../../geometry/cylinder.stl';
body(6).viz.color = [0 0 1];
body(6).viz.opacity = 1;

%% Body 7: Arm - Fixed Cylinder (attached to seafloor)
body(7) = bodyClass('');
body(7).nhBody = 1;
body(7).name = 'arm_cylinderFixed';
body(7).mass = 1;
body(7).momOfInertia = [1 1 1];
body(7).cg = [0 0 -1.1];
body(7).dispVol = 1/1000;
body(7).initDisp.initLinDisp = [0 0 0];
body(7).initDisp.initAngularDispAxis = [0 1 0];
body(7).initDisp.initAngularDispAngle = 0;
body(7).geometryFile = '../../../geometry/cylinder_fixed.stl';
body(7).viz.color = [0 0 1];
body(7).viz.opacity = 0.25;


%% PTO and Constraint Parameters
%% Constraint 1
constraint(1)= constraintClass('rectangle_fixed');
constraint(1).loc = [0 0 -0.5];

%% Constraint 2 - Surge
constraint(2)= constraintClass('arm_surge');
constraint(2).loc = [0 0 -0.5];
constraint(2).orientation.z = [1 0 0];

mooring(1) = mooringClass('bungees');
mooring(1).matrix.k(1,1) = 925; %[N/m]   %based on static offset test 904-962 N/m
mooring(1).matrix.c(1,1) = 770; %[N/m/s]

%% Constraint 3 - Pitch
constraint(3)= constraintClass('arm_pitch');
constraint(3).loc = [0 0 -0.5];

%% Constraint 4 - Heave
constraint(4)= constraintClass('arm_heave');
constraint(4).loc = [0 0 -0.75];

%% Constraint 5
constraint(5)= constraintClass('arm_floor');
constraint(5).loc = [0 0 -1];

%% PTO 1 - Fixed
constraint(6)= constraintClass('PTO_flap1');
constraint(6).loc = [-0.65 0 -0.5];

%% PTO 2 - Fixed
constraint(7)= constraintClass('PTO_flap2');
constraint(7).loc = [ 0.65 0 -0.5];


filename = 'wecsimtest';


fid=fopen(strcat(filename,'.m'),'w');
fprintf(fid,'%%%% Simulation Data \n');
fprintf(fid,'simu = simulationClass();               %%%% Initialize Simulation Class \n');
fprintf(fid,"simu.simMechanicsFile = '%s';    %%%% Specify Simulink Model File\n",'dsdsds');
fprintf(fid,"simu.mode = 'normal';                   %%%% Specify Simulation Mode ('normal','accelerator','rapid-accelerator')\n");
fprintf(fid,"simu.explorer = 'on';                   %%%% Turn SimMechanics Explorer (on/off)\n");
fprintf(fid,'simu.startTime = 0;                     %%%% Simulation Start Time [s]\n');
fprintf(fid,'simu.rampTime = 100;                    %%%% Wave Ramp Time [s]   \n');
fprintf(fid,'simu.endTime = 400;                     %%%% Simulation End Time [s]     \n');   
fprintf(fid,"simu.solver = 'ode4';                   %%%% simu.solver = 'ode4' for fixed step & simu.solver = 'ode45' for variable step \n");
fprintf(fid,'simu.dt = 0.1;                          %%%% Simulation Time-Step [s]\n');
fprintf(fid,'simu.cicEndTime = 30;                   %%%% Specify CI Time [s]\n');

fprintf(fid,'%%%%%%%% Wave Information\n');
fprintf(fid,'%%%% %%%% noWaveCIC, no waves with radiation CIC  \n');
fprintf(fid,"%% waves = waveClass('noWaveCIC');       %% Initialize Wave Class and Specify Type  \n");

fprintf(fid,'%% %% Regular Waves \n');
fprintf(fid,"%% waves = waveClass('regular');           %% Initialize Wave Class and Specify Type      \n");                           
fprintf(fid,'%% waves.height = 2.5;                     %% Wave Height [m]\n');
fprintf(fid,'%% waves.period = 8;                       %% Wave Period [s]\n');

fprintf(fid,'%% Irregular Waves using PM Spectrum with Directionality \n');
fprintf(fid,"waves = waveClass('irregular');         %% Initialize Wave Class and Specify Type\n");
fprintf(fid,'waves.height = 2.5;                     %% Significant Wave Height [m]\n');
fprintf(fid,'waves.period = 8;                       %% Peak Period [s]\n');
fprintf(fid,"waves.spectrumType = 'PM';              %% Specify Spectrum Type\n");
fprintf(fid,'waves.direction = [0,30,90];            %% Wave Directionality [deg]\n');
fprintf(fid,'waves.spread = [0.1,0.2,0.7];           %% Wave Directional Spreading [%%}\n');

fprintf(fid,"%% %% Irregular Waves with imported spectrum\n");
fprintf(fid,"%% waves = waveClass('spectrumImport');      %% Create the Wave Variable and Specify Type\n");
fprintf(fid,"%% waves.spectrumFile = 'spectrumData.mat';  %% Name of User-Defined Spectrum File [:,2] = [f, Sf]\n");

fprintf(fid,'%% %% Waves with imported wave elevation time-history  \n');
fprintf(fid,"%% waves = waveClass('elevationImport');          %% Create the Wave Variable and Specify Type\n");
fprintf(fid,"%% waves.elevationFile = 'elevationData.mat';     %% Name of User-Defined Time-Series File [:,2] = [time, eta]\n");



fprintf(fid,'%%%% Body Data\n');
fprintf(fid,'%% Flap\n');
fprintf(fid,"body(1) = bodyClass('hydroData/oswec.h5');      %% Initialize bodyClass for Flap\n");
fprintf(fid,"body(1).geometryFile = 'geometry/flap.stl';     %% Geometry File\n");
fprintf(fid,'body(1).mass = 127000;                          %% User-Defined mass [kg]\n');
fprintf(fid,'body(1).inertia = [1.85e6 1.85e6 1.85e6];       %% Moment of Inertia [kg-m^2]\n');

fprintf(fid,'%% Base\n');
fprintf(fid,"body(2) = bodyClass('hydroData/oswec.h5');      %% Initialize bodyClass for Base\n");
fprintf(fid,"body(2).geometryFile = 'geometry/base.stl';     %% Geometry File\n");
fprintf(fid,"body(2).mass = 'fixed';                         %% Creates Fixed Body\n");

fprintf(fid,'%%%% PTO and Constraint Parameters\n');
fprintf(fid,'%% Fixed\n');
fprintf(fid,"constraint(1)= constraintClass('Constraint1');  %% Initialize ConstraintClass for Constraint1\n");
fprintf(fid,'constraint(1).location = [0 0 -10];             %% Constraint Location [m]\n');

fprintf(fid,'%% Rotational PTO\n');
fprintf(fid,"pto(1) = ptoClass('PTO1');                      %% Initialize ptoClass for PTO1\n");
fprintf(fid,'pto(1).stiffness = 0;                           %% PTO Stiffness Coeff [Nm/rad]\n');
fprintf(fid,'pto(1).damping = 12000;                         %% PTO Damping Coeff [Nsm/rad]\n');
fprintf(fid,'pto(1).location = [0 0 -8.9];                   %% PTO Location [m]\n');

fclose(fid);
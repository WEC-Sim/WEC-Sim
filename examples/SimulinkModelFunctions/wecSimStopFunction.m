%% wecSimStopFunction
% Post processing and save functions that are performed after simulation
% has ended. These functions were pulled from the wecSim.m file, following
% the command to simulate the Simulink model.

clear nlHydro sv_linearHydro sv_nonlinearHydro ssCalc radiation_option sv_convolution sv_stateSpace sv_constantCoeff typeNum B2B sv_B2B sv_noB2B;
clear nhbod* sv_b* sv_noWave sv_regularWaves sv_irregularWaves sv_udfWaves sv_instFS sv_meanFS sv_MEOn sv_MEOff morisonElement flexHydrobody_* sv_irregularWavesNonLinYaw sv_regularWavesNonLinYaw yawNonLin numBody;


tic
%% Post processing and Saving Results
postProcess
% User Defined Post-Processing
if exist('userDefinedFunctions.m','file') == 2
    userDefinedFunctions;
end
% ASCII files
if simu.outputtxt==1
    output.writetxt();
end
paraViewVisualization

%% Save files
clear ans table tout;
toc
diary off
%movefile('simulation.log',simu.logFile)
if simu.saveMat==1
    save(simu.caseFile,'-v7.3')
end

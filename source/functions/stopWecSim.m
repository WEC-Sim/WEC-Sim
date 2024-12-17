%% stopWecSim
% Post processing and save functions that are performed after simulation
% has ended. These functions were pulled from the wecSim.m file, following
% the command to simulate the Simulink model.

if exist('pctDir') 
    cd (['..' filesep pctDir filesep '..' filesep]); 
end

% Close MoorDyn if used
if simu.numMoorDyn > 0
    % Close MoorDyn
    mooring.closeMoorDynLib();
end

% Clear intermediate variables and variant subsystem flags
clear nonlinearHydro sv_linearHydro sv_nonlinearHydro stateSpace radiation_option sv_convolution sv_stateSpace sv_constantCoeff typeNum B2B sv_B2B sv_noB2B;
clear nhbod* sv_b* sv_noWave sv_regularWaves* sv_irregularWaves* sv_udfWaves sv_instFS sv_meanFS sv_MEOn sv_MEOff morisonElement flexHydrobody_* sv_irregularWavesYaw_* sv_regularWavesYaw_* yaw numBody variableHydro*;
clear sv_visualizationOFF sv_visualizationON visON X Y
clear sv_FIR
clear dragBodLogic hydroBodLogic nonHydroBodLogic idx it numNonHydroBodies morisonElement* nonLinearHydro* yaw*;
clear runWecSimCML
clear sv_1_control* sv_wind_* WindChoice ControlChoice*
clear iW secondOrderExt_* sv_fullDirIrregularWaves_*

toc

tic
%% Post processing and Saving Results
postProcessWecSim

% User Defined Post-Processing
if exist('userDefinedFunctions.m','file') == 2
    userDefinedFunctions;
end

% Paraview output. Must call while output is an instance of responseClass 
paraviewVisualization

% ASCII files
if simu.saveText==1
    output.writeText();
end
if simu.saveStructure==1
    warning('off','MATLAB:structOnObject')
    outputStructure = struct(output);
end


%% Save files
clear ans table tout;
toc
diary off

if simu.saveWorkspace==1
    if exist('pctDir') 
       cd(pctDir);
       simu.caseDir = [simu.caseDir filesep pctDir];
    end
    outputFile = [simu.caseDir filesep simu.outputDir filesep simu.caseFile];
    save(outputFile,'-v7.3')
    if exist('pctDir') 
        filename = sprintf('savedData%03d.mat', imcr);
        copyfile(outputFile,['../' filename])
        cd (['..' filesep pctDir filesep '..' filesep]);
    end
end

%% Remove 'temp' directory from path and remove 'temp' directory
rmpath(fullfile(projectRootDir,'temp'));
try
    rmdir(fullfile(projectRootDir,'temp'),'s');
end

% Reset the loction of Simulink-generated files
Simulink.fileGenControl('reset');
clear projectRootDir

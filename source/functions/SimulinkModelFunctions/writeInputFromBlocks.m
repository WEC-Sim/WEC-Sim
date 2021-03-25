function writeInputFromBlocks(inputFile)
% This script reads custom parameters from masked WEC-Sim blocks, and 
% writes a new wecSimInputFile.m based on the mask variables
% 
% Note: str2num used because mask parameters are always read as 'char'
% Note: mat2str used so that types are printed in the correct format

% Get all block names
blocks = find_system(bdroot,'Type','Block');

% Write input file
fid = fopen(['./' inputFile '.m'],'w');
fprintf(fid,'%% %s\r\n','WEC-Sim Input File, written with custom Simulink parameters');
fprintf(fid,'%% %s\r\n',string(datetime));

% Get write each mask to an input file section
for i=1:length(blocks)
    names = get_param(blocks{i},'MaskNames');
    values = get_param(blocks{i},'MaskValues');
    
    % Create struct with mask variable name/value pairs
    maskVars = struct();
    for j = 1:length(names)
        maskVars.(names{j,1}) = values{j,1};
    end; clear j;
    
    if isfield(maskVars,'simu') && isfield(maskVars,'waves')
        % Block is Global Reference Frame
        fprintf(fid,'\r\n%s\r\n','%% Simulation Class');
        fprintf(fid,'simu = simulationClass(); \r\n');
        fprinf(fid,'simu.simMechanicsFile = ''%s.slx''; \r\n',bdroot);
        fprinf(fid,'simu.mode = %s; \r\n',mat2str(maskVars.mode));
        fprinf(fid,'simu.explorer = %s; \r\n',mat2str(maskVars.explorer));
        fprinf(fid,'simu.startTime = %f; \r\n',maskVars.startTime);
        fprinf(fid,'simu.rampTime = %f; \r\n',maskVars.rampTime);
        fprinf(fid,'simu.endTime = %f; \r\n',maskVars.endTime);
        fprinf(fid,'simu.solver = %s; \r\n',mat2str(maskVars.solver));
        fprinf(fid,'simu.dt = %f; \r\n',maskVars.dt);
        fprinf(fid,'simu.CITime = %f; \r\n',maskVars.CITime);
        fprinf(fid,'simu.ssCalc = %f; \r\n',maskVars.ssCalc);
        fprinf(fid,'simu.morisonElement = %f; \r\n',maskVars.morisonElement);
        
        % Wave Information 
        fprintf(fid,'\r\n%s\r\n','%% Wave Class');
        fprinf(fid,'waves = waveClass(%s); \r\n',mat2str(maskVars.WaveClass));
        
        switch maskVars.WaveClass
            
            case 'noWaveCIC'
            % noWaveCIC, no waves with radiation CIC  

            case 'regular'
            % Regular Waves
            fprinf(fid,'waves.H = %f; \r\n',maskVars.H);
            fprinf(fid,'waves.T = %f; \r\n',maskVars.T);
            fprinf(fid,'waves.waveDir = %s; \r\n',mat2str(str2num(maskVars.waveDir)));
            fprinf(fid,'waves.waveSpread = %s; \r\n',mat2str(str2num(maskVars.waveSpread)));
        
            case 'regularCIC'
            % Regular Waves with CIC
            fprinf(fid,'waves.H = %f; \r\n',maskVars.H);
            fprinf(fid,'waves.T = %f; \r\n',maskVars.T);
            fprinf(fid,'waves.waveDir = %s; \r\n',mat2str(str2num(maskVars.waveDir)));
            fprinf(fid,'waves.waveSpread = %s; \r\n',mat2str(str2num(maskVars.waveSpread)));

            case 'irregular'
            % Irregular Waves
            fprinf(fid,'waves.H = %f; \r\n',maskVars.H);
            fprinf(fid,'waves.T = %f; \r\n',maskVars.T);
            fprinf(fid,'waves.waveDir = %s; \r\n',mat2str(str2num(maskVars.waveDir)));
            fprinf(fid,'waves.waveSpread = %s; \r\n',mat2str(str2num(maskVars.waveSpread)));
            fprinf(fid,'waves.spectrumType = %s; \r\n',mat2str(maskVars.spectrumType));
            fprinf(fid,'waves.freqDisc = %s; \r\n',mat2str(maskVars.freqDisc));
            
            case 'spectrumImport'
            % Irregular Waves with imported spectrum
            fprinf(fid,'waves.spectrumDataFile = %s; \r\n',mat2str(maskVars.spectrumDataFile));
            fprinf(fid,'waves.phaseSeed = %f; \r\n',maskVars.phaseSeed);
            
            case 'etaImport'
            % Waves with imported wave elevation time-history  
            fprinf(fid,'waves.etaDataFile = %s; \r\n',mat2str(maskVars.etaDataFile));
        end

    elseif isfield(maskVars,'body')
        % Block is a body
        fprintf(fid,'\r\n%s\r\n','%% Body Class');
        
        tmp = string(maskVars.body);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        
        fprintf(fid,'body(%d) = bodyClass(''body%d''); \r\n',num,num);
        fprintf(fid,'body(%d).geometryFile = %s; \r\n',num,mat2str(maskVars.geometryFile));
        
        if strcmp(maskVars.mass,'equilibrium') || strcmp(maskVars.mass,'fixed')
            fprintf(fid,'body(%d).mass = %s; \r\n',num,mat2str(maskVars.mass));
        else
            fprintf(fid,'body(%d).mass = %f; \r\n',num,maskVars.mass);
        end
        fprintf(fid,'body(%d).nhBody = %s; \r\n',num,mat2str(maskVars.momOfInertia));
        fprintf(fid,'body(%d).flexHydroBody = %s; \r\n',num,mat2str(maskVars.momOfInertia));
        fprintf(fid,'body(%d).cg = %s; \r\n',num,mat2str(maskVars.momOfInertia));
        fprintf(fid,'body(%d).cb = %s; \r\n',num,mat2str(maskVars.momOfInertia));
        fprintf(fid,'body(%d).dof = %s; \r\n',num,mat2str(maskVars.momOfInertia));
        fprintf(fid,'body(%d).dispVol = %s; \r\n',num,mat2str(maskVars.momOfInertia));
        fprintf(fid,'body(%d).initDisp.initLinDisp = %s; \r\n',num,mat2str(maskVars.initLinDisp));
        fprintf(fid,'body(%d).initDisp.initAngularDispAxis = %s; \r\n',num,mat2str(maskVars.initAngularDispAxis));
        fprintf(fid,'body(%d).initDisp.initAngularDispAngle = %s; \r\n',num,mat2str(maskVars.initAngularDispAngle));
        fprintf(fid,'body(%d).morisonElement.cd = %s; \r\n',num,mat2str(maskVars.cd));
        fprintf(fid,'body(%d).morisonElement.ca = %s; \r\n',num,mat2str(maskVars.ca));
        fprintf(fid,'body(%d).morisonElement.characteristicArea = %s; \r\n',num,mat2str(maskVars.characteristicArea));
        fprintf(fid,'body(%d).morisonElement.VME = %s; \r\n',num,mat2str(maskVars.VME));
        fprintf(fid,'body(%d).morisonElement.rgME = %s; \r\n',num,mat2str(maskVars.rgME));
        fprintf(fid,'body(%d).morisonElement.z = %s; \r\n',num,mat2str(maskVars.z));
        
    elseif isfield(maskVars,'constraint')
        % Block is a constraint
        tmp = string(maskVars.constraint);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'constraint(%d) = constraintClass(''constraint%d''); \r\n',num,num);
        fprintf(fid,'constraint(%d).loc = %s; \r\n',num,mat2str(str2num(maskVars.loc)));
        fprintf(fid,'constraint(%d).orientation.y = %s; \r\n',num,mat2str(str2num(maskVars.y)));
        fprintf(fid,'constraint(%d).orientation.z = %s; \r\n',num,mat2str(str2num(maskVars.z)));
        fprintf(fid,'constraint(%d).initDisp.initLinDisp = %s; \r\n',num,mat2str(str2num(maskVars.initLinDisp)));
        fprintf(fid,'constraint(%d).hardStops.upperLimitSpecify = %s; \r\n',num,mat2str(maskVars.upperLimitSpecify));
        fprintf(fid,'constraint(%d).hardStops.upperLimitBound = %f; \r\n',num,maskVars.upperLimitBound);
        fprintf(fid,'constraint(%d).hardStops.upperLimitStiffness = %f; \r\n',num,maskVars.upperLimitStiffness);
        fprintf(fid,'constraint(%d).hardStops.upperLimitDamping = %f; \r\n',num,maskVars.upperLimitDamping);
        fprintf(fid,'constraint(%d).hardStops.upperLimitTransitionRegionWidth = %f; \r\n',num,maskVars.upperLimitTransitionRegionWidth);
        fprintf(fid,'constraint(%d).hardStops.lowerLimitSpecify = %s; \r\n',num,mat2str(maskVars.lowerLimitSpecify));
        fprintf(fid,'constraint(%d).hardStops.lowerLimitBound = %f; \r\n',num,maskVars.lowerLimitBound);
        fprintf(fid,'constraint(%d).hardStops.lowerLimitStiffness = %f; \r\n',num,maskVars.lowerLimitStiffness);
        fprintf(fid,'constraint(%d).hardStops.lowerLimitDamping = %f; \r\n',num,maskVars.lowerLimitDamping);
        fprintf(fid,'constraint(%d).hardStops.lowerLimitTransitionRegionWidth = %f; \r\n',num,maskVars.lowerLimitTransitionRegionWidth);
        
    elseif isfield(maskVars,'pto')
        % Block is a PTO
        tmp = string(maskVars.pto);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'pto(%d) = ptoClass(''pto%d''); \r\n',num,num);
        fprintf(fid,'pto(%d).k = %f; \r\n',num,maskVars.k);
        fprintf(fid,'pto(%d).c = %f; \r\n',num,maskVars.c);
        fprintf(fid,'pto(%d).loc = %s; \r\n',num,mat2str(str2num(maskVars.loc)));
        fprintf(fid,'pto(%d).orientation.y = %s; \r\n',num,mat2str(str2num(maskVars.y)));
        fprintf(fid,'pto(%d).orientation.z = %s; \r\n',num,mat2str(str2num(maskVars.z)));
        fprintf(fid,'pto(%d).initDisp.initLinDisp = %s; \r\n',num,mat2str(str2num(maskVars.initLinDisp)));
        fprintf(fid,'pto(%d).hardStops.upperLimitSpecify = %s; \r\n',num,mat2str(maskVars.upperLimitSpecify));
        fprintf(fid,'pto(%d).hardStops.upperLimitBound = %f; \r\n',num,maskVars.upperLimitBound);
        fprintf(fid,'pto(%d).hardStops.upperLimitStiffness = %f; \r\n',num,maskVars.upperLimitStiffness);
        fprintf(fid,'pto(%d).hardStops.upperLimitDamping = %f; \r\n',num,maskVars.upperLimitDamping);
        fprintf(fid,'pto(%d).hardStops.upperLimitTransitionRegionWidth = %f; \r\n',num,maskVars.upperLimitTransitionRegionWidth);
        fprintf(fid,'pto(%d).hardStops.lowerLimitSpecify = %s; \r\n',num,mat2str(maskVars.lowerLimitSpecify));
        fprintf(fid,'pto(%d).hardStops.lowerLimitBound = %f; \r\n',num,maskVars.lowerLimitBound);
        fprintf(fid,'pto(%d).hardStops.lowerLimitStiffness = %f; \r\n',num,maskVars.lowerLimitStiffness);
        fprintf(fid,'pto(%d).hardStops.lowerLimitDamping = %f; \r\n',num,maskVars.lowerLimitDamping);
        fprintf(fid,'pto(%d).hardStops.lowerLimitTransitionRegionWidth = %f; \r\n',num,maskVars.lowerLimitTransitionRegionWidth);
        
        
    elseif isfield(maskVars,'mooring') && isfield(maskVars,'stiffness')
        % Block is a Mooring system
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'mooring(%d) = mooringClass(''mooring%d''); \r\n',num,num);
        fprintf(fid,'mooring(%d).ref = %s; \r\n',num,mat2str(str2num(maskVars.ref)));
        fprintf(fid,'mooring(%d).matrix.k = %s; \r\n',num,mat2str(str2num(maskVars.stiffness)));
        fprintf(fid,'mooring(%d).matrix.c = %s; \r\n',num,mat2str(str2num(maskVars.damping)));
        fprintf(fid,'mooring(%d).matrix.preTension = %s; \r\n',num,mat2str(str2num(maskVars.preTension)));
        
    elseif isfield(maskVars,'mooring') && isfield(maskVars,'moorDynlines')
        % Block is a Mooring system
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'mooring(%d) = mooringClass(''mooring%d''); \r\n',num,num);
        fprintf(fid,'mooring(%d).ref = %s; \r\n',num,mat2str(str2num(maskVars.ref)));
        fprintf(fid,'mooring(%d).moorDynLines = %s; \r\n',num,mat2str(str2num(maskVars.moorDynLines)));
        fprintf(fid,'mooring(%d).moorDynNodes = %s; \r\n',num,mat2str(str2num(maskVars.moorDynNodes)));
    end
    clear names values maskVars
end

run(inputFile);


function writeInputFromBlocks(inputFile)
% This script reads custom parameters from masked WEC-Sim blocks, and 
% writes a new wecSimInputFile.m based on the mask variables
% 
% Note: str2num used because mask parameters are always read as 'char'
% Note: mat2str used so that types are printed in the correct format

% Get all block names
blocks = find_system(bdroot,'Type','Block');

% reorder blocks into standard input file format:
%    simu/waves, body, constraints, ptos, moorings
inds = [];
indb = [];
indc = [];
indp = [];
indm = [];
for i=1:length(blocks)
    names = get_param(blocks{i},'MaskNames');
    if any(strcmp(names,'simu'))
        inds = i;
    elseif any(strcmp(names,'body'))
        indb(end+1) = i;
    elseif any(strcmp(names,'constraint'))
        indc(end+1) = i;
    elseif any(strcmp(names,'pto'))
        indp(end+1) = i;
    elseif any(strcmp(names,'mooring'))
        indm(end+1) = i;
    end
end
ind = [inds indb indc indp indm];
blocks = blocks(ind);


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
        % check if the value should be converted from a string to a float
        tmp = str2num(values{j});
        if ~isempty(tmp)
            values{j} = str2num(values{j});
        end
        
        % convert matlab to string to write to input file correctly
        values{j} = mat2str(values{j});
        maskVars.(names{j,1}) = values{j,1};
    end; clear j;
    
    if isfield(maskVars,'simu') && isfield(maskVars,'waves')
        % Block is Global Reference Frame
        fprintf(fid,'\r\n%s\r\n','%% Simulation Class');
        fprintf(fid,'simu = simulationClass(); \r\n');
        fprintf(fid,'simu.simMechanicsFile = ''%s.slx''; \r\n',bdroot);
        fprintf(fid,'simu.mode = %s; \r\n',maskVars.mode);
        fprintf(fid,'simu.explorer = %s; \r\n',maskVars.explorer);
        fprintf(fid,'simu.startTime = %s; \r\n',maskVars.startTime);
        fprintf(fid,'simu.rampTime = %s; \r\n',maskVars.rampTime);
        fprintf(fid,'simu.endTime = %s; \r\n',maskVars.endTime);
        fprintf(fid,'simu.solver = %s; \r\n',maskVars.solver);
        fprintf(fid,'simu.dt = %s; \r\n',maskVars.dt);
        fprintf(fid,'simu.CITime = %s; \r\n',maskVars.CITime);
        fprintf(fid,'simu.ssCalc = %s; \r\n',maskVars.ssCalc);
        fprintf(fid,'simu.morisonElement = %s; \r\n',maskVars.morisonElement);
        
        % Wave Information 
        fprintf(fid,'\r\n%s\r\n','%% Wave Class');
        fprintf(fid,'waves = waveClass(%s); \r\n',maskVars.WaveClass);
        
        switch maskVars.WaveClass(2:end-1) % remove extra leading/trailing apostrophe from mask formatting
            
            case 'noWaveCIC'
            % noWaveCIC, no waves with radiation CIC  

            case 'regular'
            % Regular Waves
            fprintf(fid,'waves.H = %s; \r\n',maskVars.H);
            fprintf(fid,'waves.T = %s; \r\n',maskVars.T);
            fprintf(fid,'waves.waveDir = %s; \r\n',maskVars.waveDir);
            fprintf(fid,'waves.waveSpread = %s; \r\n',maskVars.waveSpread);
        
            case 'regularCIC'
            % Regular Waves with CIC
            fprintf(fid,'waves.H = %s; \r\n',maskVars.H);
            fprintf(fid,'waves.T = %s; \r\n',maskVars.T);
            fprintf(fid,'waves.waveDir = %s; \r\n',maskVars.waveDir);
            fprintf(fid,'waves.waveSpread = %s; \r\n',maskVars.waveSpread);

            case 'irregular'
            % Irregular Waves
            fprintf(fid,'waves.H = %s; \r\n',maskVars.H);
            fprintf(fid,'waves.T = %s; \r\n',maskVars.T);
            fprintf(fid,'waves.waveDir = %s; \r\n',maskVars.waveDir);
            fprintf(fid,'waves.waveSpread = %s; \r\n',maskVars.waveSpread);
            fprintf(fid,'waves.spectrumType = %s; \r\n',maskVars.spectrumType);
            fprintf(fid,'waves.freqDisc = %s; \r\n',maskVars.freqDisc);
            
            case 'spectrumImport'
            % Irregular Waves with imported spectrum
            fprintf(fid,'waves.spectrumDataFile = %s; \r\n',maskVars.spectrumDataFile);
            fprintf(fid,'waves.phaseSeed = %s; \r\n',maskVars.phaseSeed);
            
            case 'etaImport'
            % Waves with imported wave elevation time-history  
            fprintf(fid,'waves.etaDataFile = %s; \r\n',maskVars.etaDataFile);
        end

    elseif isfield(maskVars,'body')
        % Block is a body
        fprintf(fid,'\r\n%s\r\n','%% Body Class');
        
        tmp = string(maskVars.body);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        
        fprintf(fid,'body(%d) = bodyClass(%s); \r\n',num,maskVars.h5File);
        fprintf(fid,'body(%d).geometryFile = %s; \r\n',num,maskVars.geometryFile);
        
        if strcmp(maskVars.mass,'equilibrium') || strcmp(maskVars.mass,'fixed')
            fprintf(fid,'body(%d).mass = %s; \r\n',num,maskVars.mass);
        else
            fprintf(fid,'body(%d).mass = %s; \r\n',num,maskVars.mass);
        end
        fprintf(fid,'body(%d).momOfInertia = %s; \r\n',num,maskVars.momOfInertia);
        fprintf(fid,'body(%d).nhBody = %s; \r\n',num,maskVars.nhBody);
        fprintf(fid,'body(%d).flexHydroBody = %s; \r\n',num,maskVars.flexHydroBody);
        fprintf(fid,'body(%d).cg = %s; \r\n',num,maskVars.cg);
        fprintf(fid,'body(%d).cb = %s; \r\n',num,maskVars.cb);
        fprintf(fid,'body(%d).dof = %s; \r\n',num,maskVars.dof);
        fprintf(fid,'body(%d).dispVol = %s; \r\n',num,maskVars.dispVol);
        fprintf(fid,'body(%d).initDisp.initLinDisp = %s; \r\n',num,maskVars.initLinDisp);
        fprintf(fid,'body(%d).initDisp.initAngularDispAxis = %s; \r\n',num,maskVars.initAngularDispAxis);
        fprintf(fid,'body(%d).initDisp.initAngularDispAngle = %s; \r\n',num,maskVars.initAngularDispAngle);
        fprintf(fid,'body(%d).morisonElement.cd = %s; \r\n',num,maskVars.cd);
        fprintf(fid,'body(%d).morisonElement.ca = %s; \r\n',num,maskVars.ca);
        fprintf(fid,'body(%d).morisonElement.characteristicArea = %s; \r\n',num,maskVars.characteristicArea);
        fprintf(fid,'body(%d).morisonElement.VME = %s; \r\n',num,maskVars.VME);
        fprintf(fid,'body(%d).morisonElement.rgME = %s; \r\n',num,maskVars.rgME);
        fprintf(fid,'body(%d).morisonElement.z = %s; \r\n',num,maskVars.z);
        
    elseif isfield(maskVars,'constraint')
        % Block is a constraint
        fprintf(fid,'\r\n%s\r\n','%% Constraint Class');
        
        tmp = string(maskVars.constraint);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'constraint(%d) = constraintClass(''constraint%d''); \r\n',num,num);
        fprintf(fid,'constraint(%d).loc = %s; \r\n',num,maskVars.loc);
        fprintf(fid,'constraint(%d).orientation.y = %s; \r\n',num,maskVars.y);
        fprintf(fid,'constraint(%d).orientation.z = %s; \r\n',num,maskVars.z);
        fprintf(fid,'constraint(%d).initDisp.initLinDisp = %s; \r\n',num,maskVars.initLinDisp);
        fprintf(fid,'constraint(%d).hardStops.upperLimitSpecify = %s; \r\n',num,maskVars.upperLimitSpecify);
        fprintf(fid,'constraint(%d).hardStops.upperLimitBound = %s; \r\n',num,maskVars.upperLimitBound);
        fprintf(fid,'constraint(%d).hardStops.upperLimitStiffness = %s; \r\n',num,maskVars.upperLimitStiffness);
        fprintf(fid,'constraint(%d).hardStops.upperLimitDamping = %s; \r\n',num,maskVars.upperLimitDamping);
        fprintf(fid,'constraint(%d).hardStops.upperLimitTransitionRegionWidth = %s; \r\n',num,maskVars.upperLimitTransitionRegionWidth);
        fprintf(fid,'constraint(%d).hardStops.lowerLimitSpecify = %s; \r\n',num,maskVars.lowerLimitSpecify);
        fprintf(fid,'constraint(%d).hardStops.lowerLimitBound = %s; \r\n',num,maskVars.lowerLimitBound);
        fprintf(fid,'constraint(%d).hardStops.lowerLimitStiffness = %s; \r\n',num,maskVars.lowerLimitStiffness);
        fprintf(fid,'constraint(%d).hardStops.lowerLimitDamping = %s; \r\n',num,maskVars.lowerLimitDamping);
        fprintf(fid,'constraint(%d).hardStops.lowerLimitTransitionRegionWidth = %s; \r\n',num,maskVars.lowerLimitTransitionRegionWidth);
        
    elseif isfield(maskVars,'pto')
        % Block is a PTO
        fprintf(fid,'\r\n%s\r\n','%% PTO Class');
        
        tmp = string(maskVars.pto);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'pto(%d) = ptoClass(''pto%d''); \r\n',num,num);
        fprintf(fid,'pto(%d).k = %s; \r\n',num,maskVars.k);
        fprintf(fid,'pto(%d).c = %s; \r\n',num,maskVars.c);
        fprintf(fid,'pto(%d).loc = %s; \r\n',num,maskVars.loc);
        fprintf(fid,'pto(%d).orientation.y = %s; \r\n',num,maskVars.y);
        fprintf(fid,'pto(%d).orientation.z = %s; \r\n',num,maskVars.z);
        fprintf(fid,'pto(%d).initDisp.initLinDisp = %s; \r\n',num,maskVars.initLinDisp);
        fprintf(fid,'pto(%d).hardStops.upperLimitSpecify = %s; \r\n',num,maskVars.upperLimitSpecify);
        fprintf(fid,'pto(%d).hardStops.upperLimitBound = %s; \r\n',num,maskVars.upperLimitBound);
        fprintf(fid,'pto(%d).hardStops.upperLimitStiffness = %s; \r\n',num,maskVars.upperLimitStiffness);
        fprintf(fid,'pto(%d).hardStops.upperLimitDamping = %s; \r\n',num,maskVars.upperLimitDamping);
        fprintf(fid,'pto(%d).hardStops.upperLimitTransitionRegionWidth = %s; \r\n',num,maskVars.upperLimitTransitionRegionWidth);
        fprintf(fid,'pto(%d).hardStops.lowerLimitSpecify = %s; \r\n',num,maskVars.lowerLimitSpecify);
        fprintf(fid,'pto(%d).hardStops.lowerLimitBound = %s; \r\n',num,maskVars.lowerLimitBound);
        fprintf(fid,'pto(%d).hardStops.lowerLimitStiffness = %s; \r\n',num,maskVars.lowerLimitStiffness);
        fprintf(fid,'pto(%d).hardStops.lowerLimitDamping = %s; \r\n',num,maskVars.lowerLimitDamping);
        fprintf(fid,'pto(%d).hardStops.lowerLimitTransitionRegionWidth = %s; \r\n',num,maskVars.lowerLimitTransitionRegionWidth);
        
        
    elseif isfield(maskVars,'mooring') && isfield(maskVars,'stiffness')
        % Block is a Mooring system
        fprintf(fid,'\r\n%s\r\n','%% Mooring Class');
        
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'mooring(%d) = mooringClass(''mooring%d''); \r\n',num,num);
        fprintf(fid,'mooring(%d).ref = %s; \r\n',num,maskVars.ref);
        fprintf(fid,'mooring(%d).matrix.k = %s; \r\n',num,maskVars.stiffness);
        fprintf(fid,'mooring(%d).matrix.c = %s; \r\n',num,maskVars.damping);
        fprintf(fid,'mooring(%d).matrix.preTension = %s; \r\n',num,maskVars.preTension);
        
    elseif isfield(maskVars,'mooring') && isfield(maskVars,'moorDynlines')
        % Block is a Mooring system
        fprintf(fid,'\r\n%s\r\n','%% Mooring Class');
        
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'mooring(%d) = mooringClass(''mooring%d''); \r\n',num,num);
        fprintf(fid,'mooring(%d).ref = %s; \r\n',num,maskVars.ref);
        fprintf(fid,'mooring(%d).moorDynLines = %s; \r\n',num,maskVars.moorDynLines);
        fprintf(fid,'mooring(%d).moorDynNodes = %s; \r\n',num,maskVars.moorDynNodes);
    end
    clear names values maskVars
end

run(inputFile);


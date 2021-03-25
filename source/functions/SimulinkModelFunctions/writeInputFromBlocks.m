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
        maskVars.(names{j,1}) = values{j,1};
    end; clear j;
    
    if isfield(maskVars,'simu') && isfield(maskVars,'waves')
        % Block is Global Reference Frame
        fprintf(fid,'\r\n%s\r\n','%% Simulation Class');
        fprintf(fid,'simu = simulationClass(); \r\n');
        fprintf(fid,'simu.simMechanicsFile = ''%s.slx''; \r\n',bdroot);
        fprintf(fid,'simu.mode = %s; \r\n',mat2str(maskVars.mode));
        fprintf(fid,'simu.explorer = %s; \r\n',mat2str(maskVars.explorer));
        fprintf(fid,'simu.startTime = %f; \r\n',str2num(maskVars.startTime));
        fprintf(fid,'simu.rampTime = %f; \r\n',str2num(maskVars.rampTime));
        fprintf(fid,'simu.endTime = %f; \r\n',str2num(maskVars.endTime));
        fprintf(fid,'simu.solver = %s; \r\n',mat2str(maskVars.solver));
        fprintf(fid,'simu.dt = %f; \r\n',str2num(maskVars.dt));
        fprintf(fid,'simu.CITime = %f; \r\n',str2num(maskVars.CITime));
        fprintf(fid,'simu.ssCalc = %f; \r\n',str2num(maskVars.ssCalc));
        fprintf(fid,'simu.morisonElement = %f; \r\n',str2num(maskVars.morisonElement));
        
        % Wave Information 
        fprintf(fid,'\r\n%s\r\n','%% Wave Class');
        fprintf(fid,'waves = waveClass(%s); \r\n',mat2str(maskVars.WaveClass));
        
        switch string(maskVars.WaveClass)
            
            case 'noWaveCIC'
            % noWaveCIC, no waves with radiation CIC  

            case 'regular'
            % Regular Waves
            fprintf(fid,'waves.H = %f; \r\n',str2num(maskVars.H));
            fprintf(fid,'waves.T = %f; \r\n',str2num(maskVars.T));
            fprintf(fid,'waves.waveDir = %s; \r\n',mat2str(str2num(maskVars.waveDir)));
            fprintf(fid,'waves.waveSpread = %s; \r\n',mat2str(str2num(maskVars.waveSpread)));
        
            case 'regularCIC'
            % Regular Waves with CIC
            fprintf(fid,'waves.H = %f; \r\n',str2num(maskVars.H));
            fprintf(fid,'waves.T = %f; \r\n',str2num(maskVars.T));
            fprintf(fid,'waves.waveDir = %s; \r\n',mat2str(str2num(maskVars.waveDir)));
            fprintf(fid,'waves.waveSpread = %s; \r\n',mat2str(str2num(maskVars.waveSpread)));

            case 'irregular'
            % Irregular Waves
            fprintf(fid,'waves.H = %f; \r\n',str2num(maskVars.H));
            fprintf(fid,'waves.T = %f; \r\n',str2num(maskVars.T));
            fprintf(fid,'waves.waveDir = %s; \r\n',mat2str(str2num(maskVars.waveDir)));
            fprintf(fid,'waves.waveSpread = %s; \r\n',mat2str(str2num(maskVars.waveSpread)));
            fprintf(fid,'waves.spectrumType = %s; \r\n',mat2str(maskVars.spectrumType));
            fprintf(fid,'waves.freqDisc = %s; \r\n',mat2str(maskVars.freqDisc));
            
            case 'spectrumImport'
            % Irregular Waves with imported spectrum
            fprintf(fid,'waves.spectrumDataFile = %s; \r\n',mat2str(maskVars.spectrumDataFile));
            fprintf(fid,'waves.phaseSeed = %f; \r\n',str2num(maskVars.phaseSeed));
            
            case 'etaImport'
            % Waves with imported wave elevation time-history  
            fprintf(fid,'waves.etaDataFile = %s; \r\n',mat2str(maskVars.etaDataFile));
        end

    elseif isfield(maskVars,'body')
        % Block is a body
        fprintf(fid,'\r\n%s\r\n','%% Body Class');
        
        tmp = string(maskVars.body);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        
        fprintf(fid,'body(%d) = bodyClass(%s); \r\n',num,mat2str(maskVars.h5File));
        fprintf(fid,'body(%d).geometryFile = %s; \r\n',num,mat2str(maskVars.geometryFile));
        
        if strcmp(maskVars.mass,'equilibrium') || strcmp(maskVars.mass,'fixed')
            fprintf(fid,'body(%d).mass = %s; \r\n',num,mat2str(maskVars.mass));
        else
            fprintf(fid,'body(%d).mass = %f; \r\n',num,str2num(maskVars.mass));
        end
        fprintf(fid,'body(%d).momOfInertia = %s; \r\n',num,mat2str(str2num(maskVars.momOfInertia)));
        fprintf(fid,'body(%d).nhBody = %f; \r\n',num,str2num(maskVars.nhBody));
        fprintf(fid,'body(%d).flexHydroBody = %f; \r\n',num,str2num(maskVars.flexHydroBody));
        fprintf(fid,'body(%d).cg = %s; \r\n',num,mat2str(str2num(maskVars.cg)));
        fprintf(fid,'body(%d).cb = %s; \r\n',num,mat2str(str2num(maskVars.cb)));
        fprintf(fid,'body(%d).dof = %f; \r\n',num,str2num(maskVars.dof));
        fprintf(fid,'body(%d).dispVol = %f; \r\n',num,str2num(maskVars.dispVol));
        fprintf(fid,'body(%d).initDisp.initLinDisp = %s; \r\n',num,mat2str(str2num(maskVars.initLinDisp)));
        fprintf(fid,'body(%d).initDisp.initAngularDispAxis = %s; \r\n',num,mat2str(str2num(maskVars.initAngularDispAxis)));
        fprintf(fid,'body(%d).initDisp.initAngularDispAngle = %s; \r\n',num,mat2str(str2num(maskVars.initAngularDispAngle)));
        fprintf(fid,'body(%d).morisonElement.cd = %s; \r\n',num,mat2str(str2num(maskVars.cd)));
        fprintf(fid,'body(%d).morisonElement.ca = %s; \r\n',num,mat2str(str2num(maskVars.ca)));
        fprintf(fid,'body(%d).morisonElement.characteristicArea = %s; \r\n',num,mat2str(str2num(maskVars.characteristicArea)));
        fprintf(fid,'body(%d).morisonElement.VME = %s; \r\n',num,mat2str(str2num(maskVars.VME)));
        fprintf(fid,'body(%d).morisonElement.rgME = %s; \r\n',num,mat2str(str2num(maskVars.rgME)));
        fprintf(fid,'body(%d).morisonElement.z = %s; \r\n',num,mat2str(str2num(maskVars.z)));
        
    elseif isfield(maskVars,'constraint')
        % Block is a constraint
        fprintf(fid,'\r\n%s\r\n','%% Constraint Class');
        
        tmp = string(maskVars.constraint);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'constraint(%d) = constraintClass(''constraint%d''); \r\n',num,num);
        fprintf(fid,'constraint(%d).loc = %s; \r\n',num,mat2str(str2num(maskVars.loc)));
        fprintf(fid,'constraint(%d).orientation.y = %s; \r\n',num,mat2str(str2num(maskVars.y)));
        fprintf(fid,'constraint(%d).orientation.z = %s; \r\n',num,mat2str(str2num(maskVars.z)));
        fprintf(fid,'constraint(%d).initDisp.initLinDisp = %s; \r\n',num,mat2str(str2num(maskVars.initLinDisp)));
        fprintf(fid,'constraint(%d).hardStops.upperLimitSpecify = %s; \r\n',num,mat2str(maskVars.upperLimitSpecify));
        fprintf(fid,'constraint(%d).hardStops.upperLimitBound = %f; \r\n',num,str2num(maskVars.upperLimitBound));
        fprintf(fid,'constraint(%d).hardStops.upperLimitStiffness = %f; \r\n',num,str2num(maskVars.upperLimitStiffness));
        fprintf(fid,'constraint(%d).hardStops.upperLimitDamping = %f; \r\n',num,str2num(maskVars.upperLimitDamping));
        fprintf(fid,'constraint(%d).hardStops.upperLimitTransitionRegionWidth = %f; \r\n',num,str2num(maskVars.upperLimitTransitionRegionWidth));
        fprintf(fid,'constraint(%d).hardStops.lowerLimitSpecify = %s; \r\n',num,mat2str(maskVars.lowerLimitSpecify));
        fprintf(fid,'constraint(%d).hardStops.lowerLimitBound = %f; \r\n',num,str2num(maskVars.lowerLimitBound));
        fprintf(fid,'constraint(%d).hardStops.lowerLimitStiffness = %f; \r\n',num,str2num(maskVars.lowerLimitStiffness));
        fprintf(fid,'constraint(%d).hardStops.lowerLimitDamping = %f; \r\n',num,str2num(maskVars.lowerLimitDamping));
        fprintf(fid,'constraint(%d).hardStops.lowerLimitTransitionRegionWidth = %f; \r\n',num,str2num(maskVars.lowerLimitTransitionRegionWidth));
        
    elseif isfield(maskVars,'pto')
        % Block is a PTO
        fprintf(fid,'\r\n%s\r\n','%% PTO Class');
        
        tmp = string(maskVars.pto);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'pto(%d) = ptoClass(''pto%d''); \r\n',num,num);
        fprintf(fid,'pto(%d).k = %f; \r\n',num,str2num(maskVars.k));
        fprintf(fid,'pto(%d).c = %f; \r\n',num,str2num(maskVars.c));
        fprintf(fid,'pto(%d).loc = %s; \r\n',num,mat2str(str2num(maskVars.loc)));
        fprintf(fid,'pto(%d).orientation.y = %s; \r\n',num,mat2str(str2num(maskVars.y)));
        fprintf(fid,'pto(%d).orientation.z = %s; \r\n',num,mat2str(str2num(maskVars.z)));
        fprintf(fid,'pto(%d).initDisp.initLinDisp = %s; \r\n',num,mat2str(str2num(maskVars.initLinDisp)));
        fprintf(fid,'pto(%d).hardStops.upperLimitSpecify = %s; \r\n',num,mat2str(maskVars.upperLimitSpecify));
        fprintf(fid,'pto(%d).hardStops.upperLimitBound = %f; \r\n',num,str2num(maskVars.upperLimitBound));
        fprintf(fid,'pto(%d).hardStops.upperLimitStiffness = %f; \r\n',num,str2num(maskVars.upperLimitStiffness));
        fprintf(fid,'pto(%d).hardStops.upperLimitDamping = %f; \r\n',num,str2num(maskVars.upperLimitDamping));
        fprintf(fid,'pto(%d).hardStops.upperLimitTransitionRegionWidth = %f; \r\n',num,str2num(maskVars.upperLimitTransitionRegionWidth));
        fprintf(fid,'pto(%d).hardStops.lowerLimitSpecify = %s; \r\n',num,mat2str(maskVars.lowerLimitSpecify));
        fprintf(fid,'pto(%d).hardStops.lowerLimitBound = %f; \r\n',num,str2num(maskVars.lowerLimitBound));
        fprintf(fid,'pto(%d).hardStops.lowerLimitStiffness = %f; \r\n',num,str2num(maskVars.lowerLimitStiffness));
        fprintf(fid,'pto(%d).hardStops.lowerLimitDamping = %f; \r\n',num,str2num(maskVars.lowerLimitDamping));
        fprintf(fid,'pto(%d).hardStops.lowerLimitTransitionRegionWidth = %f; \r\n',num,str2num(maskVars.lowerLimitTransitionRegionWidth));
        
        
    elseif isfield(maskVars,'mooring') && isfield(maskVars,'stiffness')
        % Block is a Mooring system
        fprintf(fid,'\r\n%s\r\n','%% Mooring Class');
        
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'mooring(%d) = mooringClass(''mooring%d''); \r\n',num,num);
        fprintf(fid,'mooring(%d).ref = %s; \r\n',num,mat2str(str2num(maskVars.ref)));
        fprintf(fid,'mooring(%d).matrix.k = %s; \r\n',num,mat2str(str2num(maskVars.stiffness)));
        fprintf(fid,'mooring(%d).matrix.c = %s; \r\n',num,mat2str(str2num(maskVars.damping)));
        fprintf(fid,'mooring(%d).matrix.preTension = %s; \r\n',num,mat2str(str2num(maskVars.preTension)));
        
    elseif isfield(maskVars,'mooring') && isfield(maskVars,'moorDynlines')
        % Block is a Mooring system
        fprintf(fid,'\r\n%s\r\n','%% Mooring Class');
        
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


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

% create default classes to compare values against
simu = simulationClass();
waves = waveClass('');
body = bodyClass('');
constraint = constraintClass('');
pto = ptoClass('');
mooring = mooringClass('');

% Get write each mask to an input file section
for i=1:length(blocks)
    names = get_param(blocks{i},'MaskNames');
    values = get_param(blocks{i},'MaskValues');
    visibilities = get_param(blocks{i},'MaskVisibilities');
    
    % Create struct with mask variable name/value pairs
    maskVars = struct();
    maskViz = struct();
    for j = 1:length(names)
        % check if the value should be converted from a string to a float
        tmp = str2num(values{j});
        if ~isempty(tmp)
            values{j} = str2num(values{j});
        end
        
        % convert matlab to string to write to input file correctly
        values{j} = mat2str(values{j});
        maskVars.(names{j}) = values{j};
        maskViz.(names{j}) = visibilities{j};
    end; clear j;
    
    if isfield(maskVars,'simu') && isfield(maskVars,'waves')
        % Block is Global Reference Frame
        fprintf(fid,'\r\n%s\r\n','%% Simulation Class');
        fprintf(fid,'simu = simulationClass(); \r\n');
        fprintf(fid,'simu.simMechanicsFile = ''%s.slx''; \r\n',bdroot);
        
        fprintf(fid,writeLineFromVar(simu, 'mode', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(simu, 'explorer', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(simu, 'startTime', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(simu, 'rampTime', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(simu, 'endTime', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(simu, 'solver', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(simu, 'dt', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(simu, 'CITime', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(simu, 'ssCalc', maskVars, maskViz, [], []));
        
        % Wave Information 
        fprintf(fid,'\r\n%s\r\n','%% Wave Class');
        fprintf(fid,'waves = waveClass(%s); \r\n',maskVars.WaveClass);
        
        fprintf(fid,writeLineFromVar(waves, 'H', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(waves, 'T', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(waves, 'waveDir', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(waves, 'waveSpread', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(waves, 'spectrumType', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(waves, 'freqDisc', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(waves, 'spectrumDataFile', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(waves, 'phaseSeed', maskVars, maskViz, [], []));
        fprintf(fid,writeLineFromVar(waves, 'etaDataFile', maskVars, maskViz, [], []));
            

    elseif isfield(maskVars,'body')
        % Block is a body
        fprintf(fid,'\r\n%s\r\n','%% Body Class');
        
        tmp = string(maskVars.body);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'body(%d) = bodyClass(%s); \r\n',num,maskVars.h5File);
        
        fprintf(fid,writeLineFromVar(body, 'geometryFile', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(body, 'mass', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(body, 'momOfInertia', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(body, 'nhBody', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(body, 'flexHydroBody', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(body, 'cg', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(body, 'cb', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(body, 'dof', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(body, 'dispVol', maskVars, maskViz, num, []));
        
        fprintf(fid,writeLineFromVar(body, 'initLinDisp', maskVars, maskViz, num, 'initDisp'));
        fprintf(fid,writeLineFromVar(body, 'initAngularDispAxis', maskVars, maskViz, num, 'initDisp'));
        fprintf(fid,writeLineFromVar(body, 'initAngularDispAngle', maskVars, maskViz, num, 'initDisp'));
        
        fprintf(fid,writeLineFromVar(body, 'option', maskVars, maskViz, num, 'morisonElement'));
        fprintf(fid,writeLineFromVar(body, 'cd', maskVars, maskViz, num, 'morisonElement'));
        fprintf(fid,writeLineFromVar(body, 'ca', maskVars, maskViz, num, 'morisonElement'));
        fprintf(fid,writeLineFromVar(body, 'characteristicArea', maskVars, maskViz, num, 'morisonElement'));
        fprintf(fid,writeLineFromVar(body, 'VME', maskVars, maskViz, num, 'morisonElement'));
        fprintf(fid,writeLineFromVar(body, 'rgME', maskVars, maskViz, num, 'morisonElement'));
        fprintf(fid,writeLineFromVar(body, 'z', maskVars, maskViz, num, 'morisonElement'));
        
    elseif isfield(maskVars,'constraint')
        % Block is a constraint
        fprintf(fid,'\r\n%s\r\n','%% Constraint Class');
        
        tmp = string(maskVars.constraint);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'constraint(%d) = constraintClass(''constraint%d''); \r\n',num,num);
        
        fprintf(fid,writeLineFromVar(constraint, 'loc', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(constraint, 'y', maskVars, maskViz, num, 'orientation'));
        fprintf(fid,writeLineFromVar(constraint, 'z', maskVars, maskViz, num, 'orientation'));
        fprintf(fid,writeLineFromVar(constraint, 'initLinDisp', maskVars, maskViz, num, 'initDisp'));
        fprintf(fid,writeLineFromVar(constraint, 'upperLimitSpecify', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(constraint, 'upperLimitBound', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(constraint, 'upperLimitStiffness', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(constraint, 'upperLimitDamping', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(constraint, 'upperLimitTransitionRegionWidth', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(constraint, 'lowerLimitSpecify', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(constraint, 'lowerLimitBound', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(constraint, 'lowerLimitStiffness', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(constraint, 'lowerLimitDamping', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(constraint, 'lowerLimitTransitionRegionWidth', maskVars, maskViz, num, 'hardStops'));

    elseif isfield(maskVars,'pto')
        % Block is a PTO
        fprintf(fid,'\r\n%s\r\n','%% PTO Class');
        
        tmp = string(maskVars.pto);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'pto(%d) = ptoClass(''pto%d''); \r\n',num,num);
        
        fprintf(fid,writeLineFromVar(pto, 'k', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(pto, 'c', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(pto, 'loc', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(pto, 'y', maskVars, maskViz, num, 'orientation'));
        fprintf(fid,writeLineFromVar(pto, 'z', maskVars, maskViz, num, 'orientation'));
        fprintf(fid,writeLineFromVar(pto, 'initLinDisp', maskVars, maskViz, num, 'initDisp'));
        fprintf(fid,writeLineFromVar(pto, 'upperLimitSpecify', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(pto, 'upperLimitBound', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(pto, 'upperLimitStiffness', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(pto, 'upperLimitDamping', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(pto, 'upperLimitTransitionRegionWidth', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(pto, 'lowerLimitSpecify', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(pto, 'lowerLimitBound', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(pto, 'lowerLimitStiffness', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(pto, 'lowerLimitDamping', maskVars, maskViz, num, 'hardStops'));
        fprintf(fid,writeLineFromVar(pto, 'lowerLimitTransitionRegionWidth', maskVars, maskViz, num, 'hardStops'));
        
    elseif isfield(maskVars,'mooring') && isfield(maskVars,'stiffness')
        % Block is a Mooring system
        fprintf(fid,'\r\n%s\r\n','%% Mooring Class');
        
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'mooring(%d) = mooringClass(''mooring%d''); \r\n',num,num);
        
        fprintf(fid,writeLineFromVar(mooring, 'ref', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(mooring, 'k', maskVars, maskViz, num, 'matrix'));
        fprintf(fid,writeLineFromVar(mooring, 'c', maskVars, maskViz, num, 'matrix'));
        fprintf(fid,writeLineFromVar(mooring, 'preTension', maskVars, maskViz, num, 'matrix'));
        
    elseif isfield(maskVars,'mooring') && isfield(maskVars,'moorDynlines')
        % Block is a Mooring system
        fprintf(fid,'\r\n%s\r\n','%% Mooring Class');
        
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        fprintf(fid,'mooring(%d) = mooringClass(''mooring%d''); \r\n',num,num);
        
        fprintf(fid,writeLineFromVar(mooring, 'ref', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(mooring, 'moorDynLines', maskVars, maskViz, num, []));
        fprintf(fid,writeLineFromVar(mooring, 'moorDynNodes', maskVars, maskViz, num, []));
    end
    clear names values maskVars
end

fclose(fid);

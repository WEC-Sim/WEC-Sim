function writeInputFromBlocks(inputFile)
% This function reads custom parameters from masked WEC-Sim blocks, and 
% writes a new wecSimInputFile.m based on the mask variables. 
% 
% Steps:
% 1. Blocks are reordered into the standard WEC-Sim input file order
%    (simu, waves, body, constraint, pto, cable, mooring)
% 2. Open a new output file and create default classes
% 3. For every mask variable, call the writeLineFromVar() function for 
%    that block to determine the appropriate string for the input file
% 
% Note: str2num used because mask parameters are always read as type 'char'
% Note: mat2str used so that types are printed in the correct format

% Get all block names
blocks = find_system(bdroot,'Type','Block');

%% Reorder blocks 
% Order blocks by class:
%    simu/waves, body, constraints, ptos, cables, moorings
iSimulation = [];
iBody = [];
iConstraint = [];
iPTO = [];
iCable = [];
iMooring = [];

for i=1:length(blocks)
    names = get_param(blocks{i},'MaskNames');
    if any(strcmp(names,'simu'))
        iSimulation = i;
    elseif any(strcmp(names,'body'))
        iBody(end+1) = i;
    elseif any(strcmp(names,'constraint'))
        iConstraint(end+1) = i;
    elseif any(strcmp(names,'pto'))
        iPTO(end+1) = i;
    elseif any(strcmp(names,'cable'))
        iCable(end+1) = i;
    elseif any(strcmp(names,'mooring'))
        iMooring(end+1) = i;
    end
end


% Order classes by number
iSorted = sortBlocksByNumber(blocks(iBody),'body');
iBody = iBody(iSorted);

iSorted = sortBlocksByNumber(blocks(iConstraint),'constraint');
iConstraint = iConstraint(iSorted);

iSorted = sortBlocksByNumber(blocks(iPTO),'pto');
iPTO = iPTO(iSorted);

iSorted = sortBlocksByNumber(blocks(iCable),'cable');
iCable = iCable(iSorted);

iSorted = sortBlocksByNumber(blocks(iMooring),'mooring');
iMooring = iMooring(iSorted);

% Order blocks
ind = [iSimulation iBody iConstraint iPTO iCable iMooring];
blocks = blocks(ind);

%% Write input file
fid = fopen(['./' inputFile '.m'],'w');
fprintf(fid,'%% %s\r\n','WEC-Sim Input File, written with custom Simulink parameters');
fprintf(fid,'%% %s\r\n',string(datetime));

% create default classes to compare values against
simu = simulationClass();
waves = waveClass('');
body = bodyClass('');
constraint = constraintClass('');
pto = ptoClass('');
cable = cableClass('','constraint','pto');
mooring = mooringClass('');

%% Write each mask to an input file section
for i = 1:length(blocks)
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
        writeLineFromVar(fid, simu, 'mode', maskVars, maskViz, [], []);
        writeLineFromVar(fid, simu, 'explorer', maskVars, maskViz, [], []);
        writeLineFromVar(fid, simu, 'startTime', maskVars, maskViz, [], []);
        writeLineFromVar(fid, simu, 'rampTime', maskVars, maskViz, [], []);
        writeLineFromVar(fid, simu, 'endTime', maskVars, maskViz, [], []);
        writeLineFromVar(fid, simu, 'solver', maskVars, maskViz, [], []);
        writeLineFromVar(fid, simu, 'dt', maskVars, maskViz, [], []);
        writeLineFromVar(fid, simu, 'cicEndTime', maskVars, maskViz, [], []);
        writeLineFromVar(fid, simu, 'stateSpace', maskVars, maskViz, [], []);
        
        % Wave Information 
        fprintf(fid,'\r\n%s\r\n','%% Wave Class');
        fprintf(fid,'waves = waveClass(%s); \r\n',maskVars.WaveClass);
        writeLineFromVar(fid, waves, 'height', maskVars, maskViz, [], []);
        writeLineFromVar(fid, waves, 'period', maskVars, maskViz, [], []);
        writeLineFromVar(fid, waves, 'direction', maskVars, maskViz, [], []);
        writeLineFromVar(fid, waves, 'spread', maskVars, maskViz, [], []);
        writeLineFromVar(fid, waves, 'spectrumType', maskVars, maskViz, [], []);
        writeLineFromVar(fid, waves, 'option', maskVars, maskViz, [], 'bem');
        writeLineFromVar(fid, waves, 'spectrumFile', maskVars, maskViz, [], []);
        writeLineFromVar(fid, waves, 'phaseSeed', maskVars, maskViz, [], []);
        writeLineFromVar(fid, waves, 'elevationFile', maskVars, maskViz, [], []);

    elseif isfield(maskVars,'body')
        % Block is a body
        fprintf(fid,'\r\n%s\r\n','%% Body Class');        
        tmp = string(maskVars.body);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));

        fprintf(fid,'body(%d) = bodyClass(%s); \r\n',num,maskVars.h5File);
        writeLineFromVar(fid, body, 'geometryFile', maskVars, maskViz, num, []);
        writeLineFromVar(fid, body, 'mass', maskVars, maskViz, num, []);
        writeLineFromVar(fid, body, 'inertia', maskVars, maskViz, num, []);
        writeLineFromVar(fid, body, 'inertiaProducts', maskVars, maskViz, num, []);
        writeLineFromVar(fid, body, 'nonHydro', maskVars, maskViz, num, []);
        writeLineFromVar(fid, body, 'nonlinearHydro', maskVars, maskViz, num, []);
        writeLineFromVar(fid, body, 'flex', maskVars, maskViz, num, []);
        writeLineFromVar(fid, body, 'QTFs', maskVars, maskViz, num, []);
        writeLineFromVar(fid, body, 'centerGravity', maskVars, maskViz, num, []);
        writeLineFromVar(fid, body, 'centerBuoyancy', maskVars, maskViz, num, []);
        writeLineFromVar(fid, body, 'dof', maskVars, maskViz, num, []);
        writeLineFromVar(fid, body, 'volume', maskVars, maskViz, num, []);        
        writeLineFromVar(fid, body, 'displacement', maskVars, maskViz, num, 'initial');
        writeLineFromVar(fid, body, 'axis', maskVars, maskViz, num, 'initial');
        writeLineFromVar(fid, body, 'angle', maskVars, maskViz, num, 'initial');        
        writeLineFromVar(fid, body, 'option', maskVars, maskViz, num, 'morisonElement');
        writeLineFromVar(fid, body, 'cd', maskVars, maskViz, num, 'morisonElement');
        writeLineFromVar(fid, body, 'ca', maskVars, maskViz, num, 'morisonElement');
        writeLineFromVar(fid, body, 'area', maskVars, maskViz, num, 'morisonElement');
        writeLineFromVar(fid, body, 'VME', maskVars, maskViz, num, 'morisonElement');
        writeLineFromVar(fid, body, 'rgME', maskVars, maskViz, num, 'morisonElement');
        writeLineFromVar(fid, body, 'z', maskVars, maskViz, num, 'morisonElement');
        
    elseif isfield(maskVars,'constraint')
        % Block is a constraint
        fprintf(fid,'\r\n%s\r\n','%% Constraint Class');        
        tmp = string(maskVars.constraint);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));

        fprintf(fid,'constraint(%d) = constraintClass(''constraint%d''); \r\n',num,num);
        fprintf(fid,['constraint(%d).location = ' maskVars.loc '; \r\n'],num); % custom mask variable cannot be called 'location', so this variable has a special print statement
        writeLineFromVar(fid, constraint, 'y', maskVars, maskViz, num, 'orientation');
        writeLineFromVar(fid, constraint, 'z', maskVars, maskViz, num, 'orientation');
        writeLineFromVar(fid, constraint, 'displacement', maskVars, maskViz, num, 'initial');
        writeLineFromVar(fid, constraint, 'upperLimitSpecify', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, constraint, 'upperLimitBound', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, constraint, 'upperLimitStiffness', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, constraint, 'upperLimitDamping', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, constraint, 'upperLimitTransitionRegionWidth', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, constraint, 'lowerLimitSpecify', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, constraint, 'lowerLimitBound', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, constraint, 'lowerLimitStiffness', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, constraint, 'lowerLimitDamping', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, constraint, 'lowerLimitTransitionRegionWidth', maskVars, maskViz, num, 'hardStops');

    elseif isfield(maskVars,'pto')
        % Block is a PTO
        fprintf(fid,'\r\n%s\r\n','%% PTO Class');        
        tmp = string(maskVars.pto);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));

        fprintf(fid,'pto(%d) = ptoClass(''pto%d''); \r\n',num,num);
        writeLineFromVar(fid, pto, 'stiffness', maskVars, maskViz, num, []);
        writeLineFromVar(fid, pto, 'damping', maskVars, maskViz, num, []);
        fprintf(fid,['pto(%d).location = ' maskVars.loc '; \r\n'],num); % custom mask variables cannot be called 'location', so this variable has a special print statement
        writeLineFromVar(fid, pto, 'y', maskVars, maskViz, num, 'orientation');
        writeLineFromVar(fid, pto, 'z', maskVars, maskViz, num, 'orientation');
        writeLineFromVar(fid, pto, 'displacement', maskVars, maskViz, num, 'initial');
        writeLineFromVar(fid, pto, 'upperLimitSpecify', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, pto, 'upperLimitBound', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, pto, 'upperLimitStiffness', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, pto, 'upperLimitDamping', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, pto, 'upperLimitTransitionRegionWidth', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, pto, 'lowerLimitSpecify', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, pto, 'lowerLimitBound', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, pto, 'lowerLimitStiffness', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, pto, 'lowerLimitDamping', maskVars, maskViz, num, 'hardStops');
        writeLineFromVar(fid, pto, 'lowerLimitTransitionRegionWidth', maskVars, maskViz, num, 'hardStops');
        
    elseif isfield(maskVars,'cable')
        % Block is a cable
        fprintf(fid,'\r\n%s\r\n','%% Cable Class');        
        tmp = string(maskVars.cable);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        
        fprintf(fid,'cable(%d) = cableClass(''cable%d'',%s,%s); \r\n',num,num,...
            maskVars.baseName,maskVars.followerName);        
        writeLineFromVar(fid, cable, 'stiffness', maskVars, maskViz, num, []);
        writeLineFromVar(fid, cable, 'damping', maskVars, maskViz, num, []);
        writeLineFromVar(fid, cable, 'L0', maskVars, maskViz, num, []);
        writeLineFromVar(fid, cable, 'preTension', maskVars, maskViz, num, []);
        writeLineFromVar(fid, cable, 'y', maskVars, maskViz, num, 'orientation');
        writeLineFromVar(fid, cable, 'z', maskVars, maskViz, num, 'orientation');
        writeLineFromVar(fid, cable, 'displacement', maskVars, maskViz, num, 'initial');
        writeLineFromVar(fid, cable, 'axis', maskVars, maskViz, num, 'initial');
        writeLineFromVar(fid, cable, 'angle', maskVars, maskViz, num, 'initial');
        
    elseif isfield(maskVars,'mooring') && isfield(maskVars,'stiffness')
        % Block is a Mooring system
        fprintf(fid,'\r\n%s\r\n','%% Mooring Class');        
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        
        fprintf(fid,'mooring(%d) = mooringClass(''mooring%d''); \r\n',num,num);        
        fprintf(fid,['mooring(%d).location = ' maskVars.loc '; \r\n'],num); % custom mask variable cannot be called 'location', so this variable has a special print statement
        writeLineFromVar(fid, mooring, 'stiffness', maskVars, maskViz, num, 'matrix');
        writeLineFromVar(fid, mooring, 'damping', maskVars, maskViz, num, 'matrix');
        writeLineFromVar(fid, mooring, 'preTension', maskVars, maskViz, num, 'matrix');
        
    elseif isfield(maskVars,'mooring') && isfield(maskVars,'moorDynlines')
        % Block is a Mooring system
        fprintf(fid,'\r\n%s\r\n','%% Mooring Class');
        tmp = string(maskVars.mooring);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));

        fprintf(fid,'mooring(%d) = mooringClass(''mooring%d''); \r\n',num,num);        
        fprintf(fid,['mooring(%d).location = ' maskVars.loc '; \r\n'],num); % custom mask variable cannot be called 'location', so this variable has a special print statement
        writeLineFromVar(fid, mooring, 'moorDynLines', maskVars, maskViz, num, []);
        writeLineFromVar(fid, mooring, 'moorDynNodes', maskVars, maskViz, num, []);
    end
    clear names values maskVars
end

fclose(fid);

end

function iSorted = sortBlocksByNumber(blockList, className)
    % This function takes in a list of blocks (bodies or ptos or
    % constraints, but not bodies and ptos, etc) and orders the blocks
    % based on the class number
    classNums = [];
    for i=1:length(blockList)
        mask = Simulink.Mask.get(blockList{i});
        tmp = string(mask.getParameter(className).Value);
        num = str2num(extractBetween(tmp,strfind(tmp,'('),strfind(tmp,')'),'Boundaries','Exclusive'));
        classNums(i) = num;
    end
    [~,iSorted] = sort(classNums,'ascend');
    
end


% Script to write the custom parameters set in Simulink to an input file
% for reference. This script only runs if custom parameters are set in
% Simulink. It does not run if the simulation is run using wecSim.m or if
% the option to use a specific wecSimInputFile.m is chosen in the Global
% Reference Frame block.

% Get default parameters.
default_simu = simulationClass();
default_wave = waveClass('');
default_body = bodyClass('');
default_pto = ptoClass('');
default_constraint = constraintClass('');
default_mooring = mooringClass('');

% New input file. Write header
fid = fopen('./testin.m','w');
fprintf(fid,'%% %s\r\n','WEC-Sim Input File, written with custom Simulink parameters');
fprintf(fid,'%% %s\r\n',string(datetime));

if exist('simu','var')
    fprintf(fid,'%s\r\n','%% Simulation Class');
    fprintf(fid,'simu = simulationClass(); \r\n');
    
    props_def = properties(default_simu);
    props = properties(simu);
    
    for j=1:length(props)
        if ~isequal(simu.(props{j}),default_simu.(props{j}))
            if isa(simu.(props{j}),'string')
                fprintf(fid,'%s.%s = ''%s''; \r\n','simu',props{j},simu.(props{j}));
            elseif isa(simu.(props{j}),'float') && length(simu.(props{j}))==1
                fprintf(fid,'%s.%s = %f; \r\n','simu',props{j},simu.(props{j}));
            end
        end
    end
end

if exist('waves','var')
    fprintf(fid,'\r\n%s\r\n','%% Wave Class');
    fprintf(fid,'waves = waveClass(''%s''); \r\n',waves.type);
    
    props_def = properties(default_wave);
    props = properties(waves);
    
	for j=1:length(props)
        if ~isequal(waves.(props{j}),default_wave.(props{j}))
            if isa(waves.(props{j}),'string')
                fprintf(fid,'%s.%s = ''%s''; \r\n','waves',props{j},waves.(props{j}));
            elseif isa(waves.(props{j}),'float') && length(waves.(props{j}))==1
                fprintf(fid,'%s.%s = %f; \r\n','waves',props{j},waves.(props{j}));
            elseif isa(waves.(props{j}),'float') && length(waves.(props{j}))==2
                fprintf(fid,'%s.%s = [%f %f]; \r\n','waves',props{j},waves.(props{j}));
            end
        end
    end
end

if exist('body','var')
    fprintf(fid,'\r\n%s\r\n','%% Body Class');
    
    props_def = properties(default_body);
    
	for i = 1:length(body)
        fprintf(fid,'body(%d) = bodyClass(''%s''); \r\n',i,body(i).name);
        
        props = properties(body(i));
        
        for j=1:length(props)
            if ~isequal(body(i).(props{j}),default_body.(props{j}))
                if isa(body(i).(props{j}),'string')
                    fprintf(fid,'%s(%d).%s = ''%s''; \r\n','body',i,props{j},body(i).(props{j}));
                elseif isa(body(i).(props{j}),'float') && length(body(i).(props{j}))==1
                    fprintf(fid,'%s(%d).%s = %f; \r\n','body',i,props{j},body(i).(props{j}));
                elseif isa(body(i).(props{j}),'float') && length(body(i).(props{j}))~=1
                    fprintf(fid,'%s(%d).%s = [%f %f %f]; \r\n','body',i,props{j},body(i).(props{j}));
                end
            end
        end
	end
end

if exist('constraint','var')
    fprintf(fid,'\r\n%s\r\n','%% Constraint Class');
    
    props_def = properties(default_constraint);
    
	for i = 1:length(constraint)
        fprintf(fid,'constraint(%d) = constraintClass(''%s''); \r\n',i,constraint(i).name);
        
        props = properties(constraint(i));
        
        for j=1:length(props)
            if ~isequal(constraint(i).(props{j}),default_constraint.(props{j}))
                if isa(constraint(i).(props{j}),'string')
                    fprintf(fid,'%s(%d).%s = ''%s''; \r\n','constraint',i,props{j},constraint(i).(props{j}));
                elseif isa(constraint(i).(props{j}),'float') && length(constraint(i).(props{j}))==1
                    fprintf(fid,'%s(%d).%s = %f; \r\n','constraint',i,props{j},constraint(i).(props{j}));
                elseif isa(constraint(i).(props{j}),'float') && length(constraint(i).(props{j}))~=1
                    fprintf(fid,'%s(%d).%s = [%f %f %f]; \r\n','constraint',i,props{j},constraint(i).(props{j}));
                end
            end
        end
	end
end

if exist('pto','var')
    fprintf(fid,'\r\n%s\r\n','%% PTO Class');
    
    props_def = properties(default_pto);
    
	for i = 1:length(pto)
        fprintf(fid,'pto(%d) = ptoClass(''%s''); \r\n',i,pto(i).name);
        
        props = properties(pto(i));
        
        for j=1:length(props)
            if ~isequal(pto(i).(props{j}),default_pto.(props{j}))
                if isa(pto(i).(props{j}),'string')
                    fprintf(fid,'%s(%d).%s = ''%s''; \r\n','pto',i,props{j},pto(i).(props{j}));
                elseif isa(pto(i).(props{j}),'float') && length(pto(i).(props{j}))==1
                    fprintf(fid,'%s(%d).%s = %f; \r\n','pto',i,props{j},pto(i).(props{j}));
                elseif isa(pto(i).(props{j}),'float') && length(pto(i).(props{j}))~=1
                    fprintf(fid,'%s(%d).%s = [%f %f %f]; \r\n','pto',i,props{j},pto(i).(props{j}));
                end
            end
        end
	end
end

if exist('mooring','var')
    fprintf(fid,'\r\n%s\r\n','%% Mooring Class');
    
    props_def = properties(default_mooring);
    
	for i = 1:length(mooring)
        fprintf(fid,'mooring(%d) = mooringClass(''%s''); \r\n',i,mooring(i).name);
        
        props = properties(mooring(i));
        
        for j=1:length(props)
            if ~isequal(mooring(i).(props{j}),default_mooring.(props{j}))
                if isa(mooring(i).(props{j}),'string')
                    fprintf(fid,'%s(%d).%s = ''%s''; \r\n','mooring',i,props{j},mooring(i).(props{j}));
                elseif isa(mooring(i).(props{j}),'float') && length(mooring(i).(props{j}))==1
                    fprintf(fid,'%s(%d).%s = %f; \r\n','mooring',i,props{j},mooring(i).(props{j}));
                elseif isa(mooring(i).(props{j}),'float') && length(mooring(i).(props{j}))~=1
                    fprintf(fid,'%s(%d).%s = [%f %f %f]; \r\n','mooring',i,props{j},mooring(i).(props{j}));
                end
            end
        end
    end
end


fclose(fid);

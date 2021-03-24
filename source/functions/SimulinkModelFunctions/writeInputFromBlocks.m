% Script to write the custom parameters set in Simulink to an input file
% for reference. This script only runs if custom parameters are set in
% Simulink. It does not run if the simulation is run using wecSim.m or if
% the option to use a specific wecSimInputFile.m is chosen in the Global
% Reference Frame block.

% Get default parameters.
default_simu = simulationClass();
default_simu.setupSim();
default_wave = waveClass('');
default_body = bodyClass('');
default_pto = ptoClass('');
default_constraint = constraintClass('');
default_mooring = mooringClass('');

% New input file. Write header
fid = fopen('./wecSimInputFile_simulinkCustomParameters.m','w');
fprintf(fid,'%% %s\r\n','WEC-Sim Input File, written with custom Simulink parameters');
fprintf(fid,'%% %s\r\n',string(datetime));

if exist('simu','var')
    fprintf(fid,'%s\r\n','%% Simulation Class');
    fprintf(fid,'simu = simulationClass(); \r\n');
    
    props = properties(simu);
    
    for j=1:length(props)
        if ~isequal(simu.(props{j}),default_simu.(props{j}))
            try
                default_simu.(props{j}) = 0; % test that property setAccess is public
                fprintf(fid,'%s.%s = %s; \r\n','simu',props{j},mat2str(simu.(props{j})));
            end
        end
    end
end

if exist('waves','var')
    fprintf(fid,'\r\n%s\r\n','%% Wave Class');
    fprintf(fid,'waves = waveClass(''%s''); \r\n',waves.type);
    
    props = properties(waves);
    
	for j=1:length(props)
        if ~isequal(waves.(props{j}),default_wave.(props{j})) && ~any(isnan(waves.(props{j})))
            try
                default_wave.(props{j}) = 0; % test that property setAccess is public
                fprintf(fid,'%s.%s = %s; \r\n','waves',props{j},mat2str(waves.(props{j})));
            end
        end
    end
end

if exist('body','var')
    fprintf(fid,'\r\n%s\r\n','%% Body Class');
    
	for i = 1:length(body)
        fprintf(fid,'body(%d) = bodyClass(''%s''); \r\n',i,body(i).name);
        
        props = properties(body(i));
        
        for j=1:length(props)
            if ~isequal(body(i).(props{j}),default_body.(props{j}))
                try
                    default_body.(props{j}) = 0; % test that property setAccess is public
                    fprintf(fid,'%s(%d).%s = %s; \r\n','body',i,props{j},mat2str(body(i).(props{j})));
                end
            end
        end
	end
end

if exist('constraint','var')
    fprintf(fid,'\r\n%s\r\n','%% Constraint Class');
    
	for i = 1:length(constraint)
        fprintf(fid,'constraint(%d) = constraintClass(''%s''); \r\n',i,constraint(i).name);
        
        props = properties(constraint(i));
        
        for j=1:length(props)
            if ~isequal(constraint(i).(props{j}),default_constraint.(props{j}))
                try
                    default_constraint.(props{j}) = 0; % test that property setAccess is public
                    fprintf(fid,'%s(%d).%s = %s; \r\n','constraint',i,props{j},mat2str(constraint(i).(props{j})));
                end
            end
        end
	end
end

if exist('pto','var')
    fprintf(fid,'\r\n%s\r\n','%% PTO Class');
    
	for i = 1:length(pto)
        fprintf(fid,'pto(%d) = ptoClass(''%s''); \r\n',i,pto(i).name);
        
        props = properties(pto(i));
        
        for j=1:length(props)
            if ~isequal(pto(i).(props{j}),default_pto.(props{j}))
                try
                    default_pto.(props{j}) = 0; % test that property setAccess is public
                    fprintf(fid,'%s(%d).%s = %s; \r\n','pto',i,props{j},mat2str(pto(i).(props{j})));
                end
            end
        end
	end
end

if exist('mooring','var')
    fprintf(fid,'\r\n%s\r\n','%% Mooring Class');
    
	for i = 1:length(mooring)
        fprintf(fid,'mooring(%d) = mooringClass(''%s''); \r\n',i,mooring(i).name);
        
        props = properties(mooring(i));
        
        for j=1:length(props)
            if ~isequal(mooring(i).(props{j}),default_mooring.(props{j}))
                try
                    default_mooring.(props{j}) = 0; % test that property setAccess is public
                    fprintf(fid,'%s(%d).%s = %s; \r\n','mooring',i,props{j},mat2str(mooring(i).(props{j})));
                end
            end
        end
    end
end

fclose(fid);
clear default_* props

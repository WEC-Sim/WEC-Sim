function hydro = readWAMIT(hydro,filename,exCoeff)
% Reads data from a WAMIT output file.
% 
% If generalized body modes are used, the output directory must also 
% include the `*.cfg`, `*.mmx`, and `*.hst` files.
% If simu.nonlinearHydro = 3 will be used, the output directory must also
% include the `*.3fk` and `*.3sc` files.
% 
% See ``WEC-Sim/examples/BEMIO/WAMIT`` for examples of usage.
% 
% Parameters
% ----------
%     hydro : struct
%         Structure of hydro data that WAMIT input data will be appended to
%
%     filename : string
%         Path to the WAMIT output file
%
%     exCoeff : integer
%         Flag indicating the type of excitation force coefficients to
%         read, ‘diffraction’ (default), ‘haskind’, or ‘rao’
% 
% Returns
% -------
%     hydro : struct
%         Structure of hydro data with WAMIT data appended
% 

%% 
[a,b] = size(hydro);  % Check on what is already there
if b == 1 && ~isfield(hydro(b),'Nb')
    F = 1;
elseif b >= 1
    F = b+1;
end

p = waitbar(0,'Reading WAMIT output file...');  % Progress bar
e = 0;

if isempty(exCoeff)==1;  exCoeff = 'diffraction';  end  % 'diffraction' or 'haskind'

hydro(F).code = 'WAMIT';
[filepath,name,ext] = fileparts(filename);
hydro(F).file = name;  % Base name

fileID = fopen(filename);
raw = textscan(fileID,'%[^\n\r]');  % Read/copy raw output
raw = raw{:};
fclose(fileID);

hydro(F).rho = 1000;  % Set density value
N = length(raw);
hydro(F).Nf = 0;  % Number of wave frequencies
hydro(F).Nb = 0;  % Number of bodies
k = 0;
for n = 1:N
    if ((isempty(strfind(raw{n},'Input from Geometric Data File'))==0 | isempty(strfind(raw{n},'N='))==0) &...
            (isempty(strfind(raw{n},'.GDF'))==0 | isempty(strfind(raw{n},'.gdf'))==0))
        k = k+1;
        tmp = strsplit(raw{n},{' ','.'});
        tmp(cellfun('isempty',tmp)) = [];
        hydro(F).body(k) = tmp(length(tmp)-1);  % Body names
    end
    if isempty(strfind(raw{n},'Gravity:'))==0
        tmp = textscan(raw{n},'%s %f %s %s %f');
        hydro(F).g = tmp{2};  % Gravity
    end
    if isempty(strfind(raw{n},'Water depth:'))==0
        tmp = textscan(raw{n},'%s %s %f %s %s %f','TreatAsEmpty',{'infinite'},'EmptyValue',Inf);
        hydro(F).h = tmp{3};  % Water depth
    end
    if isempty(strfind(raw{n},'XBODY ='))==0
        hydro(F).Nb = hydro(F).Nb+1;
        tmp = textscan(raw{n},'%s %s %f %s %s %f %s %s %f %s %s %f');
        hydro(F).cg(:,hydro(F).Nb) = [tmp{3} tmp{6} tmp{9}];  % Center of gravity
    end
    if isempty(strfind(raw{n},'Volumes (VOLX,VOLY,VOLZ):'))==0
        tmp = textscan(raw{n}(find(raw{n}==':')+1:end),'%f');
        hydro(F).Vo(hydro(F).Nb) = median(tmp{:});  % Displacement volume
    end
    if isempty(strfind(raw{n},'Center of Buoyancy (Xb,Yb,Zb):'))==0
        tmp = textscan(raw{n}(find(raw{n}==':')+1:end),'%f');
        hydro(F).cb(:,hydro(F).Nb) = hydro(F).cg(:,hydro(F).Nb) + tmp{1};  % Center of buoyancy
    end
    if isempty(strfind(raw{n},'Hydrostatic and gravitational'))==0
        hydro(F).Khs(:,:,hydro(F).Nb) = zeros(6,6);  % Linear restoring stiffness
        tmp = textscan(raw{n+1}(find(raw{n+1}==':')+1:end),'%f');
        hydro(F).Khs(3,3:5,hydro(F).Nb) = tmp{1};
        hydro(F).Khs(3:5,3,hydro(F).Nb) = tmp{1};
        tmp = textscan(raw{n+2}(find(raw{n+2}==':')+1:end),'%f');
        hydro(F).Khs(4,4:6,hydro(F).Nb) = tmp{1};
        hydro(F).Khs(4:5,4,hydro(F).Nb) = tmp{1}(1:2);
        tmp = textscan(raw{n+3}(find(raw{n+3}==':')+1:end),'%f');
        hydro(F).Khs(5,5:6,hydro(F).Nb) = tmp{1};
    end
    if isempty(strfind(raw{n},'Wave period'))==0
        if isempty(strfind(raw{n},'Wave period = infinite'))==0  T = 0;  end
        if isempty(strfind(raw{n},'Wave period = zero'))==0  T = 1;  end
        if isempty(strfind(raw{n},'Wave period (sec)'))==0
            T = 2;
            hydro(F).Nf = hydro(F).Nf+1;
            tmp = textscan(raw{n}(find(raw{n}=='=')+1:end),'%f');
            hydro(F).T(hydro(F).Nf) = tmp{1};  % Wave periods
            hydro(F).w(hydro(F).Nf) = 2*pi/tmp{1};  % Wave frequencies
        end
        i = 4;
        while (isempty(strfind(raw{n+i},'*******************************'))~=0 & ...
                isempty(strfind(raw{n+i},'EXCITING FORCES AND MOMENTS'))~=0 & ...
                isempty(strfind(raw{n+i},'RESPONSE AMPLITUDE OPERATORS'))~=0)
            tmp = textscan(raw{n+i},'%f');
            if T==0
                A0(tmp{1}(1),tmp{1}(2)) = tmp{1}(3);  % Added mass, inf T (zero f)
            end
            if T==1
                hydro(F).Ainf(tmp{1}(1),tmp{1}(2)) = tmp{1}(3);  % Added mass, zero T (inf f)
            end
            if T==2
                hydro(F).A(tmp{1}(1),tmp{1}(2),hydro(F).Nf) = tmp{1}(3);  % Added mass
                hydro(F).B(tmp{1}(1),tmp{1}(2),hydro(F).Nf) = tmp{1}(4);  % Radiation damping
            end
            i = i+1;
        end
    end
    if ((isempty(strfind(raw{n},'HASKIND EXCITING FORCES AND MOMENTS'))==0 & ...
            strcmp(exCoeff,'haskind')==1) |...
            (isempty(strfind(raw{n},'DIFFRACTION EXCITING FORCES AND MOMENTS'))==0 & ...
            strcmp(exCoeff,'diffraction')==1) |...
            (isempty(strfind(raw{n},'RESPONSE AMPLITUDE OPERATORS'))==0 & ...
            strcmp(exCoeff,'rao')==1))
        hydro(F).Nh = 0;  % Number of wave headings
        i = n+1;
        while isempty(strfind(raw{i},'Wave Heading'))==0
            hydro(F).Nh = hydro(F).Nh+1;
            tmp = textscan(raw{i}(find(raw{i}==':')+1:end),'%f');
            hydro(F).theta(hydro(F).Nh) = tmp{1};  % Wave headings
            i = i+2;
            while (isempty(strfind(raw{i},'*******************************'))~=0 & ...
                    isempty(strfind(raw{i},'EXCITING FORCES AND MOMENTS'))~=0 & ...
                    isempty(strfind(raw{i},'RESPONSE AMPLITUDE OPERATORS'))~=0 & ...
                    isempty(strfind(raw{i},'SURGE, SWAY & YAW DRIFT FORCES (Momentum Conservation)'))~=0 & ...
                    isempty(strfind(raw{i},'SURGE, SWAY, HEAVE, ROLL, PITCH & YAW DRIFT FORCES (Control Surface)'))~=0 & ...
                    isempty(strfind(raw{i},'Wave Heading'))~=0)
                tmp = textscan(raw{i},'%f');
                ma = tmp{1}(2);  % Magnitude of exciting force
                ph = deg2rad(tmp{1}(3));  % Phase of exciting force
                re = ma.*cos(ph);  % Real part of exciting force
                im = ma.*sin(ph);  % Imaginary part of exciting force
                hydro(F).ex_ma(abs(tmp{1}(1)),hydro(F).Nh,hydro(F).Nf) = ma;
                hydro(F).ex_ph(abs(tmp{1}(1)),hydro(F).Nh,hydro(F).Nf) = ph;
                hydro(F).ex_re(abs(tmp{1}(1)),hydro(F).Nh,hydro(F).Nf) = re;
                hydro(F).ex_im(abs(tmp{1}(1)),hydro(F).Nh,hydro(F).Nf) = im;
                i = i+1;
                if i>N break; end
            end
            if i>N break; end
        end
    end

    if isempty(strfind(raw{n},'SURGE, SWAY & YAW DRIFT FORCES (Momentum Conservation)'))==0
        hydro(F).Nh = 0;  % Number of wave headings
        i = n+1;
        hydro(F).md_mc(:,:,hydro(F).Nf)=hydro(F).ex_ma(:,:,hydro(F).Nf).*0;
        while isempty(strfind(raw{i},'Wave Heading'))==0
            hydro(F).Nh = hydro(F).Nh+1;
            tmp = textscan(raw{i}(find(raw{i}==':')+1:end),'%f');
            hydro(F).theta(hydro(F).Nh) = tmp{1}(1);  % Wave headings
            i = i+2;
            while (isempty(strfind(raw{i},'*******************************'))~=0 & ...
                    isempty(strfind(raw{i},'EXCITING FORCES AND MOMENTS'))~=0 & ...
                    isempty(strfind(raw{i},'RESPONSE AMPLITUDE OPERATORS'))~=0 & ...
                    isempty(strfind(raw{i},'SURGE, SWAY & YAW DRIFT FORCES (Momentum Conservation)'))~=0 & ...
                    isempty(strfind(raw{i},'SURGE, SWAY, HEAVE, ROLL, PITCH & YAW DRIFT FORCES (Control Surface)'))~=0 & ...
                    isempty(strfind(raw{i},'SURGE, SWAY, HEAVE, ROLL, PITCH & YAW DRIFT FORCES (Pressure Integration)'))~=0 & ...
                    isempty(strfind(raw{i},'Wave Heading'))~=0)
                tmp = textscan(raw{i},'%f');
                ma = tmp{1}(2);  % Magnitude of exciting force
                ph = deg2rad(tmp{1}(3));  % Phase of exciting force
                if isnan(ma) ==1
                    ma = 0;
                    ph = 0;
                end
                hydro(F).md_mc(abs(tmp{1}(1)),hydro(F).Nh,hydro(F).Nf) = ma.*cos(ph);
                i = i+1;
                if i>N break; end
            end
            if i>N break; end
        end
    end    
    
    if isempty(strfind(raw{n},'SURGE, SWAY, HEAVE, ROLL, PITCH & YAW DRIFT FORCES (Control Surface)'))==0
        hydro(F).Nh = 0;  % Number of wave headings
        i = n+1;
        while isempty(strfind(raw{i},'Wave Heading'))==0
            hydro(F).Nh = hydro(F).Nh+1;
            tmp = textscan(raw{i}(find(raw{i}==':')+1:end),'%f');
            hydro(F).theta(hydro(F).Nh) = tmp{1}(1);  % Wave headings
            i = i+2;
            while (isempty(strfind(raw{i},'*******************************'))~=0 & ...
                    isempty(strfind(raw{i},'EXCITING FORCES AND MOMENTS'))~=0 & ...
                    isempty(strfind(raw{i},'RESPONSE AMPLITUDE OPERATORS'))~=0 & ...
                    isempty(strfind(raw{i},'SURGE, SWAY & YAW DRIFT FORCES (Momentum Conservation)'))~=0 & ...
                    isempty(strfind(raw{i},'SURGE, SWAY, HEAVE, ROLL, PITCH & YAW DRIFT FORCES (Control Surface)'))~=0 & ...
                    isempty(strfind(raw{i},'SURGE, SWAY, HEAVE, ROLL, PITCH & YAW DRIFT FORCES (Pressure Integration)'))~=0 & ...
                    isempty(strfind(raw{i},'Wave Heading'))~=0)
                tmp = textscan(raw{i},'%f');
                ma = tmp{1}(2);  % Magnitude of exciting force
                ph = deg2rad(tmp{1}(3));  % Phase of exciting force
                if isnan(ma) ==1
                    ma = 0;
                    ph = 0;
                end
                hydro(F).md_cs(abs(tmp{1}(1)),hydro(F).Nh,hydro(F).Nf) = ma.*cos(ph);
                i = i+1;
                if i>N break; end
            end
            if i>N break; end
        end
    end

    if isempty(strfind(raw{n},'SURGE, SWAY, HEAVE, ROLL, PITCH & YAW DRIFT FORCES (Pressure Integration)'))==0
        hydro(F).Nh = 0;  % Number of wave headings
        i = n+1;
        while isempty(strfind(raw{i},'Wave Heading'))==0
            hydro(F).Nh = hydro(F).Nh+1;
            tmp = textscan(raw{i}(find(raw{i}==':')+1:end),'%f');
            hydro(F).theta(hydro(F).Nh) = tmp{1}(1);  % Wave headings
            i = i+2;
            while (isempty(strfind(raw{i},'*******************************'))~=0 & ...
                    isempty(strfind(raw{i},'EXCITING FORCES AND MOMENTS'))~=0 & ...
                    isempty(strfind(raw{i},'RESPONSE AMPLITUDE OPERATORS'))~=0 & ...
                    isempty(strfind(raw{i},'SURGE, SWAY & YAW DRIFT FORCES (Momentum Conservation)'))~=0 & ...
                    isempty(strfind(raw{i},'SURGE, SWAY, HEAVE, ROLL, PITCH & YAW DRIFT FORCES (Control Surface)'))~=0 & ...
                    isempty(strfind(raw{i},'SURGE, SWAY & YAW DRIFT FORCES (Momentum Conservation)'))~=0 & ...
                    isempty(strfind(raw{i},'Wave Heading'))~=0)
                tmp = textscan(raw{i},'%f');
                ma = tmp{1}(2);  % Magnitude of exciting force
                ph = deg2rad(tmp{1}(3));  % Phase of exciting force
                if isnan(ma) ==1
                    ma = 0;
                    ph = 0;
                end
                hydro(F).md_pi(abs(tmp{1}(1)),hydro(F).Nh,hydro(F).Nf) = ma.*cos(ph);
                i = i+1;
                if i>N break; end
            end
            if i>N break; end
        end
    end
    
    d = floor(10*n/N);  % Update progress bar every 10%, otherwise slows computation
    if d>e  waitbar(n/N);  e = d;  end
end

%% Scattering Force
hydro(F).sc_ma = NaN(size(hydro(F).ex_ma));
hydro(F).sc_ph = NaN(size(hydro(F).ex_ph));
hydro(F).sc_re = NaN(size(hydro(F).ex_re));
hydro(F).sc_im = NaN(size(hydro(F).ex_im));
tmp = strsplit(filename,{' ','.out'});
if exist([tmp{1} '.3sc'],'file')==2
    fileID = fopen([tmp{1} '.3sc']);
    raw = textscan(fileID,'%[^\n\r]');
    raw = raw{:};
    fclose(fileID);
    n = 1;
    for i = 1:hydro(F).Nf
        for j = 1:hydro(F).Nh
            for k = 1:round(size(find(hydro(F).ex_ma),1)/hydro(F).Nf/hydro(F).Nh)  % Number of non-zero dof
                n = n+1;
                tmp = textscan(raw{n},'%f');
                hydro(F).sc_ma(tmp{1,1}(3),j,i) = tmp{1,1}(4);
                hydro(F).sc_ph(tmp{1,1}(3),j,i) = deg2rad(tmp{1,1}(5));
                hydro(F).sc_re(tmp{1,1}(3),j,i) = tmp{1,1}(6);
                hydro(F).sc_im(tmp{1,1}(3),j,i) = tmp{1,1}(7);
            end
        end
    end
end

%% Froude-Krylov force
hydro(F).fk_ma = NaN(size(hydro(F).ex_ma));  
hydro(F).fk_ph = NaN(size(hydro(F).ex_ph));
hydro(F).fk_re = NaN(size(hydro(F).ex_re));
hydro(F).fk_im = NaN(size(hydro(F).ex_im));
tmp = strsplit(filename,{' ','.out'});
if exist([tmp{1} '.3fk'],'file')==2
    fileID = fopen([tmp{1} '.3fk']);
    raw = textscan(fileID,'%[^\n\r]');
    raw = raw{:};
    fclose(fileID);
    n = 1;
    for i = 1:hydro(F).Nf
        for j = 1:hydro(F).Nh
            for k = 1:round(size(find(hydro(F).ex_ma),1)/hydro(F).Nf/hydro(F).Nh)  % Number of non-zero dof
                n = n+1;
                tmp = textscan(raw{n},'%f');
                hydro(F).fk_ma(tmp{1,1}(3),j,i) = tmp{1,1}(4);
                hydro(F).fk_ph(tmp{1,1}(3),j,i) = deg2rad(tmp{1,1}(5));
                hydro(F).fk_re(tmp{1,1}(3),j,i) = tmp{1,1}(6);
                hydro(F).fk_im(tmp{1,1}(3),j,i) = tmp{1,1}(7);
            end
        end
    end
end

%% Generalized body modes
for i = 1:hydro(F).Nb
    hydro(F).dof(i) = 6;  % Default degrees of freedom for each body is 6
end
tmp = strsplit(filename,{' ','.out'});
if exist([tmp{1} '.cfg'],'file')==2
    fileID = fopen([tmp{1} '.cfg']);  % Read in number of possible generalized body modes
    raw = textscan(fileID,'%[^\n\r]');  % Read/copy raw output from .cfg file
    raw = raw{:};
    fclose(fileID);
    N = length(raw);
    for n = 1:N
        if isempty(strfind(raw{n},'NEWMDS'))==0 || ~isempty(strfind(raw{n},'IMODESFSP'))
            tmp = strsplit(raw{n},{'(',')','=',' '});
            if raw{n}(7) == '('
                hydro(F).dof(str2num(tmp{2})) = hydro(F).dof(str2num(tmp{2}))+str2num(tmp{3});
            else
                hydro(F).dof(1) = hydro(F).dof(1)+str2num(tmp{2});
            end
        end
    end
    if sum(hydro(F).dof) > hydro(F).Nb*6  % If there are generalized body modes        
        tmp = strsplit(filename,{' ','.out'});
        fileID = fopen([tmp{1} '.mmx']);    % Read in mass, damping, and stiffness
        raw = textscan(fileID,'%[^\n\r]');  % Read/copy raw output
        raw = raw{:};
        fclose(fileID);
        N = length(raw);
        for n = 1:N
            if isempty(strfind(raw{n},'External force matrices'))==0
                for k = 1:sum(hydro(F).dof)*sum(hydro(F).dof)
                    tmp = textscan(raw{n+k+1},'%f');
                    hydro(F).gbm(tmp{1,1}(1),tmp{1,1}(2),1) = tmp{1,1}(3);  % gbm[:,:,1] - Mass
                    hydro(F).gbm(tmp{1,1}(1),tmp{1,1}(2),2) = tmp{1,1}(4);  % gbm[:,:,2] - Damping
                    hydro(F).gbm(tmp{1,1}(1),tmp{1,1}(2),3) = tmp{1,1}(5);  % gbm[:,:,3] - Stiffness
                end
            end
        end        
        tmp = strsplit(filename,{' ','.out'});
        fileID = fopen([tmp{1} '.hst']);    % Read in hydrostatic stiffness 
        raw = textscan(fileID,'%[^\n\r]');  % Read/copy raw output
        raw = raw{:};
        fclose(fileID);
        N = length(raw);
        for n = 2:N
            tmp = textscan(raw{n},'%f');
            hydro(F).gbm(tmp{1,1}(1),tmp{1,1}(2),4) = tmp{1,1}(3);  % gbm[:,:,4] - Hydrostatic Stiffness
        end     % hydro.gbm([1:6],[1:6],4) will be redundant of rigid body hydro.Khs values
    end
end

%%
hydro = normalizeBEM(hydro);  % For WAMIT this just sorts the data, if neccessary
hydro = addDefaultPlotVars(hydro);

close(p);
end

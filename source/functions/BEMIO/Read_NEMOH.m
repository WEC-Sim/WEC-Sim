function hydro = Read_NEMOH(hydro,filedir)

% Reads data from a NEMOH working folder.
%
% hydro = Read_NEMOH(hydro, filedir)
%     hydro –   data structure
%     filedir – NEMOH working folder, must include:
%         - Nemoh.cal
%         - Mesh/Hydrostatics.dat (or Hydrostatiscs_0.dat, Hydrostatics_1.dat,
%           etc. for multiple bodies)
%         - Mesh/KH.dat (or KH_0.dat, KH_1.dat, etc. for multiple bodies)
%         - Results/RadiationCoefficients.tec
%         - Results/ExcitationForce.tec
%         - Results/DiffractionForce.tec - If simu.nlHydro = 3 will be used
%         - Results/FKForce.tec - If simu.nlHydro = 3 will be used
%
% See ‘…\WEC-Sim\tutorials\BEMIO\NEMOH\...’ for examples of usage.

[a,b] = size(hydro);  % Check on what is already there
if b==1
    if isfield(hydro(b),'Nb')==0  F = 1;
    else  F = 2;
    end
elseif b>1  F = b+1;
end

p = waitbar(0,'Reading NEMOH output file...');  % Progress bar

hydro(F).code = 'NEMOH';
tmp = strsplit(filedir,{' ','\'});
tmp(cellfun('isempty',tmp)) = [];
hydro(F).file = tmp{length(tmp)};  % Base name

%% nemoh.cal file
fileID = fopen(fullfile(filedir,'nemoh.cal'));
raw = textscan(fileID,'%[^\n\r]');  %Read nemoh.cal
raw = raw{:};
fclose(fileID);
N = length(raw);
b = 0;
for n = 1:N
    if isempty(strfind(raw{n},'Fluid specific volume'))==0
        tmp = textscan(raw{n},'%f');
        hydro(F).rho = tmp{1};  % Density
    end
    if isempty(strfind(raw{n},'Gravity'))==0
        tmp = textscan(raw{n},'%f');
        hydro(F).g = tmp{1};  % Gravity
    end
    if isempty(strfind(raw{n},'Water depth'))==0
        tmp = textscan(raw{n},'%f');
        if tmp{1} == 0 hydro(F).h = Inf;
        else hydro(F).h = tmp{1};  % Water depth
        end
    end
    if isempty(strfind(raw{n},'Number of bodies'))==0
        tmp = textscan(raw{n},'%f');
        hydro(F).Nb = tmp{1};  % Number of bodies
    end
    if isempty(strfind(raw{n},'Name of mesh file'))==0
        b = b+1;
        tmp = strsplit(raw{n},{'.','\'});
        hydro(F).body{b} = tmp{length(tmp)-1};  % Body names
    end
    if isempty(strfind(raw{n},'Number of wave frequencies'))==0
        tmp = textscan(raw{n},'%f %f %f');
        hydro(F).Nf = tmp{1};  % Number of wave frequencies
        hydro(F).w = linspace(tmp{2},tmp{3},tmp{1});  % Wave frequencies
        hydro(F).T = 2*pi./hydro(F).w;  % Wave periods
    end
    if isempty(strfind(raw{n},'Number of wave directions'))==0
        tmp = textscan(raw{n},'%f %f %f');
        hydro(F).Nh = tmp{1};  % Number of wave headings
        hydro(F).beta = linspace(tmp{2},tmp{3},tmp{1});  % Wave headings
    end
end
waitbar(1/7);

%% Hydrostatics file(s)
for m = 1:hydro(F).Nb
    hydro(F).dof(m) = 6;  % Default degrees of freedom for each body is 6
    if hydro(F).Nb == 1
        fileID = fopen(fullfile(filedir,'Mesh','Hydrostatics.dat'));
    else
        fileID = fopen([fullfile(filedir,'Mesh','Hydrostatics_'),num2str(m-1),'.dat']);
    end
    raw = textscan(fileID,'%[^\n\r]');  % Read Hydrostatics.dat
    raw = raw{:};
    fclose(fileID);
    for i=1:3
        tmp = textscan(raw{i},'%s %s %f %s %s %s %f');
        hydro(F).cg(i,m) = tmp{7};  % Center of gravity
        hydro(F).cb(i,m) = tmp{3};  % Center of buoyancy
    end
    tmp = textscan(raw{4},'%s %s %f');
    hydro(F).Vo(m) = tmp{3};  % Displacement volume
end
waitbar(2/7);

%% KH file(s)
for m = 1:hydro(F).Nb
    if hydro(F).Nb == 1
        fileID = fopen(fullfile(filedir,'Mesh','KH.dat'));
    else
        fileID = fopen([fullfile(filedir,'Mesh','KH_'),num2str(m-1),'.dat']);
    end
    raw = textscan(fileID,'%[^\n\r]');
    raw = raw{:};
    fclose(fileID);
    for i=1:6
        tmp = textscan(raw{i},'%f');
        hydro(F).C(i,:,m) = tmp{1,1}(1:6);  % Linear restoring stiffness
    end
end
waitbar(3/7);

%% Radiation Coefficient file
fileID = fopen(fullfile(filedir,'Results','RadiationCoefficients.tec'));
raw = textscan(fileID,'%[^\n\r]');
raw = raw{:};
fclose(fileID);
N = length(raw);
i = 0;
for n = 1:N
    if isempty(strfind(raw{n},'Motion of body'))==0
        i = i+1;
        for k = 1:hydro(F).Nf
            tmp = textscan(raw{n+k},'%f');
            hydro(F).A(i,:,k) = tmp{1,1}(2:2:end);  % Added mass
            hydro(F).B(i,:,k) = tmp{1,1}(3:2:end);  % Radiation damping
        end
    end
end
waitbar(4/7);

%% Excitation Force file
fileID = fopen(fullfile(filedir,'Results','ExcitationForce.tec'));
raw = textscan(fileID,'%[^\n\r]');
raw = raw{:};
fclose(fileID);
N = length(raw);
i = 0;
for n = 1:N
    if isempty(strfind(raw{n},'Diffraction force'))==0
        i = i+1;
        for k = 1:hydro(F).Nf
            tmp = textscan(raw{n+k},'%f');
            hydro(F).ex_ma(:,i,k) = tmp{1,1}(2:2:end);  % Magnitude of exciting force
            hydro(F).ex_ph(:,i,k) = -tmp{1,1}(3:2:end);  % Phase of exciting force (-ph, since NEMOH's x-dir is flipped)
        end
    end
end
hydro(F).ex_re = hydro(F).ex_ma.*cos(hydro(F).ex_ph);  % Real part of exciting force
hydro(F).ex_im = hydro(F).ex_ma.*sin(hydro(F).ex_ph);  % Imaginary part of exciting force
waitbar(5/7);

%% Diffraction Force file (scattering)
hydro(F).sc_ma = NaN(size(hydro(F).ex_ma));
hydro(F).sc_ph = NaN(size(hydro(F).ex_ph));
hydro(F).sc_re = NaN(size(hydro(F).ex_re));
hydro(F).sc_im = NaN(size(hydro(F).ex_im));
if exist(fullfile(filedir,'Results,DiffractionForce.tec'),'file')==2
    fileID = fopen(fullfile(filedir,'Results,DiffractionForce.tec'));
    raw = textscan(fileID,'%[^\n\r]');
    raw = raw{:};
    fclose(fileID);
    N = length(raw);
    i = 0;
    for n = 1:N
        if isempty(strfind(raw{n},'Diffraction force'))==0
            i = i+1;
            for k = 1:hydro(F).Nf
                tmp = textscan(raw{n+k},'%f');
                hydro(F).sc_ma(:,i,k) = tmp{1,1}(2:2:end);  % Magnitude of diffraction force
                hydro(F).sc_ph(:,i,k) = -tmp{1,1}(3:2:end);  % Phase of diffraction force 
            end
        end
    end
    hydro(F).sc_re = hydro(F).sc_ma.*cos(hydro(F).sc_ph);  % Real part of diffraction force
    hydro(F).sc_im = hydro(F).sc_ma.*sin(hydro(F).sc_ph);  % Imaginary part of diffraction force
end
waitbar(6/7);

%% Froude-Krylov force file
hydro(F).fk_ma = NaN(size(hydro(F).ex_ma));  
hydro(F).fk_ph = NaN(size(hydro(F).ex_ph));
hydro(F).fk_re = NaN(size(hydro(F).ex_re));
hydro(F).fk_im = NaN(size(hydro(F).ex_im));
if exist(fullfile(filedir,'Results,FKForce.tec'),'file')==2
    fileID = fopen(fullfile(filedir,'Results,FKForce.tec'));
    raw = textscan(fileID,'%[^\n\r]');
    raw = raw{:};
    fclose(fileID);
    N = length(raw);
    i = 0;
    for n = 1:N
        if isempty(strfind(raw{n},'FKforce'))==0
            i = i+1;
            for k = 1:hydro(F).Nf
                tmp = textscan(raw{n+k},'%f');
                hydro(F).fk_ma(:,i,k) = tmp{1,1}(2:2:end);  % Magnitude of Froude-Krylov force
                hydro(F).fk_ph(:,i,k) = -tmp{1,1}(3:2:end);  % Phase of Froude-Krylov force 
            end
        end
    end
    hydro(F).fk_re = hydro(F).fk_ma.*cos(hydro(F).fk_ph);  % Real part of Froude-Krylov force
    hydro(F).fk_im = hydro(F).fk_ma.*sin(hydro(F).fk_ph);  % Imaginary part of Froude-Krylov force
end
waitbar(7/7);

hydro = Normalize(hydro);  % Normalize the data according the WAMIT convention

close(p);
end

function hydro = Read_NEMOH(hydro,filedir)

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
fileID = fopen([filedir 'nemoh.cal']);
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
waitbar(1/5);

%% Hydrostatics file(s)
for m = 1:hydro(F).Nb
    if hydro(F).Nb == 1
        fileID = fopen([filedir 'Mesh\Hydrostatics.dat']);
    else
        fileID = fopen([filedir 'Mesh\Hydrostatics_' num2str(m-1) '.dat']);
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
waitbar(2/5);

%% KH file(s)
for m = 1:hydro(F).Nb
    if hydro(F).Nb == 1
        fileID = fopen([filedir 'Mesh\KH.dat']);
    else
        fileID = fopen([filedir 'Mesh\KH_' num2str(m-1) '.dat']);
    end
    raw = textscan(fileID,'%[^\n\r]');
    raw = raw{:};
    fclose(fileID);
    for i=1:6
        tmp = textscan(raw{i},'%f');
        hydro(F).C(i,:,m) = tmp{1,1}(1:6);  % Linear restoring stiffness
    end
end
waitbar(3/5);

%% Radiation Coefficient file
fileID = fopen([filedir 'Results\RadiationCoefficients.tec']);
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
waitbar(4/5);

%% Excitation Force file
fileID = fopen([filedir 'Results\ExcitationForce.tec']);
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
            hydro(F).ex_ma(:,i,k) = tmp{1,1}(2:2:end);  % Magnitude of excitaing force
            hydro(F).ex_ph(:,i,k) = -tmp{1,1}(3:2:end);  % Phase of exciting force
        end
    end
end
hydro(F).ex_re = hydro(F).ex_ma.*cos(hydro(F).ex_ph);  % Real part of exciting force (-ph, since NEMOH's x-dir is flipped)
hydro(F).ex_im = hydro(F).ex_ma.*sin(hydro(F).ex_ph);  % Imaginary part of exciting force
waitbar(5/5);

hydro = Normalize(hydro);
close(p);
end

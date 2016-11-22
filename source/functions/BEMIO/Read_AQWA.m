function hydro = Read_AQWA(hydro,ah1_filename,lis_filename)

% Reads data from AQWA output files.
% 
% hydro = Read_AQWA(hydro, ah1_filename, lis_filename)
%     hydro –         data structure
%     ah1_filename –  .AH1 AQWA output file
%     lis_filename –  .LIS AQWA output file
% 
% See ‘…\WEC-Sim\tutorials\BEMIO\AQWA\...’ for examples of usage.

[a,b] = size(hydro);  % Check on what is already there
if b==1
    if isfield(hydro(b),'Nb')==0  F = 1;
    else  F = 2;
    end
elseif b>1  F = b+1;
end

p = waitbar(0,'Reading AQWA output file...'); %Progress bar
e = 0;

hydro(F).code = 'AQWA';
tmp = strsplit(ah1_filename,{' ','\','.'});
hydro(F).file = tmp{length(tmp)-1};  % Base filename

fileID = fopen(ah1_filename);
raw1 = textscan(fileID,'%[^\n\r]'); %Read/copy raw output, ah1
raw1 = raw1{:};
fclose(fileID);
fileID = fopen(lis_filename);
raw2 = textscan(fileID,'%[^\n\r]'); %Read/copy raw output, lis
raw2 = raw2{:};
fclose(fileID);
N = length([raw1(:);raw2(:)]);

n = 2;
tmp = str2num(raw1{n});
hydro(F).Nb = tmp(1); % Number of bodies
for i=1:hydro(F).Nb
    hydro(F).body{i} = ['body' num2str(i)]; %Body name
    hydro(F).dof(i) = 6;  % Default degrees of freedom for each body is 6
end
hydro(F).Nh = tmp(2);  % Number of wave headings
hydro(F).Nf = tmp(3);  % Number of wave frequencies
hydro(F).beta = [];
for i = 1:ceil(hydro(F).Nh/6)
    hydro(F).beta = [hydro(F).beta str2num(raw1{n})]; % Wave headings
    n=n+1;
end
hydro(F).beta(1:3) = [];
hydro(F).w = [];
for i=1:ceil(hydro(F).Nf/6)
    hydro(F).w = [hydro(F).w str2num(raw1{n})]; % Wave frequencies
    n = n+1;
end
hydro(F).T = 2*pi./hydro(F).w;

for ln = n:length(raw1);
    if isempty(strfind(raw1{ln},'GENERAL'))==0
        tmp = str2num(raw1{ln+1});
        hydro(F).h = tmp(1);   % Water depth
        hydro(F).rho = tmp(2); % Water density
        hydro(F).g = tmp(3);   % Gravity
    end
    if isempty(strfind(raw1{ln},'COG'))==0
        for i=1:hydro(F).Nb
            tmp = str2num(raw1{ln+i});
            hydro(F).cg(:,i) = tmp(2:4); % Center of gravity
        end
    end
    if isempty(strfind(raw1{ln},'DRAFT'))==0
        for i=1:hydro(F).Nb
            tmp = str2num(raw1{ln+i});
            draft(i) = tmp(2); % Draft
        end
    end
    if (isempty(strfind(raw1{ln},'HYDSTIFFNESS'))==0 |...
            (isempty(strfind(raw1{ln},'MASS'))==0 & isempty(strfind(raw1{ln},'ADDEDMASS'))==1))
        if isempty(strfind(raw1{ln},'HYDSTIFFNESS'))==0 f = 0; else f = 1; end
        for j=1:hydro(F).Nb
            for i=1:6
                tmp = str2num(raw1{ln+(j-1)*6+i});
                if length(tmp)>6 tmp(1)=[]; end
                if f==0
                    hydro(F).C(i,:,j) = tmp; % Linear restoring stiffness
                elseif f==1
                    M(i,:,j) = tmp; % Mass
                end
            end
        end
    end
    if (isempty(strfind(raw1{ln},'ADDEDMASS'))==0 | isempty(strfind(raw1{ln},'DAMPING'))==0)
        if isempty(strfind(raw1{ln},'ADDEDMASS'))==0 f = 0; else f = 1; end
        for m=1:hydro(F).Nb
            for k=1:hydro(F).Nb
                for j=1:hydro(F).Nf
                    for i=1:6
                        tmp = str2num(raw1{ln+(m-1)*hydro(F).Nb*hydro(F).Nf*6+(k-1)*hydro(F).Nf*6+(j-1)*6+i});
                        if length(tmp)>6 ind = tmp(1:3); tmp(1:3)=[]; end
                        if f==0 % Added Mass
                            hydro(F).A((ind(2)-1)*6+i,((ind(1)-1)*6+1):(ind(1)*6),ind(3)) = tmp;
                        elseif f==1 % Radiation Damping
                            hydro(F).B((ind(2)-1)*6+i,((ind(1)-1)*6+1):(ind(1)*6),ind(3)) = tmp;
                        end
                    end
                end
            end
        end
    end
    if isempty(strfind(raw1{ln},'FORCERAO'))==0
        for k=1:hydro(F).Nb
            for j=1:hydro(F).Nh
                for i=1:hydro(F).Nf
                    tmp1 = str2num(raw1{ln+(k-1)*hydro(F).Nh*hydro(F).Nf*2+(j-1)*hydro(F).Nf*2+(i-1)*2+1});
                    tmp2 = str2num(raw1{ln+(k-1)*hydro(F).Nh*hydro(F).Nf*2+(j-1)*hydro(F).Nf*2+(i-1)*2+2});
                    ind = tmp1(1:3); tmp1(1:3)=[];
                    hydro(F).ex_ma(((ind(1)-1)*6+1):(ind(1)*6),ind(2),ind(3)) = tmp1; % Magnitude of exciting force
                    hydro(F).ex_ph(((ind(1)-1)*6+1):(ind(1)*6),ind(2),ind(3)) = tmp2; % Phase of exciting force
                end
            end
        end
        hydro(F).ex_re = hydro(F).ex_ma.*cos(hydro(F).ex_ph*pi/180); % Real part of exciting force
        hydro(F).ex_im = hydro(F).ex_ma.*sin(hydro(F).ex_ph*pi/180); % Imaginary part of exciting force
    end    
    d = floor(10*ln/N);  %Update waitbar every 10%, or slows computation time
    if (d>e) waitbar(ln/N); e = d; end
end

hydro(F).Vo = [];
hydro(F).cb = [];
for ln = 1:length(raw2);
    if isempty(strfind(raw2{ln},'MESH BASED DISPLACEMENT'))==0
        tmp = textscan(raw2{ln}(find(raw2{ln}=='=')+1:end),'%f');
        hydro(F).Vo = [hydro(F).Vo tmp{1}];   % Volume
    end
    if isempty(strfind(raw2{ln},'POSITION OF THE CENTRE OF BUOYANCY'))==0
        cb = [];
        for i=1:3
            tmp = textscan(raw2{(ln-1)+i}(find(raw2{(ln-1)+i}=='=')+1:end),'%f');
            cb = [cb; tmp{1}];
        end
        hydro(F).cb = [hydro(F).cb cb]; % Center of buoyancy
    end
    d = floor(10*(ln+length(raw1))/N);  %Update waitbar every 10%, or slows computation time
    if (d>e) waitbar((ln+length(raw1))/N); e = d; end
end

hydro = Normalize(hydro);
close(p);

end


function hydro = readAQWA(hydro,ah1Filename,lisFilename)
% Reads data from AQWA output files.
% 
% See ``WEC-Sim\examples\BEMIO\AQWA`` for examples of usage.
% 
% Parameters
% ----------
%     hydro : struct
%         Structure of hydro data that Aqwa input data will be appended to
%     
%     ah1Filename : string
%         .AH1 AQWA output file
%     
%     lisFilename : string
%         .LIS AQWA output file
% 
% Returns
% -------
%     hydro : struct
%         Structure of hydro data with Aqwa data appended
%

%%
[a,b] = size(hydro);  % Check on what is already there
if b == 1 && ~isfield(hydro(b),'Nb')
    F = 1;
elseif b >= 1
    F = b+1;
end

%%

p = waitbar(0,'Reading AQWA output file...'); %Progress bar
e = 0;

hydro(F).code   = 'AQWA';
V182            = 0; % Set AqwaVersion flag "Version 18.2 or larger" to 0
[~,tmp,~]       = fileparts(ah1Filename);
hydro(F).file   = tmp;  % Base filename

fileID          = fopen(ah1Filename);
raw1            = textscan(fileID,'%[^\n\r]'); %Read/copy raw output, ah1
raw1            = raw1{:};
fclose(fileID);
fileID          = fopen(lisFilename);
raw2            = textscan(fileID,'%[^\n\r]'); %Read/copy raw output, lis
raw2            = raw2{:};
fclose(fileID);
N               = length([raw1(:);raw2(:)]);

%% 
% n=2;
n = 1;
TF = 1;
while TF == 1
    if isempty(strfind(raw1{n},'LHFR'))==0; V182 = 1; end % Change Aqwa Version flag to 1 if specific string is found in header
    n   = n+1;
    TF  = startsWith(raw1(n),'*');
end

%%

tmp = str2num(raw1{n});
COGidx=find(contains(raw1,'COG'),1); % finds line of COG heading
DRAFTidx=find(contains(raw1,'DRAFT'),1); % finds line of DRAFT heading
hydro(F).Nb = (DRAFTidx-COGidx)-1; % Number of bodies is the distance between (in all tested versions)

%%

for i=1:hydro(F).Nb
    hydro(F).body{i}    = ['body' num2str(i)]; %Body name
    hydro(F).dof(i)     = 6;  % Default degrees of freedom for each body is 6
end
%%
hydro(F).Nh     = tmp(2);  % Number of wave headings
hydro(F).Nf     = tmp(3);  % Number of wave frequencies
hydro(F).theta   = [];
for i = 1:ceil(hydro(F).Nh/6)
    hydro(F).theta   = [hydro(F).theta str2num(raw1{n})]; % Wave headings
    n               = n+1;
end
hydro(F).theta(1:3) = [];
hydro.A = zeros(hydro.Nb*6,hydro.Nb*6,hydro.Nf); 
hydro.B = zeros(hydro.Nb*6,hydro.Nb*6,hydro.Nf);
%%
hydro(F).w = [];
for i=1:ceil(hydro(F).Nf/6)
    hydro(F).w = [hydro(F).w str2num(raw1{n})]; % Wave frequencies
    n = n+1;
end
hydro(F).T = 2*pi./hydro(F).w;
%%
for ln = n:length(raw1)
    if isempty(strfind(raw1{ln},'GENERAL'))==0
        if V182 == 1  % General information columns in Versions>18.2
            tmp = str2num(raw1{ln+1});
            hydro(F).h      = tmp(2);   % Water depth
            hydro(F).rho    = tmp(3);   % Water density
            hydro(F).g      = tmp(4);   % Gravity
        else          % General information columns in Versions<18.2
            tmp = str2num(raw1{ln+1});
            hydro(F).h      = tmp(1);   % Water depth
            hydro(F).rho    = tmp(2); % Water density
            hydro(F).g      = tmp(3);   % Gravity
        end
        clear V182
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
                    hydro(F).Khs(i,:,j) = tmp; % Linear restoring stiffness
                elseif f==1
                    M(i,:,j) = tmp; % Mass
                end
            end
        end
    end 
    if ((isempty(strfind(raw1{ln},'ADDEDMASS'))==0) && isempty(strfind(raw1{ln},'LF'))==1 && isempty(strfind(raw1{ln},'HF'))==1) || ...
            (isempty(strfind(raw1{ln},'DAMPING'))==0 && isempty(strfind(raw1{ln},'LF'))==1)
        flag = 0;
        if isempty(strfind(raw1{ln},'ADDEDMASS'))==0 f = 0; else f = 1; end
        for m=1:hydro(F).Nb  
            for k=1:hydro(F).Nb
                for j=1:hydro(F).Nf
                    for i=1:6
                        tmp = str2num(raw1{ln+(m-1)*hydro(F).Nb*hydro(F).Nf*6+(k-1)*hydro(F).Nf*6+(j-1)*6+i});
                        if isempty(tmp) flag = 1; break; end % if temp variable is empty, exit loops
                        if length(tmp)>6 ind = tmp(1:3); tmp(1:3)=[]; end
                        if f==0 % Added Mass
                            hydro(F).A((ind(2)-1)*6+i,((ind(1)-1)*6+1):(ind(1)*6),ind(3)) = tmp;
                        elseif f==1 % Radiation Damping
                            hydro(F).B((ind(2)-1)*6+i,((ind(1)-1)*6+1):(ind(1)*6),ind(3)) = tmp;
                        end
                        if flag == 1 break; end
                    end
                    if flag == 1 break; end
                end
                if flag == 1 break; end
            end
            if flag == 1 break; end
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
                    hydro(F).ex_ph(((ind(1)-1)*6+1):(ind(1)*6),ind(2),ind(3)) = wrapToPi(-tmp2*pi/180); % Phase of exciting force    
                end
            end
        end

        hydro(F).ex_re = hydro(F).ex_ma.*cos(hydro(F).ex_ph); % Real part of exciting force
        hydro(F).ex_im = hydro(F).ex_ma.*sin(hydro(F).ex_ph); % Imaginary part of exciting force
        
    end
    d = floor(10*ln/N);  %Update waitbar every 10%, or slows computation time
    if (d>e) waitbar(ln/N); e = d; end
end


%%
V2020       = [];
hydro(F).Vo = [];
hydro(F).cb = [];
lnlog=zeros(length(raw2),1); % initialize line find log
for ln=1:length(raw2)
    if isempty(find(ln==lnlog,1))==0
        continue
    elseif isempty(strfind(raw2{ln},'MESH BASED DISPLACEMENT'))==0
        tmp = textscan(raw2{ln}(find(raw2{ln}=='=')+1:end),'%f');
        hydro(F).Vo = [hydro(F).Vo tmp{1}];   % Volume
    
    elseif isempty(strfind(raw2{ln},'POSITION OF THE CENTRE OF BUOYANCY'))==0
        cb = [];
        for i=1:3
            tmp = textscan(raw2{(ln-1)+i}(find(raw2{(ln-1)+i}=='=')+1:end),'%f');
            cb = [cb; tmp{1}];
        end
        hydro(F).cb = [hydro(F).cb cb]; % Center of buoyancy
        
    elseif isempty(strfind(raw2{ln},'FROUDE KRYLOV FORCES-VARIATION WITH WAVE PERIOD'))==0
        headerCount = 0;
        k=str2num(raw2{ln-2}(end-9:end-8));                       % Body number flag
        if isempty(k) 
            k=str2num(raw2{ln-3}(end-9:end-8));                     % Version 2020 R1
            V2020 = 1;
        end
        for j=1:hydro(F).Nh
            for i=1:hydro(F).Nf
                if isempty(V2020)
                    tmp1 = str2num(raw2{ln+6+(j-1)*(hydro(F).Nf+9)+(i-1)});
                else 
                    if j>=2 && i==1
                        tmp1 = str2num(raw2{ln+6+(j-1)*(hydro(F).Nf)+10*headerCount+(i-1)});
                        if tmp1 == 1
                            headerCount = headerCount+1;
                        end
                    end
                    tmp1 = str2num(raw2{ln+6+(j-1)*(hydro(F).Nf)+10*headerCount+(i-1)});
                end
                if i==1
                    ind = tmp1(1:3); tmp1(1:3)=[];
                else
                    ind = tmp1(1:2); tmp1(1:2)=[];
                end
                tmp2 = tmp1(2:2:end);
                tmp1(2:2:end)=[];
                hydro(F).fk_ma((k-1)*6+1:k*6,j,i) = tmp1;  % mag of froude Krylov force
                hydro(F).fk_ph((k-1)*6+1:k*6,j,i) = tmp2;  % phase of froude Krylov force
            end
        end        
        hydro(F).fk_re = hydro(F).fk_ma.*cos(hydro(F).fk_ph*pi/180); % real part of Froude Krylov force
        hydro(F).fk_im = hydro(F).fk_ma.*sin(hydro(F).fk_ph*pi/180); % imaginary part of Froude Krylov force
        lnlog(ln:ln+6+(j-1)*(hydro(F).Nf)+headerCount*10+(i-1))=[ln:ln+6+(j-1)*(hydro(F).Nf)+headerCount*10+(i-1)]; % avoids repeating line operations for repeated matches
    elseif isempty(strfind(raw2{ln},'DIFFRACTION FORCES-VARIATION WITH WAVE PERIOD/FREQUENCY'))==0 ...
            && isempty(strfind(raw2{ln},'FROUDE KRYLOV +'))==1
        headerCount = 0;
        kdiff=str2num(raw2{ln-2}(end-9:end-8));                       % Body number flag
        if isempty(kdiff) 
            kdiff = str2num(raw2{ln-3}(end-9:end-8));                     % Version 2020 R1
            V2020 = 1;
        end
        for j=1:hydro(F).Nh
            for i=1:hydro(F).Nf
                if isempty(V2020)
                    tmp1 = str2num(raw2{ln+6+(j-1)*(hydro(F).Nf+9)+(i-1)});
                else
                    if j>=2 && i==1
                        tmp1 = str2num(raw2{ln+6+(j-1)*(hydro(F).Nf)+10*headerCount+(i-1)});
                        if tmp1 == 1
                            headerCount = headerCount+1;
                        end
                    end
                    tmp1 = str2num(raw2{ln+6+(j-1)*(hydro(F).Nf)+10*headerCount+(i-1)});
                end
                if i==1
                    ind = tmp1(1:3); tmp1(1:3)=[];
                else
                    ind = tmp1(1:2); tmp1(1:2)=[];
                end
                tmp2 = tmp1(2:2:end);
                tmp1(2:2:end)=[];
                hydro(F).sc_ma((kdiff-1)*6+1:kdiff*6,j,i) = tmp1;  % mag of scattering force
                hydro(F).sc_ph((kdiff-1)*6+1:kdiff*6,j,i) = tmp2;  % phase of scattering force
            end
        end        
        hydro(F).sc_re = hydro(F).sc_ma.*cos(hydro(F).sc_ph*pi/180); % real part of scattering force
        hydro(F).sc_im = hydro(F).sc_ma.*sin(hydro(F).sc_ph*pi/180); % imaginary part of scattering force
        lnlog(ln:ln+6+(j-1)*(hydro(F).Nf)+headerCount*10+(i-1))=[ln:ln+6+(j-1)*(hydro(F).Nf)+headerCount*10+(i-1)];      
    end
    
    d = floor(10*(ln+length(raw2))/N);  %Update waitbar every 10%, or slows computation time
    if (d>e) waitbar((ln+length(raw1))/N); e = d; end
    
end
%%
hydro = normalizeBEM(hydro);  % Normalize the data according the WAMIT convention
hydro = addDefaultPlotVars(hydro);

close(p);
end

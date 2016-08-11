function hydro = Read_WAMIT(hydro,filename,ex_coeff)

[a,b] = size(hydro);  % Check on what is already there
if b==1
    if isfield(hydro(b),'Nb')==0  F = 1;
    else  F = 2;
    end
elseif b>1  F = b+1;
end

p = waitbar(0,'Reading WAMIT output file...');  % Progress bar
e = 0;

if isempty(ex_coeff)==1;  ex_coeff = 'diffraction';  end  % 'diffraction' or 'haskind'

hydro(F).code = 'WAMIT';
tmp = strsplit(filename,{' ','\','.'});
hydro(F).file = tmp{length(tmp)-1};  % Base name

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
        tmp = textscan(raw{n},'%s %s %f','TreatAsEmpty',{'infinite'},'EmptyValue',Inf);
        hydro(F).h = tmp{3};  % Water depth
    end
    if isempty(strfind(raw{n},'XBODY ='))==0
        hydro(F).Nb = hydro(F).Nb+1;
        tmp = textscan(raw{n},'%s %s %f %s %s %f %s %s %f %s %s %f');
        hydro(F).cg(:,hydro(F).Nb) = [tmp{3} tmp{6} tmp{9}];  % Center of gravity
    end
    if isempty(strfind(raw{n},'Volumes (VOLX,VOLY,VOLZ):'))==0
        tmp = textscan(raw{n}(find(raw{n}==':')+1:end),'%f');
        hydro(F).Vo(hydro(F).Nb) = tmp{1}(3);  % Displacement volume
    end
    if isempty(strfind(raw{n},'Center of Buoyancy (Xb,Yb,Zb):'))==0
        tmp = textscan(raw{n}(find(raw{n}==':')+1:end),'%f');
        hydro(F).cb(:,hydro(F).Nb) = tmp{1};  % Center of buoyancy
    end
    if isempty(strfind(raw{n},'Hydrostatic and gravitational'))==0
        hydro(F).C(:,:,hydro(F).Nb) = zeros(6,6);  % Linear restoring stiffness
        tmp = textscan(raw{n+1}(find(raw{n+1}==':')+1:end),'%f');
        hydro(F).C(3,3:5,hydro(F).Nb) = tmp{1};
        hydro(F).C(3:5,3,hydro(F).Nb) = tmp{1};
        tmp = textscan(raw{n+2}(find(raw{n+2}==':')+1:end),'%f');
        hydro(F).C(4,4:6,hydro(F).Nb) = tmp{1};
        hydro(F).C(4:6,4,hydro(F).Nb) = tmp{1};
        tmp = textscan(raw{n+3}(find(raw{n+3}==':')+1:end),'%f');
        hydro(F).C(5,5:6,hydro(F).Nb) = tmp{1};
        hydro(F).C(5:6,5,hydro(F).Nb) = tmp{1};
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
                isempty(strfind(raw{n+i},'EXCITING FORCES AND MOMENTS'))~=0)
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
            strcmp(ex_coeff,'haskind')==1) |...
            (isempty(strfind(raw{n},'DIFFRACTION EXCITING FORCES AND MOMENTS'))==0 & ...
            strcmp(ex_coeff,'diffraction')==1))
        hydro(F).Nh = 0;  % Number of wave headings
        i = n+1;
        while isempty(strfind(raw{i},'Wave Heading'))==0
            hydro(F).Nh = hydro(F).Nh+1;
            tmp = textscan(raw{i}(find(raw{i}==':')+1:end),'%f');
            hydro(F).beta(hydro(F).Nh) = tmp{1};  % Wave headings
            i = i+2;
            for j = 1:6*hydro(F).Nb
                tmp = textscan(raw{i},'%f');
                ma = tmp{1}(2);  % Magnitude of exciting force
                ph = deg2rad(tmp{1}(3));  % Phase of exciting force
                re = ma.*cos(ph);  % Real part of exciting force
                im = ma.*sin(ph);  % Imaginary part of exciting force
                hydro(F).ex_ma(j,hydro(F).Nh,hydro(F).Nf) = ma;
                hydro(F).ex_ph(j,hydro(F).Nh,hydro(F).Nf) = ph;
                hydro(F).ex_re(j,hydro(F).Nh,hydro(F).Nf) = re;
                hydro(F).ex_im(j,hydro(F).Nh,hydro(F).Nf) = im;
                if (i+1<=N)  i = i+1;  end
            end
        end
    end
    d = floor(10*n/N);  % Update progress bar every 10%, otherwise slows computation
    if d>e  waitbar(n/N);  e = d;  end
end

close(p);

end



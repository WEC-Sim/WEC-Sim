function hydro = readNEMOH(hydro,filedir)
% Reads data from a NEMOH working folder.
%
% See ``WEC-Sim\examples\BEMIO\NEMOH`` for examples of usage.
% 
% Parameters
% ----------
%     hydro : struct
%         Structure of hydro data that NEMOH input data will be appended to
%
%     filename : string
%         Path to the NEMOH working folder, must include:
%             
%             - ``Nemoh.cal``
%             - ``Mesh/Hydrostatics.dat`` (or ``Hydrostatiscs_0.dat``, ``Hydrostatics_1.dat``, etc. for multiple bodies)
%             - ``Mesh/KH.dat (or ``KH_0.dat``, ``KH_1.dat``, etc. for multiple bodies)
%             - ``Results/RadiationCoefficients.tec``
%             - ``Results/ExcitationForce.tec``
%             - ``Results/DiffractionForce.tec`` - If simu.nonlinearHydro = 3 will be used
%             - ``Results/FKForce.tec`` - If simu.nonlinearHydro = 3 will be used
% 
% Returns
% -------
%     hydro : struct
%         Structure of hydro data with NEMOH data appended
%

%% Check filedir for required directories
% NOTE: reads upper and lower case directories
    if exist ( fullfile (filedir, 'mesh'), 'dir') == 7        
        meshdir = fullfile (filedir, 'mesh');        
    elseif exist ( fullfile (filedir, 'Mesh'), 'dir') == 7        
        meshdir = fullfile (filedir, 'Mesh');        
    else
        error ('mesh (or Mesh) directory not found in working folder');
    end
    
    if exist ( fullfile (filedir, 'results'), 'dir') == 7        
        resultsdir = fullfile (filedir, 'results');        
    elseif exist ( fullfile (filedir, 'Results'), 'dir') == 7        
        resultsdir = fullfile (filedir, 'Results');        
    else
        error ('results (or Results) directory not found in working folder');
    end

%%
[a,b] = size(hydro);  % Check on what is already there
if b == 1 && ~isfield(hydro(b),'Nb')
    F = 1;
elseif b >= 1
    F = b+1;
end

p = waitbar(0,'Reading NEMOH output file...');  % Progress bar

hydro(F).code = 'NEMOH';
tmp = strsplit(filedir,{' ','\','/'});
tmp(cellfun('isempty',tmp)) = [];
hydro(F).file = tmp{length(tmp)};  % Base name

%% nemoh.cal file
fileID = fopen(fullfile(filedir,'Nemoh.cal'));
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
        tmp = textscan(raw{n},'%f %f %f %f');
        if isempty(tmp{end})
            hydro(F).Nf = tmp{1};  % Number of wave frequencies
            hydro(F).w = linspace(tmp{2},tmp{3},tmp{1});  % Wave frequencies
            hydro(F).T = 2*pi./hydro(F).w;  % Wave periods
        else
            hydro(F).Nf = tmp{2};  % Number of wave frequencies
            if tmp{1} == 1
                hydro(F).w = linspace(tmp{3},tmp{4},tmp{2});  % Wave frequencies
                hydro(F).T = 2*pi./hydro(F).w;  % Wave periods
            elseif tmp{1} == 2
                hydro(F).w = 2*pi*linspace(tmp{3},tmp{4},tmp{2});  % Wave frequencies
                hydro(F).T = 2*pi./hydro(F).w;  % Wave periods
            else
                hydro(F).T = linspace(tmp{3},tmp{4},tmp{2});  % Wave periods
                hydro(F).w = 2*pi./hydro(F).T;  % Wave frequencies
            end
        end   
    end
    if isempty(strfind(raw{n},'Number of wave directions'))==0
        tmp = textscan(raw{n},'%f %f %f');
        hydro(F).Nh = tmp{1};  % Number of wave headings
        hydro(F).theta = linspace(tmp{2},tmp{3},tmp{1});  % Wave headings
    end
end
waitbar(1/8);

%% Hydrostatics file(s)
for m = 1:hydro(F).Nb
    hydro(F).dof(m) = 6;  % Default degrees of freedom for each body is 6
    if hydro(F).Nb == 1
        fileID = fopen(fullfile(meshdir,'Hydrostatics.dat'));
    else
        fileID = fopen([fullfile(meshdir,'Hydrostatics_'),num2str(m-1),'.dat']);
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
waitbar(2/8);

%% KH file(s)
for m = 1:hydro(F).Nb
    if hydro(F).Nb == 1
        fileID = fopen(fullfile(meshdir,'KH.dat'));
    else
        fileID = fopen([fullfile(meshdir,'KH_'),num2str(m-1),'.dat']);   
    end
    raw = textscan(fileID,'%[^\n\r]');
    raw = raw{:};
    fclose(fileID);
    for i=1:6
        tmp = textscan(raw{i},'%f');
        hydro(F).Khs(i,:,m) = tmp{1,1}(1:6);  % Linear restoring stiffness
    end
end
waitbar(3/8);

%% Radiation Coefficient file
fileID = fopen(fullfile(resultsdir,'RadiationCoefficients.tec'));
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
waitbar(4/8);



%% Excitation Force file
fileID = fopen(fullfile(resultsdir,'ExcitationForce.tec'));
raw = textscan(fileID,'%[^\n\r]');
raw = raw{:};
fclose(fileID);
N = length(raw);
i = 0;
for n = 1:N
    if isempty(strfind(raw{n},'Excitation force'))==0 || isempty(strfind(raw{n},'Diffraction force'))==0
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
waitbar(5/8);

%% Diffraction Force file (scattering)
hydro(F).sc_ma = NaN(size(hydro(F).ex_ma));
hydro(F).sc_ph = NaN(size(hydro(F).ex_ph));
hydro(F).sc_re = NaN(size(hydro(F).ex_re));
hydro(F).sc_im = NaN(size(hydro(F).ex_im));
if exist(fullfile(resultsdir,'DiffractionForce.tec'),'file')==2
    fileID = fopen(fullfile(resultsdir,'DiffractionForce.tec'));
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
waitbar(6/8);

%% Froude-Krylov force file
hydro(F).fk_ma = NaN(size(hydro(F).ex_ma));
hydro(F).fk_ph = NaN(size(hydro(F).ex_ph));
hydro(F).fk_re = NaN(size(hydro(F).ex_re));
hydro(F).fk_im = NaN(size(hydro(F).ex_im));
if exist(fullfile(resultsdir,'FKForce.tec'),'file')==2
    fileID = fopen(fullfile(resultsdir,'FKForce.tec'));
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
waitbar(7/8);


%================= READING KOCHIN FILES ===================%
%clear Kochin_BVP x theta i H
if exist(fullfile(resultsdir,'Kochin.    1.dat'),'file')==2
    nb_DOF=size(hydro(F).ex_ma,1);
    nBodies=hydro(F).Nb;
    nw=hydro(F).Nf;
    for j=1:nw
        for i=1:(nb_DOF*nBodies+1)
            clear Kochin
            x=(nb_DOF*nBodies+1)*(j-1)+i;
            switch  numel(num2str(x))
                case 1
                    filename=['Kochin.    ',num2str(x),'.dat'];
                case 2
                    filename=['Kochin.   ',num2str(x),'.dat'];
                case 3
                    filename=['Kochin.  ',num2str(x),'.dat'];
                case 4
                    filename=['Kochin. ',num2str(x),'.dat'];
                case 5
                    filename=['Kochin.',num2str(x),'.dat'];
            end
            
            if exist(fullfile(resultsdir,filename),'file')==2
                fileID = fopen(fullfile(resultsdir,filename));
            end
            Kochin= fscanf(fileID,'%f');
        
            % Kochin###.dat format is [theta1,mag1,phase1,theta2,mag2,phase2...]
            for ntheta=1:size(Kochin,1)/3 
                theta(ntheta)= Kochin(3*(ntheta-1)+1);
                Kochin_BVP(ntheta,1,x)= Kochin(3*(ntheta-1)+2);
                Kochin_BVP(ntheta,2,x)= Kochin(3*(ntheta-1)+3);
            end
            fclose(fileID);
        end
    end

%------Calculate RAO-------
    w=hydro(F).w;
    Fe = hydro(F).ex_re - hydro(F).ex_im*1i; % Added by Toan
    A= hydro(F).A;
    B = hydro(F).B ;
    f=w/(2*pi);
    M=zeros(size(A)); % initialized to be large enough for N bodies
 for m = 1:hydro(F).Nb;
    for nn =1:3
       M(nn+(6*(m-1)),nn+(6*(m-1))) = hydro(F).Vo(m)*hydro(F).rho;
    end

    %% Read Inertia
    if hydro(F).Nb == 1
        fileID = fopen(fullfile(meshdir,'Inertia_hull.dat'));
    else
        fileID = fopen([fullfile(meshdir,'Inertia_'),num2str(m-1),'.dat']);
    end
    for k=1:3
            ligne=fscanf(fileID,'%g %g',3);
            M((6*(m-1))+k+3,((6*(m-1))+4):((6*(m-1))+6))=ligne;
    end
 end       
    KHyd = squeeze(hydro(F).Khs);
    for k=1:length(w)
        for j=1:nb_DOF
            RAO1(k,j)=(Fe(j,k))/(-(M(j,j)+A(j,j,k))*(w(k))^2-1i*w(k)*(B(j,j,k))+KHyd(j,j)); % No coupling between the DoF
        end
    end
    RAO=RAO1;

    %------Initialisation-----
    first_constant= zeros(1,nw);
    second_constant= zeros(1,nw);
    Fdrift_x=zeros(1,nw);
    Fdrift_y=zeros(1,nw);
    H=zeros(ntheta,nw);
    ampl_wave = 1;

%--------------- CALCULATION-----------------------%
    Kochin_BVP_complex(:,:)=Kochin_BVP(:,1,:).*exp(1i*Kochin_BVP(:,2,:)); % H complex
    w=hydro(F).w;
    depth=hydro(F).h;
    for j=1:nw
        m0(j) = calcWaveNumber(w(j),depth);
        k0(j) = (w(j)^2)/9.81; % wave number at an infinite water depth
    
        local1=zeros(ntheta,nb_DOF*nBodies+1);
        local1(:,1)=ampl_wave*Kochin_BVP_complex(:,(nb_DOF*nBodies+1)*(j-1)+1)*exp(1i*pi/2);%
    
        for i=2:(nb_DOF*nBodies+1)% sum of the radiation terms times velocities RAOs
            x=(nb_DOF*nBodies+1)*(j-1)+i;
            local1(:,i)=ampl_wave*(RAO(j,i-1))*(Kochin_BVP_complex(:,x))*exp(1i*pi/2)*(-1i*w(j));
        end
        H(:,j)=sum(local1,2); % H= Kochin function per frequency
        H_real(:,j)=real(H(:,j));
        H_imag(:,j)=imag(H(:,j));
    end
    
    % initialize mean drift field;
    hydro(F).md_mc=hydro(F).ex_ma.*0;
    
    for k=1:hydro(F).Nh; % wave heading loop (in case length(theta)>1)
        rad = pi/180*hydro(F).theta(k); % conversion degrees to radians for nemoh wave direction
        ind_theta=find(abs(theta-rad)==min(abs(theta-rad))); % ind_theta used for determining the appropriate angle of H(dir)
        ind_theta=min(ind_theta); % in case of 2 min found
        for j=1:nw
            % FORMULA (2.170) in Delhommeau Thesis
            first_constant(j)=-2*pi*ampl_wave*hydro(F).rho*w(j);
            second_constant(j)=-(8*pi*hydro(F).rho*m0(j)*(k0(j)*depth)^2)/(depth*(m0(j)^2*depth^2-k0(j)^2*depth^2+k0(j)*depth));
            Fdrift_x(j)=first_constant(j)*cos(rad)*imag(H(ind_theta,j)) + second_constant(j)*imag(trapz(theta,H_real(:,j).*imag(conj(H(:,j))).*cos(theta')));
            Fdrift_y(j)=first_constant(j)*sin(rad)*imag(H(ind_theta,j)) + second_constant(j)*imag(trapz(theta,H_real(:,j).*imag(conj(H(:,j))).*sin(theta')));
        end
        hydro(F).md_mc(1,k,:) = Fdrift_x;
        hydro(F).md_mc(2,k,:) = Fdrift_y;
    end
end

waitbar(8/8);

hydro = normalizeBEM(hydro);  % Normalize the data according the WAMIT convention
hydro = addDefaultPlotVars(hydro);

close(p);
end

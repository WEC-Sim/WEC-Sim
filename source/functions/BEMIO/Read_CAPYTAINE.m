function hydro = Read_CAPYTAINE(hydro,filename)

%% Reads data from a Capytaine netcdf file
%
% hydro = Read_Read_capytaine(hydro, filename)
%     hydro -   data structure
%     filename - Capytaine output file.
% 
% - hydrostatics supported if output from Capytaine appropriately:
% output data should contain center_of_mass, center_of_buoyancy,
% displaced_volume, hydrostatic_stiffness variables
%
% See the call_capytaine function in WEC-Sim/examples/BEMIO/CAPYTAINE for
% correctly outputting these quantities.
%
% Notes:
%     - Body-to-body interaction not currently supported. Only include the 6
%     standard dofs for each body.
%     - Generalized body modes should be supported, but has not yet been
%     tested with the barge example.
%
% TODO:
%     - Add B2B interaction support
%     - Test GBM with barge example
% 
% See '...WEC-Sim\examples\BEMIO\CAPYTAINE...' for examples of usage.

%% Check file for required variables
[a,b] = size(hydro);  % Check on what is already there
if b==1 && ~isfield(hydro(b),'Nb')
    F = 1;
elseif b>=1
    F = b+1;
end

p = waitbar(0,'Reading Capytaine netcdf output file...'); %Progress bar

hydro(F).code = 'CAPYTAINE';
[filepath,name,ext] = fileparts(filename);
hydro(F).file = name;  % Base name

% Load info (names, size, ...) of Capytaine variables, dimensions, ...
info = ncinfo(filename);

% get all variables names in Capytaine output
cpt_vars = cell(length(info.Variables),1);
for ii=1:length(info.Variables)
    cpt_vars{ii} = info.Variables(ii).Name;
end

% get all dimension names in Capytaine output
cpt_dims = cell(length(info.Dimensions),1);
for ii=1:length(info.Dimensions)
    cpt_dims{ii} = info.Dimensions(ii).Name;
end

% list of variables to get from netcdf file
req_vars = {
    'complex',...
    'body_name',...
    'g',...
    'rho',...
    'water_depth',...
    'influenced_dof'...
    'radiating_dof',...
    'omega',...
    'wave_direction',...
    'added_mass',...
    'radiation_damping',...
    'diffraction_force',...
    'Froude_Krylov_force',...
    'center_of_mass',...
    'center_of_buoyancy',...
    'hydrostatic_stiffness',...
    'displaced_volume'};

% Other vars in Capytaine .nc file not currently used
% {'theta','kochin_diffraction','kochin',...
% 'wavenumber';'wavelength';'radiation_damping';}

% check that all required Capytaine output is present
tmp = '';
for i=1:length(req_vars)
    if ~contains(lower(req_vars{i}), lower(cpt_vars))
%         error('Capytaine output does not contain: %s',req_vars{i});
        tmp = strcat(tmp, sprintf('Capytaine output does not contain: %s \n',req_vars{i}));
    end
end
if isempty(tmp)
    error(tmp);
end

% test dofs reordering function
% test = ["Surge","Heave","Yaw","Sway","Roll","Pitch"];
% var = ([1:6]'*[1 3 6 2 4 5])';
% nv = reset_dofs(var,test,1);

%% begin parsing netcdf file to hydro struct
% Read number of bodies
tmp = getInd(info.Dimensions,'body_name');
if tmp==0
    hydro(F).Nb = 1;
else
    hydro(F).Nb = info.Dimensions(tmp).Length;
end

% Read body names and strip file path/extension if necessary
tmp = ncread(filename,'body_name')';
for i=1:hydro(F).Nb
    hydro(F).body{i} = tmp(i,:);
end

% Read center of gravity, center of buoyancy, displaced volume
% NOTE: requires additional Capytaine hydrostatics functions to work. 
% (these are not currently output in Capytaine, hence the if statement)
hydro(F).cg = [0;0;0];
hydro(F).cb = [0;0;1e-2];
hydro(F).Vo = 0;
if max(contains(lower(cpt_vars), 'center_of_mass')) && ...
    max(contains(lower(cpt_vars), 'center_of_buoyancy')) && ...
    max(contains(lower(cpt_vars), 'displaced_volume'))

    hydro(F).cg = ncread(filename,'center_of_mass'); % center of gravity
    hydro(F).cb = ncread(filename,'center_of_buoyancy'); % center of buoyancy
    hydro(F).Vo = ncread(filename,'displaced_volume')'; % displaced volume
else
    warning('Hydrostatics data not included in Capytaine output. Using default values.');
end

% Read density, gravity and water depth
hydro(F).rho = ncread(filename,'rho');
hydro(F).g = ncread(filename,'g');
hydro(F).h = ncread(filename,'water_depth');

% Read number of frequencies and wave headings
hydro(F).Nf = info.Dimensions(getInd(info.Dimensions,'omega')).Length;
hydro(F).Nh = info.Dimensions(getInd(info.Dimensions,'wave_direction')).Length;

% Read frequency array, wave direction and calculate period from frequency
hydro(F).w = ncread(filename,'omega')';
hydro(F).T = 2*pi./hydro(F).w;
hydro(F).beta = ncread(filename,'wave_direction')';

% Read number of dofs (should be 6x6 or larger for GBM)
for i=1:hydro(F).Nb
    dof_i = info.Dimensions(getInd(info.Dimensions,'influenced_dof')).Length;
    dof_r = info.Dimensions(getInd(info.Dimensions,'radiating_dof')).Length;
    if dof_i ~= dof_r
        error(['Error:read_capytaine_v1: Length of influenced and radiating degrees of freedom do not' ...
            'match. Check input / BEM simulation.']);
    end
    hydro(F).dof(1,i) = dof_i; % 6 normally, >6 with GBM
end
waitbar(2/8);

%% Reordering parameters
% check the ordering of the 'complex' dimension
tmp = ncread(filename,'complex')';
if tmp(1,:) == "re" && tmp(2,:) == "im"
    i_re = 1;
    i_im = 2;
elseif tmp(1,:) == "im" && tmp(2,:) == "re"
    i_im = 1;
    i_re = 2;
else
    error('check complex dimension indices');
end

% check the ordering of the 'radiating_dof' dimension
rdofs = lower(string(ncread(filename,'radiating_dof')'));
rdofs = erase(rdofs, char(0));
if strcmp(rdofs(1), "surge") && ... 
        strcmp(rdofs(2), "sway") && ...
        strcmp(rdofs(3), "heave") && ...
        strcmp(rdofs(4), "roll") && ...
        strcmp(rdofs(5), "pitch") && ...
        strcmp(rdofs(6), "yaw")
    reset_rdofs = false;
else
    reset_rdofs = true;
end

% check the ordering of the 'influenced_dof' dimension
idofs = lower(string(ncread(filename,'influenced_dof')'));
idofs = erase(idofs,char(0));
if strcmp(idofs(1), "surge") && ... 
        strcmp(idofs(2), "sway") && ...
        strcmp(idofs(3), "heave") && ...
        strcmp(idofs(4), "roll") && ...
        strcmp(idofs(5), "pitch") && ...
        strcmp(idofs(6), "yaw")
    reset_idofs = false;
else
    reset_idofs = true;
end
waitbar(1/8);

%% Linear restoring stiffness [6, 6, Nb]
% Note: Capytaine does not calculate this by default. Must currently
% include additional function to calculate this before outputting
hydro(F).C = zeros(6,6,hydro(F).Nb);  % Linear restoring stiffness, Defaults to 0 if Capytaine doesn't include
if max(contains(lower(cpt_vars), 'hydrostatic_stiffness'))
    % Get index of variable
    i_var = getInd(info.Variables,'hydrostatic_stiffness');

    % get dimensions of the variable
    dim = info.Variables(i_var).Dimensions;
    i_infdof = getInd(dim,'influenced_dof');
    i_raddof = getInd(dim,'radiating_dof');
    i_bod = getInd(dim,'body_name');

    % read variable
    tmp = ncread(filename,'hydrostatic_stiffness');

    % Loop through bodies and add each body's stiffness to the matrix
    for n=1:hydro(F).Nb
        % Assign stiffness values to matrix
        tmp2 = [tmp(1,n) tmp(2,n) tmp(3,n); ...
                tmp(2,n) tmp(4,n) tmp(5,n); ...
                tmp(3,n) tmp(5,n) tmp(6,n)];
        hydro(F).C(3:5,3:5,n) = tmp2; % Linear restoring stiffness
    end
end
waitbar(3/8);

%% Radiation added mass [6*Nb, 6*Nb, Nf]
% Get index of variable
i_var = getInd(info.Variables,'added_mass');

% get dimensions of the variable
dim = info.Variables(i_var).Dimensions;
i_infdof = getInd(dim,'influenced_dof');
i_raddof = getInd(dim,'radiating_dof');
i_w = getInd(dim,'omega');
i_bod = getInd(dim,'body_name');

% read variable
tmp = ncread(filename,'added_mass');

% permute variable to correct dimensions if incorrect
if hydro(F).Nb == 1 || i_bod == 0
    tmp = permute(tmp,[i_infdof, i_raddof, i_w]);
else
    tmp = permute(tmp,[i_infdof, i_raddof, i_w, i_bod]);
end

% permute the influenced dof direction is not output by Capytaine correctly
if reset_idofs
    tmp = reset_dofs(tmp,idofs,1);
end
if reset_rdofs
    tmp = reset_dofs(tmp,rdofs,2);
end

% Loop through bodies and add each body to its diagonal 6x6 matrix
hydro(F).A = zeros(6*hydro(F).Nb, 6*hydro(F).Nb, hydro(F).Nf);
for n=1:hydro(F).Nb
    hydro(F).A(6*(n-1)+1:6*n,6*(n-1)+1:6*n,:) = tmp(:,:,:,n); % Radiation added mass matrix
end

%% Radiation damping [6*Nb, 6*Nb, Nf]
% Get index of variable
i_var = getInd(info.Variables,'radiation_damping');

% get dimensions of the variable
dim = info.Variables(i_var).Dimensions;
i_infdof = getInd(dim,'influenced_dof');
i_raddof = getInd(dim,'radiating_dof');
i_w = getInd(dim,'omega');
i_bod = getInd(dim,'body_name');

% read variable
tmp = ncread(filename,'radiation_damping');

% permute variable to correct dimensions if incorrect
if hydro(F).Nb == 1 || i_bod == 0
    tmp = permute(tmp,[i_infdof, i_raddof, i_w]);
else
    tmp = permute(tmp,[i_infdof, i_raddof, i_w, i_bod]);
end

% permute the influenced dof direction is not output by Capytaine correctly
if reset_idofs
    tmp = reset_dofs(tmp,idofs,1);
end
if reset_rdofs
    tmp = reset_dofs(tmp,rdofs,2);
end

% Loop through bodies and add each body to its diagonal 6x6 matrix
hydro(F).B = zeros(6*hydro(F).Nb, 6*hydro(F).Nb, hydro(F).Nf);
for n=1:hydro(F).Nb
    hydro(F).B(6*(n-1)+1:6*n,6*(n-1)+1:6*n,:) = tmp(:,:,:,n); % Radiation damping matrix
end
waitbar(4/8);

%% Froude-Krylov force file [6*Nb,Nh,Nf];
% Get index of variable
i_var = getInd(info.Variables,'Froude_Krylov_force');

% get dimensions of the variable
dim = info.Variables(i_var).Dimensions;
i_infdof = getInd(dim,'influenced_dof');
i_dir = getInd(dim,'wave_direction');
i_w = getInd(dim,'omega');
i_bod = getInd(dim,'body_name');
i_comp = getInd(dim,'complex');

% read variable
tmp = ncread(filename,'Froude_Krylov_force');

% permute variable to correct dimensions if incorrect
if hydro(F).Nb == 1 || i_bod == 0
    tmp = permute(tmp,[i_infdof, i_dir, i_w, i_comp]);
else
    tmp = permute(tmp,[i_infdof, i_dir, i_w, i_comp, i_bod]);
end

% permute the influenced dof direction is not output by Capytaine correctly
if reset_idofs
    tmp = reset_dofs(tmp,idofs,1);
end

% Set real and imaginary components of variable. Calculate magnitude and
% phase from components
for n=1:hydro(F).Nb
    hydro(F).fk_re(6*(n-1)+1:6*n,:,:) = tmp(:,:,:,i_re,n);      % Real part of Froude Krylov force
    hydro(F).fk_im(6*(n-1)+1:6*n,:,:) = -tmp(:,:,:,i_im,n);     % Imaginary part of Froude Krylov force, negative because Nemoh/Capytaine x-direction is flipped
end
hydro(F).fk_ma = (hydro(F).fk_re.^2 + hydro(F).fk_im.^2).^0.5;  % Magnitude of Froude Krylov force
hydro(F).fk_ph = angle(hydro(F).fk_re + 1i*hydro(F).fk_im);     % Phase of Froude Krylov force
waitbar(6/8);

%% Diffraction Force (scattering) [6*Nb,Nh,Nf];
% Get index of variable
i_var = getInd(info.Variables,'diffraction_force');

% get dimensions of the variable
dim = info.Variables(i_var).Dimensions;
i_infdof = getInd(dim,'influenced_dof');
i_dir = getInd(dim,'wave_direction');
i_w = getInd(dim,'omega');
i_bod = getInd(dim,'body_name');
i_comp = getInd(dim,'complex');

% read variable
tmp = ncread(filename,'diffraction_force');

% permute variable to correct dimensions if incorrect
if hydro(F).Nb == 1 || i_bod == 0
    tmp = permute(tmp,[i_infdof, i_dir, i_w, i_comp]);
else
    tmp = permute(tmp,[i_infdof, i_dir, i_w, i_comp, i_bod]);
end

% permute the influenced dof direction is not output by Capytaine correctly
if reset_idofs
    tmp = reset_dofs(tmp,idofs,1); 
end

% Set real and imaginary components of variable. Calculate magnitude and
% phase from components
for n=1:hydro(F).Nb
    hydro(F).sc_re(6*(n-1)+1:6*n,:,:) = tmp(:,:,:,i_re,n);      % Real part of diffraction force
    hydro(F).sc_im(6*(n-1)+1:6*n,:,:) = -tmp(:,:,:,i_im,n);     % Imaginary part of diffraction force, negative because Nemoh/Capytaine x-direction is flipped
end
hydro(F).sc_ma = (hydro(F).sc_re.^2 + hydro(F).sc_im.^2).^0.5;  % Magnitude of diffraction force
hydro(F).sc_ph = angle(hydro(F).sc_re + 1i*hydro(F).sc_im);     % Phase of diffraction force
waitbar(5/8);

%% Excitation Force [6*Nb,Nh,Nf];
% Calculate total excitation force: F_ex = F_sc + F_fk
hydro(F).ex_re = hydro(F).sc_re + hydro(F).fk_re;
hydro(F).ex_im = hydro(F).sc_im + hydro(F).fk_im;
hydro(F).ex_ma = (hydro(F).ex_re.^2 + hydro(F).ex_im.^2).^0.5;  % Magnitude of excitation force
hydro(F).ex_ph = angle(hydro(F).ex_re + 1i*hydro(F).ex_im);     % Phase of excitation force
waitbar(7/8);

%% Kochin diffraction
% from 
% theta(ntheta)= Kochin(3*(ntheta-1)+1); % theta
% Kochin_BVP(ntheta,1,x)= Kochin(3*(ntheta-1)+2); % magnitude
% Kochin_BVP(ntheta,2,x)= Kochin(3*(ntheta-1)+3); % phase

% CHECK if the kochin_diffraction is actually the excitation force??
% i_var = getInd(info.Variables,'kochin_diffraction');

waitbar(8/8);

hydro = Normalize(hydro);  % Normalize the data according the WAMIT convention

close(p);

%% test reset_dofs w/ gbm
% a = magic(6);
% amix = a;
% ar = ["surge", "sway", "heave", "roll", "pitch", "yaw"];
% ai = ["surge", "sway", "heave", "roll", "pitch", "yaw"];
% a2 = reset_dofs(amix, ar, 1);
% a2 = reset_dofs(a2, ai, 2);
% fprintf(['a should be unchanged. max diff: ' int2str(max(abs(a2-a),[],'all')) '\n']);
% 
% b = magic(7);
% bmix = b(:,[1 7 2 3 4 5 6]);
% br = ["surge", "sway", "heave", "roll", "pitch", "yaw", "gbm1asdf"];
% bi = ["surge", "gbm1", "sway", "heave", "roll", "pitch", "yaw"];
% b2 = reset_dofs(bmix, br, 1);
% b2 = reset_dofs(b2, bi, 2);
% fprintf(['b should be unchanged. max diff: ' int2str(max(abs(b2-b),[],'all')) '\n']);
% 
% c = magic(7);
% cmix = c;
% cr = ["surge", "sway", "heave", "roll", "pitch", "yaw", "gbm1asdf"];
% ci = ["surge", "sway", "heave", "roll", "pitch", "yaw", "gbm1"];
% c2 = reset_dofs(cmix, cr, 1);
% c2 = reset_dofs(c2, ci, 2);
% fprintf(['c should be unchanged. max diff: ' int2str(max(abs(c2-c),[],'all')) '\n']);
% 
% d = magic(6);
% dmix = d([2 1 3 5 4 6],[1 2 4 3 5 6]);
% dr = ["sway", "surge", "heave", "pitch", "roll", "yaw"];
% di = ["surge", "sway", "roll", "heave", "pitch", "yaw"];
% d2 = reset_dofs(dmix, dr, 1);
% d2 = reset_dofs(d2, di, 2);
% fprintf(['d should be unchanged. max diff: ' int2str(max(abs(d2-d),[],'all')) '\n']);

end

function new_var = reset_dofs(variable, old_dofs, dim)
% this function will rearrange dimension 'dim' of a 'variable' if the dofs
% ('old_dofs') are not in the correct order: 
%    [surge, sway, heave, roll, pitch, yaw, gbm, ...]

% todo - may need to change standard dof list when b2b is implemented

% list of standard dofs
new_dofs = ["surge", "sway", "heave", "roll", "pitch", "yaw"];

% Check for any GBM degrees of freedom, and add them to a list of GBM dof
% names if any
gbm_dofs = [];
if length(old_dofs) > 6
    n_gbm = length(old_dofs)-6; % number of GBM dofs
    gbm_dofs = []; % list of GBM dofs (string)
    
    % Loop through all of the variables dofs. If a dof is not contained in
    % the standard list of 6, add it to the GBM dof list
    for i=1:n_gbm+6
        if ~max(contains(new_dofs,old_dofs(i)))
            if isempty(gbm_dofs)
                gbm_dofs = old_dofs(i);
            else
                gbm_dofs(end+1) = old_dofs(i);
            end
        end
    end
else
    n_gbm = 0;
end

% concatenate standard and GBM dofs
new_dofs = [new_dofs gbm_dofs];
new_inds = zeros(6+n_gbm,1);

% find the index of the old_dof, and assign to correct location in new_inds
for j=1:6+n_gbm
    for i=1:6+n_gbm
        if lower(old_dofs(j)) == new_dofs(i)
            new_inds(i) = j;
            continue
        end
    end
end

% Create new_var as the reordered variable(:,new_inds,:,:,:,:,:,...); 
% If necessary, they are reordered as:
%    [surge, sway, heave, roll, pitch, yaw, gbm...]
% Colons are included to ensure all dimensions are captured
new_var = zeros(size(variable));
str = [repmat(':,',[1,dim-1]) 'new_inds' repmat(',:',[1,(ndims(variable)-dim)])];

% eval(['new_var = variable(' str ');']);
new_var = variable;
end

function ind = getInd(dimStruct, str2find)
    ind = 0;
    for j=1:length(dimStruct)
        if string(dimStruct(j).Name) == str2find
            ind = j;
        end
    end
end


function hydro = Read_CAPYTAINE_b2b_v4(hydro,filename)

%% Reads data from a Capytaine netcdf file
%
% Adding B2B interaction capability
% Current with Read_CAPYTAINE() as of 11/24 (commit 1692c3684fe)
%
% _v3 changes the sorting function to work with both GBM and B2B
% _v4 changes b2b functionality to work with actual Capytaine b2b output
% body=(body1+body2+...)

%% Check file for required variables
[a,b] = size(hydro);  % Check on what is already there
if b==1 && ~isfield(hydro(b),'Nb')
    F = 1;
elseif b>=1
    F = b+1;
end

p = waitbar(0,'Reading Capytaine netcdf output file...'); %Progress bar

hydro(F).code = 'CAPYTAINE';
[~,name,~] = fileparts(filename);
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
%     'center_of_mass',...
%     'center_of_buoyancy',...
%     'hydrostatic_stiffness',...
%     'displaced_volume',...
    };

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
error(tmp); % only throws error if required variables are not present (tmp ~= '')
% if ~isempty(tmp)
%     error(tmp);
% end

%% begin parsing netcdf file to hydro struct
% Read body names
tmp = ncread(filename,'body_name')';
[s1,s2] = size(tmp);
for i=1:s1
    hydro(F).body{i} = erase(tmp(i,:), char(0)); % assign preliminary value to body names
end
% hydro(F).body = tmp;

% sort radiating dof into standard list if necessary
rdofs = lower(string(ncread(filename,'radiating_dof')'));
rdofs = erase(rdofs, char(0));
[r_sorted_dofs,rinds,reset_rdofs,r_nDofs,r_bodies] = sorted_dof_list(rdofs, hydro(F).body);

% sort radiating dof into standard list if necessary
idofs = lower(string(ncread(filename,'influenced_dof')'));
idofs = erase(idofs, char(0));
[i_sorted_dofs,iinds,reset_idofs,i_nDofs,i_bodies] = sorted_dof_list(idofs, hydro(F).body);

% Set number of bodies. 
% Can't use the 'body_name' variable bc in Capytaine B2B this becomes one 
%    value with 'body1+body2+...bodyN'
if length(r_nDofs) == length(i_nDofs)
    hydro(F).Nb = length(i_nDofs);
else
    error('Error:read_capytaine: Number of bodies in radiating and influenced dofs does not match.');
end

% number of dofs / body (should be 6 or larger for GBM)
hydro(F).dof = i_nDofs;

% update body names
hydro(F).body = i_bodies;

%% Reorder dofs if needed
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

% Check that radiating & influenced dofs are same length and at least 6*Nb
dof_i = length(i_sorted_dofs);
dof_r = length(r_sorted_dofs);
if dof_i ~= dof_r
    error(['Error:read_capytaine_v1: Length of influenced and radiating degrees of freedom do not' ...
        'match. Check input / BEM simulation.']);
end
if dof_i < 6*hydro(F).Nb || dof_r < 6*hydro(F).Nb
    error(['Error:read_capytaine_v1: Length of influenced and radiating degrees of freedom is less' ...
        'than 6*Nb (standard dofs for each body). Check input / BEM simulation.']);
end

waitbar(1/8);

%% Read hydrostatics and basic parameters
% center of gravity, center of buoyancy, displaced volume
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
    warning('Hydrostatics data not included in Capytaine output. Using zero for cg,cb,Vo.');
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

waitbar(2/8);

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
clear tmp tmp2
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
    tmp = sum(tmp,4); % combine body dimensions
end

% permute the influenced/radiating dofs if not output by Capytaine correctly
if reset_idofs
    tmp = tmp(iinds,:,:);
end
if reset_rdofs
    tmp = tmp(:,rinds,:);
end

hydro(F).A = tmp;

clear tmp

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
    tmp = sum(tmp,4); % combine body dimensions
end

% permute the influenced/radiating dofs if not output by Capytaine correctly
if reset_idofs
    tmp = tmp(iinds,:,:);
end
if reset_rdofs
    tmp = tmp(:,rinds,:);
end

hydro(F).B = tmp;

clear tmp
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
    tmp = sum(tmp,5); % combine body dimensions
end

% permute the influenced dofs if not output by Capytaine correctly
if reset_idofs
    tmp = tmp(iinds,:,:,:);
end

% Set real and imaginary components of variable. Calculate magnitude and
% phase from components
hydro(F).fk_re = tmp(:,:,:,i_re);
hydro(F).fk_im = -tmp(:,:,:,i_im);
hydro(F).fk_ma = (hydro(F).fk_re.^2 + hydro(F).fk_im.^2).^0.5;  % Magnitude of Froude Krylov force
hydro(F).fk_ph = angle(hydro(F).fk_re + 1i*hydro(F).fk_im);     % Phase of Froude Krylov force

clear tmp
waitbar(5/8);

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
    tmp = sum(tmp,5); % combine body dimensions
end

% permute the influenced dofs if not output by Capytaine correctly
if reset_idofs
    tmp = tmp(iinds,:,:,:);
end

% Set real and imaginary components of variable. Calculate magnitude and
% phase from components
hydro(F).sc_re = tmp(:,:,:,i_re);
hydro(F).sc_im = -tmp(:,:,:,i_im);
hydro(F).sc_ma = (hydro(F).sc_re.^2 + hydro(F).sc_im.^2).^0.5;  % Magnitude of diffraction force
hydro(F).sc_ph = angle(hydro(F).sc_re + 1i*hydro(F).sc_im);     % Phase of diffraction force

clear tmp
waitbar(6/8);

%% Excitation Force [6*Nb,Nh,Nf];
% Calculate total excitation force: F_ex = F_sc + F_fk
hydro(F).ex_re = hydro(F).sc_re + hydro(F).fk_re;
hydro(F).ex_im = hydro(F).sc_im + hydro(F).fk_im;
hydro(F).ex_ma = (hydro(F).ex_re.^2 + hydro(F).ex_im.^2).^0.5;  % Magnitude of excitation force
hydro(F).ex_ph = angle(hydro(F).ex_re + 1i*hydro(F).ex_im);     % Phase of excitation force

waitbar(7/8);

%% Kochin diffraction
% from Read_WAMIT()
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

%% functions
function [sorted_dofs,inds,reset_tf, nDofs_per_body, new_body_names] = sorted_dof_list(old_dofs, body_names)
% 1. sort by body name: 'bodyName{i}__dofName'
% 2. sort each body's dofs by std + gbm: surge, sway, heave, roll, pitch, yaw, gbm1, gbm2, ...
% 3. concate
% this function will rearrange dimension 'dim' of a 'variable' if the dofs
% ('old_dofs') are not in the correct order: 
%    [surge, sway, heave, roll, pitch, yaw, gbm, ...]

% list of standard dofs
std_dofs = ["surge", "sway", "heave", "roll", "pitch", "yaw"];
tmp = '__';

new_body_names = body_names;
if length(body_names)==1
    if contains(body_names,'+')
        tmpi = strfind(body_names,'+');
        tmpname = body_names;
        
        body_names{1} = tmpname{1}(1:tmpi{1}-1); % first
        for i=1:length(tmpi)-1
            body_names{i+1} = tmpname{1}(tmpi{i-1}+1:tmpi{i}-1); % rest
        end
        body_names{end+1} = tmpname{1}(tmpi{end}+1:end); % first
        new_body_names = body_names; % reset if body_names was 'body1+body2+body3+...'
        clear tmpi tmpname i
    else
        body_names = {''};
        tmp = '';
    end
end
nDofs_per_body = zeros(1,length(body_names));

sorted_dofs = [];
for k=1:length(body_names)
    body_dofs = old_dofs(contains(old_dofs,body_names{k})); % all dofs for body k
    std_body_dofs = strcat(body_names{k},tmp,std_dofs); % standard 6 dofs for body k
    gbm_dofs = body_dofs(~contains(body_dofs,std_body_dofs)); % any gbm dofs for body k (i.e. not in std list)
    
    if isempty(gbm_dofs); gbm_dofs=[]; end % prevent formatting error when concatenating on next line
    sorted_dofs = [sorted_dofs std_body_dofs gbm_dofs]; % concatenate [std(k) gbm(k) std(k+1) gbm(k+1)...]
    
    nDofs_per_body(k) = length(body_dofs); % set number of dofs for each body
end

% set the indices that sort the old dofs/variables into the correct order
for j=1:length(old_dofs)
    for i=1:length(sorted_dofs)
        if lower(old_dofs(j)) == sorted_dofs(i)
            inds(i) = j;
            continue
        end
    end
end

% check that inds is setup correctly. test should match sorted_dofs
% test = old_dofs(inds); 
reset_tf = any(inds~=1:length(sorted_dofs));
end


function ind = getInd(dimStruct, str2find)
    ind = 0;
    for j=1:length(dimStruct)
        if string(dimStruct(j).Name) == str2find
            ind = j;
        end
    end
end


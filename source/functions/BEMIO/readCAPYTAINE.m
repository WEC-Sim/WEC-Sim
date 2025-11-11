function hydro = readCAPYTAINE(hydro, filename, hydrostatics_sub_dir)
% Reads data from a Capytaine netcdf file
% 
% See ``WEC-Sim\examples\BEMIO\CAPYTAINE`` for examples of usage.
%
% Parameters
% ----------
%     hydro : struct
%         Structure of hydro data that Capytaine input data will be appended to
%     
%     filename : string
%         Capytaine .nc output file
%
%     hydrostatics_sub_dir : string
%         Path to directory where Hydrostatics.dat and KH.dat files are saved 
%
% Returns
% -------
%     hydro : struct
%         Structure of hydro data with Capytaine data appended

%% Check file for required variables
[~,b] = size(hydro);  % Check on what is already there
if b == 1 && ~isfield(hydro(b),'Nb')
    F = 1;
elseif b >= 1
    F = b+1;
end

p = waitbar(0,'Reading Capytaine netcdf output file...'); %Progress bar

hydro(F).code = 'CAPYTAINE';

[base_dir, name, ~] = fileparts(filename);

if exist('hydrostatics_sub_dir','var') & ~isempty(hydrostatics_sub_dir)
    hydrostatics_dir = append(base_dir, hydrostatics_sub_dir);
else
    hydrostatics_dir = base_dir;
end

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
    };

% Other vars in Capytaine .nc file not currently used:
% {'theta','kochin_diffraction','kochin',...
% 'wavenumber';'wavelength','center_of_mass',...
% 'center_of_buoyancy','hydrostatic_stiffness',...
% 'displaced_volume'};

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
[s1,~] = size(tmp);
for i=1:s1
    hydro(F).body{i} = erase(tmp(i,:), char(0)); % assign preliminary value to body names
end
hydro(F).body = split(hydro(F).body{1},'+');

% sort radiating dof into standard list if necessary
rdofs = lower(string(ncread(filename,'radiating_dof')'));
rdofs = erase(rdofs, char(0));
[r_sorted_dofs,rinds,reset_rdofs,r_nDofs,r_bodies] = sorted_dof_list(rdofs, hydro(F).body);

% sort influenced dof into standard list if necessary
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
for i=1:hydro(F).Nb
    hydro(F).dof(i) = max(6,i_nDofs(i));
end


%% Reorder dofs if needed
% check the ordering of the 'complex' dimension
tmp = string(ncread(filename,'complex')');
if tmp{1} == "re" && tmp{2} == "im"
    i_re = 1;
    i_im = 2;
elseif tmp(1,:) == "im" && tmp(2,:) == "re"
    i_im = 1;
    i_re = 2;
else
    error('Error:BEMIO:Read_Capytaine: check complex dimension indices');
end

% Check that radiating & influenced dofs are same length and at least 6*Nb
dof_i = length(i_sorted_dofs);
dof_r = length(r_sorted_dofs);
if dof_i ~= dof_r
    error(['Error:BEMIO:Read_Capytaine: Length of influenced and radiating degrees of freedom do not' ...
        'match. Check input / BEM simulation.']);
end
if dof_i < 6*hydro(F).Nb || dof_r < 6*hydro(F).Nb
    warning(['Warning:BEMIO:Read_Capytaine: Length of influenced and radiating degrees of freedom is less' ...
        'than 6*Nb (standard dofs for each body). Check input / BEM simulation.']);
end

waitbar(1/8);

%% Read simulation parameters
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
hydro(F).theta = 180/pi*ncread(filename,'wave_direction')';

%% Read hydrostatics - center of gravity, center of buoyancy, displaced volume
% Note: Capytaine may not output this by default.
for m = 1:hydro(F).Nb
    % Look for Hydrostatics.dat files. Same format as Nemoh.
    if hydro(F).Nb == 1
        fileID = fopen(fullfile(hydrostatics_dir,'Hydrostatics.dat'));
    else
        fileID = fopen([fullfile(hydrostatics_dir,'Hydrostatics_'),num2str(m-1),'.dat']);
    end
    
    if fileID ~= -1
        % Hydrostatics.dat files present, read them
        raw = textscan(fileID,'%[^\n\r]');
        raw = raw{:};
        fclose(fileID);
        for i=1:3
            tmp = textscan(raw{i},'%s %s %f %s %s %s %f');
            hydro(F).cb(i,m) = tmp{3};  % Center of buoyancy
            hydro(F).cg(i,m) = tmp{7};  % Center of gravity
        end
        tmp = textscan(raw{4},'%s %s %f');
        hydro(F).Vo(m) = tmp{3};  % Displaced volume
    else
        % No Hydrostatics.dat files present. Check the .nc file
        try
            hydro(F).cg = ncread(filename,'center_of_mass');
            hydro(F).cb = ncread(filename,'center_of_buoyancy');
            hydro(F).Vo = ncread(filename,'volume')';
        catch ME
            switch ME.identifier
                case 'MATLAB:imagesci:netcdf:unknownLocation'
                    warning(['Hydrostatics data not included in .nc nor .dat files! ',...
                             'Value of zero assigned to cg, cb, Vo.']);
                    hydro(F).cg = zeros(3,hydro(F).Nb);
                    hydro(F).cb = zeros(3,hydro(F).Nb);
                    hydro(F).Vo = zeros(1,hydro(F).Nb);
                otherwise
                    rethrow(ME)
            end
        end
    end
end

waitbar(2/8);

%% Linear restoring stiffness [6, 6, Nb]
% Note: Capytaine may not output this by default.
% Look for KH.dat files. Same format as Nemoh.
if hydro(F).Nb == 1
    fileID = fopen(fullfile(hydrostatics_dir,'KH.dat'));
else
    fileID = fopen(fullfile(hydrostatics_dir,'KH_0.dat'));
end

if fileID ~= -1
    for m = 1:hydro(F).Nb
        if hydro(F).Nb == 1
            fileID = fopen(fullfile(hydrostatics_dir,'KH.dat'));
        else
            fileID = fopen([fullfile(hydrostatics_dir,'KH_'),num2str(m-1),'.dat']);
        end
        
        % KH.dat files present, read them
        raw = textscan(fileID,'%[^\n\r]');
        raw = raw{:};
        fclose(fileID);
        for i = 1:6
            tmp = textscan(raw{i},'%f');
            hydro(F).Khs(i,:,m) = tmp{1,1}(1:6);  % Linear restoring stiffness
        end
    end
else
    % No KH.dat files present. Check the .nc file
    try
        % Get index of variable
        i_var = getInd(info.Variables,'hydrostatic_stiffness');
        
        % get dimensions of the variable
        dim = info.Variables(i_var).Dimensions;
        i_infdof = getInd(dim,'influenced_dof');
        i_raddof = getInd(dim,'radiating_dof');

        % read variable
        tmp = ncread(filename,'hydrostatic_stiffness');

        % permute variable to correct dimensions if incorrect
        tmp = permute(tmp,[i_infdof, i_raddof]);

        % permute the influenced/radiating dofs if not output by Capytaine correctly
        % Initialize stiffness as 6*Nbx6*Nb to allow reading 
        % Capytaine data with <6 DOFs.
        % Then convert to 6x6xNb
        KHS = zeros(sum(hydro(F).dof),sum(hydro(F).dof));
        if reset_idofs || reset_rdofs
            for j=1:sum(hydro(F).dof)
                for k=1:sum(hydro(F).dof)
                    if iinds(j) ~= 0 && rinds(k) ~= 0
                        KHS(j,k) = tmp(iinds(j),rinds(k));
                    end
                end
            end
        else
            KHS = tmp;
        end

  %% Add GBM field
  %
        if hydro(F).dof > 6;
            hydro(F).gbm = zeros(hydro(F).dof,hydro(F).dof,4); % mech inertia, mech damping, mech stiffness, hydrostatic stiffness
            % capytaine at this time does not allow non-zero mech inertia, damping,
            % stiffness but DOES include hydrostatic stiffness for gbm modes.
            hydro(F).gbm(:,:,4) = KHS;
             % hydro.gbm([1:6],[1:6],4) will be redundant of rigid body hydro.Khs
            % values
            warning(['Additional modes detected. \n \r ' ...
                'Capytaine does not allow non-zero mechanical inertia, damping, or stiffness \n \r ' ...
                'for generalized body modes, these have been presumed zero.' ...
                'Modify hydro.gbm(:,:,[1:3]) to consider non-zero values.' ...
                'The hydrostatic stiffness \n \r ' ...
                'of these modes (hydro.gbm(:,:,4)) are calculated from BEM.'])
         end
        % Expand the Khs matrix from 6*Nbx6*Nb to the desired 6x6xNb
        for m = 1:hydro(F).Nb
            hydro(F).Khs(:,:,m) = KHS((m-1)*6+1:(m-1)*6+6,(m-1)*6+1:(m-1)*6+6);
        end

    catch ME
        switch ME.identifier
            case 'MATLAB:imagesci:netcdf:unknownLocation'
                warning(['Hydrostatic stiffness not included in .nc nor .dat files! ',...
                         'Value of zero assigned to Khs.']);
                hydro(F).Khs = zeros(6,6,hydro(F).Nb);
            otherwise
                rethrow(ME)
        end
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
    tmp = sum(tmp,4); % combine body dimensions
end

% permute the influenced/radiating dofs if not output by Capytaine correctly
% Initialize added mass as 6x6xNf (or larger if gbm) to allow reading 
% Capytaine data with <6 DOFs.
AM = zeros(sum(hydro(F).dof), sum(hydro(F).dof), hydro(F).Nf);
if reset_idofs || reset_rdofs
    for j=1:sum(hydro(F).dof)
        for k=1:sum(hydro(F).dof)
            if iinds(j) ~= 0 && rinds(k) ~= 0
                AM(j,k,:) = tmp(iinds(j),rinds(k),:);
            end
        end
    end
else
    AM = tmp;
end
hydro(F).A = AM;
clear tmp AM

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
% Initialize radiation damping as 6x6xNf (or larger if gbm) to allow reading 
% Capytaine data with <6 DOFs.
RD = zeros(sum(hydro(F).dof), sum(hydro(F).dof), hydro(F).Nf);
if reset_idofs || reset_rdofs
    for j=1:sum(hydro(F).dof)
        for k=1:sum(hydro(F).dof)
            if iinds(j) ~= 0 && rinds(k) ~= 0
                RD(j,k,:) = tmp(iinds(j),rinds(k),:);
            end
        end
    end
else
    RD = tmp;
end
hydro(F).B = RD;

clear tmp RD
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
% Initialize FK force as 6xNhxNf (or larger if gbm) to allow reading 
% Capytaine data with <6 DOFs.
FK = zeros(sum(hydro(F).dof), hydro(F).Nh, hydro(F).Nf, 2);
if reset_idofs
    for j=1:sum(hydro(F).dof)
        if iinds(j) ~= 0
            FK(j,:,:,:) = tmp(iinds(j),:,:,:);
        end
    end
else
    FK = tmp;
end

% Set real and imaginary components of variable. Calculate magnitude and
% phase from components
hydro(F).fk_re = FK(:,:,:,i_re);
hydro(F).fk_im = -FK(:,:,:,i_im);
hydro(F).fk_ma = (hydro(F).fk_re.^2 + hydro(F).fk_im.^2).^0.5;  % Magnitude of Froude Krylov force
hydro(F).fk_ph = angle(hydro(F).fk_re + 1i*hydro(F).fk_im);     % Phase of Froude Krylov force

clear tmp FK
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
% Initialize Diffraction force as 6xNhxNf (or larger if gbm) to allow reading 
% Capytaine data with <6 DOFs.
DF = zeros(sum(hydro(F).dof), hydro(F).Nh, hydro(F).Nf, 2);
if reset_idofs
    for j=1:sum(hydro(F).dof)
        if iinds(j) ~= 0
            DF(j,:,:,:) = tmp(iinds(j),:,:,:);
        end
    end
else
    DF = tmp;
end

% Set real and imaginary components of variable. Calculate magnitude and
% phase from components
hydro(F).sc_re = DF(:,:,:,i_re);
hydro(F).sc_im = -DF(:,:,:,i_im);
hydro(F).sc_ma = (hydro(F).sc_re.^2 + hydro(F).sc_im.^2).^0.5;  % Magnitude of diffraction force
hydro(F).sc_ph = angle(hydro(F).sc_re + 1i*hydro(F).sc_im);     % Phase of diffraction force

clear tmp DF
waitbar(6/8);

%% Excitation Force [6*Nb,Nh,Nf];
% Calculate total excitation force: F_ex = F_sc + F_fk
hydro(F).ex_re = hydro(F).sc_re + hydro(F).fk_re;
hydro(F).ex_im = hydro(F).sc_im + hydro(F).fk_im;
hydro(F).ex_ma = (hydro(F).ex_re.^2 + hydro(F).ex_im.^2).^0.5;  % Magnitude of excitation force
hydro(F).ex_ph = angle(hydro(F).ex_re + 1i*hydro(F).ex_im);     % Phase of excitation force

waitbar(7/8);

%% Kochin diffraction
% necessary?
% from readWAMIT():
% theta(ntheta)= Kochin(3*(ntheta-1)+1); % theta
% Kochin_BVP(ntheta,1,x)= Kochin(3*(ntheta-1)+2); % magnitude
% Kochin_BVP(ntheta,2,x)= Kochin(3*(ntheta-1)+3); % phase

hydro = normalizeBEM(hydro);  % Normalize the data according the WAMIT convention
hydro = addDefaultPlotVars(hydro);

waitbar(8/8);

%% Catch and remove nan values
lowFrequencyNanMask = squeeze(all(isnan(hydro.A),[1 2])) | ...
    squeeze(all(isnan(hydro.B),[1 2])) | ...
    squeeze(all(isnan(hydro.ex_re),[1 2])) | ...
    squeeze(all(isnan(hydro.ex_im),[1 2]));
if any(lowFrequencyNanMask)
    nRemoved = sum(lowFrequencyNanMask);
    warning('BEM results contain NaN data at low frequencies. Removing %i frequencies (%s).',nRemoved,num2str(hydro.w(lowFrequencyNanMask),'%.3f, '));
    hydro.Nf = hydro.Nf-nRemoved;
    hydro.w = hydro.w(~lowFrequencyNanMask);
    assert(hydro.Nf == length(hydro.w));
    hydro.T = hydro.T(~lowFrequencyNanMask);
    hydro.A = hydro.A(:,:,~lowFrequencyNanMask);
    hydro.B = hydro.B(:,:,~lowFrequencyNanMask);
    hydro.fk_re = hydro.fk_re(:,:,~lowFrequencyNanMask);
    hydro.fk_im = hydro.fk_im(:,:,~lowFrequencyNanMask);
    hydro.fk_ma = hydro.fk_ma(:,:,~lowFrequencyNanMask);
    hydro.fk_ph = hydro.fk_ph(:,:,~lowFrequencyNanMask);
    hydro.sc_re = hydro.sc_re(:,:,~lowFrequencyNanMask);
    hydro.sc_im = hydro.sc_im(:,:,~lowFrequencyNanMask);
    hydro.sc_ma = hydro.sc_ma(:,:,~lowFrequencyNanMask);
    hydro.sc_ph = hydro.sc_ph(:,:,~lowFrequencyNanMask);
    hydro.ex_re = hydro.ex_re(:,:,~lowFrequencyNanMask);
    hydro.ex_im = hydro.ex_im(:,:,~lowFrequencyNanMask);
    hydro.ex_ma = hydro.ex_ma(:,:,~lowFrequencyNanMask);
    hydro.ex_ph = hydro.ex_ph(:,:,~lowFrequencyNanMask);
end

close(p);
end

%% functions
function [sorted_dofs,inds,reset_tf, nDofs_per_body, split_body_names] = sorted_dof_list(old_dofs, body_names)
% This function reorders a list of dofs if not in the correct order: 
%    [body 1 surge, sway, heave, roll, pitch, yaw, gbm, body 2 surge, ...]\
% Steps:
% 1. Find each body name
% 2. sort each body's dofs by [standard gbm]: surge, sway, heave, roll, pitch, yaw, gbm1, gbm2, ...
% 3. concatenate dofs

% Capytaine lowers the case of body names when used in the dof names. Do
% the same here to parse and reorder dofs correctly.
body_names = lower(body_names);

% list of standard dofs
std_dofs = ["surge", "sway", "heave", "roll", "pitch", "yaw"];
nDofs = length(old_dofs);

% Split Capytaine name variable to get each body name.
% If using multiple bodies w/ body interactions, Captaine sets a single
% name as "body1Name+body2Name+..."
if length(body_names)==1
    if contains(body_names,'+')
        split_body_names = split(body_names,'+');
        tmp = '__';
    else
        split_body_names = {''};
        tmp = '';
    end
else
    split_body_names = body_names;
    tmp = '__';
end
nDofs_per_body = zeros(1,length(split_body_names));

sorted_dofs = [];
for k=1:length(split_body_names)
    body_dofs = old_dofs(contains(old_dofs, [split_body_names{k} tmp])); % all dofs for body k. Add tmp to the body name to discriminate between body names that contain each other (e.g. if named "body" and "body2", then "body2" contains "body")
    std_body_dofs = strcat(split_body_names{k}, tmp, std_dofs); % standard 6 dofs for body k
    gbm_dofs = body_dofs(~contains(body_dofs, std_body_dofs))'; % gbm dofs are not in the standard 6 DOF list
    % gbm dofs for body k are not associated with another body name
    
    if isempty(gbm_dofs); gbm_dofs=[]; end % prevent formatting error when concatenating on next line
    sorted_dofs = [sorted_dofs std_body_dofs gbm_dofs]; % concatenate [std(k) gbm(k) std(k+1) gbm(k+1)...]
    
    nDofs_per_body(k) = length(body_dofs); % set number of dofs for each body
end

% set the indices that sort the old dofs/variables into the correct order
inds = zeros(1,length(sorted_dofs));
for j=1:length(old_dofs)
    for i=1:length(sorted_dofs)
        if lower(old_dofs(j)) == sorted_dofs(i)
            inds(i) = j;
            continue
        end
    end
end

% check that inds is setup correctly. test should match sorted_dofs
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

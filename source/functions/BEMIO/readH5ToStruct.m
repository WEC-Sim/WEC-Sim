function hydro = readH5ToStruct(filename)
% Function to read BEMIO data from an h5 file into a hydrodata structure
% 
% Parameters
% ----------
%     filename : string
%         Path to the BEMIO .h5 file to read
% 
% Returns
% -------
%     hydroData : struct
%         Struct of hydro data
% 

hydro = {};

% Read body-independent wave parameters
hydro.code = h5read(filename,'/bem_data/code');
[~,hydro.file,~] = fileparts(filename);
hydro.rho = h5read(filename,'/simulation_parameters/rho');
hydro.theta = h5read(filename,'/simulation_parameters/wave_dir');
hydro.Nh = length(hydro.theta);
hydro.h = h5read(filename,'/simulation_parameters/water_depth');
if hydro.h == 'infinite'
    hydro.h = Inf;
end
hydro.w = h5read(filename,'/simulation_parameters/w');
hydro.T = h5read(filename,'/simulation_parameters/T');
hydro.g = h5read(filename,'/simulation_parameters/g');
hydro.Nf = length(hydro.w);

% Determine how many bodies are in the h5 file
for i = 1:1e6
    h5BodyName = ['/body' num2str(i)];
    try
        hydro.body{i} = h5read(filename,[h5BodyName '/properties/name']); 
    catch
        hydro.Nb = i-1;
        fprintf('Number of bodies in h5 file = %.0f \n',hydro.Nb)
        break
    end
end

for i = 1:hydro.Nb
    h5BodyName = ['/body' num2str(i)];

    hydro.cg(1:3,i) = h5read(filename,[h5BodyName '/properties/cg']);
    hydro.Vo(i) = h5read(filename,[h5BodyName '/properties/disp_vol']);
    hydro.cb(1:3,i) = h5read(filename,[h5BodyName '/properties/cb']);
    hydro.Khs(:,:,i) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/linear_restoring_stiffness']));
    hydro.dof(i) = h5read(filename,[h5BodyName '/properties/dof']);
    dofStart = h5read(filename,[h5BodyName '/properties/dof_start']);
    dofEnd = h5read(filename,[h5BodyName '/properties/dof_end']);
    hydro.Ainf(dofStart:dofEnd,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/added_mass/inf_freq']));
    hydro.A(dofStart:dofEnd,:,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/added_mass/all']));
    hydro.B(dofStart:dofEnd,:,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/all']));
    exCoeffs = readComplexCoeff(filename, [h5BodyName '/hydro_coeffs/excitation'], 'excitation');
    hydro.ex_ma(dofStart:dofEnd,:,:) = exCoeffs.ma;
    hydro.ex_ph(dofStart:dofEnd,:,:) = exCoeffs.ph;
    hydro.ex_re(dofStart:dofEnd,:,:) = exCoeffs.re;
    hydro.ex_im(dofStart:dofEnd,:,:) = exCoeffs.im;
    
    % Read scattering and Froude-Krylov coefficients if available
    try
        scCoeffs = readComplexCoeff(filename, [h5BodyName '/hydro_coeffs/excitation/scattering'], 'scattering');
        hydro.sc_ma(dofStart:dofEnd,:,:) = scCoeffs.ma;
        hydro.sc_ph(dofStart:dofEnd,:,:) = scCoeffs.ph;
        hydro.sc_re(dofStart:dofEnd,:,:) = scCoeffs.re;
        hydro.sc_im(dofStart:dofEnd,:,:) = scCoeffs.im;
    end
    try
        fkCoeffs = readComplexCoeff(filename, [h5BodyName '/hydro_coeffs/excitation/froude-krylov'], 'froude-krylov');
        hydro.fk_ma(dofStart:dofEnd,:,:) = fkCoeffs.ma;
        hydro.fk_ph(dofStart:dofEnd,:,:) = fkCoeffs.ph;
        hydro.fk_re(dofStart:dofEnd,:,:) = fkCoeffs.re;
        hydro.fk_im(dofStart:dofEnd,:,:) = fkCoeffs.im;
    end

    % Read radiation and excitation IRFs if available
    try
        % Assumes all bodies have same interpolated frequencies and time vector
        hydro.ra_K(dofStart:dofEnd,:,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/impulse_response_fun/K']));
        hydro.ra_t(1,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/impulse_response_fun/t']));
        hydro.ra_w(1,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/impulse_response_fun/w']));
    end
    try 
        hydro.ex_K(dofStart:dofEnd,:,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/excitation/impulse_response_fun/f']));
        hydro.ex_t(1,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/excitation/impulse_response_fun/t']));
        hydro.ex_w(1,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/excitation/impulse_response_fun/w'])); 
    end 

    % Read radiation damping state space coefficients if available
    try 
        hydro.ss_A(dofStart:dofEnd,:,:,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/A/all']));
        hydro.ss_B(dofStart:dofEnd,:,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/B/all']));
        hydro.ss_C(dofStart:dofEnd,:,:,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/C/all']));
        hydro.ss_D(dofStart:dofEnd,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/D/all']));
    end
    try hydro.ss_K(dofStart:dofEnd,:,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/K/all'])); end
    try hydro.ss_O(dofStart:dofEnd,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/it'])); end
    try hydro.ss_R2(dofStart:dofEnd,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/r2t'])); end
    try hydro.ss_conv(dofStart:dofEnd,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/radiation_damping/state_space/conv'])); end

    % Read GBM coefficients if available
    try 
        hydro.gbm(dofStart:dofEnd,:,1) = h5read(filename,[h5BodyName '/properties/mass']);
        hydro.gbm(dofStart:dofEnd,:,2) = h5read(filename,[h5BodyName '/properties/damping']);
        hydro.gbm(dofStart:dofEnd,:,3) = h5read(filename,[h5BodyName '/properties/stiffness']);
        hydro.gbm(dofStart:dofEnd,:,4) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/linear_restoring_stiffness']));
    end

    % Read mean drift variables if available
    try hydro.md_mc(dofStart:dofEnd,:,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/mean_drift/momentum_conservation/val'])); end
    try hydro.md_cs(dofStart:dofEnd,:,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/mean_drift/control_surface/val'])); end
    try hydro.md_pi(dofStart:dofEnd,:,:) = reverseDimensionOrder(h5read(filename, [h5BodyName '/hydro_coeffs/mean_drift/pressure_integration/val'])); end
    
end

% Add default plotting flags back in
hydro = addDefaultPlotVars(hydro);

end


function c = readComplexCoeff(filename, basePath, label)

[c.ma, hasMa] = readH5Maybe(filename, [basePath '/mag']);
[c.ph, hasPh] = readH5Maybe(filename, [basePath '/phase']);
[c.re, hasRe] = readH5Maybe(filename, [basePath '/re']);
[c.im, hasIm] = readH5Maybe(filename, [basePath '/im']);

hasMagPhase = hasMa && hasPh;
hasRealImag = hasRe && hasIm;

if hasMagPhase && ~hasRealImag
    warning('%s: only magnitude/phase found. Computing real/imaginary parts.', label);
    c.re = c.ma .* cos(c.ph);
    c.im = c.ma .* sin(c.ph);

elseif hasRealImag && ~hasMagPhase
    warning('%s: only real/imaginary parts found. Computing magnitude/phase.', label);
    c.ma = sqrt(c.re.^2 + c.im.^2);
    c.ph = atan2(c.im, c.re);

elseif hasMagPhase && hasRealImag
    % All available; use file values.

else
    error('%s: incomplete complex coefficient data. Need mag+phase or re+im.', label);
end

end


function [x, ok] = readH5Maybe(filename, dataset)
try
    x = reverseDimensionOrder(h5read(filename, dataset));
    ok = true;
catch
    x = [];
    ok = false;
end
end
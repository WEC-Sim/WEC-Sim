function [hydroData] = rebuildHydroStruct(hydro, iBod, meanDrift)
% converts a BEMIO format hydro stucture to the Body Class format hydroData structure
% Author: @degoeden
% 
% Parameters
% ----------
%     hydro : struct
%         BEMIO-type structure of hydrodynamic data that would be written
%         to an H5 file.
% 
% Returns
% -------
%     hydroData : struct
%         Struct of hydroData used by the bodyClass. Different format than
%         the BEMIO hydro struct
% 

% Set-up format
hydroData = struct;
hydroData.simulation_parameters = struct();
hydroData.properties = struct();
hydroData.hydro_coeffs = struct();

% Read body-independent wave parameters
hydroData.simulation_parameters.scaled = 0;
hydroData.simulation_parameters.direction = hydro.theta;
if isequal(hydro.h,Inf)
    hydroData.simulation_parameters.waterDepth = 'infinite';
else
    hydroData.simulation_parameters.waterDepth = hydro.h;
end
hydroData.simulation_parameters.w = hydro.w;
hydroData.simulation_parameters.T = hydro.T;

% Read body properties
if ischar(hydro.body)
    hydroData.properties.name = hydro.body;
else
    hydroData.properties.name = hydro.body{iBod};
end

hydroData.properties.number = iBod;
hydroData.properties.centerGravity = hydro.cg(:,iBod)';
hydroData.properties.centerBuoyancy = hydro.cb(:,iBod)';
hydroData.properties.volume = hydro.Vo(iBod);

% Read DOFs
hydroData.properties.dof = hydro.dof(iBod);
if iBod > 1
    dofStart = sum(hydro.dof(1:iBod-1)) + 1;
    dofEnd = dofStart - 1 + hydroData.properties.dof;
else
    dofStart = 1;
    dofEnd = hydroData.properties.dof;
end
hydroData.properties.dofStart = dofStart;
hydroData.properties.dofEnd = dofEnd;

% Read hydrostatic stiffness
if isfield(hydro,'gbm')
    hydroData.hydro_coeffs.linear_restoring_stiffness = hydro.gbm(dofStart:dofEnd, dofStart:dofEnd, 4);
else
    hydroData.hydro_coeffs.linear_restoring_stiffness = hydro.Khs(:, :, iBod);
end

% Read excitation coefficients and IRF
hydroData.hydro_coeffs.excitation = struct();
hydroData.hydro_coeffs.excitation.re = hydro.ex_re(dofStart:dofEnd, :, :);
hydroData.hydro_coeffs.excitation.im = hydro.ex_im(dofStart:dofEnd, :, :);
try hydroData.hydro_coeffs.excitation.impulse_response_fun.f = hydro.ex_K(dofStart:dofEnd, :, :); end
try hydroData.hydro_coeffs.excitation.impulse_response_fun.t = hydro.ex_t'; end

% Read second order excitation forces data (QTFs)
try
    for dof = 1 : hydroData.properties.dof
        hydroData.hydro_coeffs.excitation.QTFs.Sum(dof).PER_i = hydro.QTFs(iBod).Sum(dof).PER_i;
        hydroData.hydro_coeffs.excitation.QTFs.Sum(dof).BETA_i = hydro.QTFs(iBod).Sum(dof).BETA_i;
        hydroData.hydro_coeffs.excitation.QTFs.Sum(dof).BETA_j = hydro.QTFs(iBod).Sum(dof).BETA_j;
        hydroData.hydro_coeffs.excitation.QTFs.Sum(dof).PHS_F_ij = hydro.QTFs(iBod).Sum(dof).PHS_F_ij;
        hydroData.hydro_coeffs.excitation.QTFs.Sum(dof).Re_F_ij = hydro.QTFs(iBod).Sum(dof).Re_F_ij;
        hydroData.hydro_coeffs.excitation.QTFs.Sum(dof).Im_F_ij = hydro.QTFs(iBod).Sum(dof).Im_F_ij;
        hydroData.hydro_coeffs.excitation.QTFs.Diff(dof).PER_i = hydro.QTFs(iBod).Diff(dof).PER_i;
        hydroData.hydro_coeffs.excitation.QTFs.Diff(dof).BETA_i = hydro.QTFs(iBod).Diff(dof).BETA_i;
        hydroData.hydro_coeffs.excitation.QTFs.Diff(dof).BETA_j = hydro.QTFs(iBod).Diff(dof).BETA_j;
        hydroData.hydro_coeffs.excitation.QTFs.Diff(dof).PHS_F_ij = hydro.QTFs(iBod).Diff(dof).PHS_F_ij;
        hydroData.hydro_coeffs.excitation.QTFs.Diff(dof).Re_F_ij = hydro.QTFs(iBod).Diff(dof).Re_F_ij;
        hydroData.hydro_coeffs.excitation.QTFs.Diff(dof).Im_F_ij = hydro.QTFs(iBod).Diff(dof).Im_F_ij;
    end
end

% Read added mass coefficients
hydroData.hydro_coeffs.added_mass.all = hydro.A(dofStart:dofEnd, :, :);
hydroData.hydro_coeffs.added_mass.inf_freq = hydro.Ainf(dofStart:dofEnd, :);

% Read radiation damping coefficients and IRF
hydroData.hydro_coeffs.radiation_damping = struct();
hydroData.hydro_coeffs.radiation_damping.all = hydro.B(dofStart:dofEnd, :, :);
try hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.K = hydro.ra_K(dofStart:dofEnd, :, :); end
try hydroData.hydro_coeffs.radiation_damping.impulse_response_fun.t = hydro.ra_t; end

% Read radiation damping state space coefficients
try hydroData.hydro_coeffs.radiation_damping.state_space.it = hydro.ss_O(dofStart:dofEnd, :); end
try hydroData.hydro_coeffs.radiation_damping.state_space.A.all = hydro.ss_A(dofStart:dofEnd, :, :, :); end
try hydroData.hydro_coeffs.radiation_damping.state_space.B.all = hydro.ss_B(dofStart:dofEnd, :, :, :); end
try hydroData.hydro_coeffs.radiation_damping.state_space.C.all = hydro.ss_C(dofStart:dofEnd, :, :, :); end
try hydroData.hydro_coeffs.radiation_damping.state_space.D.all = hydro.ss_D(dofStart:dofEnd, :); end

% Read GBM parameters if available
try 
    hydroData.gbm.mass = hydro.gbm(dofStart+6:dofEnd, dofStart+6:dofEnd, 1);
    hydroData.gbm.stiffness = hydro.gbm(dofStart+6:dofEnd, dofStart+6:dofEnd, 2);
    hydroData.gbm.damping = hydro.gbm(dofStart+6:dofEnd, dofStart+6:dofEnd, 3);
end

% Read mean drift coefficients if available
switch meanDrift
    case 0
        hydroData.hydro_coeffs.mean_drift = 0.*hydroData.hydro_coeffs.excitation.re;
    case 1
        hydroData.hydro_coeffs.mean_drift = hydro.md_cs(dofStart:dofEnd, :, :);
    case 2
        hydroData.hydro_coeffs.mean_drift = hydro.md_mc(dofStart:dofEnd, :, :);
    case 3
        hydroData.hydro_coeffs.mean_drift = hydro.md_pi(dofStart:dofEnd, :, :);
    otherwise
        error(['Wrong flag for mean drift force in body(' num2str(iBod) ').']);
end

end

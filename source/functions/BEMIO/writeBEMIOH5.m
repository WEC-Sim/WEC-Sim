function writeBEMIOH5(hydro)
% Writes the hydro data structure to a .h5 file.
%
% See ``WEC-Sim\tutorials\BEMIO`` for examples of usage.
%
% Parameters
% ----------
%     hydro : [1 x 1] struct
%         Structure of hydro data that is written to ``hydro.file``
% 
p = waitbar(0,'Writing data in h5 format...');  % Progress bar
N = 1 + hydro.Nb;  % Rough division of tasks

filename = [hydro.file '.h5'];

% Create h5 output file
fileID = H5F.create(filename,'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');

% Write string data
writeH5Text(fileID,{'bem_data'},'code',hydro.code)
for i = 1:hydro.Nb
    writeH5Text(fileID,{['body' num2str(i)] 'properties'},'name',hydro.body{i})
end
if hydro.h==inf
    writeH5Text(fileID,{'simulation_parameters'},'water_depth','infinite') % A residual of the python based code
end
H5F.close(fileID);
clear fileID

% Write body-independent wave parameters
writeH5Parameter(filename,'/simulation_parameters/scaled',0,'','') % use >>body(#).bemioFlag = 0; in input
writeH5Parameter(filename,'/simulation_parameters/g',hydro.g,'Gravitational acceleration','m/s^2')
writeH5Parameter(filename,'/simulation_parameters/rho',hydro.rho,'Water density','kg/m^3')
writeH5Parameter(filename,'/simulation_parameters/T',hydro.T,'Wave periods','s');
writeH5Parameter(filename,'/simulation_parameters/w',hydro.w,'Wave frequencies','rad/s');
if hydro.h~=inf     % A residual of the python based code
    writeH5Parameter(filename,'/simulation_parameters/water_depth',hydro.h,'Water depth','m');
end
writeH5Parameter(filename,'/simulation_parameters/wave_dir',hydro.theta,'Wave direction','deg');
waitbar(1/N);

n = 0;
m_add = 0;
for i = 1:hydro.Nb
    m = hydro.dof(i);

    % Write body properties
    writeH5Parameter(filename,['/body' num2str(i) '/properties/body_number'],i,'Number of rigid body from the BEM simulation','');
    writeH5Parameter(filename,['/body' num2str(i) '/properties/cb'],hydro.cb(:,i)','Center of buoyancy','m')
    writeH5Parameter(filename,['/body' num2str(i) '/properties/cg'],hydro.cg(:,i)','Center of gravity','m');
    writeH5Parameter(filename,['/body' num2str(i) '/properties/disp_vol'],hydro.Vo(i),'Displaced volume','m^3');
    writeH5Parameter(filename,['/body' num2str(i) '/properties/dof'],hydro.dof(i),'Degrees of freedom','');
    writeH5Parameter(filename,['/body' num2str(i) '/properties/dof_start'],m_add + 1,'Degrees of freedom','');
    writeH5Parameter(filename,['/body' num2str(i) '/properties/dof_end'],  m_add + m,'Degrees of freedom','');

    % Write GBM coefficients if available
    if isfield(hydro,'gbm')
        writeH5Parameter(filename,['/body' num2str(i) '/properties/mass'],permute(hydro.gbm((n+1):(n+m),:,1),[3 2 1]),'Generalized body modes mass','kg');
        writeH5Parameter(filename,['/body' num2str(i) '/properties/damping'],permute(hydro.gbm((n+1):(n+m),:,2),[3 2 1]),'Generalized body modes damping','N-s/m');
        writeH5Parameter(filename,['/body' num2str(i) '/properties/stiffness'],permute(hydro.gbm((n+1):(n+m),:,3),[3 2 1]),'Generalized body modes stiffness','N/m');
    end

    % Write hydrostatic stiffness
    if isfield(hydro,'gbm')
        tmp = permute(hydro.gbm((n+1):(n+m),:,4),[3 2 1]);
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/linear_restoring_stiffness'],tmp(1,m_add + 1:m_add + m,:),'Hydrostatic stiffness (normalized by rho*g)','N/m');
        clear tmp;
    else
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/linear_restoring_stiffness'],hydro.Khs(:,:,i)','Hydrostatic stiffness matrix (normalized by rho*g)','N/m');        
    end

    % Write added mass coefficients
    m_add = m_add + m;
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/added_mass/inf_freq'],permute(hydro.Ainf((n+1):(n+m),:),[2 1]),'Infinite frequency added mass (normalized by rho)','kg');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/added_mass/all'],permute(hydro.A((n+1):(n+m),:,:),[3 2 1]),'Added mass (normalized by rho)','kg');
    
    % Write excitation coefficients and IRF
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/im'],permute(hydro.ex_im((n+1):(n+m),:,:),[3 2 1]),'Imaginary component of excitation force (normalized by rho*g)','N');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/mag'],permute(hydro.ex_ma((n+1):(n+m),:,:),[3 2 1]),'Magnitude of excitation force (normalized by rho*g)','N');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/phase'],permute(hydro.ex_ph((n+1):(n+m),:,:),[3 2 1]),'Phase angle of excitation force','rad');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/re'],permute(hydro.ex_re((n+1):(n+m),:,:),[3 2 1]),'Real component of excitation force (normalized by rho*g)','N');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/im'],permute(hydro.sc_im((n+1):(n+m),:,:),[3 2 1]),'Imaginary component of scattering force (normalized by rho*g)','N');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/mag'],permute(hydro.sc_ma((n+1):(n+m),:,:),[3 2 1]),'Magnitude of scattering force (normalized by rho*g)','N');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/phase'],permute(hydro.sc_ph((n+1):(n+m),:,:),[3 2 1]),'Phase angle of scattering force','rad');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/re'],permute(hydro.sc_re((n+1):(n+m),:,:),[3 2 1]),'Real component of scattering force (normalized by rho*g)','N');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/im'],permute(hydro.fk_im((n+1):(n+m),:,:),[3 2 1]),'Imaginary component of Froude-Krylov force (normalized by rho*g)','N');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/mag'],permute(hydro.fk_ma((n+1):(n+m),:,:),[3 2 1]),'Magnitude of Froude-Krylov force (normalized by rho*g)','N');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/phase'],permute(hydro.fk_ph((n+1):(n+m),:,:),[3 2 1]),'Phase angle of Froude-Krylov force','rad');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/re'],permute(hydro.fk_re((n+1):(n+m),:,:),[3 2 1]),'Real component of Froude-Krylov force (normalized by rho*g)','N');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/impulse_response_fun/f'],permute(hydro.ex_K((n+1):(n+m),:,:),[3 2 1]),'Impulse response function','');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/impulse_response_fun/t'],hydro.ex_t,'Time vector for the impulse resonse function','s');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/impulse_response_fun/w'],hydro.ex_w,'Interpolated frequencies used to compute the impulse response function','rad/s');

    % Write QTFs data if available
    if isfield(hydro, 'QTFs') && ~isempty(hydro.QTFs(i).Diff)
        for dof = 1 : hydro.dof(i)
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Sum'  num2str(dof) '/PER_i'],    hydro.QTFs(i).Sum(dof).PER_i,'Periodic Time of QTF','s');
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Sum' num2str(dof) '/BETA_i'],    hydro.QTFs(i).Sum(dof).BETA_i,'ith Wave direction','');
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Sum' num2str(dof) '/BETA_j'],    hydro.QTFs(i).Sum(dof).BETA_j,'jth Wave direction','');
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Sum'  num2str(dof) '/PHS_F_ij'], hydro.QTFs(i).Sum(dof).PHS_F_ij,'Phase of QTF','s');
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Sum'  num2str(dof) '/Re_F_ij'],  hydro.QTFs(i).Sum(dof).Re_F_ij,'Real component of QTF Coeffcients','');
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Sum'  num2str(dof) '/Im_F_ij'],  hydro.QTFs(i).Sum(dof).Im_F_ij,'Imaginary component of QTF Coeffcients','');
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Diff' num2str(dof) '/PER_i'],    hydro.QTFs(i).Diff(dof).PER_i,'Periodic Time of QTF','s');
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Diff' num2str(dof) '/BETA_i'],   hydro.QTFs(i).Diff(dof).BETA_i,'ith Wave direction','');
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Diff' num2str(dof) '/BETA_j'],   hydro.QTFs(i).Diff(dof).BETA_j,'jth Wave direction','');
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Diff' num2str(dof) '/PHS_F_ij'], hydro.QTFs(i).Diff(dof).PHS_F_ij,'Phase of QTF','');
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Diff' num2str(dof) '/Re_F_ij'],  hydro.QTFs(i).Diff(dof).Re_F_ij,'Real component of QTF Coeffcients','');
            writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/excitation/QTF' num2str(i) '/Diff' num2str(dof) '/Im_F_ij'],  hydro.QTFs(i).Diff(dof).Im_F_ij,'Imaginary component of QTF Coeffcients','');
        end
    end

    % Write mean drift coefficients if available
    if isfield(hydro,'md_mc') % Only if mean drift variables (momentum conservation) have been calculated in BEM
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/mean_drift/momentum_conservation/val'],permute(hydro.md_mc((n+1):(n+m),:,:),[3 2 1]),'Value of mean drift force (momentum conservation)','');
    end
    if isfield(hydro,'md_cs') % Only if mean drift variables (control surface approach) have been calculated in BEM
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/mean_drift/control_surface/val'],permute(hydro.md_cs((n+1):(n+m),:,:),[3 2 1]),'Value of mean drift force (control surface)','');
    end
    if isfield(hydro,'md_pi') % Only if mean drift variables (pressure integration approach) have been calculated in BEM
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/mean_drift/pressure_integration/val'],permute(hydro.md_pi((n+1):(n+m),:,:),[3 2 1]),'Value of mean drift force (pressure integration)','');
    end

     % Write radiation damping coefficients and IRF
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/all'],permute(hydro.B((n+1):(n+m),:,:),[3 2 1]),'Radiation damping (normalized by rho*w)','N-s/m');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/K'],permute(hydro.ra_K((n+1):(n+m),:,:),[3 2 1]),'Impulse response function','');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/t'],hydro.ra_t,'Time vector for the impulse resonse function','s');
    writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/w'],hydro.ra_w,'Interpolated frequencies used to compute the impulse response function','rad/s');
    
    % Write radiation damping state space coefficients (optional)
    if isfield(hydro,'ss_A')
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/A/all'],permute(hydro.ss_A((n+1):(n+m),:,:,:),[4 3 2 1]),'State Space A Coefficient','');
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/B/all'],permute(hydro.ss_B((n+1):(n+m),:,:,:),[4 3 2 1]),'State Space B Coefficient','');
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/C/all'],permute(hydro.ss_C((n+1):(n+m),:,:,:),[4 3 2 1]),'State Space C Coefficient','');
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/D/all'],permute(hydro.ss_D((n+1):(n+m),:),[2 1]),'State Space D Coefficient','');
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/K/all'],permute(hydro.ss_K((n+1):(n+m),:,:,:),[4 3 2 1]),'State Space K Coefficient','');
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/it'],permute(hydro.ss_O((n+1):(n+m),:),[2 1]),'Order of state space realization','');
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/r2t'],permute(hydro.ss_R2((n+1):(n+m),:),[2 1]),'State space curve fitting R**2 value','');
        writeH5Parameter(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/conv'],permute(hydro.ss_conv((n+1):(n+m),:),[2 1]),'State space conversion status','');
    end
    waitbar((1+i)/N);
    n = n + m;
end

waitbar(1);
close(p);

end


function writeH5Parameter(filename,location,values,description,units)

h5create(filename,location,size(values))
h5write(filename,location,values);
h5writeatt(filename,location,'description',description);
h5writeatt(filename,location,'units',units);

end


function writeH5Text(fileID, group, dataset, data)

if isscalar(group)
    group_id = H5G.create(fileID,group{1},'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
    space_id = H5S.create('H5S_SCALAR');
    stype = H5T.copy('H5T_C_S1');
    H5T.set_size(stype,numel(data));
    dataset_id = H5D.create(group_id,dataset,stype,space_id,'H5P_DEFAULT');
    H5D.write(dataset_id,stype,'H5S_ALL','H5S_ALL','H5P_DEFAULT',data);
    H5D.close(dataset_id)
    H5S.close(space_id)
    H5G.close(group_id);
elseif length(group)==2
    group_1_id = H5G.create(fileID,group{1},'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
    group_2_id = H5G.create(group_1_id,group{2},'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
    space_id = H5S.create('H5S_SCALAR');
    stype = H5T.copy('H5T_C_S1');
    H5T.set_size(stype,numel(data));
    dataset_id = H5D.create(group_2_id,dataset,stype,space_id,'H5P_DEFAULT');
    H5D.write(dataset_id,stype,'H5S_ALL','H5S_ALL','H5P_DEFAULT',data);
    H5D.close(dataset_id)
    H5S.close(space_id)
    H5G.close(group_2_id);
    H5G.close(group_1_id);
end

end

function Write_H5(hydro)

% Writes the hydro data structure to a .h5 file.
%
% Write_H5(hydro)
%     hydro � data structure
%
% See ��\WEC-Sim\tutorials\BEMIO\...� for examples of usage.

p = waitbar(0,'Writing data in h5 format...');  % Progress bar
N = 1+(1+1+1)*hydro.Nb;  % Rough division of tasks

filename=[hydro.file '.h5'];

% Create h5 output file
file_id = H5F.create(filename,'H5F_ACC_TRUNC','H5P_DEFAULT','H5P_DEFAULT');

% Write string data
H5_Text(file_id,{'bem_data'},'code',hydro.code)
for i = 1:hydro.Nb
    H5_Text(file_id,{['body' num2str(i)] 'properties'},'name',hydro.body{i})
end
if hydro.h==inf
    H5_Text(file_id,{'simulation_parameters'},'water_depth','infinite') % A residual of the python based code
end
H5F.close(file_id);
clear file_id

H5_Create_Write_Att(filename,'/simulation_parameters/scaled',0,'','') % use >>body(#).bemioFlag = 0; in input
% Write array data
H5_Create_Write_Att(filename,'/simulation_parameters/g',hydro.g,'Gravitational acceleration','m/s^2')
H5_Create_Write_Att(filename,'/simulation_parameters/rho',hydro.rho,'Water density','kg/m^3')
H5_Create_Write_Att(filename,'/simulation_parameters/T',hydro.T,'Wave periods','s');
H5_Create_Write_Att(filename,'/simulation_parameters/w',hydro.w,'Wave frequencies','rad/s');
if hydro.h~=inf     % A residual of the python based code
    H5_Create_Write_Att(filename,'/simulation_parameters/water_depth',hydro.h,'Water depth','m');
end
H5_Create_Write_Att(filename,'/simulation_parameters/wave_dir',hydro.beta,'Wave direction','deg');
waitbar(1/N);
n = 0;
m_add = 0;
for i = 1:hydro.Nb
    m = hydro.dof(i);
    H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/body_number'],i,'Number of rigid body from the BEM simulationCenter of gravity','m');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/cb'],hydro.cb(:,i)','hydro.cg','m')
    H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/cg'],hydro.cg(:,i)','Center of gravity','m');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/disp_vol'],hydro.Vo(i),'Displaced volume','m^3');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/dof'],hydro.dof(i),'Degrees of freedom','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/dof_start'],m_add + 1,'Degrees of freedom','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/dof_end'],  m_add + m,'Degrees of freedom','');    
    if isfield(hydro,'gbm')==1 % Only if generalized body modes have been used
        H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/mass'],permute(hydro.gbm((n+1):(n+m),:,1),[3 2 1]),'Generalized body modes mass','kg');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/damping'],permute(hydro.gbm((n+1):(n+m),:,2),[3 2 1]),'Generalized body modes damping','N/m');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/stiffness'],permute(hydro.gbm((n+1):(n+m),:,3),[3 2 1]),'Generalized body modes stiffness','N-s/m');
    end
    if isfield(hydro,'gbm')==1 % Only if generalized body modes have been used
        tmp = permute(hydro.gbm((n+1):(n+m),:,4),[3 2 1]);
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/linear_restoring_stiffness'],tmp(1,m_add + 1:m_add + m,:),'Hydrostatic stiffness','N/m');
        clear tmp;
    else
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/linear_restoring_stiffness'],hydro.C(:,:,i),'Hydrostatic stiffness matrix','');        
    end        
    m_add = m_add + m;
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/added_mass/inf_freq'],permute(hydro.Ainf((n+1):(n+m),:),[2 1]),'Infinite frequency added mass','kg');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/added_mass/all'],permute(hydro.A((n+1):(n+m),:,:),[3 2 1]),'Added mass','kg-m^2 (rotation); kg (translation)');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/im'],permute(hydro.ex_im((n+1):(n+m),:,:),[3 2 1]),'Imaginary component of excitation force','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/mag'],permute(hydro.ex_ma((n+1):(n+m),:,:),[3 2 1]),'Magnitude of excitation force','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/phase'],permute(hydro.ex_ph((n+1):(n+m),:,:),[3 2 1]),'Phase angle of excitation force','rad');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/re'],permute(hydro.ex_re((n+1):(n+m),:,:),[3 2 1]),'Real component of excitation force','');
    if isfield(hydro,'md_mc')==1 % Only if mean drift variables (momentum conservation) have been calculated in BEM
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/mean_drift/momentum_conservation/val'],permute(hydro.md_mc((n+1):(n+m),:,:),[3 2 1]),'Value of mean drift force (momentum conservation)','');
    end
    if isfield(hydro,'md_cs')==1 % Only if mean drift variables (control surface approach) have been calculated in BEM
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/mean_drift/control_surface/val'],permute(hydro.md_cs((n+1):(n+m),:,:),[3 2 1]),'Value of mean drift force (control surface)','');
    end
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/im'],permute(hydro.sc_im((n+1):(n+m),:,:),[3 2 1]),'Imaginary component of scattering force','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/mag'],permute(hydro.sc_ma((n+1):(n+m),:,:),[3 2 1]),'Magnitude of scattering force','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/phase'],permute(hydro.sc_ph((n+1):(n+m),:,:),[3 2 1]),'Phase angle of scattering force','rad');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/re'],permute(hydro.sc_re((n+1):(n+m),:,:),[3 2 1]),'Real component of scattering force','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/im'],permute(hydro.fk_im((n+1):(n+m),:,:),[3 2 1]),'Imaginary component of Froude-Krylov force','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/mag'],permute(hydro.fk_ma((n+1):(n+m),:,:),[3 2 1]),'Magnitude of Froude-Krylov force','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/phase'],permute(hydro.fk_ph((n+1):(n+m),:,:),[3 2 1]),'Phase angle of Froude-Krylov force','rad');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/re'],permute(hydro.fk_re((n+1):(n+m),:,:),[3 2 1]),'Real component of Froude-Krylov force','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/impulse_response_fun/f'],permute(hydro.ex_K((n+1):(n+m),:,:),[3 2 1]),'Impulse response function','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/impulse_response_fun/t'],hydro.ex_t,'Time vector for the impulse resonse function','s');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/impulse_response_fun/w'],hydro.ex_w,'Interpolated frequencies used to compute the impulse response function','s');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/all'],permute(hydro.B((n+1):(n+m),:,:),[3 2 1]),'Radiation damping','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/K'],permute(hydro.ra_K((n+1):(n+m),:,:),[3 2 1]),'Impulse response function','');
    % H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/L'],permute(hydro.ra_L((n+1):(n+m),:,:),[3 2 1]),'Time derivative of the impulse resonse function','');  % Not used
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/t'],hydro.ra_t,'Time vector for the impulse resonse function','s');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/w'],hydro.ra_w,'Interpolated frequencies used to compute the impulse response function','s');
    if isfield(hydro,'ss_A')==1 % Only if state space variables have been calculated
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/A/all'],permute(hydro.ss_A((n+1):(n+m),:,:,:),[4 3 2 1]),'State Space A Coefficient','');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/B/all'],permute(hydro.ss_B((n+1):(n+m),:,:,:),[4 3 2 1]),'State Space B Coefficient','');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/C/all'],permute(hydro.ss_C((n+1):(n+m),:,:,:),[4 3 2 1]),'State Space C Coefficient','');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/D/all'],permute(hydro.ss_D((n+1):(n+m),:),[2 1]),'State Space D Coefficient','');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/it'],permute(hydro.ss_O((n+1):(n+m),:),[2 1]),'Order of state space realization','');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/r2t'],permute(hydro.ss_R2((n+1):(n+m),:),[2 1]),'State space curve fitting R**2 value','');
    end
    waitbar((1+(i+i-1+i-1))/N);
    for j = (n+1):(n+m)
        for k = 1:sum(hydro.dof)
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/added_mass/components/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.A(j,k,:),[3 2 1])]','Added mass components as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/components/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.B(j,k,:),[3 2 1])]','Radiation damping components as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/components/K/' num2str(j-m*i+m) '_' num2str(k)],[hydro.ra_t',permute(hydro.ra_K(j,k,:),[3 2 1])]','Components of the IRF','');
            % H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/components/L/' num2str(j-m*i+m) '_' num2str(k)],[hydro.ra_t',permute(hydro.ra_L(j,k,:),[3 2 1])]','Components of the ddt(IRF):K','');  % Not used
            if isfield(hydro,'ss_A')==1 % Only if state space variables have been calculated
                H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/A/components/' num2str(j-m*i+m) '_' num2str(k)],permute(hydro.ss_A(j,k,:,:),[4 3 2 1]),'Components of the State Space A Coefficient','');
                H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/B/components/' num2str(j-m*i+m) '_' num2str(k)],permute(hydro.ss_B(j,k,:,:),[4 3 2 1]),'Components of the State Space B Coefficient','');
                H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/C/components/' num2str(j-m*i+m) '_' num2str(k)],permute(hydro.ss_C(j,k,:,:),[4 3 2 1]),'Components of the State Space C Coefficient','');
                H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/D/components/' num2str(j-m*i+m) '_' num2str(k)],permute(hydro.ss_D(j,k),[2 1]),'Components of the State Space D Coefficient','');
            end
        end
    end
    waitbar((1+(i+i+i-1))/N);
    for j = (n+1):(n+m)
        for k = 1:hydro.Nh
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/components/im/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.ex_im(j,k,:),[3 2 1])]','Imaginary component of excitation force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/components/re/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.ex_re(j,k,:),[3 2 1])]','Real component of excitation force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/components/mag/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.ex_ma(j,k,:),[3 2 1])]','Magnitude of excitation force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/components/phase/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.ex_ph(j,k,:),[3 2 1])]','Phase of excitation force as a function of frequency','');
            if isfield(hydro,'md_mc')==1 % Only if mean drift variables (momentum conservation) have been calculated in BEM
                H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/mean_drift/momentum_conservation/components/val/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.md_mc(j,k,:),[3 2 1])]','Magnitude of mean drift force (momentum conservation) as a function of frequency','');
            end
            if isfield(hydro,'md_cs')==1 % Only if mean drift variables (control surface approach) have been calculated in BEM
                H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/mean_drift/control_surface/components/val/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.md_cs(j,k,:),[3 2 1])]','Magnitude of mean drift force (control surface) as a function of frequency','');
            end
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/impulse_response_fun/components/f/' num2str(j-m*i+m) '_' num2str(k)],[hydro.ex_t',permute(hydro.ex_K(j,k,:),[3 2 1])]','Components of the IRF:f','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/components/im/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.sc_im(j,k,:),[3 2 1])]','Imaginary component of scattering force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/components/mag/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.sc_ma(j,k,:),[3 2 1])]','Magnitude of scattering force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/components/phase/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.sc_ph(j,k,:),[3 2 1])]','Phase of scattering force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/scattering/components/re/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.sc_re(j,k,:),[3 2 1])]','Real component of scattering force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/components/im/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.fk_im(j,k,:),[3 2 1])]','Imaginary component of Froude-Krylov force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/components/mag/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.fk_ma(j,k,:),[3 2 1])]','Magnitude of Froude-Krylov force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/components/phase/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.fk_ph(j,k,:),[3 2 1])]','Phase of Froude-Krylov force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/froude-krylov/components/re/' num2str(j-m*i+m) '_' num2str(k)],[hydro.T',permute(hydro.fk_re(j,k,:),[3 2 1])]','Real component of Froude-Krylov force as a function of frequency','');
        end
    end
    waitbar((1+(i+i+i))/N);
    n = n + m;
end
waitbar(1);
close(p);
end


function H5_Create_Write_Att(filename,location,values,description,units)

h5create(filename,location,size(values))
h5write(filename,location,values);
h5writeatt(filename,location,'description',description);
h5writeatt(filename,location,'units',units);

end


function H5_Text(file_id, group, dataset, data)

if length(group)==1
    group_id = H5G.create(file_id,group{1},'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
    space_id = H5S.create('H5S_SCALAR');
    stype = H5T.copy('H5T_C_S1');
    H5T.set_size(stype,numel(data));
    dataset_id = H5D.create(group_id,dataset,stype,space_id,'H5P_DEFAULT');
    H5D.write(dataset_id,stype,'H5S_ALL','H5S_ALL','H5P_DEFAULT',data);
    H5D.close(dataset_id)
    H5S.close(space_id)
    H5G.close(group_id);
elseif length(group)==2
    group_1_id = H5G.create(file_id,group{1},'H5P_DEFAULT','H5P_DEFAULT','H5P_DEFAULT');
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





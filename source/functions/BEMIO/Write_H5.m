function Write_H5(hydro)

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
H5_Text(file_id,{'simulation_parameters'},'scaled','FALSE') % A residual of the python based code
H5F.close(file_id);
clear file_id

% Write array data
H5_Create_Write_Att(filename,'/simulation_parameters/g',hydro.g,'Gravitational acceleration','m/s^2')
H5_Create_Write_Att(filename,'/simulation_parameters/rho',hydro.rho,'Water density','kg/m^3')
H5_Create_Write_Att(filename,'/simulation_parameters/T',hydro.T,'Wave periods','s');
H5_Create_Write_Att(filename,'/simulation_parameters/w',hydro.w,'Wave frequencies','rad/s');
H5_Create_Write_Att(filename,'/simulation_parameters/water_depth',hydro.h,'Water depth','m');
H5_Create_Write_Att(filename,'/simulation_parameters/wave_dir',hydro.beta,'Wave direction','deg');
waitbar(1/N);
for i = 1:hydro.Nb
    H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/body_number'],i-1,'Number of rigid body from the BEM simulationCenter of gravity','m');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/cb'],hydro.cb(:,i)','hydro.cg','m')
    H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/cg'],hydro.cg(:,i)','Center of gravity','m');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/properties/disp_vol'],hydro.Vo(i),'Displaced volume','m^3');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/linear_restoring_stiffness'],hydro.C(:,:,i),'Hydrostatic stiffness matrix','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/added_mass/inf_freq'],permute(hydro.Ainf((6*i-5):(6*i),:),[2 1]),'Infinite frequency added mass','kg');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/added_mass/all'],permute(hydro.A((6*i-5):(6*i),:,:),[3 2 1]),'Added mass','kg-m^2 (rotation); kg (translation)');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/im'],permute(hydro.ex_im((6*i-5):(6*i),:,:),[3 2 1]),'Imaginary component of excitation force','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/mag'],permute(hydro.ex_ma((6*i-5):(6*i),:,:),[3 2 1]),'Magnitude of excitation force','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/phase'],permute(hydro.ex_ph((6*i-5):(6*i),:,:),[3 2 1]),'Phase angle of excitation force','rad');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/re'],permute(hydro.ex_re((6*i-5):(6*i),:,:),[3 2 1]),'Real component of excitation force','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/impulse_response_fun/f'],permute(hydro.ex_K((6*i-5):(6*i),:,:),[3 2 1]),'Impulse response function','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/impulse_response_fun/t'],hydro.ex_t,'Time vector for the impulse resonse function','s');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/impulse_response_fun/w'],hydro.ex_w,'Interpolated frequencies used to compute the impulse response function','s');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/all'],permute(hydro.B((6*i-5):(6*i),:,:),[3 2 1]),'Radiation damping','');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/K'],permute(hydro.ra_K((6*i-5):(6*i),:,:),[3 2 1]),'Impulse response function','');
%     H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/L'],permute(hydro.ra_L((6*i-5):(6*i),:,:),[3 2 1]),'Time derivative of the impulse resonse function','');  % Not used
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/t'],hydro.ra_t,'Time vector for the impulse resonse function','s');
    H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/w'],hydro.ra_w,'Interpolated frequencies used to compute the impulse response function','s');
    if isfield(hydro,'ss_A')==1 % Only write state space variables if they were calculated
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/A/all'],permute(hydro.ss_A((6*i-5):(6*i),:,:,:),[4 3 2 1]),'State Space A Coefficient','');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/B/all'],permute(hydro.ss_B((6*i-5):(6*i),:,:,:),[4 3 2 1]),'State Space B Coefficient','');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/C/all'],permute(hydro.ss_C((6*i-5):(6*i),:,:,:),[4 3 2 1]),'State Space C Coefficient','');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/D/all'],permute(hydro.ss_D((6*i-5):(6*i),:),[2 1]),'State Space D Coefficient','');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/it'],permute(hydro.ss_O((6*i-5):(6*i),:),[2 1]),'Order of state space realization','');
        H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/r2t'],permute(hydro.ss_R2((6*i-5):(6*i),:),[2 1]),'State space curve fitting R**2 value','');
    end
    waitbar((1+(i+i-1+i-1))/N);
    for j = (6*i-5):(6*i)
        for k = 1:6*hydro.Nb
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/added_mass/components/' num2str(j-6*i+6) '_' num2str(k)],[hydro.T',permute(hydro.A(j,k,:),[3 2 1])]','Added mass components as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/components/' num2str(j-6*i+6) '_' num2str(k)],[hydro.T',permute(hydro.B(j,k,:),[3 2 1])]','Radiation damping components as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/components/K/' num2str(j-6*i+6) '_' num2str(k)],[hydro.ra_t',permute(hydro.ra_K(j,k,:),[3 2 1])]','Components of the IRF','');
%             H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/impulse_response_fun/components/L/' num2str(j-6*i+6) '_' num2str(k)],[hydro.ra_t',permute(hydro.ra_L(j,k,:),[3 2 1])]','Components of the ddt(IRF):K','');  % Not used
            if isfield(hydro,'ss_A')==1 % Only if state space variables have been calculated
                H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/A/components/' num2str(j-6*i+6) '_' num2str(k)],permute(hydro.ss_A(j,k,:,:),[4 3 2 1]),'Components of the State Space A Coefficient','');
                H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/B/components/' num2str(j-6*i+6) '_' num2str(k)],permute(hydro.ss_B(j,k,:,:),[4 3 2 1]),'Components of the State Space B Coefficient','');
                H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/C/components/' num2str(j-6*i+6) '_' num2str(k)],permute(hydro.ss_C(j,k,:,:),[4 3 2 1]),'Components of the State Space C Coefficient','');
                H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/radiation_damping/state_space/D/components/' num2str(j-6*i+6) '_' num2str(k)],permute(hydro.ss_D(j,k),[2 1]),'Components of the State Space D Coefficient','');
            end
        end
    end    
    waitbar((1+(i+i+i-1))/N);
    for j = (6*i-5):(6*i)
        for k = 1:hydro.Nh
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/components/im/' num2str(j-6*i+6) '_' num2str(k)],[hydro.T',permute(hydro.ex_im(j,k,:),[3 2 1])]','Imaginary component of excitation force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/components/mag/' num2str(j-6*i+6) '_' num2str(k)],[hydro.T',permute(hydro.ex_ma(j,k,:),[3 2 1])]','Magnitude of excitation force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/components/phase/' num2str(j-6*i+6) '_' num2str(k)],[hydro.T',permute(hydro.ex_ph(j,k,:),[3 2 1])]','Phase of excitation force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/components/re/' num2str(j-6*i+6) '_' num2str(k)],[hydro.T',permute(hydro.ex_re(j,k,:),[3 2 1])]','Real component of excitation force as a function of frequency','');
            H5_Create_Write_Att(filename,['/body' num2str(i) '/hydro_coeffs/excitation/impulse_response_fun/components/f/' num2str(j-6*i+6) '_' num2str(k)],[hydro.ex_t',permute(hydro.ex_K(j,k,:),[3 2 1])]','Components of the IRF:f','');
        end
    end       
    waitbar((1+(i+i+i))/N);
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





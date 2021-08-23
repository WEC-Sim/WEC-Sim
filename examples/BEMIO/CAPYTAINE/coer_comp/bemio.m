hydro = struct();

hydro = Read_CAPYTAINE(hydro,'.\coer_comp_full.nc');
% hydro = Read_NEMOH(hydro,'..\..\NEMOH\Coer_Comp\');
% hydro(end).body = {'coercomp_nemoh'};
% hydro = Read_WAMIT(hydro,'..\..\WAMIT\Coer_Comp\coer_comp.out',[]);
% hydro(end).body = {'coercomp_wamit'};
% hydro = Combine_BEM(hydro); % Compare to NEMOH and WAMIT
hydro = Radiation_IRF(hydro,10,[],[],[],[]);
hydro = Radiation_IRF_SS(hydro,[],[]);
hydro = Excitation_IRF(hydro,20,[],[],[],[]);
Write_H5(hydro)
Plot_BEMIO(hydro)


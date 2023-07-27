% calculates impedance from h5 Data.
clear; close all;
rho = 1025; % rho, to renormalize WAMIT BEM
g = 9.81; % gravity, to renormalize WAMIT

%% long tube
hydro=readBEMIOH5('../../../examples/RM3/hydroData/rm3.h5',1,0)
%Z = (m+a)iw + B + K/(iw)

% grab the free surface motion. the multiplication converts WAMIT
% normalized outputs to units. 
w(1,1,:)= hydro.simulation_parameters.w.';
WMAT = repmat(w,[6,6]);
B= hydro.hydro_coeffs.radiation_damping.all([1:6],[1:6],:).*rho.*WMAT;
A= hydro.hydro_coeffs.added_mass.all([1:6],[1:6],:).*rho;
m= 0; % the free-surface mass in heave is in theory 0. It should be gInertia if you use this.
K= hydro.hydro_coeffs.linear_restoring_stiffness.*rho.*g;

Z_long = (m+A).*(1i*w) + B + K./(1i*w);
plotDOFs = [1,1;3,3;5,5;1,3;1,5;3,5];
[NplotDOFs,~]=size(plotDOFs);
%% create FRD, estimate TF
Z_frd = frd(Z_long,squeeze(w),'FrequencyUnit','rad/s');
Z_tf = tfest(Z_frd,4,4);
Z_frf=freqresp(Z_tf,squeeze(w),'rad/s')
formatVec = {'k','b','g','--b','--g','--c',':k',':b',':g','-.b','-.g','-.c'};
figure(1); clf;
figure(2); clf;
for k = 1:NplotDOFs
    figure(1);
    subplot(2,1,1)
    plot(squeeze(w),real(squeeze(Z_long(plotDOFs(k,1),plotDOFs(k,2),:))),formatVec{k},'LineWidth',1.2);
    grid on; hold on;
    plot(squeeze(w),real(squeeze(Z_frf(plotDOFs(k,1),plotDOFs(k,2),:))),formatVec{k+6},'LineWidth',1.4);
    ylabel('Real(Z)')
    subplot(2,1,2)
    plot(squeeze(w),imag(squeeze(Z_long(plotDOFs(k,1),plotDOFs(k,2),:))),formatVec{k},'LineWidth',1.2);
    grid on; hold on;
    plot(squeeze(w),imag(squeeze(Z_frf(plotDOFs(k,1),plotDOFs(k,2),:))),formatVec{k+6},'LineWidth',1.4);
    ylabel('Imag(Z)')
    xlabel('rad/s')

    figure(2);
    subplot(2,1,1)
    semilogx(squeeze(w),mag2db(abs(squeeze(Z_long(plotDOFs(k,1),plotDOFs(k,2),:)))),formatVec{k},'LineWidth',1.2);
    grid on; hold on;
    semilogx(squeeze(w),mag2db(abs(squeeze(Z_frf(plotDOFs(k,1),plotDOFs(k,2),:)))),formatVec{k+6},'LineWidth',1.4);
    %ylabel('Real(Z)')
    subplot(2,1,2)
    semilogx(squeeze(w),atan2(imag(squeeze(Z_long(plotDOFs(k,1),plotDOFs(k,2),:))),real(squeeze(Z_long(plotDOFs(k,1),plotDOFs(k,2),:)))),formatVec{k},'LineWidth',1.2);
    grid on; hold on;
    semilogx(squeeze(w),atan2(imag(squeeze(Z_frf(plotDOFs(k,1),plotDOFs(k,2),:))),real(squeeze(Z_frf(plotDOFs(k,1),plotDOFs(k,2),:)))),formatVec{k+6},'LineWidth',1.4);
    %ylabel('Imag(Z)')
    xlabel('rad/s')
end



%clear w B A m K
%% short tube
% hydro=readBEMIOH5('./hydroData/triton_lidlessdipCut.h5',1,0);
% 
% w= hydro.simulation_parameters.w.';
% B= squeeze(hydro.hydro_coeffs.radiation_damping.all(7,7,:))*rho.*w;
% A= squeeze(hydro.hydro_coeffs.added_mass.all(7,7,:))*rho;
% m= 0; % the free-surface mass in heave is in theory 0. It should be gInertia if you use this.
% K= squeeze(hydro.hydro_coeffs.linear_restoring_stiffness(7,7)).*rho.*g;
% 
% Z_short = (m+A).*(1i.*w) + B + K./(1i.*w);
% 
% figure(1);
% subplot(2,1,1)
% plot(w,real(Z_short));
% ylabel('Real(Z)')
% grid on; hold on;
% subplot(2,1,2)
% plot(w,imag(Z_short));
% ylabel('Imag(Z)')
% xlabel('rad/s')
% grid on; hold on;
% legend('Long Tube','short tube')
% 
% figure(2);
% subplot(2,1,1)
% semilogx(w,mag2db(abs(Z_short)));
% ylabel('abs(Z) db')
% grid on; hold on;
% subplot(2,1,2)
% semilogx(w,atan2(imag(Z_short),real(Z_short)));
% ylabel('angle(Z)')
% xlabel('rad/s')
% grid on; hold on;

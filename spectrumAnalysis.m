%%
%% Calculating the statistics of the wave spectrum
%%
m0 = trapz(waves.w,waves.S);
Hs = 4*sqrt(m0);
%%
m2 = trapz(waves.w,waves.w.^2.*waves.S);
Tz = 2*pi*sqrt(m0/m2)
if strcmp(waves.spectrumType,'PM')
    Tzc = waves.T/sqrt(2)
else
    Tzc = waves.T*sqrt((5+waves.gamma)/(11+waves.gamma))
end
%%
close all
plot(waves.w/(2*pi),waves.w.*waves.S*2*pi,...
     waves.w/(2*pi),waves.w.^2.*waves.S*2*pi,'--');grid on
xlabel('Wave Angular Frequency, \sigma, [rad/s]')
ylabel('Wave Spectrum');set(gca,'ylim',[0 3.5],'ytick',[0:0.7:3.5])
legend('S(\omega)','\omega^{2}S(\omega)')
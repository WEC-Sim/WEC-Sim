%Example of user input MATLAB file for post processing

%Plot waves
waves.plotElevation(simu.rampTime);
try 
    waves.plotSpectrum();
catch
end

%Plot heave response for body 1
output.plotResponse(1,3);
xlim([85 115])

%Plot heave response for body 2
output.plotResponse(2,3);
xlim([85 115])

%Plot heave forces for body 1
output.plotForces(1,3);
xlim([85 115])

%Plot heave forces for body 2
output.plotForces(2,3);
xlim([85 115])

%Save waves and response as video
% output.saveViz(simu,body,waves,...
%     'timesPerFrame',5,'axisLimits',[-150 150 -150 150 -50 20],...
%     'startEndTime',[100 125]);

%%
if body(1).variableHydro.option == 1 && body(2).variableHydro.option == 1
    figure()
    hold on
    for iBod = 1:2
        plot(output.bodies(iBod).time, output.bodies(iBod).hydroForceIndex);
    end
    hold off
    xlabel('Time (s)');
    ylabel('HydroForceIndex');
    legend('Body 1 (float)','Body 2 (spar)');
    title('Hydro force index changing over time');
end

% figure()
% plot(body(1).hydroData(1).simulation_parameters.w,squeeze(body(1).hydroData(1).hydro_coeffs.excitation.re(3,1,:)));


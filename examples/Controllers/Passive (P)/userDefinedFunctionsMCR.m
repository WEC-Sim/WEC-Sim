%% User Defined Functions for MCR run
endInd = length(output.controllers.power);
startTime = output.controllers.power(end,3) - 10*waves.period; % select last 10 periods
[~,startInd] = min(abs(output.controllers.power(:,3) - startTime));

mcr.meanPower(imcr) = mean(output.controllers.power(startInd:endInd,3));
mcr.meanForce(imcr) = mean(output.controllers.force(startInd:endInd,3));

mcr.maxPower(imcr) = max(output.controllers.power(startInd:endInd,3));
mcr.maxForce(imcr) = max(output.controllers.force(startInd:endInd,3));

if imcr == 9
    figure()
    plot(mcr.cases,mcr.meanPower)
    title('Mean Power vs. Proportional Gain')
    xlabel('Proportional Gain/Damping (Ns/m)')
    ylabel('Mean Power (W)')
    xline(9.9347e+05, '--')
    %yline(-3.9286e+05, '--')
    legend('','Theoretical Optimal')
end
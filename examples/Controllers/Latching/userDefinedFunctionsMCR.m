%% User Defined Functions for MCR run
endInd = length(output.controllers.time);
startTime = output.controllers.time(end) - 10*waves.period; % select last 10 periods
[~,startInd] = min(abs(output.controllers.time - startTime));

mcr.meanPower(imcr) = mean(output.controllers.power(startInd:endInd,3));
mcr.meanForce(imcr) = mean(output.controllers.force(startInd:endInd,3));

mcr.maxPower(imcr) = max(output.controllers.power(startInd:endInd,3));
mcr.maxForce(imcr) = max(output.controllers.force(startInd:endInd,3));


if imcr == length(mcr.cases)
    figure()
    plot(mcr.cases,mcr.meanPower)
    title('Mean Power vs. Latching Time')
    xlabel('Latching Time (s)')
    ylabel('Mean Power (W)')
    xline(2.2667, '--')
    %yline(-3.9286e5, '--')
    legend('','Theoretical Optimal')
end
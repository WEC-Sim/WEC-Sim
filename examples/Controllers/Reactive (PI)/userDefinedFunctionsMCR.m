%% User Defined Functions for MCR run
endInd = length(output.controllers.power);
startTime = output.controllers.power(end,3) - 10*waves.period; % select last 10 periods
[~,startInd] = min(abs(output.controllers.power(:,3) - startTime));

mcr.meanPower(imcr) = mean(output.controllers.power(startInd:endInd,3));
mcr.meanForce(imcr) = mean(output.controllers.force(startInd:endInd,3));

mcr.maxPower(imcr) = max(output.controllers.power(startInd:endInd,3));
mcr.maxForce(imcr) = max(output.controllers.force(startInd:endInd,3));

if imcr == 81

    % Kp and Ki gains
    kps = unique(mcr.cases(:,1));
    kis = unique(mcr.cases(:,2));

    i = 1;
    for kpIdx = 1:length(kps)
        for kiIdx = 1:length(kis)
            meanPowerMat(kiIdx, kpIdx) = mcr.meanPower(i);
            i = i+1;
        end
    end

    % Plot surface for controller power at each gain combination
    figure()
    surf(kps,kis,meanPowerMat)
    % Create labels
    zlabel('Mean Controller Power (W)');
    ylabel('Integral Gain/Stiffness (N/m)');
    xlabel('Proportional Gain/Damping (Ns/m)');
    % Set color bar and color map
    C = colorbar('location','EastOutside');
    colormap(jet);
    set(get(C,'XLabel'),'String','Power (Watts)')
    % Create title
    title('Mean Power vs. Proportional and Integral Gains');
end
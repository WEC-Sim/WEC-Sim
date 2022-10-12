%% Plot Position, PTO Force, and Power for Irregular Waves
% Requires an MCR run using MCR build to make the necessary range

close all

meanPowerMat = zeros();

% Kp and Ki gains
kps = unique(mcr.cases(:,1),'stable');
kis = unique(mcr.cases(:,2),'stable');

i = 1;
for kpIdx = 1:length(kps)
    for kiIdx = 1:length(kis)
        meanPowerMat(kpIdx, kiIdx) = mcr.power(i);
        i = i+1;
    end
end

% Plot surface for heave at each gain
figure()
[X,Y] = meshgrid(kps,kis);
surf(X,Y,meanPowerMat')
% Create labels
zlabel('Mean Power (m)');
ylabel('spring coefficent');
xlabel('damping coefficient');
% Set color bar and color map
C = colorbar('location','EastOutside');
colormap(jet);
set(get(C,'XLabel'),'String','heave (m)')
% Create title
title('Parameter Sweep-damping and spring coefficent vs mean power');

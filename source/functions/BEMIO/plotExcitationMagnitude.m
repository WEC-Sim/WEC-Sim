function plotExcitationMagnitude(varargin)
% Plots the excitation force magnitude for each hydro structure's bodies in
% the given degrees of freedom.
% 
% Usage:
% ``plotExcitationMagnitude(hydro, hydro2, hydro3, ...)``
% 
% Parameters
% ----------  
%     varargin : struct(s)
%         The hydroData structure(s) created by the other BEMIO functions.
%         One or more may be input.
% 

if isempty(varargin)
    error(['plotExcitationMagnitude: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotExcitationMagnitude(hydro1, hydro2, ...)']);
end

varargin = checkAndFormatPlotVars(varargin, 1);

figHandle = figure();
titleString = ['Normalized Excitation Force Magnitude: ',...
    '$$\bar{X_i}(\omega,\theta) = {\frac{X_i(\omega,\theta)}{{\rho}g}}$$'];
subtitleStrings = getDofNames(varargin{1}.diagPlotDofs);
xString = {'$$\omega (rad/s)$$'};
for dof = 1:size(varargin{1}.diagPlotDofs,1)
    yString{dof} = ['$$\bar{X_',num2str(varargin{1}.diagPlotDofs(dof)),'}(\omega)$$'];
end

notes = {''};

numHydro = length(varargin);

for iH = 1:numHydro
    tmp1 = strcat('X',num2str(iH));
    X.(tmp1) = varargin{iH}.w;
    tmp2 = strcat('Y',num2str(iH));
    legendCount = 0;
    for ii = 1:length(varargin{iH}.plotBodies)
        iB = varargin{iH}.plotBodies(ii);
        a = sum(varargin{iH}.dof(1:iB)) - varargin{iH}.dof(iB);
        for iii = 1:size(varargin{iH}.diagPlotDofs,1)
            iDof = a+varargin{iH}.diagPlotDofs(iii,1);
            for iv = 1:length(varargin{iH}.plotDirections)
                iDir = varargin{iH}.plotDirections(iv);
                tmp3 = strcat('d',num2str(iv));
                Y.(tmp2).(tmp3)(iii,ii,:) = squeeze(varargin{iH}.ex_ma(iDof,iDir,:));
                legendStrings{legendCount+iv,iH} = strcat('hydro_',num2str(iH),'.',varargin{iH}.body{iB},' \theta =  ',num2str(varargin{iH}.theta(iDir)),'^{\circ}');
            end
        end
        legendCount = legendCount+iv;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,varargin{1}.diagPlotDofs);
saveas(figHandle,'Excitation_Magnitude.png');

end

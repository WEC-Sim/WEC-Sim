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

for ii = 1:numHydro
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.w;
    tmp2 = strcat('Y',num2str(ii));
    b = 0;
    for i = 1:length(varargin{ii}.plotBodies)
        a = 0;
        if i > 1
            for i = 2:varargin{ii}.plotBodies(i)
                a = a + varargin{ii}.dof(varargin{ii}.plotBodies(i-1));
            end
        end
        for j = 1:size(varargin{ii}.diagPlotDofs,1)
            for k = 1:length(varargin{ii}.plotDirections)
                tmp3 = strcat('d',num2str(k));
                Y.(tmp2).(tmp3)(j,i,:) = squeeze(varargin{ii}.ex_ma(a+varargin{ii}.diagPlotDofs(j),varargin{ii}.plotDirections(k),:));
                legendStrings{b+k,ii} = [strcat('hydro_',num2str(ii),'.',varargin{ii}.body{varargin{ii}.plotBodies(i)},' \theta =  ',num2str(varargin{1}.theta(varargin{ii}.plotDirections(k))),'^{\circ}')];
            end
        end
        b = b+k;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,varargin{1}.diagPlotDofs);
saveas(figHandle,'Excitation_Magnitude.png');

end

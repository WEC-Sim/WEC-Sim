function plotRadiationDamping(varargin)
% Plots the radiation damping for each hydro structure's bodies in
% the given degrees of freedom.
% 
% Usage:
% ``plotRadiationDamping(hydro, hydro2, hydro3, ...)``
% 
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure(s) created by the other BEMIO functions.
%         One or more may be input.
% 

if isempty(varargin)
    error(['plotRadiationDamping: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotRadiationDamping(hydro1, hydro2, ...)']);
end

varargin = checkAndFormatPlotVars(varargin);

figHandle = figure();
titleString = ['Normalized Radiation Damping: $$\bar{B}_{i,j}(\omega) = {\frac{B_{i,j}(\omega)}{\rho\omega}}$$'];
subtitleStrings = getDofNames(varargin{1}.plotDofs);
xString = {'$$\omega (rad/s)$$'};
for dof = 1:size(varargin{1}.plotDofs,1)
    yString{dof} = ['$$\bar{B}_{',num2str(varargin{1}.plotDofs(dof,1)),',',num2str(varargin{1}.plotDofs(dof,2)),'}(\omega)$$'];
end

notes = {'Notes:',...
    ['$$\bullet$$ $$\bar{B}_{i,j}(\omega)$$ should tend towards zero within ',...
    'the specified $$\omega$$ range.'],...
    ['$$\bullet$$ Only $$\bar{B}_{i,j}(\omega)$$ for the surge, heave, and ',...
    'pitch DOFs are plotted here. If another DOF is significant to the system ',...
    'that $$\bar{B}_{i,j}(\omega)$$ should also be plotted and verified before ',...
    'proceeding.']};

numHydro = length(varargin);

for ii=1:numHydro
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.w;
    tmp2 = strcat('Y',num2str(ii));        
    for i = 1:length(varargin{ii}.plotBodies)
        a = 0;
        if i > 1
            for i = 2:varargin{ii}.plotBodies(i)
                a = a + varargin{ii}.dof(varargin{ii}.plotBodies(i-1));
            end
        end
        if i ~= 1
            a = (varargin{ii}.plotBodies(i)-1)*varargin{ii}.dof(varargin{ii}.plotBodies(i-1));
        end
        for j = 1:size(varargin{ii}.plotDofs,1)
            Y.(tmp2)(j,i,:) = squeeze(varargin{ii}.B(a+varargin{ii}.plotDofs(j,1),a+varargin{ii}.plotDofs(j,2),:));
        end
        legendStrings{i,ii} = [strcat('hydro_',num2str(ii),'.',varargin{ii}.body{varargin{ii}.plotBodies(i)})];
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,varargin{1}.plotDofs)  
saveas(figHandle,'Radiation_Damping.png');

end

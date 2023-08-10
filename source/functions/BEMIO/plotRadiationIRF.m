function plotRadiationIRF(varargin)
% Plots the radiation IRF for each hydro structure's bodies in
% the given degrees of freedom.
% 
% Usage:
% ``plotRadiationIRF(hydro, hydro2, hydro3, ...)``
% 
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure(s) created by the other BEMIO functions.
%         One or more may be input.
% 

if isempty(varargin)
    error(['plotRadiationIRF: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotRadiationIRF(hydro1, hydro2, ...)']);
end

varargin = checkAndFormatPlotVars(varargin);

figHandle = figure();
titleString = ['Normalized Radiation Impulse Response Functions: ',...
    '$$\bar{K}_{i,j}(t) = {\frac{2}{\pi}}\int_0^{\infty}{\frac{B_{i,j}(\omega)}{\rho}}\cos({\omega}t)d\omega$$'];
subtitleStrings = getDofNames(varargin{1}.plotDofs);
xString = {'$$t (s)$$'};
for dof = 1:size(varargin{1}.plotDofs,1)
    yString{dof} = ['$$\bar{K}_{',num2str(varargin{1}.plotDofs(dof,1)),',',num2str(varargin{1}.plotDofs(dof,2)),'}(t)$$'];
end

notes = {'Notes:',...
    ['$$\bullet$$ The IRF should tend towards zero within the specified timeframe. ',...
    'If it does not, attempt to correct this by adjusting the $$\omega$$ and ',...
    '$$t$$ range and/or step size used in the IRF calculation.'],...
    ['$$\bullet$$ Only the IRFs for the surge, heave, and pitch DOFs are plotted ',...
    'here. If another DOF is significant to the system, that IRF should also ',...
    'be plotted and verified before proceeding.']};

numHydro = length(varargin);

for ii = 1:numHydro
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.ra_t;
    tmp2 = strcat('Y',num2str(ii));
    q = 0;
    for i = 1:length(varargin{ii}.plotBodies)
        a = 0;
        if i > 1
            for i = 2:varargin{ii}.plotBodies(i)
                a = a + varargin{ii}.dof(varargin{ii}.plotBodies(i-1));
            end
        end
        for j = 1:size(varargin{ii}.plotDofs,1)
            Y.(tmp2)(j,i,:) = squeeze(varargin{ii}.ra_K(a+varargin{ii}.plotDofs(j,1),a+varargin{ii}.plotDofs(j,2),:));
            if isfield(varargin{ii},'ss_A')==1
                q = 1;
                Y.(tmp2)(j,i,:) = squeeze(varargin{ii}.ss_K(a+varargin{ii}.plotDofs(j,1),a+varargin{ii}.plotDofs(j,2),:));
            end
        end
        legendStrings{i,ii} = [strcat('hydro_',num2str(ii),'.',varargin{ii}.body{varargin{ii}.plotBodies(i)})];
        if q == 1
            legendStrings{i,ii} = [strcat('hydro_',num2str(ii),'.',varargin{ii}.body{varargin{ii}.plotBodies(i)}),' (SS)'];
        end
        q = 0;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,varargin{1}.plotDofs)  
saveas(figHandle,'Radiation_IRFs.png');

end

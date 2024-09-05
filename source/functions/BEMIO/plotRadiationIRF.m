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

for iH = 1:numHydro
    tmp1 = strcat('X',num2str(iH));
    X.(tmp1) = varargin{iH}.ra_t;
    tmp2 = strcat('Y',num2str(iH));
    ssFlag = isfield(varargin{iH},'ss_A');
    for ii = 1:length(varargin{iH}.plotBodies)
        iB = varargin{iH}.plotBodies(ii);
        a = sum(varargin{iH}.dof(1:iB)) - varargin{iH}.dof(iB);
        for iii = 1:size(varargin{iH}.plotDofs,1)
            iDof1 = a+varargin{iH}.plotDofs(iii,1);
            iDof2 = a+varargin{iH}.plotDofs(iii,2);
            if ssFlag
                Y.(tmp2)(iii,ii,:) = squeeze(varargin{iH}.ss_K(iDof1,iDof2,:));
            else
                Y.(tmp2)(iii,ii,:) = squeeze(varargin{iH}.ra_K(iDof1,iDof2,:));
            end
        end
        if ssFlag
            legendStrings{ii,iH} = strcat('hydro_',num2str(iH),'.',varargin{iH}.body{iB},' (SS)');
        else
            legendStrings{ii,iH} = strcat('hydro_',num2str(iH),'.',varargin{iH}.body{iB});
        end
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,varargin{1}.plotDofs)  
saveas(figHandle,'Radiation_IRFs.png');

end

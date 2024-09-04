function plotExcitationIRF(varargin)
% Plots the excitation IRF for each hydro structure's bodies in
% the given degrees of freedom.
% 
% Usage:
% ``plotExcitationIRF(hydro, hydro2, hydro3, ...)``
% 
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure(s) created by the other BEMIO functions.
%         One or more may be input.
% 

varargin = checkAndFormatPlotVars(varargin, 1);

if isempty(varargin)
    error(['plotExcitationIRF: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotExcitationIRF(hydro1, hydro2, ...)']);
end

figHandle = figure();
titleString = ['Normalized Excitation Impulse Response Functions:   ',...
    '$$\bar{K}_i(t) = {\frac{1}{2\pi}}\int_{-\infty}^{\infty}{\frac{X_i(\omega,\theta)e^{i{\omega}t}}{{\rho}g}}d\omega$$'];
subtitleStrings = getDofNames(varargin{1}.diagPlotDofs);
xString = {'$$t (s)$$'};
for dof = 1:size(varargin{1}.diagPlotDofs,1)
    yString{dof} = ['$$\bar{K}_',num2str(varargin{1}.diagPlotDofs(dof)),'(t)$$'];
end

notes = {'Notes:',...
    ['$$\bullet$$ The IRF should tend towards zero within the specified timeframe. ',...
    'If it does not, attempt to correct this by adjusting the $$\omega$$ and ',...
    '$$t$$ range and/or step size used in the IRF calculation.'],...
    ['$$\bullet$$ Only the IRFs for the first wave heading, surge, heave, and ',...
    'pitch DOFs are plotted here. If another wave heading or DOF is significant ',...
    'to the system, that IRF should also be plotted and verified before proceeding.']};

numHydro = length(varargin);

for iH = 1:numHydro
    tmp1 = strcat('X',num2str(iH));
    X.(tmp1) = varargin{iH}.ex_t;
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
                Y.(tmp2).(tmp3)(iii,ii,:) = squeeze(varargin{iH}.ex_K(iDof,iDir,:));
                legendStrings{legendCount+iv,iH} = strcat('hydro_',num2str(iH),'.',varargin{iH}.body{iB},' \theta =  ',num2str(varargin{iH}.theta(iDir)),'^{\circ}');
            end
        end
        legendCount = legendCount+iv;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,varargin{1}.diagPlotDofs)  
saveas(figHandle,'Excitation_IRFs.png');

end

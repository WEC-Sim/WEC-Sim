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

for ii = 1:numHydro
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.ex_t;
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
                Y.(tmp2).(tmp3)(j,i,:) = squeeze(varargin{ii}.ex_K(a+varargin{ii}.diagPlotDofs(j),varargin{ii}.plotDirections(k),:));
                legendStrings{b+k,ii} = [strcat('hydro_',num2str(ii),'.',varargin{ii}.body{varargin{ii}.plotBodies(i)},' \theta =  ',num2str(varargin{1}.theta(varargin{ii}.plotDirections(k))),'^{\circ}')];
            end
        end
        b = b+k;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,varargin{1}.diagPlotDofs)  
saveas(figHandle,'Excitation_IRFs.png');

end

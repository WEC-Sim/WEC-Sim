function plotAddedMass(varargin)
% Plots the added mass for each hydro structure's bodies in
% the given degrees of freedom.
% 
% Usage:
% ``plotAddedMass(hydro, hydro2, hydro3, ...)``
% 
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure(s) created by the other BEMIO functions.
%         One or more may be input.

if isempty(varargin)
    error(['plotAddedMass: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotAddedMass(hydro1, hydro2, ...)']);
end

varargin = checkAndFormatPlotVars(varargin);

figHandle = figure();
titleString = ['Normalized Added Mass: $$\bar{A}_{i,j}(\omega) = {\frac{A_{i,j}(\omega)}{\rho}}$$'];
subtitleStrings = getDofNames(varargin{1}.plotDofs);
xString = {'$$\omega (rad/s)$$'};
for dof = 1:size(varargin{1}.plotDofs,1)
    yString{dof} = ['$$\bar{A}_{',num2str(varargin{1}.plotDofs(dof,1)),',',num2str(varargin{1}.plotDofs(dof,2)),'}(\omega)$$'];
end
%yString = {'$$\bar{A}_{1,1}(\omega)$$','$$\bar{A}_{2,2}(\omega)$$','$$\bar{A}_{3,3}(\omega)$$','$$\bar{A}_{4,4}(\omega)$$','$$\bar{A}_{5,5}(\omega)$$','$$\bar{A}_{6,6}(\omega)$$'};

notes = {'Notes:',...
    ['$$\bullet$$ $$\bar{A}_{i,j}(\omega)$$ should tend towards a constant, ',...
    '$$A_{\infty}$$, within the specified $$\omega$$ range.'],...
    ['$$\bullet$$ Only $$\bar{A}_{i,j}(\omega)$$ for the surge, heave, and ',...
    'pitch DOFs are plotted here. If another DOF is significant to the system, ',...
    'that $$\bar{A}_{i,j}(\omega)$$ should also be plotted and verified before ',...
    'proceeding.']};

numHydro = length(varargin);

for iH = 1:numHydro
    tmp1 = strcat('X',num2str(iH));
    X.(tmp1) = varargin{iH}.w;
    tmp2 = strcat('Y',num2str(iH));
    for ii = 1:length(varargin{iH}.plotBodies)
        iB = varargin{iH}.plotBodies(ii);
        a = sum(varargin{iH}.dof(1:iB)) - varargin{iH}.dof(iB);
        for iii = 1:size(varargin{iH}.plotDofs,1)
            iDof1 = a+varargin{iH}.plotDofs(iii,1);
            iDof2 = a+varargin{iH}.plotDofs(iii,2);
            Y.(tmp2)(iii,ii,:) = squeeze(varargin{iH}.A(iDof1,iDof2,:));
        end
        legendStrings{ii,iH} = strcat('hydro_',num2str(iH),'.',varargin{iH}.body{iB});
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,varargin{1}.plotDofs);
saveas(figHandle,'Added_Mass.png');

end

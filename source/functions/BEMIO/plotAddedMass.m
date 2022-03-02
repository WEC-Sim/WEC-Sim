function plotAddedMass(varargin)
% Plots the added mass for each hydro structure's bodies in
% the heave, surge and pitch degrees of freedom.
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

figHandle = figure('Position',[50,500,975,521]);
titleString = ['Normalized Added Mass: $$\bar{A}_{i,j}(\omega) = {\frac{A_{i,j}(\omega)}{\rho}}$$'];
subtitleStrings = {'Surge','Heave','Pitch'};
xString = {'$$\omega (rad/s)$$','$$\omega (rad/s)$$','$$\omega (rad/s)$$'};
yString = {'$$\bar{A}_{1,1}(\omega)$$','$$\bar{A}_{3,3}(\omega)$$','$$\bar{A}_{5,5}(\omega)$$'};

notes = {'Notes:',...
    ['$$\bullet$$ $$\bar{A}_{i,j}(\omega)$$ should tend towards a constant, ',...
    '$$A_{\infty}$$, within the specified $$\omega$$ range.'],...
    ['$$\bullet$$ Only $$\bar{A}_{i,j}(\omega)$$ for the surge, heave, and ',...
    'pitch DOFs are plotted here. If another DOF is significant to the system, ',...
    'that $$\bar{A}_{i,j}(\omega)$$ should also be plotted and verified before ',...
    'proceeding.']};

numHydro = length(varargin);
for ii = 1:numHydro
    numBod = varargin{ii}.Nb;
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.w;
    tmp2 = strcat('Y',num2str(ii));
    a = 0;            
    for i = 1:numBod    
        m = varargin{ii}.dof(i);
        Y.(tmp2)(1,i,:) = squeeze(varargin{ii}.A(a+1,a+1,:));
        Y.(tmp2)(2,i,:) = squeeze(varargin{ii}.A(a+3,a+3,:));
        Y.(tmp2)(3,i,:) = squeeze(varargin{ii}.A(a+5,a+5,:));
        legendStrings{i,ii} = [varargin{ii}.body{i}];
        a = a + m;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes);
saveas(figHandle,'Added_Mass.png');

end

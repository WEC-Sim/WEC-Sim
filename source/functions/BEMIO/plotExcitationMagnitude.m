function plotExcitationMagnitude(varargin)
% Plots the excitation force magnitude for each hydro structure's bodies in
% the heave, surge and pitch degrees of freedom.
% 
% Usage:
% ``plotExcitationMagnitude(hydro, hydro2, hydro3, ...)``
% 
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure `hydro` created by the other BEMIO
%         functions. One or more may be input.

if isempty(varargin)
    error(['plotExcitationMagnitude: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotExcitationMagnitude(hydro1, hydro2, ...)']);
end

B=1;  % Wave heading index
figHandle = figure('Position',[950,500,975,521]);
titleString = ['Normalized Excitation Force Magnitude: ',...
    '$$\bar{X_i}(\omega,\beta) = {\frac{X_i(\omega,\beta)}{{\rho}g}}$$'];
subtitleString = {'Surge','Heave','Pitch'};
xString = {'$$\omega (rad/s)$$','$$\omega (rad/s)$$','$$\omega (rad/s)$$'};
yString = {['$$\bar{X_1}(\omega,\beta$$',' = ',num2str(varargin{1}.beta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{X_3}(\omega,\beta$$',' = ',num2str(varargin{1}.beta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{X_5}(\omega,\beta$$',' = ',num2str(varargin{1}.beta(B)),'$$^{\circ}$$)']};

notes = {''};

numHydro = length(varargin);
for ii = 1:numHydro
    numBod = varargin{ii}.Nb;
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.w;
    tmp2 = strcat('Y',num2str(ii));
    a = 0;
    for i = 1:numBod
        m = varargin{ii}.dof(i);
        Y.(tmp2)(1,i,:) = squeeze(varargin{ii}.ex_ma(a+1,B,:));
        Y.(tmp2)(2,i,:) = squeeze(varargin{ii}.ex_ma(a+3,B,:));
        Y.(tmp2)(3,i,:) = squeeze(varargin{ii}.ex_ma(a+5,B,:));
        legendStrings{i,ii} = [varargin{ii}.body{i}];
        a = a + m;
    end
end

formatPlot(figHandle,titleString,subtitleString,xString,yString,X,Y,legendStrings,notes);
saveas(figHandle,'Excitation_Magnitude.png');

end

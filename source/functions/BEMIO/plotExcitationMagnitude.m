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
%         The hydroData structure(s) created by the other BEMIO functions.
%         One or more may be input.
% 

if isempty(varargin)
    error(['plotExcitationMagnitude: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotExcitationMagnitude(hydro1, hydro2, ...)']);
end

options.dofs = [1 3 5];
options.bodies = 'all';
optionNames = fieldnames(options);

for i = 1:length(varargin) % check if any options are given
    optInds(i) = isnumeric(varargin{i}) || strcmp(varargin{i},'all') || strcmp(varargin{i},'first');
    if optInds(i) == 1 
        if any(strcmpi(varargin{i-1},optionNames))
            options.(varargin{i-1}) = varargin{i};
        else
            error('%s is not a recognized parameter name')
        end
    end
end

if strcmp(options.dofs,'all')
    options.dofs = [1:varargin{1}.dof(1)];
end
if strcmp(options.bodies,'all')
    options.bodies = [1:varargin{1}.Nb];
end

B=1;  % Wave heading index
figHandle = figure('Position',[950,500,325*length(options.dofs),520]);
titleString = ['Normalized Excitation Force Magnitude: ',...
    '$$\bar{X_i}(\omega,\theta) = {\frac{X_i(\omega,\theta)}{{\rho}g}}$$'];
subtitleStrings = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
xString = {'$$\omega (rad/s)$$'};
yString = {['$$\bar{X_1}(\omega,\theta$$',' = ',num2str(varargin{1}.theta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{X_2}(\omega,\theta$$',' = ',num2str(varargin{1}.theta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{X_3}(\omega,\theta$$',' = ',num2str(varargin{1}.theta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{X_4}(\omega,\theta$$',' = ',num2str(varargin{1}.theta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{X_5}(\omega,\theta$$',' = ',num2str(varargin{1}.theta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{X_6}(\omega,\theta$$',' = ',num2str(varargin{1}.theta(B)),'$$^{\circ}$$)']};

notes = {''};

numHydro = length(varargin) - sum(optInds)*2;

for ii = 1:numHydro
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.w;
    tmp2 = strcat('Y',num2str(ii));
    a = 0;
    for i = 1:length(options.bodies)
        a = (options.bodies(i)-1)*varargin{ii}.dof(options.bodies(1));
        for j = 1:length(options.dofs)
            Y.(tmp2)(j,i,:) = squeeze(varargin{ii}.ex_ma(a+options.dofs(j),B,:));
        end
        legendStrings{i,ii} = [varargin{ii}.body{options.bodies(i)}];
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,options);
saveas(figHandle,'Excitation_Magnitude.png');

end

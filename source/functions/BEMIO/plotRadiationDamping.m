function plotRadiationDamping(varargin)
% Plots the radiation damping for each hydro structure's bodies in
% the heave, surge and pitch degrees of freedom.
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

figHandle = figure('Position',[50,300,325*length(options.dofs),521]);
titleString = ['Normalized Radiation Damping: $$\bar{B}_{i,j}(\omega) = {\frac{B_{i,j}(\omega)}{\rho\omega}}$$'];
subtitleStrings = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
xString = {'$$\omega (rad/s)$$'};
yString = {'$$\bar{B}_{1,1}(\omega)$$','$$\bar{B}_{2,2}(\omega)$$','$$\bar{B}_{3,3}(\omega)$$','$$\bar{B}_{4,4}(\omega)$$','$$\bar{B}_{5,5}(\omega)$$','$$\bar{B}_{6,6}(\omega)$$'};

notes = {'Notes:',...
    ['$$\bullet$$ $$\bar{B}_{i,j}(\omega)$$ should tend towards zero within ',...
    'the specified $$\omega$$ range.'],...
    ['$$\bullet$$ Only $$\bar{B}_{i,j}(\omega)$$ for the surge, heave, and ',...
    'pitch DOFs are plotted here. If another DOF is significant to the system ',...
    'that $$\bar{B}_{i,j}(\omega)$$ should also be plotted and verified before ',...
    'proceeding.']};

numHydro = length(varargin) - sum(optInds)*2;

for ii=1:numHydro
tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.w;
    tmp2 = strcat('Y',num2str(ii));
    a = 0;          
    for i = 1:length(options.bodies)
        a = (options.bodies(i)-1)*varargin{ii}.dof(options.bodies(1));
        for j = 1:length(options.dofs)
            Y.(tmp2)(j,i,:) = squeeze(varargin{ii}.B(a+options.dofs(j),a+options.dofs(j),:));
        end
        legendStrings{i,ii} = [varargin{ii}.body{options.bodies(i)}];
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,options)  
saveas(figHandle,'Radiation_Damping.png');

end

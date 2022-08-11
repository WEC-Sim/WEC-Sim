function plotRadiationIRF(varargin)
% Plots the radiation IRF for each hydro structure's bodies in
% the heave, surge and pitch degrees of freedom.
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

figHandle = figure('Position',[50,100,325*length(options.dofs),521]);
titleString = ['Normalized Radiation Impulse Response Functions: ',...
    '$$\bar{K}_{i,j}(t) = {\frac{2}{\pi}}\int_0^{\infty}{\frac{B_{i,j}(\omega)}{\rho}}\cos({\omega}t)d\omega$$'];
subtitleStrings = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
xString = {'$$t (s)$$'};
yString = {'$$\bar{K}_{1,1}(t)$$','$$\bar{K}_{2,2}(t)$$','$$\bar{K}_{3,3}(t)$$','$$\bar{K}_{4,4}(t)$$','$$\bar{K}_{5,5}(t)$$','$$\bar{K}_{6,6}(t)$$'};

notes = {'Notes:',...
    ['$$\bullet$$ The IRF should tend towards zero within the specified timeframe. ',...
    'If it does not, attempt to correct this by adjusting the $$\omega$$ and ',...
    '$$t$$ range and/or step size used in the IRF calculation.'],...
    ['$$\bullet$$ Only the IRFs for the surge, heave, and pitch DOFs are plotted ',...
    'here. If another DOF is significant to the system, that IRF should also ',...
    'be plotted and verified before proceeding.']};
    
numHydro = length(varargin) - sum(optInds)*2;

for ii = 1:numHydro
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.ra_t;
    tmp2 = strcat('Y',num2str(ii));
    a = 0;
    q = 0;
    for i = 1:length(options.bodies)
        a = (options.bodies(i)-1)*varargin{ii}.dof(options.bodies(1));
        for j = 1:length(options.dofs)
            Y.(tmp2)(j,i,:) = squeeze(varargin{ii}.ra_K(a+options.dofs(j),a+options.dofs(j),:));
            if isfield(varargin{ii},'ss_A')==1
                q = 1;
                Y.(tmp2)(1,i,:) = squeeze(varargin{ii}.ss_K(a+options.dofs(j),a+options.dofs(j),:));
                
            end
        end
        legendStrings{i,ii} = [varargin{ii}.body{options.bodies(i)}];
        if q == 1
            legendStrings{i,ii} = [varargin{ii}.body{i},' (SS)'];
        end
        q = 0;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,options)  
saveas(figHandle,'Radiation_IRFs.png');

end

function plotExcitationIRF(varargin)
% Plots the excitation IRF for each hydro structure's bodies in
% the heave, surge and pitch degrees of freedom.
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

if isempty(varargin)
    error(['plotExcitationIRF: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotExcitationIRF(hydro1, hydro2, ...)']);
end

options.dofs = [1 3 5];
options.bodies = 'all';
options.directions = 1;
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
if strcmp(options.directions,'all')
    options.directions = varargin{1}.theta;
end

figHandle = figure('Position',[950,100,325*length(options.dofs),520]);
titleString = ['Normalized Excitation Impulse Response Functions:   ',...
    '$$\bar{K}_i(t) = {\frac{1}{2\pi}}\int_{-\infty}^{\infty}{\frac{X_i(\omega,\theta)e^{i{\omega}t}}{{\rho}g}}d\omega$$'];
subtitleStrings = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
xString = {'$$t (s)$$'};
yString = {['$$\bar{K}_1(t,\theta$$)'],...
    ['$$\bar{K}_2(t,\theta$$)'],...
    ['$$\bar{K}_3(t,\theta$$)'],...
    ['$$\bar{K}_4(t,\theta$$)'],...
    ['$$\bar{K}_5(t,\theta$$)'],...
    ['$$\bar{K}_6(t,\theta$$)']};

notes = {'Notes:',...
    ['$$\bullet$$ The IRF should tend towards zero within the specified timeframe. ',...
    'If it does not, attempt to correct this by adjusting the $$\omega$$ and ',...
    '$$t$$ range and/or step size used in the IRF calculation.'],...
    ['$$\bullet$$ Only the IRFs for the first wave heading, surge, heave, and ',...
    'pitch DOFs are plotted here. If another wave heading or DOF is significant ',...
    'to the system, that IRF should also be plotted and verified before proceeding.']};

numHydro = length(varargin) - sum(optInds)*2;

for ii = 1:numHydro
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.ex_t;
    tmp2 = strcat('Y',num2str(ii));
    a = 0;
    b = 0;
    for i = 1:length(options.bodies)
        a = (options.bodies(i)-1)*varargin{ii}.dof(options.bodies(1));
        for j = 1:length(options.dofs)
            for k = 1:length(options.directions)
                tmp3 = strcat('d',num2str(k));
                Y.(tmp2).(tmp3)(j,i,:) = squeeze(varargin{ii}.ex_K(a+options.dofs(j),options.directions(k),:));
                legendStrings{b+k,ii} = [strcat(varargin{ii}.body{options.bodies(i)},' $\theta$ =  ',num2str(varargin{1}.theta(options.directions(k))),'$$^{\circ}$$')];
            end
        end
        b = b+k;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,options)  
saveas(figHandle,'Excitation_IRFs.png');

end

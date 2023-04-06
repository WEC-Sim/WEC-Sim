function plotExcitationIRF(dofList, varargin)
% Plots the excitation IRF for each hydro structure's bodies in
% the given degrees of freedom.
% 
% Usage:
% ``plotExcitationIRF([1], hydro, hydro2, hydro3, ...)``
% ``plotExcitationIRF([1 3 5], hydro, hydro2, hydro3, ...)``
% 
% Parameters
% ----------
%     dofList : [1 n] int vector
%         Array of DOFs that will be plotted. Default = [1 3 5]
%     
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

% DEV Stuff
subtitleStrings = getDofNames(dofList);

B=1;  % Wave heading index
figHandle = figure('Position',[950,100,975,521]);
titleString = ['Normalized Excitation Impulse Response Functions:   ',...
    '$$\bar{K}_i(t) = {\frac{1}{2\pi}}\int_{-\infty}^{\infty}{\frac{X_i(\omega,\theta)e^{i{\omega}t}}{{\rho}g}}d\omega$$'];

for dof = 1:length(dofList)
    xString{dof} = '$$t (s)$$';
    yString{dof} = ['$$\bar{K}_',num2str(dofList(dof)),'(t,\theta$$',' = ',...
        num2str(varargin{1}.theta(B)),'$$^{\circ}$$)'];
end
%

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
    for i = 1:numBod
        m = varargin{ii}.dof(i);
        id = 0;
        for d = 1:length(dofList)
            id = id + 1;
            Y.(tmp2)(id,i,:) = squeeze(varargin{ii}.ex_K(a+dofList(d),B,:));
        end
        legendStrings{i,ii} = [varargin{ii}.body{i}];
        a = a + m;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,options)  
saveas(figHandle,'Excitation_IRFs.png');

end

function plotExcitationPhase(varargin)
% Plots the excitation force phase for each hydro structure's bodies in
% the heave, surge and pitch degrees of freedom.
% 
% Usage:
% ``plotExcitationPhase(hydro, hydro2, hydro3, ...)``
% 
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure(s) created by the other BEMIO functions.
%         One or more may be input.
% 

if isempty(varargin)
    error(['plotExcitationPhase: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotExcitationPhase(hydro1, hydro2, ...)']);
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

figHandle = figure('Position',[950,300,325*length(options.dofs),520]);
titleString = ['Excitation Force Phase: $$\phi_i(\omega,\theta)$$'];
subtitleStrings = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
xString = {'$$\omega (rad/s)$$'};
yString = {['$$\phi_1(\omega,\theta$$)'],...
    ['$$\phi_2(\omega,\theta$$)'],...
    ['$$\phi_3(\omega,\theta$$)'],...
    ['$$\phi_4(\omega,\theta$$)'],...
    ['$$\phi_5(\omega,\theta$$)'],...
    ['$$\phi_6(\omega,\theta$$)']};

notes = {''};

numHydro = length(varargin) - sum(optInds)*2;

for ii = 1:numHydro
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.w;
    tmp2 = strcat('Y',num2str(ii));
    a = 0;
    b = 0;
    for i = 1:length(options.bodies)
        a = (options.bodies(i)-1)*varargin{ii}.dof(options.bodies(1));
        for j = 1:length(options.dofs)
            for k = 1:length(options.directions)
                tmp3 = strcat('d',num2str(k));
                Y.(tmp2).(tmp3)(j,i,:) = squeeze(varargin{ii}.ex_ph(a+options.dofs(j),options.directions(k),:));
                legendStrings{b+k,ii} = [strcat(varargin{ii}.code(1:3),varargin{ii}.body{options.bodies(i)},' \theta =',num2str(varargin{1}.theta(options.directions(k))),'^{\circ}')];
            end
        end
        b = b+k;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,options)  
saveas(figHandle,'Excitation_Phase.png');

end

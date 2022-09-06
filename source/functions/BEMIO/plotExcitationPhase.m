function plotExcitationPhase(dofList, varargin)
% Plots the excitation force phase for each hydro structure's bodies in
% the given degrees of freedom.
% 
% Usage:
% ``plotExcitationPhase([1], hydro, hydro2, hydro3, ...)``
% ``plotExcitationPhase([1 3 5], hydro, hydro2, hydro3, ...)``
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
    error(['plotExcitationPhase: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotExcitationPhase(hydro1, hydro2, ...)']);
end

dofNames = {'Surge','Sway','Heave','Roll','Pitch','Yaw',...
    'dof7','dof8','dof9','dof10','dof11','dof12'};

B=1;  % Wave heading index
figHandle = figure('Position',[950,300,975,521]);
titleString = ['Excitation Force Phase: $$\phi_i(\omega,\theta)$$'];
subtitleStrings = dofNames(dofList);
for dof = dofList
    xString{dof} = '$$\omega (rad/s)$$';
    yString{dof} = ['$$\phi_',num2str(dof),'(\omega,\theta$$',' = ',...
        num2str(varargin{1}.theta(B)),'$$^{\circ})$$'];
end

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
        id = 0;
        for d = dofList
            id = id + 1;
            Y.(tmp2)(id,i,:) = squeeze(varargin{ii}.ex_ph(a+d,B,:));
        end
        legendStrings{i,ii} = [varargin{ii}.body{i}];
        a = a + m;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes)  
saveas(figHandle,'Excitation_Phase.png');

end

function plotExcitationPhase(varargin)
% Plots the excitation force phase for each hydro structure's bodies in
% the heave, surge and pitch degrees of freedom.
% 
% Usage
% -----
% plotExcitationPhase(hydro, hydro2, hydro3, ...)
% 
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure `hydro` created by the other BEMIO
%         functions. One or more may be input.

if isempty(varargin)
    error(['plotExcitationPhase: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotExcitationPhase(hydro1, hydro2, ...)']);
end

B=1;  % Wave heading index
figHandle = figure('Position',[950,300,975,521]);
titleString = ['Excitation Force Phase: $$\phi_i(\omega,\beta)$$'];
subtitleString = {'Surge','Heave','Pitch'};
xString = {'$$\omega (rad/s)$$','$$\omega (rad/s)$$','$$\omega (rad/s)$$'};
yString = {['$$\phi_1(\omega,\beta$$',' = ',num2str(varargin{1}.beta(B)),'$$^{\circ})$$'],...
    ['$$\phi_3(\omega,\beta$$',' = ',num2str(varargin{1}.beta(B)),'$$^{\circ}$$)'],...
    ['$$\phi_5(\omega,\beta$$',' = ',num2str(varargin{1}.beta(B)),'$$^{\circ}$$)']};

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
        Y.(tmp2)(1,i,:) = squeeze(varargin{ii}.ex_ph(a+1,B,:));
        Y.(tmp2)(2,i,:) = squeeze(varargin{ii}.ex_ph(a+3,B,:));
        Y.(tmp2)(3,i,:) = squeeze(varargin{ii}.ex_ph(a+5,B,:));
        legendStrings{i,ii} = [varargin{ii}.body{i}];
        a = a + m;
    end
end

FormatPlot(figHandle,titleString,subtitleString,xString,yString,X,Y,legendStrings,notes)  
saveas(figHandle,'Excitation_Phase.png');

end

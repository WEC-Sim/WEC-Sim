function plotExcitationMagnitude(dofList, varargin)
% Plots the excitation force magnitude for each hydro structure's bodies in
% the given degrees of freedom.
% 
% Usage:
% ``plotExcitationMagnitude([1], hydro, hydro2, hydro3, ...)``
% ``plotExcitationMagnitude([1 3 5], hydro, hydro2, hydro3, ...)``
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
    error(['plotExcitationMagnitude: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotExcitationMagnitude(hydro1, hydro2, ...)']);
end

subtitleStrings = getDofNames(dofList);

B=1;  % Wave heading index
figHandle = figure('Position',[950,500,975,521]);
titleString = ['Normalized Excitation Force Magnitude: ',...
    '$$\bar{X_i}(\omega,\theta) = {\frac{X_i(\omega,\theta)}{{\rho}g}}$$'];

for dof = 1:length(dofList)
    xString{dof} = '$$\omega (rad/s)$$';
    yString{dof} = ['$$\bar{X_',num2str(dofList(dof)),'}(\omega,\theta$$',' = ',...
        num2str(varargin{1}.theta(B)),'$$^{\circ}$$)'];
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
        for d = 1:length(dofList)
            id = id + 1;
            Y.(tmp2)(id,i,:) = squeeze(varargin{ii}.ex_ma(a+dofList(d),B,:));
        end
        legendStrings{i,ii} = [varargin{ii}.body{i}];
        a = a + m;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes);
saveas(figHandle,'Excitation_Magnitude.png');

end

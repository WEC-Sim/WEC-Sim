function plotAddedMass(dofList, varargin)
% Plots the added mass for each hydro structure's bodies in
% the given degrees of freedom.
% 
% Usage:
% ``plotAddedMass([1], hydro, hydro2, hydro3, ...)``
% ``plotAddedMass([1 3 5], hydro, hydro2, hydro3, ...)``
% 
% Parameters
% ----------
%     dofList : [1 n] int vector
%         Array of DOFs that will be plotted. Default = [1 3 5]
% 
%     varargin : struct(s)
%         The hydroData structure(s) created by the other BEMIO functions.
%         One or more may be input.

if isempty(varargin)
    error(['plotAddedMass: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotAddedMass(hydro1, hydro2, ...)']);
end

dofNames = {'Surge','Sway','Heave','Roll','Pitch','Yaw',...
    'dof7','dof8','dof9','dof10','dof11','dof12'};

figHandle = figure('Position',[50,500,975,521]);
titleString = ['Normalized Added Mass: $$\bar{A}_{i,j}(\omega) = {\frac{A_{i,j}(\omega)}{\rho}}$$'];
subtitleStrings = dofNames(dofList);
for dof = dofList
    xString{dof} = '$$\omega (rad/s)$$';
    yString{dof} = ['$$\bar{A}_{',num2str(dof),',',num2str(dof),'}(\omega)$$'];
end

notes = {'Notes:',...
    ['$$\bullet$$ $$\bar{A}_{i,j}(\omega)$$ should tend towards a constant, ',...
    '$$A_{\infty}$$, within the specified $$\omega$$ range.'],...
    ['$$\bullet$$ Only $$\bar{A}_{i,j}(\omega)$$ for the surge, heave, and ',...
    'pitch DOFs are plotted here. If another DOF is significant to the system, ',...
    'that $$\bar{A}_{i,j}(\omega)$$ should also be plotted and verified before ',...
    'proceeding.']};

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
            Y.(tmp2)(id,i,:) = squeeze(varargin{ii}.A(a+d,a+d,:));
        end
        legendStrings{i,ii} = [varargin{ii}.body{i}];
        a = a + m;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes);
saveas(figHandle,'Added_Mass.png');

end

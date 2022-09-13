function plotRadiationDamping(dofList, varargin)
% Plots the radiation damping for each hydro structure's bodies in
% the given degrees of freedom.
% 
% Usage:
% ``plotRadiationDamping([1], hydro, hydro2, hydro3, ...)``
% ``plotRadiationDamping([1 3 5], hydro, hydro2, hydro3, ...)``
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
    error(['plotRadiationDamping: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotRadiationDamping(hydro1, hydro2, ...)']);
end

subtitleStrings = getDofNames(dofList);

figHandle = figure('Position',[50,300,975,521]);
titleString = ['Normalized Radiation Damping: $$\bar{B}_{i,j}(\omega) = {\frac{B_{i,j}(\omega)}{\rho\omega}}$$'];
id = 0
for rIdx = 1:length(dofList(:,1))
   id = id+1;
   xString{id} = '$$\omega (rad/s)$$';
   yString{id} = ['$$\bar{B}_{',num2str(dofList(rIdx,1)),',',num2str(dofList(rIdx,2)),'}(\omega)$$'];
end

notes = {'Notes:',...
    ['$$\bullet$$ $$\bar{B}_{i,j}(\omega)$$ should tend towards zero within ',...
    'the specified $$\omega$$ range.'],...
    ['$$\bullet$$ Only $$\bar{B}_{i,j}(\omega)$$ for the surge, heave, and ',...
    'pitch DOFs are plotted here. If another DOF is significant to the system ',...
    'that $$\bar{B}_{i,j}(\omega)$$ should also be plotted and verified before ',...
    'proceeding.']};

numHydro = length(varargin);
for ii=1:numHydro
    numBod = varargin{ii}.Nb;
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.w;
    tmp2 = strcat('Y',num2str(ii));
    a = 0;            
    for i = 1:numBod    
        m = varargin{ii}.dof(i);
        id = 0;
        for rIdx = 1:length(dofList(:,1))
            id = id + 1;
            Y.(tmp2)(id,i,:) = squeeze(varargin{ii}.B(a+dofList(rIdx,1),a+dofList(rIdx,2),:));
        end
        legendStrings{i,ii} = [varargin{ii}.body{i}];
        a = a + m;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes)  
saveas(figHandle,'Radiation_Damping.png');

end

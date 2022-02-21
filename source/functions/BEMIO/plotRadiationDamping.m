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
%         The hydroData structure `hydro` created by the other BEMIO
%         functions. One or more may be input.

if isempty(varargin)
    error(['plotRadiationDamping: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotRadiationDamping(hydro1, hydro2, ...)']);
end

figHandle = figure('Position',[50,300,975,521]);
titleString = ['Normalized Radiation Damping: $$\bar{B}_{i,j}(\omega) = {\frac{B_{i,j}(\omega)}{\rho\omega}}$$'];
subtitleStrings = {'Surge','Heave','Pitch'};
xString = {'$$\omega (rad/s)$$','$$\omega (rad/s)$$','$$\omega (rad/s)$$'};
yString = {'$$\bar{B}_{1,1}(\omega)$$','$$\bar{B}_{3,3}(\omega)$$','$$\bar{B}_{5,5}(\omega)$$'};

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
        Y.(tmp2)(1,i,:) = squeeze(varargin{ii}.B(a+1,a+1,:));
        Y.(tmp2)(2,i,:) = squeeze(varargin{ii}.B(a+3,a+3,:));
        Y.(tmp2)(3,i,:) = squeeze(varargin{ii}.B(a+5,a+5,:));
        legendStrings{i,ii} = [varargin{ii}.body{i}];
        a = a + m;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes)  
saveas(figHandle,'Radiation_Damping.png');

end

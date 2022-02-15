function plotRadiationIRF(varargin)
% Plots the radiation IRF for each hydro structure's bodies in
% the heave, surge and pitch degrees of freedom.
% 
% Usage
% -----
% plotRadiationIRF(hydro, hydro2, hydro3, ...)
% 
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure `hydro` created by the other BEMIO
%         functions. One or more may be input.

if isempty(varargin)
    error(['plotRadiationIRF: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotRadiationIRF(hydro1, hydro2, ...)']);
end

figHandle = figure('Position',[50,100,975,521]);
titleString = ['Normalized Radiation Impulse Response Functions: ',...
    '$$\bar{K}_{i,j}(t) = {\frac{2}{\pi}}\int_0^{\infty}{\frac{B_{i,j}(\omega)}{\rho}}\cos({\omega}t)d\omega$$'];
subtitleStrings = {'Surge','Heave','Pitch'};
xString = {'$$t (s)$$','$$t (s)$$','$$t (s)$$'};
yString = {'$$\bar{K}_{1,1}(t)$$','$$\bar{K}_{3,3}(t)$$','$$\bar{K}_{3,3}(t)$$'};

notes = {'Notes:',...
    ['$$\bullet$$ The IRF should tend towards zero within the specified timeframe. ',...
    'If it does not, attempt to correct this by adjusting the $$\omega$$ and ',...
    '$$t$$ range and/or step size used in the IRF calculation.'],...
    ['$$\bullet$$ Only the IRFs for the surge, heave, and pitch DOFs are plotted ',...
    'here. If another DOF is significant to the system, that IRF should also ',...
    'be plotted and verified before proceeding.']};
    
numHydro = length(varargin);
for ii = 1:numHydro
    numBod = varargin{ii}.Nb;
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.ra_t;
    tmp2 = strcat('Y',num2str(ii));
    a = 0;
    i = 1;
    for iBod = 1:numBod
        m = varargin{ii}.dof(iBod);
        Y.(tmp2)(1,i,:) = squeeze(varargin{ii}.ra_K(a+1,a+1,:));
        Y.(tmp2)(2,i,:) = squeeze(varargin{ii}.ra_K(a+3,a+3,:));
        Y.(tmp2)(3,i,:) = squeeze(varargin{ii}.ra_K(a+5,a+5,:));
        legendStrings{i,ii} = [varargin{ii}.body{iBod}];
        i = i+1;
        if isfield(varargin{ii},'ss_A')==1
            Y.(tmp2)(1,i,:) = squeeze(varargin{ii}.ss_K(a+1,a+1,:));
            Y.(tmp2)(2,i,:) = squeeze(varargin{ii}.ss_K(a+3,a+3,:));
            Y.(tmp2)(3,i,:) = squeeze(varargin{ii}.ss_K(a+5,a+5,:));
            legendStrings{i,ii} = [varargin{ii}.body{iBod},' (SS)'];
            i = i+1;
        end
        a = a + m;
    end  
end

FormatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes)  
saveas(figHandle,'Radiation_IRFs.png');

end

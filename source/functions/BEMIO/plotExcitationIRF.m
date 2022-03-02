function plotExcitationIRF(varargin)
% Plots the excitation IRF for each hydro structure's bodies in
% the heave, surge and pitch degrees of freedom.
% 
% Usage
% -----
% plotExcitationIRF(hydro, hydro2, hydro3, ...)
% 
% Parameters
% ----------
%     varargin : struct(s)
%         The hydroData structure `hydro` created by the other BEMIO
%         functions. One or more may be input.

if isempty(varargin)
    error(['plotExcitationIRF: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotExcitationIRF(hydro1, hydro2, ...)']);
end

B=1;  % Wave heading index
figHandle = figure('Position',[950,100,975,521]);
titleString = ['Normalized Excitation Impulse Response Functions:   ',...
    '$$\bar{K}_i(t) = {\frac{1}{2\pi}}\int_{-\infty}^{\infty}{\frac{X_i(\omega,\beta)e^{i{\omega}t}}{{\rho}g}}d\omega$$'];
subtitleStrings = {'Surge','Heave','Pitch'};
xString = {'$$t (s)$$','$$t (s)$$','$$t (s)$$'};
yString = {['$$\bar{K}_1(t,\beta$$',' = ',num2str(varargin{1}.beta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{K}_3(t,\beta$$',' = ',num2str(varargin{1}.beta(B)),'$$^{\circ}$$)'],...
    ['$$\bar{K}_5(t,\beta$$',' = ',num2str(varargin{1}.beta(B)),'$$^{\circ}$$)']};

notes = {'Notes:',...
    ['$$\bullet$$ The IRF should tend towards zero within the specified timeframe. ',...
    'If it does not, attempt to correct this by adjusting the $$\omega$$ and ',...
    '$$t$$ range and/or step size used in the IRF calculation.'],...
    ['$$\bullet$$ Only the IRFs for the first wave heading, surge, heave, and ',...
    'pitch DOFs are plotted here. If another wave heading or DOF is significant ',...
    'to the system, that IRF should also be plotted and verified before proceeding.']};

numHydro = length(varargin);
for ii = 1:numHydro
    numBod = varargin{ii}.Nb;
    tmp1 = strcat('X',num2str(ii));
    X.(tmp1) = varargin{ii}.ex_t;
    tmp2 = strcat('Y',num2str(ii));
    a = 0;
    for i = 1:numBod
        m = varargin{ii}.dof(i);
        Y.(tmp2)(1,i,:) = squeeze(varargin{ii}.ex_K(a+1,B,:));
        Y.(tmp2)(2,i,:) = squeeze(varargin{ii}.ex_K(a+3,B,:));
        Y.(tmp2)(3,i,:) = squeeze(varargin{ii}.ex_K(a+5,B,:));
        legendStrings{i,ii} = [varargin{ii}.body{i}];
        a = a + m;
    end
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes)  
saveas(figHandle,'Excitation_IRFs.png');

end

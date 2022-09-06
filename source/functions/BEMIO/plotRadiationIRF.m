function plotRadiationIRF(dofList, varargin)
% Plots the radiation IRF for each hydro structure's bodies in
% the given degrees of freedom.
% 
% Usage:
% ``plotRadiationIRF([1], hydro, hydro2, hydro3, ...)``
% ``plotRadiationIRF([1 3 5], hydro, hydro2, hydro3, ...)``
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
    error(['plotRadiationIRF: No arguments passed. Include one or more hydro ' ...
        'structures when calling: plotRadiationIRF(hydro1, hydro2, ...)']);
end

dofNames = {'Surge','Sway','Heave','Roll','Pitch','Yaw',...
    'dof7','dof8','dof9','dof10','dof11','dof12'};

figHandle = figure('Position',[50,100,975,521]);
titleString = ['Normalized Radiation Impulse Response Functions: ',...
    '$$\bar{K}_{i,j}(t) = {\frac{2}{\pi}}\int_0^{\infty}{\frac{B_{i,j}(\omega)}{\rho}}\cos({\omega}t)d\omega$$'];
subtitleStrings = dofNames(dofList);
for dof = dofList
    xString{dof} = '$$t (s)$$';
    yString{dof} = ['$$\bar{K}_{',num2str(dof),',',num2str(dof),'}(t)$$'];
end

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
        id = 0;
        for d = dofList
            id = id + 1;
            Y.(tmp2)(id,i,:) = squeeze(varargin{ii}.ra_K(a+d,a+d,:));
        end
        legendStrings{i,ii} = [varargin{ii}.body{iBod}];
        i = i+1;
        if isfield(varargin{ii},'ss_A')==1
            id = 0;
            for d = dofList
                id = id + 1;
                Y.(tmp2)(id,i,:) = squeeze(varargin{ii}.ss_K(a+d,a+d,:));
            end
            legendStrings{i,ii} = [varargin{ii}.body{iBod},' (SS)'];
            i = i+1;
        end
        a = a + m;
    end  
end

formatPlot(figHandle,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes)  
saveas(figHandle,'Radiation_IRFs.png');

end

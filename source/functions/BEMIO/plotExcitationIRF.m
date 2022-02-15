function plotExcitationIRF(hydro,varargin)

    B=1;  % Wave heading index
    clear X Y Legends
    Fig6 = figure('Position',[950,100,975,521]);
    Title = ['Normalized Excitation Impulse Response Functions:   ',...
        '$$\bar{K}_i(t) = {\frac{1}{2\pi}}\int_{-\infty}^{\infty}{\frac{X_i(\omega,\beta)e^{i{\omega}t}}{{\rho}g}}d\omega$$'];
    Subtitles = {'Surge','Heave','Pitch'};
    XLables = {'$$t (s)$$','$$t (s)$$','$$t (s)$$'};
    YLables = {['$$\bar{K}_1(t,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)'],...
        ['$$\bar{K}_3(t,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)'],...
        ['$$\bar{K}_5(t,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)']};
    
    X = hydro.ex_t;
    a = 0;
    for i = 1:hydro.Nb
        m = hydro.dof(i);
        Y(1,i,:) = squeeze(hydro.ex_K(a+1,B,:));
        Y(2,i,:) = squeeze(hydro.ex_K(a+3,B,:));
        Y(3,i,:) = squeeze(hydro.ex_K(a+5,B,:));
        Legends{i,1} = [hydro.body{i}];
        a = a + m;
    end
    
    Notes = {'Notes:',...
        ['$$\bullet$$ The IRF should tend towards zero within the specified timeframe. ',...
        'If it does not, attempt to correct this by adjusting the $$\omega$$ and ',...
        '$$t$$ range and/or step size used in the IRF calculation.'],...
        ['$$\bullet$$ Only the IRFs for the first wave heading, surge, heave, and ',...
        'pitch DOFs are plotted here. If another wave heading or DOF is significant ',...
        'to the system, that IRF should also be plotted and verified before proceeding.']};
    
    if isempty(varargin)
        FormatPlot(Fig6,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes)
    end
    
    numHydro = length(varargin);
    if numHydro>=1
        for ii=1:numHydro
            numBod = varargin{ii}.Nb;
            tmp1 = strcat('X',num2str(ii));
            X1.(tmp1) = varargin{ii}.ex_t;
            tmp2 = strcat('Y',num2str(ii));
            a = 0;
            for i = 1:numBod
                m = varargin{ii}.dof(i);
                Y1.(tmp2)(1,i,:) = squeeze(varargin{ii}.ex_K(a+1,B,:));
                Y1.(tmp2)(2,i,:) = squeeze(varargin{ii}.ex_K(a+3,B,:));
                Y1.(tmp2)(3,i,:) = squeeze(varargin{ii}.ex_K(a+5,B,:));
                Legends{i,1+ii} = [varargin{ii}.body{i}];
                a = a + m;
            end
        end
        FormatPlot(Fig6,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes,X1,Y1)  
    end    
    
    % waitbar(6/6);
    saveas(Fig6,'Excitation_IRFs.png');

end
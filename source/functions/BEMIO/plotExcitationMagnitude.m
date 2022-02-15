function plotExcitationMagnitude(hydro,varargin)

    B=1;  % Wave heading index
    clear X Y Legends
    Fig4 = figure('Position',[950,500,975,521]);
    Title = ['Normalized Excitation Force Magnitude: ',...
        '$$\bar{X_i}(\omega,\beta) = {\frac{X_i(\omega,\beta)}{{\rho}g}}$$'];
    Subtitles = {'Surge','Heave','Pitch'};
    XLables = {'$$\omega (rad/s)$$','$$\omega (rad/s)$$','$$\omega (rad/s)$$'};
    YLables = {['$$\bar{X_1}(\omega,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)'],...
        ['$$\bar{X_3}(\omega,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)'],...
        ['$$\bar{X_5}(\omega,\beta$$',' = ',num2str(hydro.beta(B)),'$$^{\circ}$$)']};
    
    X = hydro.w;
    a = 0;
    for i = 1:hydro.Nb
        m = hydro.dof(i);
        Y(1,i,:) = squeeze(hydro.ex_ma(a+1,B,:));
        Y(2,i,:) = squeeze(hydro.ex_ma(a+3,B,:));
        Y(3,i,:) = squeeze(hydro.ex_ma(a+5,B,:));
        Legends{i,1} = [hydro.body{i}];
        a = a + m;
    end
    
    Notes = {''};
    
    if isempty(varargin)
        FormatPlot(Fig4,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes)
    end
    
    numHydro = length(varargin);
    if numHydro>=1   
        for ii=1:numHydro
            numBod = varargin{ii}.Nb;
            tmp1 = strcat('X',num2str(ii));
            X1.(tmp1) = varargin{ii}.w;
            tmp2 = strcat('Y',num2str(ii));
            a = 0;
            for i = 1:numBod
                m = varargin{ii}.dof(i);
                Y1.(tmp2)(1,i,:) = squeeze(varargin{ii}.ex_ma(a+1,B,:));
                Y1.(tmp2)(2,i,:) = squeeze(varargin{ii}.ex_ma(a+3,B,:));
                Y1.(tmp2)(3,i,:) = squeeze(varargin{ii}.ex_ma(a+5,B,:));
                Legends{i,1+ii} = [varargin{ii}.body{i}];
                a = a + m;
            end
        end
        FormatPlot(Fig4,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes,X1,Y1)  
    end
   
    
%     waitbar(4/6);
    saveas(Fig4,'Excitation_Magnitude.png');

end
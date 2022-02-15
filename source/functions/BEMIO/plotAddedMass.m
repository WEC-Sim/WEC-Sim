function plotAddedMass(hydro,varargin)
    
    clear X Y Legends
    Fig1 = figure('Position',[50,500,975,521]);
    Title = ['Normalized Added Mass: $$\bar{A}_{i,j}(\omega) = {\frac{A_{i,j}(\omega)}{\rho}}$$'];
    Subtitles = {'Surge','Heave','Pitch'};
    XLables = {'$$\omega (rad/s)$$','$$\omega (rad/s)$$','$$\omega (rad/s)$$'};
    YLables = {'$$\bar{A}_{1,1}(\omega)$$','$$\bar{A}_{3,3}(\omega)$$','$$\bar{A}_{5,5}(\omega)$$'};
    
    X = hydro.w;
    a = 0;
    for i = 1:hydro.Nb    
        m = hydro.dof(i);
        Y(1,i,:) = squeeze(hydro.A(a+1,a+1,:));
        Y(2,i,:) = squeeze(hydro.A(a+3,a+3,:));
        Y(3,i,:) = squeeze(hydro.A(a+5,a+5,:));
        Legends{i,1} = [hydro.body{i}];
        a = a + m;
    end
    
    Notes = {'Notes:',...
        ['$$\bullet$$ $$\bar{A}_{i,j}(\omega)$$ should tend towards a constant, ',...
        '$$A_{\infty}$$, within the specified $$\omega$$ range.'],...
        ['$$\bullet$$ Only $$\bar{A}_{i,j}(\omega)$$ for the surge, heave, and ',...
        'pitch DOFs are plotted here. If another DOF is significant to the system, ',...
        'that $$\bar{A}_{i,j}(\omega)$$ should also be plotted and verified before ',...
        'proceeding.']};
    if isempty(varargin)
        FormatPlot(Fig1,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes)
    end
    
    numHydro = length(varargin);
    if numHydro>=1
        if numHydro ==1
            try
                isnumeric(varargin{1}.Nb) == 1;
            catch
                varargin = varargin{1};
                numHydro = length(varargin);
            end
        end
        for ii=1:numHydro
            numBod = varargin{ii}.Nb;
            tmp1 = strcat('X',num2str(ii));
            X1.(tmp1) = varargin{ii}.w;
            tmp2 = strcat('Y',num2str(ii));
            a = 0;            
            for i = 1:numBod    
                m = varargin{ii}.dof(i);
                Y1.(tmp2)(1,i,:) = squeeze(varargin{ii}.A(a+1,a+1,:));
                Y1.(tmp2)(2,i,:) = squeeze(varargin{ii}.A(a+3,a+3,:));
                Y1.(tmp2)(3,i,:) = squeeze(varargin{ii}.A(a+5,a+5,:));
                Legends{i,1+ii} = [varargin{ii}.body{i}];
                a = a + m;
            end
        end
        FormatPlot(Fig1,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes,X1,Y1)    
    end
    
%     waitbar(1/6);
    saveas(Fig1,'Added_Mass.png');

end
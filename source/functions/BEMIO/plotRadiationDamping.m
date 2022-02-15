function plotRadiationDamping(hydro,varargin)
    
    clear X Y Legends
    Fig2 = figure('Position',[50,300,975,521]);
    Title = ['Normalized Radiation Damping: $$\bar{B}_{i,j}(\omega) = {\frac{B_{i,j}(\omega)}{\rho\omega}}$$'];
    Subtitles = {'Surge','Heave','Pitch'};
    XLables = {'$$\omega (rad/s)$$','$$\omega (rad/s)$$','$$\omega (rad/s)$$'};
    YLables = {'$$\bar{B}_{1,1}(\omega)$$','$$\bar{B}_{3,3}(\omega)$$','$$\bar{B}_{5,5}(\omega)$$'};

    X = hydro.w;
    a = 0;
    for i = 1:hydro.Nb
        m = hydro.dof(i);
        Y(1,i,:) = squeeze(hydro.B(a+1,a+1,:));
        Y(2,i,:) = squeeze(hydro.B(a+3,a+3,:));
        Y(3,i,:) = squeeze(hydro.B(a+5,a+5,:));
        Legends{i,1} = [hydro.body{i}];
        a = a + m;
    end

    Notes = {'Notes:',...
        ['$$\bullet$$ $$\bar{B}_{i,j}(\omega)$$ should tend towards zero within ',...
        'the specified $$\omega$$ range.'],...
        ['$$\bullet$$ Only $$\bar{B}_{i,j}(\omega)$$ for the surge, heave, and ',...
        'pitch DOFs are plotted here. If another DOF is significant to the system ',...
        'that $$\bar{B}_{i,j}(\omega)$$ should also be plotted and verified before ',...
        'proceeding.']};

    if isempty(varargin)
        FormatPlot(Fig2,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes)
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
                Y1.(tmp2)(1,i,:) = squeeze(varargin{ii}.B(a+1,a+1,:));
                Y1.(tmp2)(2,i,:) = squeeze(varargin{ii}.B(a+3,a+3,:));
                Y1.(tmp2)(3,i,:) = squeeze(varargin{ii}.B(a+5,a+5,:));
                Legends{i,1+ii} = [varargin{ii}.body{i}];
                a = a + m;
            end
        end
        FormatPlot(Fig2,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes,X1,Y1)  
    end
   
    % waitbar(2/6);
    saveas(Fig2,'Radiation_Damping.png');

end
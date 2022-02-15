function plotRadiationIRF(hydro,varargin)

    clear X Y Legends
    Fig3 = figure('Position',[50,100,975,521]);
    Title = ['Normalized Radiation Impulse Response Functions: ',...
        '$$\bar{K}_{i,j}(t) = {\frac{2}{\pi}}\int_0^{\infty}{\frac{B_{i,j}(\omega)}{\rho}}\cos({\omega}t)d\omega$$'];
    Subtitles = {'Surge','Heave','Pitch'};
    XLables = {'$$t (s)$$','$$t (s)$$','$$t (s)$$'};
    YLables = {'$$\bar{K}_{1,1}(t)$$','$$\bar{K}_{3,3}(t)$$','$$\bar{K}_{3,3}(t)$$'};
    
    X = hydro.ra_t;
    a = 0;
    for i = 1:hydro.Nb
        m = hydro.dof(i);
        Y(1,i,:) = squeeze(hydro.ra_K(a+1,a+1,:));
        Y(2,i,:) = squeeze(hydro.ra_K(a+3,a+3,:));
        Y(3,i,:) = squeeze(hydro.ra_K(a+5,a+5,:));
        Legends{i,1} = [hydro.body{i}];
        if isfield(hydro,'ss_A')==1
            Y(1,i,:) = squeeze(hydro.ss_K(a+1,a+1,:));
            Y(2,i,:) = squeeze(hydro.ss_K(a+3,a+3,:));
            Y(3,i,:) = squeeze(hydro.ss_K(a+5,a+5,:));
            Legends{i,1} = [hydro.body{i},' (SS)'];        
        end
        a = a + m;
    end
    
    Notes = {'Notes:',...
        ['$$\bullet$$ The IRF should tend towards zero within the specified timeframe. ',...
        'If it does not, attempt to correct this by adjusting the $$\omega$$ and ',...
        '$$t$$ range and/or step size used in the IRF calculation.'],...
        ['$$\bullet$$ Only the IRFs for the surge, heave, and pitch DOFs are plotted ',...
        'here. If another DOF is significant to the system, that IRF should also ',...
        'be plotted and verified before proceeding.']};
    
    if isempty(varargin)
        FormatPlot(Fig3,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes)
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
            X1.(tmp1) = varargin{ii}.ra_t;
            tmp2 = strcat('Y',num2str(ii));
            a = 0;    
            for i = 1:numBod
                m = varargin{ii}.dof(i);
                Y1.(tmp2)(1,i,:) = squeeze(varargin{ii}.ra_K(a+1,a+1,:));
                Y1.(tmp2)(2,i,:) = squeeze(varargin{ii}.ra_K(a+3,a+3,:));
                Y1.(tmp2)(3,i,:) = squeeze(varargin{ii}.ra_K(a+5,a+5,:));
                Legends{i,1+ii} = [varargin{ii}.body{i}];                
                if isfield(varargin{ii},'ss_A')==1
                    Y1.(tmp2)(1,i,:) = squeeze(varargin{ii}.ss_K(a+1,a+1,:));
                    Y1.(tmp2)(2,i,:) = squeeze(varargin{ii}.ss_K(a+3,a+3,:));
                    Y1.(tmp2)(3,i,:) = squeeze(varargin{ii}.ss_K(a+5,a+5,:));
                    Legends{i,1+ii} = [hydro.body{i},' (SS)'];    
                end
                a = a + m;
            end  
       end
        FormatPlot(Fig3,Title,Subtitles,XLables,YLables,X,Y,Legends,Notes,X1,Y1)  
    end
    
%     waitbar(3/6);
saveas(Fig3,'Radiation_IRFs.png');

end
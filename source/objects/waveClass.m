%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Renewable Energy Laboratory and National 
% Technology & Engineering Solutions of Sandia, LLC (NTESS). 
% Under the terms of Contract DE-NA0003525 with NTESS, 
% the U.S. Government retains certain rights in this software.
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
% http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef waveClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The  ``waveClass`` creates a ``waves`` object saved to the MATLAB
    % workspace. The ``waveClass`` includes properties and methods used
    % to define WEC-Sim's wave input. 
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetAccess = 'public', GetAccess = 'public')%input file     
        T = 'NOT DEFINED';      % (`float`) Wave period [s] . Defined as wave period for ``regular``, peak period for ``irregular``, or period of BEM data used for hydrodynamic coefficients for ``noWave``. Default = ``'NOT DEFINED'``
        H = 'NOT DEFINED';      % (`float`) Wave height [m]. Defined as wave height for ``regular``, or significant wave height for ``irregular``. Default =  ``'NOT DEFINED'``
        bem         = struct(...   	% (`structure`) Defines the BEM data implemtation. 
            'option',	'EqualEnergy',...   % 
            'count',	[], ...             %             
            'range',	[])                 % (`structure`) Defines the BEM data implemtation. ``option`` % (`string`) Method of frequency discretization for irregular waves, options include: ``'EqualEnergy'`` or ``'Traditional'``. Default = ``'EqualEnergy'``. ``count`` (`integer`) Number of interpolated wave frequencies, only used for ``irregular`` and ``spectrumImport``. Number of frequencies used varies depending on ``bem.option``, 1000 for ``'Traditional'``, and 500 for ``'EqualEnergy'`` and ``Imported``. Default = ``[]``. ``range`` (`2x1 vector`) Min and max wave frequency [rad/s], only used for ``irregular`` and ``spectrumImport``. If not specified, the BEM data frequency range is used. Default = ``[]``     
        current     = struct(...   	% (`structure`) Defines the current implementation. 
            'option',	3,...       %
            'depth',	0, ...      %
            'direction',0, ...      %
            'speed',	0)      % (`structure`) Defines the current implementation. ``option`` (`integer`) Define the sub-surface current model to be used in WEC-Sim, options include: ``0`` for depth-independent model, ``1`` for 1/7 power law variation with depth, ``2`` for linear variation with depth, or ``3`` for no current. Default = ``3``, ``depth`` (`float`) Current depth [m]. Define the depth over which the sub-surface current is modeled. Must be defined for options ``1`` and ``2``. The current is not calculated for any depths greater than the specified current depth. Default = ``0``, ``direction`` (`float`) Current direction [deg]. Surface current direction defined using WEC-Sim global coordinate system. Default = ``0``, ``speed``  (`float`) Current seed [m/s]. Surface current speed that is uniform along the water column. Default = ``0``         
        direction = 0;          % (`float`) Incident wave direction(s) [deg]. Incident wave direction defined using WEC-Sim global coordinate system. Should be defined as a column vector for more than one wave direction. Default = ``0``
        elevationFile = 'NOT DEFINED';  % (`string`) Data file that contains the times-series data file. Default = ``'NOT DEFINED'``
        gamma = [];             % (`float`) Defines gamma, only used for ``JS`` wave spectrum type. Default = ``[]``
        markerLoc       = [];   % (`nx2 vector`) Marker [X,Y] locations [m]. Default = ``[]``
        markerSize      = 10;   % (`float`) Marker size in Pixels. Default = ``10``
        markerStyle     = 1;    % (`integer`) Marker style, options include: ``1``: Sphere, ``2``: Cube, ``3``: Frame. Default = ``1``: Sphere
        phaseSeed = 0;          % (`integer`) Defines the random phase seed, only used for ``irregular`` and ``spectrumImport`` waves. Default = ``0``
        spectrumFile = 'NOT DEFINED';   % (`string`) Data file that contains the spectrum data file.  Default = ``'NOT DEFINED'``                
        spectrumType = 'NOT DEFINED';  % (`string`) Specifies the wave spectrum type, options inlcude:``PM`` or ``JS``. Default = ``'NOT DEFINED'``
        type = 'NOT DEFINED';   % (`string`) Specifies the wave type, options include:``noWave``, ``noWaveCIC``, ``regular``, ``regularCIC``, ``irregular``, ``spectrumImport``, or ``elevationImport``. Default = ``'NOT DEFINED'``
        viz = struct( 'numPointsX', 50, ...
                      'numPointsY', 50 ); % (`structure`) Defines visualization options, structure contains the fields ``numPointsX`` for the number of visualization points in x direction, and ``numPointsY`` for the number of visualization points in y direction. 
        waterDepth = [];        % (`float`) Water depth [m]. Default to BEM water depth if not set. 
        spread = 1;             % (`float`) Wave Spread probability associated with wave direction(s). Should be defined as a column vector for more than one wave direction. Default = ``1``
        wavegauge1loc = [NaN,NaN];      % (`1x2 vector`) Wave gauge 1 [x,y] location [m]. Default = ``[NaN,NaN]``
        wavegauge2loc = [NaN,NaN];      % (`1x2 vector`) Wave gauge 2 [x,y] location [m]. Default = ``[NaN,NaN]``
        wavegauge3loc = [NaN,NaN];      % (`1x2 vector`) Wave gauge 3 [x,y] location [m]. Default = ``[NaN,NaN]``        
    end    
  
    properties (SetAccess = 'private', GetAccess = 'public')%internal       
        % The following properties are private, for internal use by WEC-Sim
        A = [];                 % Wave amplitude [m]. For regular waves or 2*(wave spectrum vector) for irregular waves
        S = [];                 % Wave Spectrum [m^2-s/rad] for ``Traditional``
        Pw = [];                % Wave Power Per Unit Wave Crest [W/m]        
        bemFreq = [];           % Number of wave frequencies from BEM
        deepWaterWave = [];     % Deep water or not, depending on input from WAMIT, NEMOH and AQWA
        dw = 0;                 % Frequency spacing [rad] for ``irregular`` waves.
        k = [];                 % Wave Number
        phase = 0;              % Wave phase [rad] . Only used for ``irregular`` waves.
        typeNum = [];           % Number to represent different type of waves        
        w = [];                 % Wave frequency (regular waves) or wave frequency vector (irregular waves) [rad/s] 
        waveAmpTime = [];       % Wave elevation time history [m] 
        waveAmpTime1 = [];      % Wave elevation time history at a wave gauge 1 location specified by user [m] 
        waveAmpTime2 = [];      % Wave elevation time history at a wave gauge 2 location specified by user [m] 
        waveAmpTime3 = [];      % Wave elevation time history at a wave gauge 3 location specified by user [m] 
        waveAmpTimeViz = [];    % Wave elevation time history at marker locations specified by user [m]         
    end
    
    methods (Access = 'public')
        function obj = waveClass(type)
            % This method initilizes the ``waveClass`` and creates a ``waves`` object.          
            %
            % Parameters
            % ------------
            %     type : string
            %         String specifying the wave type, options include:
            %
            %           noWave 
            %               No waves      
            % 
            %           noWaveCIC  
            %               No waves but with the Convolution Integral Calculation to calculate radiation effects   
            % 
            %           regular 
            %               Regular waves
            % 
            %           regularCIC 
            %               Regular waves with Convolution Integral Calculation to calculate radiation effects
            % 
            %           irregular  
            %           	Irregular Waves
            % 
            %           spectrumImport 
            %           	Irregular Waves with predefined phase
            % 
            %           elevationImport 
            %               Irregular Waves with predefined elevation
            %
            % Returns
            % ------------
            %     waves : obj
            %         waveClass object         
            %

            obj.type = type;
            switch obj.type
                case {'noWave'}         % No Waves with Constant Hydrodynamic Coefficients
                    obj.typeNum = 0;
                case {'noWaveCIC'}      % No Waves w/Convolution Integral Calculation
                    obj.typeNum = 1;
                case {'regular'}        % Regular Waves with Constant Hydrodynamic Coefficients
                    obj.typeNum = 10;
                case {'regularCIC'}     % Regular Waves w/Convolution Integral Calculation
                    obj.typeNum = 11;
                case 'irregular'        % Irregular Waves with 'PM' or 'JS' wave spectrum
                    obj.typeNum = 20;
                case 'spectrumImport'   % Irregular waves with imported wave spectrum
                    obj.typeNum = 21;
                case 'elevationImport'        % Waves with imported wave elevation time-history
                    obj.typeNum = 30;
            end
        end
        
        function checkinputs(obj)
            % This method checks WEC-Sim user inputs and generates error
            % messages if parameters are not properly defined. 
            
           
            % check waves types
            types = {'noWave', 'noWaveCIC', 'regular', 'regularCIC', 'irregular', 'spectrumImport', 'elevationImport'};
            if sum(strcmp(types,obj.type)) ~= 1
                error(['Unexpected wave environment type setting, choose from: ' ...
                    '"noWave", "noWaveCIC", "regular", "regularCIC", "irregular", "spectrumImport", and "elevationImport".'])
            end
            % 'noWave' period undefined for hydro data
            if strcmp(obj.type,'noWave')
                if strcmp(obj.T,'NOT DEFINED')
                    error('"waves.T" must be defined for the hydrodynamic data period when using the "noWave" wave type');
                end
            end
            % check 'waves.bem' fields
            if length(fieldnames(obj.bem)) ~=3
                error(['Unrecognized method, property, or field for class "waveClass", ' ... 
                    '"waveClass.bem" structure must only include fields: "option", "count", "range"']);
            end
            % check 'waves.current' fields
            if length(fieldnames(obj.current)) ~=4
                error(['Unrecognized method, property, or field for class "waveClass", ' ... 
                    '"waveClass.current" structure must only include fields: "option", "depth", "direction", "speed"']);
            end            
            % 'elevationFile' defined for 'elevationImport' case
            if strcmp(obj.type,'elevationImport')
                if strcmp(obj.spectrumFile,'NOT DEFINED')
                    error('"elevationFile" must be defined when using the "elevationImport" wave type');
                end
            end            
            % 'spectrumFile' defined for 'spectrumImport' case
            if strcmp(obj.type,'spectrumImport')
                if strcmp(obj.spectrumFile,'NOT DEFINED')
                    error('"spectrumFile" must be defined when using the "spectrumImport" wave type');
                end
            end
            % check 'markerLoc'
            if ~isempty(obj.markerLoc)
                if ~ndims(obj.markerLoc)==2
                    error('The coordinates of the visualization markers should have an ordinate (y-coordinate) and an abscissa (x-coordinate)')
                end
            end                        
        end

        function listInfo(obj)
            % This method prints wave information to the MATLAB Command Window.
            %             
            fprintf('\nWave Environment: \n')
            switch obj.type
                case 'noWave'
                    fprintf('\tWave Type                            = No Wave (Constant Hydrodynamic Coefficients)\n')
                    fprintf('\tHydro Data Wave Period, T (sec)    	= %G\n',obj.T)
                case 'regular'
                    fprintf('\tWave Type                            = Regular Waves (Constant Hydrodynamic Coefficients)\n')
                    fprintf('\tWave Height, H (m)                   = %G\n',obj.H)
                    fprintf('\tWave Period, T (sec)                 = %G\n',obj.T)
                case 'noWaveCIC'
                    fprintf('\tWave Type                            = No Wave (Convolution Integral Calculation)\n')
                case 'regularCIC'
                    fprintf('\tWave Type                            = Regular Waves (Convolution Integral Calculation)\n')
                    fprintf('\tWave Height, H (m)                   = %G\n',obj.H)
                    fprintf('\tWave Period, T (sec)                 = %G\n',obj.T)
                case 'irregular'
                    if obj.phaseSeed == 0
                        fprintf('\tWave Type                            = Irregular Waves (Arbitrary Random Phase)\n')
                    else
                        fprintf('\tWave Type                            = Irregular Waves (Predefined Random Phase)\n')
                    end
                    obj.printWaveSpectrumType;
                    fprintf('\tSignificant Wave Height, Hs      (m) = %G\n',obj.H)
                    fprintf('\tPeak Wave Period, Tp           (sec) = %G\n',obj.T)
                case 'spectrumImport'
                    if size(importdata(obj.spectrumFile),2) == 3
                        fprintf('\tWave Type                            = Irregular waves with imported wave spectrum (Imported Phase)\n')
                    elseif obj.phaseSeed == 0
                        fprintf('\tWave Type                            = Irregular waves with imported wave spectrum (Random Phase)\n')
                    else
                        fprintf('\tWave Type                            = Irregular waves with imported wave spectrum (Seeded Phase)\n')
                    end
                    obj.printWaveSpectrumType;
                case 'elevationImport'
                    fprintf( '\tWave Type                           = Waves with imported wave elevation time-history\n')
                    fprintf(['\tWave Elevation Time-Series File    	= ' obj.elevationFile '  \n'])
            end
        end
                
        function waveSetup(obj,bemFreq,bemWaterDepth,rampTime,dt,maxIt,time,g,rho)
            % This method calculates WEC-Sim's wave properties 
            % based on the specified wave type.
            %
            
            if ~isempty(obj.markerLoc)==1
                if ~width(obj.markerLoc)==2
                    error('The coordinates of the visualization markers should have an ordinate (y-coordinate) and an abscissa (x-coordinate)')
                end
            end
            
            obj.bemFreq = bemFreq;
            if isempty(obj.bem.range) && isempty(obj.bemFreq)
                % No .h5 file and no freq range defined --> error
                error('Must define frequency range in waves.bem.range when zero hydro bodies are used (no .h5 file).');
            elseif isempty(obj.bem.range) && ~isempty(obj.bemFreq)
                % Use .h5 file range if not defined in input file
                obj.bem.range = obj.bemFreq;
            elseif ~isempty(obj.bem.range) && ~isempty(obj.bemFreq)
                % check that input file freq range is not larger than
                % available BEM data
                if obj.bem.range(1) < min(obj.bemFreq) || obj.bem.range(1) > max(obj.bemFreq)
                    warning('Min frequency range outside BEM data, min frequency set to min BEM frequency')
                    obj.bem.range(1) = min(obj.bemFreq);
                end
                if obj.bem.range(2) < min(obj.bemFreq) || obj.bem.range(2) > max(obj.bemFreq)
                    warning('Max frequency range outside BEM data, max frequency set to max BEM frequency')
                    obj.bem.range(2) = max(obj.bemFreq);
                end
            end
            
            obj.setWaterDepth(bemWaterDepth);
            
            switch obj.type
                case {'noWave','noWaveCIC'}
                    if isempty(obj.w) && strcmp(obj.T,'NOT DEFINED')
                        obj.w = min(obj.bem.range);
                        obj.T = 2*pi/obj.w;
                    elseif isempty(obj.w)
                        obj.w = 2*pi/obj.T;
                    else
                        obj.T = 2*pi/obj.w;
                    end
                    obj.H = 0;
                    obj.A = obj.H/2;
                    obj.k = waveNumber(obj.w,obj.waterDepth,g,obj.deepWaterWave);
                    obj.waveElevNowave(time);
                case {'regular','regularCIC'}
                    if isempty(obj.w) && strcmp(obj.T,'NOT DEFINED')
                        obj.w = min(obj.bem.range);
                        obj.T = 2*pi/obj.w;
                    elseif isempty(obj.w)
                        obj.w = 2*pi/obj.T;
                    else
                        obj.T = 2*pi/obj.w;
                    end
                    obj.A = obj.H/2;
                    obj.k = waveNumber(obj.w,obj.waterDepth,g,obj.deepWaterWave);
                    obj.waveElevReg(rampTime, time);
                    obj.wavePowerReg(g,rho);
                case {'irregular','spectrumImport'}
                    if strcmp(obj.type,'spectrumImport')
                        obj.H = 0;
                        obj.T = 0;
                        obj.bem.option = 'Imported';
                        obj.spectrumType = 'spectrumImport';
                    end                    
                    WFQSt=min(obj.bem.range);
                    WFQEd=max(obj.bem.range);                    
                    switch obj.bem.option
                        case {'Traditional'}
                            if isempty(obj.bem.count)
                                obj.bem.count = 1000;
                            end
                            obj.w = (WFQSt:(WFQEd-WFQSt)/(obj.bem.count-1):WFQEd)';
                            obj.dw= ones(obj.bem.count,1).*(WFQEd-WFQSt)./(obj.bem.count-1);
                        case {'EqualEnergy'}
                            bemCount_interp = 500000;
                            obj.w = (WFQSt:(WFQEd-WFQSt)/bemCount_interp:WFQEd)';
                            obj.dw = mean(diff(obj.w));
                            if isempty(obj.bem.count)
                                obj.bem.count = 500;
                            end
                        case {'Imported'}
                            data = importdata(obj.spectrumFile);
                            freq_data = data(:,1);
                            freq_loc = freq_data >= min(obj.bem.range)/2/pi & freq_data <= max(obj.bem.range)/2/pi;
                            obj.w    = freq_data(freq_loc).*2.*pi;
                            obj.bem.count = length(obj.w);
                            obj.dw(1,1)= obj.w(2)-obj.w(1);
                            obj.dw(2:obj.bem.count-1,1)=(obj.w(3:end)-obj.w(1:end-2))/2;
                            obj.dw(obj.bem.count,1)= obj.w(end)-obj.w(end-1);
                    end
                    obj.setWavePhase;
                    obj.irregWaveSpectrum(g,rho)
                    obj.k = waveNumber(obj.w,obj.waterDepth,g,obj.deepWaterWave);
                    obj.waveElevIrreg(rampTime, time, obj.dw);
                case {'elevationImport'}    %  This does not account for wave direction
                    % Import 'elevationImport' time-series here and interpolate
                    data = importdata(obj.elevationFile) ;    % Import time-series
                    obj.waveElevUser(rampTime, dt, maxIt, data, time);
            end
        end

        function calculateElevation(obj,rampTime,timeseries)
            % Calculates the wave elevation based on the wave type.
            % Used by postProcess.m
            %
            % Parameters
            % ------------
            %     waves : obj
            %         waveClass object
            %
            %     rampTime : float
            %         ramp time from the simulation class
            %
            %     timeseries : float array
            %         Array of all simulation output time steps
            %
            switch obj.type
                case {'noWave','noWaveCIC'}                    
                    obj.waveElevNowave(timeseries);

                case {'regular','regularCIC'}
                    obj.waveElevReg(rampTime, timeseries);

                case {'irregular','spectrumImport'}
                    obj.waveElevIrreg(rampTime, timeseries, obj.dw);

                case {'elevationImport'}
                    % Wave elevation is a necessary pre-processing step for
                    % the eta import case.
                    % Used by waveClass.waveSetup()
            end
        end                
        
        function waveNumber(obj,g)
            % This method calculates the wave number, 
            % used by: :meth:`waveClass.waveSetup`.
            % 
            obj.k = obj.w.^2./g;
            if obj.deepWaterWave == 0
                for i=1:100
                    obj.k = obj.w.^2./g./tanh(obj.k.*obj.waterDepth);
                end
            end
        end
                
        function Z = waveElevationGrid(obj, t, X, Y, TimeBodyParav, it, g)
            % This method calculates wave elevation on a grid at a given
            % time, used by: :func:`write_paraview_wave`.
            %             
            % Parameters
            % ------------
            %     waves: obj
            %         waveClass object
            %
            %     t : float
            %         the current time
            %
            %     X : matrix
            %         (m x n) matrix of X coordinates at which to calculate the wave elevation
            %
            %     Y : matrix
            %         (m x n) matrix of Y coordinates at which to calculate the wave elevation
            %
            %     TimeBodyParav : float array
            %         Time vector starting from zero specified for paraview
            %         video files.
            %     
            %     it : time step iteration
            %
            %     g : gravitational acceleration constant from simulationClass
            %
            %
            % Returns
            % ---------
            %     Z : matrix
            %         (m x n) matrix of Z coordinates of the wave elevation            
            %
            switch obj.type                
                case {'noWave','noWaveCIC'}                    
                    Z = zeros (size (X));                    
                case {'regular', 'regularCIC'}                    
                    Xt = X*cos (obj.direction*pi/180) + Y * sin(obj.direction*pi/180);                    
                    Z = obj.A * cos(-1 * obj.k * Xt  +  obj.w * t);                    
                case {'irregular', 'spectrumImport'}
                    Z = zeros (size (X));
                    for idir=1:length(obj.direction)
                        Xt = X*cos(obj.direction(idir)*pi/180) + Y*sin(obj.direction(idir)*pi/180);
                        for iw = 1:length(obj.w)
                            Z = Z + sqrt(obj.A(iw)*obj.spread(idir).*obj.dw(iw)) * cos(-1*obj.k(iw)*Xt + obj.w(iw)*t + obj.phase(iw,idir));
                        end
                    end
                case{'elevationImport'}
                    if it ==1
                        warning('Paraview wave surface discretization for qualitative purposes only.')
                    end
                    Z = zeros(size(X));
                    WaveEle = obj.waveAmpTime(:,2);
                    TimeWaveEle = obj.waveAmpTime(:,1);
                    %WaveEle = interp1(TimeWaveEle,WaveEle,t(1)+TimeBodyParav);
                    %TimeWaveEle = t(1)+TimeBodyParav;
                    L = length(TimeWaveEle);
                    T = TimeWaveEle(2)-TimeWaveEle(1);
                    Fs = 1/T;
                    YY = fft(WaveEle);
                    P2 = abs(YY/L);
                    P1 = P2(1:round(L/2)+1);
                    P1(2:end-1) = 2*P1(2:end-1);
                    ff = Fs*(0:round(L/2))/L;
                    PhasesEtaImp2 = angle(YY/L);
                    PhasesEtaImp1 = PhasesEtaImp2(1:round(L/2)+1);
                    kWaveEle = (2*pi.*ff).^2./g; % deep water wave approximation
                    Xt = X*cos(obj.direction*pi/180) + Y*sin(obj.direction*pi/180);
                    [~,ix0] = min(abs(Xt(1,:)));
                    Zint=zeros(size(X));
                    for iw = 2:length(ff)
                        Zint = Zint + P1(iw) * cos(-1*kWaveEle(iw)*Xt + 2*pi*ff(iw).*t+ PhasesEtaImp1(iw));
                    end
                    Z = Zint;
            end            
        end
        
        function plotElevation(obj,rampTime)
            % This method plots wave elevation time-history.
            %
            % Parameters
            % ------------
            %     rampTime : float, optional
            %         Specify wave ramp time to include in plot    
            %
            % Returns
            % ------------
            %     figure : fig
            %         Plot of wave elevation versus time  
            %            
            figure
            plot(obj.waveAmpTime(:,1),obj.waveAmpTime(:,2))
            title('Wave Surfave Elevation')
            if nargin==2
                hold on
                line([rampTime,rampTime],[1.5*min(obj.waveAmpTime(:,2)),1.5*max(obj.waveAmpTime(:,2))],'Color','k')
                title(['Wave Surface Elevation, Ramp Time ' num2str(rampTime) ' (s)'])
            end
            xlabel('Time (s)')
            ylabel('Elevation (m)')
        end
        
        function plotSpectrum(obj)
            % This method plots the wave spectrum.
            %
            % Returns
            % ------------
            %     figure : fig
            %         Plot of wave spectrum versus wave frequency
            %                 
            m0 = trapz(obj.w,obj.S);
            HsTest = 4*sqrt(m0);
            [~,I] = max(abs(obj.S));
            wp = obj.w(I);
            TpTest = 2*pi/wp;
            
            figure
            plot(obj.w,obj.S,'s-')
            hold on
            line([wp,wp],[0,max(obj.S)],'Color','k')
            xlim([0 max(obj.w)])
            title([obj.spectrumType, ' Spectrum, T_p= ' num2str(TpTest) ' [s], '  'H_m_0= ' num2str(HsTest), ' [m]'])
            if strcmp(obj.spectrumType,'JS') == 1
                title([obj.spectrumType, ' Spectrum, T_p= ' num2str(TpTest) ' [s], H_m_0= ' num2str(HsTest), ' [m], gamma = ' num2str(obj.gamma)])
            end
            xlabel('Frequency (rad/s)')
            ylabel('Spectrum (m^2-s/rad)');
        end
    
    end
    
    methods (Access = 'protected')
        function setWavePhase(obj)
            % Sets the irregular wave's random phase
            % Used by waveSetup
            if obj.phaseSeed ~= 0
                rng(obj.phaseSeed); % Phase seed = 1,2,3,...,etc
            else
                rng('shuffle');         % Phase seed shuffled
            end
            switch obj.bem.option
                case {'EqualEnergy','Traditional'}
                    obj.phase = 2*pi*rand(length(obj.direction),obj.bem.count);
                case {'Imported'}
                    data = importdata(obj.spectrumFile);
                    if size(data,2) == 3
                        freq_data = data(:,1);
                        freq_loc = freq_data>=min(obj.bem.range)/2/pi & freq_data<=max(obj.bem.range)/2/pi;
                        phase_data = data(freq_loc,3);
                        obj.phase = phase_data';
                    else
                        obj.phase = 2*pi*rand(1,obj.bem.count);
                    end
            end
            obj.phase = obj.phase';
        end
        
        function setWaterDepth(obj,bemWaterDepth)
            % Set the water depth. If defined in input file, BEM depth is
            % not used. Used by waveSetup
            if isempty(obj.waterDepth)
                if isempty(bemWaterDepth)
                    error('Must define water depth in waves.waterDepth when zero hydro bodies (no .h5 file).');
                elseif strcmp(bemWaterDepth,'infinite')
                    obj.deepWaterWave = 1;
                    obj.waterDepth = 200;
                    fprintf('\tInfinite water depth specified in BEM and "waves.waterDepth" not specified in input file.\n')
                    fprintf('Set water depth to 200m for visualization.\n')
                else
                    obj.deepWaterWave = 0;
                    obj.waterDepth = double(bemWaterDepth);
                end
            end
        end
        
        function waveElevNowave(obj,timeseries)
            % Set noWave elevation time-history
            % Used by waveSetup                    
            % Used by postProcess for variable step solvers
            obj.waveAmpTime         = zeros(length(timeseries),2);
            obj.waveAmpTime(:,1)    = timeseries;
            
            if ~isempty(obj.markerLoc)
                SZwaveAmpTimeViz = size(obj.markerLoc);
                obj.waveAmpTimeViz = zeros(length(timeseries),SZwaveAmpTimeViz(1)+1);
                obj.waveAmpTimeViz(:,1) = timeseries;
            end
        end
        
        function waveElevReg(obj,rampTime,timeseries)
            % Calculate regular wave elevation time history
            % Used by waveSetup                    
            % Used by postProcess for variable step solvers
            maxIt = length(timeseries);
            rampFunction = (1+cos(pi+pi*timeseries/rampTime))/2;
            rampFunction(timeseries>rampTime) = 1;

            obj.waveAmpTime = zeros(maxIt,2);
            obj.waveAmpTime(:,1) = timeseries;
            obj.waveAmpTime(:,2) = rampFunction.*(obj.A*cos(obj.w*timeseries));

            % Wave Gauges
            if ~any(isnan(obj.wavegauge1loc))
                obj.waveAmpTime1 = zeros(maxIt,2);
                obj.waveAmpTime1(:,1) = timeseries;
                obj.waveAmpTime1(:,2) = rampFunction.*obj.A.*cos(obj.w*timeseries - obj.k*(obj.wavegauge1loc(1).*cos(obj.direction*pi/180) + obj.wavegauge1loc(2).*sin(obj.direction*pi/180)));
            end
            if ~any(isnan(obj.wavegauge2loc))
                obj.waveAmpTime2 = zeros(maxIt,2);
                obj.waveAmpTime2(:,1) = timeseries;
                obj.waveAmpTime2(:,2) = rampFunction.*obj.A.*cos(obj.w*timeseries - obj.k*(obj.wavegauge2loc(1).*cos(obj.direction*pi/180) + obj.wavegauge2loc(2).*sin(obj.direction*pi/180)));
            end
            if ~any(isnan(obj.wavegauge3loc))
                obj.waveAmpTime3 = zeros(maxIt,2);
                obj.waveAmpTime3(:,1) = timeseries;
                obj.waveAmpTime3(:,2) = rampFunction.*obj.A.*cos(obj.w*timeseries - obj.k*(obj.wavegauge3loc(1).*cos(obj.direction*pi/180) + obj.wavegauge3loc(2).*sin(obj.direction*pi/180)));
            end
            
            % Wave Marker
            if ~isempty(obj.markerLoc)==1
                if width(obj.markerLoc)~=2
                    error('The coordinates of the visualization markers should have an ordinate (y-coordinate) and an abscissa (x-coordinate)')
                end
            end                
            if ~isempty(obj.markerLoc)
                SZwaveAmpTimeViz = size(obj.markerLoc);
                obj.waveAmpTimeViz = zeros(maxIt,SZwaveAmpTimeViz(1)+1);
                for j = 1:SZwaveAmpTimeViz(1)
                    obj.waveAmpTimeViz(:,1) = timeseries;
                    obj.waveAmpTimeViz(:,j+1) = rampFunction.*obj.A.*cos(obj.w*timeseries - obj.k*(obj.markerLoc(j,1).*cos(obj.direction*pi/180) + obj.markerLoc(j,2).*sin(obj.direction*pi/180)));                   
                end
            end          
        end        
        
        function wavePowerReg(obj,g,rho)
            % Calculate wave power per unit wave crest for regular waves
            if obj.deepWaterWave == 1
                % Deepwater Approximation
                obj.Pw = 1/(8*pi)*rho*g^(2)*(obj.A).^(2).*obj.T;               
            else
                % Full Wave Power Equation
                obj.Pw = rho*g*(obj.A).^(2)/4*sqrt(g./obj.k.*tanh(obj.k.*obj.waterDepth))*(1+2*obj.k.*obj.waterDepth./sinh(obj.k.*obj.waterDepth));
            end
        end
        
        function irregWaveSpectrum(obj,g,rho)
            % Calculate wave spectrum vector (obj.A)
            % Used by wavesIrreg (wavesIrreg used by waveSetup)            
            freq = obj.w/(2*pi);
            Tp = obj.T;
            Hs = obj.H;
            switch obj.spectrumType
                case {'PM','JS'} 
                    % Pierson-Moskowitz Spectrum from IEC TS 62600-2 ED2 Annex C.2 (2019)
                    B_PM = (5/4)*(1/Tp)^(4);
                    A_PM =  B_PM*(Hs/2)^2;
                    S_f  = (A_PM*freq.^(-5).*exp(-B_PM*freq.^(-4)));            % Wave Spectrum [m^2-s] for 'EqualEnergy'
                    if strcmp(obj.spectrumType,'JS')
                        % JONSWAP Spectrum from IEC TS 62600-2 ED2 Annex C.2 (2019)
                        fp = 1/Tp;
                        siga = 0.07;sigb = 0.09;                                    % cutoff frequencies for gamma function
                        [lind,~] = find(freq<=fp);
                        [hind,~] = find(freq>fp);
                        gammaAlpha = zeros(size(freq));
                        if isempty(obj.gamma)
                            TpsqrtHs = Tp/sqrt(Hs);
                            if TpsqrtHs <= 3.6
                                obj.gamma = 5;
                            elseif TpsqrtHs > 5
                                obj.gamma = 1;
                            else
                                obj.gamma = exp(5.75 - 1.15*TpsqrtHs);
                            end
                        end
                        gammaAlpha(lind) = obj.gamma.^exp(-(freq(lind)-fp).^2/(2*siga^2*fp^2));
                        gammaAlpha(hind) = obj.gamma.^exp(-(freq(hind)-fp).^2/(2*sigb^2*fp^2));
                        C = 1 - 0.287*log(obj.gamma);
                        S_f = C*S_f.*gammaAlpha;                                % Wave Spectrum [m^2-s]
                    end
                    obj.S = S_f./(2*pi);                                       % Wave Spectrum [m^2-s/rad]
                case 'spectrumImport' % Imported Wave Spectrum
                    data = importdata(obj.spectrumFile);
                    freq_data = data(:,1);
                    S_data = data(:,2);
                    freq_loc = freq_data >= min(obj.bem.range)/2/pi & freq_data <= max(obj.bem.range)/2/pi;
                    S_f = S_data(freq_loc);                                    % Wave Spectrum [m^2-s] for 'EqualEnergy'
                    obj.S = S_f./(2*pi);                                       % Wave Spectrum [m^2-s/rad] for 'Traditional'
                    fprintf('\t"spectrumImport" uses the number of imported wave frequencies (not "Traditional" or "EqualEnergy")\n')
                case {'BS'} 
                    error('Following IEC Standard, our Bretschneider Sprectrum (BS) option is exactly how the Pierson-Moskowitz (PM) Spectrum is defined. Please use PM instead');
            end
            % Power per Unit Wave Crest
            obj.k = waveNumber(obj.w,obj.waterDepth,g,obj.deepWaterWave); %Calculate Wave Number for Larger Number of Frequencies Before Down Sampling in Equal Energy Method
            if obj.deepWaterWave == 1
                % Deepwater Approximation
                obj.Pw = sum(1/2*rho*g^(2)*S_f/(2*pi).*obj.dw./obj.w);
            else
                % Full Wave Power Equation
                obj.Pw = sum((1/2)*rho*g.*S_f/(2*pi).*obj.dw.*sqrt(9.81./obj.k.*tanh(obj.k.*obj.waterDepth)).*(1 + 2.*obj.k.*obj.waterDepth./sinh(2.*obj.k.*obj.waterDepth)));
            end
            %
            switch obj.bem.option
                case {'EqualEnergy'}
                    m0 = trapz(freq,abs(S_f));
                    numBins = obj.bem.count+1;
                    a_targ = m0/(numBins);
                    SF = cumtrapz(freq,S_f);
                    wn(1) = 1;
                    for kk = 1:numBins
                        jj = 1;
                        tmpa{kk}(1) = 0;
                        while tmpa{kk}(jj)-kk*a_targ < 0
                            tmpa{kk}(jj+1) = SF(wn(kk)+jj);
                            jj = jj+1;
                            if wn(kk)+jj >=length(S_f)
                                break
                            end
                        end
                        [a_targ_real(kk),wna(kk)] = min(abs(tmpa{kk}-kk*a_targ));
                        wn(kk+1) = wna(kk)+wn(kk);
                        a_bins(kk) = trapz(freq(wn(kk):wn(kk+1)),abs(S_f(wn(kk):wn(kk+1))));
                    end
                    obj.w = 2*pi*freq(wn(2:end-1));
                    obj.dw = [obj.w(1)-2*pi*freq(wn(1)); diff(obj.w)];
                    obj.S = obj.S(wn(2:end-1));                             % Wave Spectrum [m^2-s/rad] 
            end
            obj.A = 2 * obj.S;                                              % Wave Amplitude [m]
        end

        function waveElevIrreg(obj,rampTime,timeseries,df)
            % Calculate irregular wave elevetaion time history
            % Used by waveSetup
            % Used by postProcess for variable time step 
            maxIt = length(timeseries);
            rampFunction = (1+cos(pi+pi*timeseries/rampTime))/2;
            rampFunction(timeseries>rampTime) = 1;

            obj.waveAmpTime = zeros(maxIt,2);
            obj.waveAmpTime(:,1) = timeseries;

            % Wave Gauges
            if ~isnan(obj.wavegauge1loc)
                obj.waveAmpTime1 = zeros(maxIt,2);
                obj.waveAmpTime1(:,1) = timeseries;
            end
            if ~isnan(obj.wavegauge2loc)
                obj.waveAmpTime2 = zeros(maxIt,2);
                obj.waveAmpTime2(:,1) = timeseries;
            end
            if ~isnan(obj.wavegauge3loc)
               obj.waveAmpTime3 = zeros(maxIt,2);
               obj.waveAmpTime3(:,1) = timeseries;
            end
            
            %  Wave Markers
            if ~isempty(obj.markerLoc)
                if width(obj.markerLoc)~=2
                    error('The coordinates of the visualization markers should have an ordinate (y-coordinate) and an abscissa (x-coordinate)')
                end
            end                              
            if ~isempty(obj.markerLoc)
               SZwaveAmpTimeViz = size(obj.markerLoc);
               obj.waveAmpTimeViz = zeros(maxIt,SZwaveAmpTimeViz(1)+1);
               obj.waveAmpTimeViz(:,1) = timeseries;
            end            
            
            % Calculate eta
            for i = 1:length(timeseries)
                tmp  = sqrt(obj.A.*df*obj.spread);
                tmp1 = tmp.*real(exp(sqrt(-1).*(obj.w.*timeseries(i) + obj.phase)));
                obj.waveAmpTime(i,2) = rampFunction(i)*sum(tmp1,'all');

                % Wave Gauges
                if ~isnan(obj.wavegauge1loc)
                    tmp11 = tmp.*real(exp(sqrt(-1).*(obj.w.*timeseries(i) - obj.k*(obj.wavegauge1loc(1).*cos(obj.direction*pi/180) + obj.wavegauge1loc(2).*sin(obj.direction*pi/180)) + obj.phase)));
                    obj.waveAmpTime1(i,2) = rampFunction(i).*sum(tmp11,'all');
                end

                if ~isnan(obj.wavegauge2loc)
                    tmp12 = tmp.*real(exp(sqrt(-1).*(obj.w.*timeseries(i) - obj.k*(obj.wavegauge2loc(1).*cos(obj.direction*pi/180) + obj.wavegauge2loc(2).*sin(obj.direction*pi/180)) + obj.phase)));
                    obj.waveAmpTime2(i,2) = rampFunction(i)*sum(tmp12,'all');
                end

                if ~isnan(obj.wavegauge3loc)
                    tmp13 = tmp.*real(exp(sqrt(-1).*(obj.w.*timeseries(i) - obj.k*(obj.wavegauge3loc(1).*cos(obj.direction*pi/180) + obj.wavegauge3loc(2).*sin(obj.direction*pi/180)) + obj.phase)));
                    obj.waveAmpTime3(i,2) = rampFunction(i)*sum(tmp13,'all');
                end
                
                % Wave Markers
                if ~isempty(obj.markerLoc)
                    for j = 1:SZwaveAmpTimeViz(1)
                        tmp14 = tmp.*real(exp(sqrt(-1).*(obj.w.*timeseries(i) - obj.k*(obj.markerLoc(j,1).*cos(obj.direction*pi/180) + obj.markerLoc(j,2).*sin(obj.direction*pi/180)) + obj.phase)));
                        obj.waveAmpTimeViz(i,j+1) = rampFunction(i).*sum(tmp14,'all');
                    end             
                end                                                                       
            end
        end        
        
        function waveElevUser(obj,rampTime,dt,maxIt,data,time)
            % Calculate imported wave elevation time history
            % Used by waveSetup
            rampFunction = (1+cos(pi+pi*time/rampTime))/2;
            rampFunction(time>rampTime) = 1;
            
            obj.waveAmpTime = zeros(maxIt+1,2);
            data_t = data(:,1)';                    % Data Time [s]
            data_x = data(:,2)';                    % Wave Surface Elevation [m]            
            obj.waveAmpTime(:,1) = time;
            obj.waveAmpTime(:,2) = rampFunction.*interp1(data_t,data_x,time);
            
            if any(~isnan(obj.wavegauge1loc)) || ...
                    any(~isnan(obj.wavegauge2loc)) || ...
                    any(~isnan(obj.wavegauge3loc)) || ...
                    ~isempty(obj.markerLoc)
                warning('Cannot use wave gauges or visualization markers with eta import. Gauges and markers removed.');
                obj.wavegauge1loc = [NaN,NaN];
                obj.wavegauge2loc = [NaN,NaN];
                obj.wavegauge3loc = [NaN,NaN];
                obj.markerLoc = [];
            end
        end
        
        function printWaveSpectrumType(obj)
            % Lists the wave spectrum type
            % Used by listInfo
            if strcmp(obj.spectrumType,'JS')
                fprintf('\tSpectrum Type                        = JONSWAP \n')
            elseif strcmp(obj.spectrumType,'PM')
                fprintf('\tSpectrum Type                        = Pierson-Moskowitz  \n')
            elseif strcmp(obj.spectrumType,'spectrumImport')
                fprintf('\tSpectrum Type                        = Imported Spectrum \n')
            end
        end
    end
end
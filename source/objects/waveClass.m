%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Laboratory of the Rockies and National
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

    properties (SetAccess = 'public', GetAccess = 'public') %input file
        bem (1,1) struct                            = struct(...            % (`structure`) Defines the BEM data implementation.
            'option',                               'EqualEnergy',...       %
            'count',                                [], ...                 %
            'frequency',                            [], ...                 %
            'range',                                [])                     % (`structure`) Defines the BEM data implementation. ``option`` (`string`) Method of frequency discretization for irregular waves, options include: ``'EqualEnergy'`` or ``'Traditional'``. Default = ``'EqualEnergy'``. ``count`` (`integer`) Number of interpolated wave frequencies, only used for ``irregular`` and ``spectrumImport``. Number of frequencies used varies depending on ``bem.option``, 1000 for ``'Traditional'``, and 500 for ``'EqualEnergy'`` and ``Imported``. Default = ``[]``. ``frequency`` (`vector`) Wave frequencies [rad/s] from BEM. Default = ``[]``. ``range`` (`2x1 vector`) Min and max wave frequency [rad/s], only used for ``irregular`` and ``spectrumImport``. If not specified, the BEM data frequency range is used. Default = ``[]``
        current (1,1) struct                        = struct(...            % (`structure`) Defines the current implementation.
            'option',                               3,...                   %
            'depth',                                0, ...                  %
            'direction',                            0, ...                  %
            'speed',                                0)                      % (`structure`) Defines the current implementation. ``option`` (`integer`) Define the sub-surface current model to be used in WEC-Sim, options include: ``0`` for depth-independent model, ``1`` for 1/7 power law variation with depth, ``2`` for linear variation with depth, or ``3`` for no current. Default = ``3``, ``depth`` (`float`) Current depth [m]. Define the depth over which the sub-surface current is modeled. Must be defined for options ``1`` and ``2``. The current is not calculated for any depths greater than the specified current depth. Default = ``0``, ``direction`` (`float`) Current direction [deg]. Surface current direction defined using WEC-Sim global coordinate system. Default = ``0``, ``speed``  (`float`) Current seed [m/s]. Surface current speed that is uniform along the water column. Default = ``0``
        direction (1,:) {mustBeNumeric}             = 0;                    % (`float`) Incident wave direction(s) [deg]. Incident wave direction defined using WEC-Sim global coordinate system. Should be defined as a row vector for more than one wave direction. Default = ``0``
        elevationFile (1,:) {mustBeText}            = 'NOT DEFINED';        % (`string`) Data file that contains the times-series data file. Default = ``'NOT DEFINED'``
        gamma (1,:) {mustBeScalarOrEmpty}           = [];                   % (`float`) Defines gamma, only used for ``JS`` wave spectrum type. Default = ``[]``
        height (1,:) {mustBeNonnegative}            = [];                   % (`float`) Wave height [m]. Defined as wave height for ``regular``, or significant wave height for ``irregular``. Default =  ``'NOT DEFINED'``
        marker (1,1) struct                         = struct(...            % (`structure`) Defines the wave marker.
            'location',                             [], ...                 %
            'size',                                 10, ...                 %
            'style',                                1, ...                  %
            'graphicColor',                         [0.26 0.96 0.89])       % (`structure`) Defines the wave marker. `loc` (`nx2 vector`) Marker [X,Y] locations [m]. Default = ``[]``. ``size`` (`float`) Marker size in Pixels. Default = ``10``. ``style`` Marker style, options include: ``1``: Sphere, ``2``: Cube, ``3``: Frame. Default = ``1``: Sphere
        period (1,:) {mustBeNonnegative}            = [];                   % (`float`) Wave period [s] . Defined as wave period for ``regular``, peak period for ``irregular``, or period of BEM data used for hydrodynamic coefficients for ``noWave``. Default = ``'NOT DEFINED'``
        phaseSeed (1,:) {mustBeNonnegative}         = 0;                    % (`integer`) Defines the random phase seed, only used for ``irregular`` and ``spectrumImport`` waves. Default = ``0``
        spectrumFile (1,:) {mustBeText}             = 'NOT DEFINED';        % (`string`) Data file that contains the spectrum data file.  Default = ``'NOT DEFINED'``
        spectrumType (1,:) {mustBeText}             = 'NOT DEFINED';        % (`string`) Specifies the wave spectrum type, options include:``PM`` or ``JS``. Default = ``'NOT DEFINED'``
        viz (1,1) struct                            = struct(...            %
            'numPointsX',                           50, ...                 %
            'numPointsY',                           50 );                   % (`structure`) Defines visualization options, structure contains the fields ``numPointsX`` for the number of visualization points in x direction, and ``numPointsY`` for the number of visualization points in y direction.
        waterDepth (1,:) {mustBeScalarOrEmpty}      = [];                   % (`float`) Water depth [m]. Default to BEM water depth if not set.
        spread (1,:) {mustBeNumeric}                = 1;                    % (`float`) Wave Spread probability associated with wave direction(s). Should be defined as a row vector for more than one wave direction. Default = ``1``
        freqDepDirection (1,1) struct               = struct(...            % (`structure`) Contains all parameters relevant to the importSpectraFullDir wave type.
            'directions',                           [], ...                 % (`float`) used only in importSpectraFullDir, wave direction at each frequency (nFreq x 1). Default = ``'NOT DEFINED'``
            'spreads',                              [], ...                 % (`float`) used only in importSpectraFullDir, wave spread (in deg) at each frequency (nFreq x 1). Default = ``'NOT DEFINED'``
            'dirRes',                               [], ...                 % (`float`) Unused. Default = ``'NOT DEFINED'``
            'nBins',                                [], ...                 % (`float`) used only in importSpectraFullDir, number of bins in which to discretize directional spreading function. Default = ``'NOT DEFINED'``
            'dirBins',                              [], ...                 % (`float`) used only in importSpectraFullDir, defines bin centers (about mean direction) at which spread function has been evaluated. Default = ``'NOT DEFINED'``
            'spreadWeights',                        [], ...                 % (`float`) used only in importSpectraFullDir, defines spread weights for each dirBin, (num frequencies x nBins). Default = ``'NOT DEFINED'``
            'spreadBins',                           [], ...                 % (`float`) used only in importSpectraFullDir, defines spread bins...
            'spreadRange',                          2);                     % (`float`) used only in importSpectraFullDir, defines the multiple of spread values (+/-) over which bin energy will be evaluated. Default = ``2``
            
    end

    properties (SetAccess = 'private', GetAccess = 'public')%internal
        % The following properties are private, for internal use by WEC-Sim
        amplitude       = [];                       % Wave amplitude [m] for regular waves or 2*(wave spectrum vector) for irregular waves
        deepWater       = [];                       % Deep water or not, depending on input from WAMIT, NEMOH and AQWA
        dOmega          = 0;                        % Frequency spacing [rad] for ``irregular`` waves.
        omega           = [];                       % Wave frequency (regular waves) or wave frequency vector (irregular waves), where omega = 2*pi/period [rad/s]
        phase           = 0;                        % (`float`) Wave phase [rad] . Only used for ``irregular`` waves.
        power           = [];                       % Wave Power Per Unit Wave Crest [W/m]
        spectrum        = [];                       % Wave Spectrum [m^2-s/rad] for ``Traditional``
        type            = 'NOT DEFINED';            % (`string`) Specifies the wave type, options include:``noWave``, ``noWaveCIC``, ``regular``, ``regularCIC``, ``irregular``, ``spectrumImport``, or ``elevationImport``. Default = ``'NOT DEFINED'``
        typeNum         = [];                       % Number to represent different type of waves
        waveAmpTime     = [];                       % Wave elevation time history [m] at the (0, 0, 0) origin
        waveAmpTimeViz  = [];                       % Wave elevation time history at marker locations specified by user [m]
        wavenumber      = [];                       % Wave Number, where wavenumber = 2*pi/wavelength [rad/m]
    end

    methods (Access = 'public')
        function obj = waveClass(type)
            % This method initializes the ``waveClass`` and creates a ``waves`` object.
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

            arguments
                type (1,1) internal.waveType
            end

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
                case 'spectrumImportFullDir' % Same as above but with 2 additional columns direction (in deg) and spread (in deg).
                    obj.typeNum = 35;
                case 'elevationImport'        % Waves with imported wave elevation time-history
                    obj.typeNum = 40;
            end
        end

        function checkInputs(obj)
            % This method checks WEC-Sim user inputs and generates error messages if parameters are not properly defined.

            % Check struct inputs:
            % BEM
            mustBeMember(obj.bem.option,{'EqualEnergy','Traditional'})
            mustBeScalarOrEmpty(obj.bem.count)
            mustBeNumeric(obj.bem.frequency)
            mustBeNumeric(obj.bem.range)
            % Current
            mustBeMember(obj.current.option,0:3)
            mustBeNonnegative(obj.current.depth)
            mustBeInRange(obj.current.direction, -360, 360)
            mustBeScalarOrEmpty(obj.current.speed)
            % Marker
            mustBeNumeric(obj.marker.location)
            mustBeScalarOrEmpty(obj.marker.size)
            mustBeMember(obj.marker.style,1:3)
            % Viz
            mustBeScalarOrEmpty(obj.viz.numPointsX)
            mustBeScalarOrEmpty(obj.viz.numPointsY)
            % Check restricted/boolean variables
            mustBeInRange(obj.direction,-360, 360)
            mustBeInRange(obj.spread,0, 1)

            % check 'waves.bem' fields
            if length(fieldnames(obj.bem)) ~=4
                error(['Unrecognized method, property, or field for class "waveClass", ' ...
                    '"waveClass.bem" structure must only include fields: "option", "count", "frequency", "range"']);
            end
            % check 'waves.current' fields
            if length(fieldnames(obj.current)) ~=4
                error(['Unrecognized method, property, or field for class "waveClass", ' ...
                    '"waveClass.current" structure must only include fields: "option", "depth", "direction", "speed"']);
            end
            % 'elevationFile' defined for 'elevationImport' case
            if strcmp(obj.type,'elevationImport')
                if strcmp(obj.elevationFile,'NOT DEFINED')
                    error('The "waves.elevationFile" must be defined when using the "elevationImport" wave type');
                end
                if ~isempty(obj.period) || ~isempty(obj.height)
                    warning('"waves.period" and "waves.height" are not used for "etaImport" wave types')
                end
            end
            % 'spectrumFile' defined for 'spectrumImport' case
            if strcmp(obj.type,'spectrumImport')
                if strcmp(obj.spectrumFile,'NOT DEFINED')
                    error('The "wave.spectrumFile" must be defined when using the "spectrumImport" wave type');
                end
                if ~isempty(obj.period) || ~isempty(obj.height)
                    warning('"waves.period" and "waves.height" are not used for "spectrumImport" wave types')
                end
            end
            % 'spectrumFileFullDir' defined for 'spectrumImport' case
            if strcmp(obj.type,'spectrumImportFullDir')
                if strcmp(obj.spectrumFile,'NOT DEFINED')
                    error('The "wave.spectrumFile" must be defined when using the "spectrumImport" wave type');
                end
                if ~isempty(obj.period) || ~isempty(obj.height)
                    warning('"waves.period" and "waves.height" are not used for "spectrumImport" wave types')
                end
            end
            % Check 'marker.location'
            if ~isempty(obj.marker.location) && ~ndims(obj.marker.location)==2
                error('The coordinates of the visualization markers should have an ordinate (y-coordinate) and an abscissa (x-coordinate)')
            end
            % Check wave spread
            if sum(obj.spread)~=1
                warning('The wave spread should always sum to 1 to preserve spectrum/energy accuracy UNLESS you are using fullDirection')
            end

            % Check inputs based on type
            if strcmp(obj.type,'noWave') && isempty(obj.period)
                error('"waves.period" must be defined for the hydrodynamic data period when using the "noWave" wave type');
            end
            if strcmp(obj.type,'noWaveCIC') && ~isempty(obj.period)
                warning('"waves.period" is not used for the hydrodynamic data period when using the "noWaveCIC" wave type')
            end
            if strcmp(obj.type,'regular') || strcmp(obj.type,'regularCIC')
                if isempty(obj.period) || isempty(obj.height)
                    error('"waves.period" and "waves.height" need to be defined for "regular" and "regularCIC" wave types')
                end
                if ~strcmp(obj.spectrumType,'NOT DEFINED')
                    warning('"waves.spectrumType" is not used for the "regular" and "regularCIC" wave types')
                end
            end
            if strcmp(obj.type,'irregular')
                if strcmp(obj.spectrumType,'NOT DEFINED')
                    error('"waves.spectrumType" needs to be defined for "irregular" wave types')
                end
                if isempty(obj.period) || isempty(obj.height)
                    error('"waves.period" and "waves.height" need to be defined for "irregular" wave types')
                end
            end
        end

        function setup(obj,bemFreq,bemWaterDepth,rampTime,dt,maxIt,time,g,rho)
            % This method calculates WEC-Sim's wave properties
            % based on the specified wave type.

            if ~isempty(obj.marker.location)==1
                if ~width(obj.marker.location)==2
                    error('The coordinates of the visualization markers should have an ordinate (y-coordinate) and an abscissa (x-coordinate)')
                end
            end
            obj.bem.frequency = bemFreq;
            if isempty(obj.bem.range) && isempty(obj.bem.frequency)
                % No .h5 file and no frequency range defined --> error
                error('Must define frequency range in waves.bem.range when zero hydro bodies are used (no .h5 file).');
            elseif isempty(obj.bem.range) && ~isempty(obj.bem.frequency)
                % Use .h5 file range if not defined in input file
                obj.bem.range = obj.bem.frequency;
            elseif ~isempty(obj.bem.range) && ~isempty(obj.bem.frequency)
                % check that input file frequency range is not larger than
                % available BEM data
                if obj.bem.range(1) < min(obj.bem.frequency) || obj.bem.range(1) > max(obj.bem.frequency)
                    warning('Min frequency range outside BEM data, min frequency set to min BEM frequency')
                    obj.bem.range(1) = min(obj.bem.frequency);
                end
                if obj.bem.range(2) < min(obj.bem.frequency) || obj.bem.range(2) > max(obj.bem.frequency)
                    warning('Max frequency range outside BEM data, max frequency set to max BEM frequency')
                    obj.bem.range(2) = max(obj.bem.frequency);
                end
            end

            obj.setWaterDepth(bemWaterDepth);

            switch obj.type
                case {'noWave','noWaveCIC'}
                    if isempty(obj.omega) && isempty(obj.period)
                        obj.omega = min(obj.bem.range);
                        obj.period = 2*pi/obj.omega;
                    elseif isempty(obj.omega)
                        obj.omega = 2*pi/obj.period;
                    else
                        obj.period = 2*pi/obj.omega;
                    end
                    obj.height = 0;
                    obj.amplitude = obj.height/2;
                    obj.wavenumber = calcWaveNumber(obj.omega,obj.waterDepth,g,obj.deepWater);
                    obj.waveElevNowave(time);
                case {'regular','regularCIC'}
                    if isempty(obj.omega) && isempty(obj.period)
                        obj.omega = min(obj.bem.range);
                        obj.period = 2*pi/obj.omega;
                    elseif isempty(obj.omega)
                        obj.omega = 2*pi/obj.period;
                    else
                        obj.period = 2*pi/obj.omega;
                    end
                    obj.amplitude = obj.height/2;
                    obj.wavenumber = calcWaveNumber(obj.omega,obj.waterDepth,g,obj.deepWater);
                    obj.waveElevReg(rampTime, time);
                    obj.wavePowerReg(g,rho);
                case {'irregular','spectrumImport','spectrumImportFullDir'}
                    if strcmp(obj.type,'spectrumImport')
                        obj.height = 0;
                        obj.period = 0;
                        obj.bem.option = 'Imported';
                        obj.spectrumType = 'spectrumImport';
                    elseif strcmp(obj.type,'spectrumImportFullDir')
                        obj.height = 0;
                        obj.period = 0;
                        obj.bem.option = 'ImportedFullDir';
                        obj.spectrumType = 'spectrumImportFullDir';
                        %obj.freqDepDirection.spreadWeights = zeros(1,obj.freqDepDirection.nBins); % iniitialize
                        %obj.freqDepDirection.dirBins = zeros(1,obj.freqDepDirection.nBins); % initialize
                    end
                    minFrequency=min(obj.bem.range);
                    maxFrequency=max(obj.bem.range);
                    switch obj.bem.option
                        case {'Traditional'}
                            if isempty(obj.bem.count)
                                obj.bem.count = 1000;
                            end
                            obj.omega = (minFrequency:(maxFrequency-minFrequency)/(obj.bem.count-1):maxFrequency)';
                            obj.dOmega = ones(obj.bem.count,1).*(maxFrequency-minFrequency)./(obj.bem.count-1);
                            obj.setWavePhase;
                            obj.irregWaveSpectrum(g,rho)
                            obj.wavenumber = calcWaveNumber(obj.omega,obj.waterDepth,g,obj.deepWater);
                            obj.waveElevIrreg(rampTime, time, obj.dOmega);
                        case {'EqualEnergy'}
                            bemCount_interp = 500000;
                            obj.omega = (minFrequency:(maxFrequency-minFrequency)/bemCount_interp:maxFrequency)';
                            obj.dOmega = mean(diff(obj.omega));
                            if isempty(obj.bem.count)
                                obj.bem.count = 500;
                            end
                            obj.setWavePhase;
                            obj.irregWaveSpectrum(g,rho)
                            obj.wavenumber = calcWaveNumber(obj.omega,obj.waterDepth,g,obj.deepWater);
                            obj.waveElevIrreg(rampTime, time, obj.dOmega);
                        case {'Imported'}
                            data = importdata(obj.spectrumFile);
                            freqData = data(:,1);
                            freqLoc = freqData >= min(obj.bem.range)/2/pi & freqData <= max(obj.bem.range)/2/pi;
                            obj.omega    = freqData(freqLoc).*2.*pi;
                            obj.bem.count = length(obj.omega);
                            obj.dOmega(1,1)= obj.omega(2)-obj.omega(1);
                            obj.dOmega(2:obj.bem.count-1,1)=(obj.omega(3:end)-obj.omega(1:end-2))/2;
                            obj.dOmega(obj.bem.count,1)= obj.omega(end)-obj.omega(end-1);
                            obj.setWavePhase;
                            obj.irregWaveSpectrum(g,rho)
                            obj.wavenumber = calcWaveNumber(obj.omega,obj.waterDepth,g,obj.deepWater);
                            obj.waveElevIrreg(rampTime, time, obj.dOmega);
                        case {'ImportedFullDir'}
                            data = importdata(obj.spectrumFile);
                            freqData = data(:,1);
                            freqLoc = freqData >= min(obj.bem.range)/2/pi & freqData <= max(obj.bem.range)/2/pi;
                            obj.omega(:,1)    = freqData(freqLoc).*2.*pi;
                            obj.freqDepDirection.directions(:,1) = data(freqLoc,3);
                            obj.freqDepDirection.spreads(:,1) = data(freqLoc,4);
                            obj.bem.count = length(obj.omega);
                            obj.dOmega(1,1)= obj.omega(2)-obj.omega(1);
                            obj.dOmega(2:obj.bem.count-1,1)=(obj.omega(3:end)-obj.omega(1:end-2))/2;
                            obj.dOmega(obj.bem.count,1)= obj.omega(end)-obj.omega(end-1);
                            % call spreading function
                            obj.spreadFunction;
                            obj.setWavePhase;
                            obj.irregWaveSpectrum(g,rho)
                            obj.wavenumber = calcWaveNumber(obj.omega,obj.waterDepth,g,obj.deepWater);
                            obj.waveElevFullDir(rampTime, time, obj.dOmega);

                    end

                case {'elevationImport'}    %  This does not account for wave direction
                    % Import 'elevationImport' time-series here and interpolate
                    data = importdata(obj.elevationFile) ;    % Import time-series
                    obj.waveElevUser(rampTime, maxIt, data, time);
            end
        end

        function listInfo(obj)
            % This method prints wave information to the MATLAB Command Window.

            fprintf('\nWave Environment: \n')
            switch obj.type
                case 'noWave'
                    fprintf('\tWave Type                            = No Wave (Constant Hydrodynamic Coefficients)\n')
                    fprintf('\tHydro Data Wave Period, period (sec)    	= %G\n',obj.period)
                case 'regular'
                    fprintf('\tWave Type                            = Regular Waves (Constant Hydrodynamic Coefficients)\n')
                    fprintf('\tWave Height, height (m)                   = %G\n',obj.height)
                    fprintf('\tWave Period, period (sec)                 = %G\n',obj.period)
                case 'noWaveCIC'
                    fprintf('\tWave Type                            = No Wave (Convolution Integral Calculation)\n')
                case 'regularCIC'
                    fprintf('\tWave Type                            = Regular Waves (Convolution Integral Calculation)\n')
                    fprintf('\tWave Height, height (m)                   = %G\n',obj.height)
                    fprintf('\tWave Period, period (sec)                 = %G\n',obj.period)
                case 'irregular'
                    if obj.phaseSeed == 0
                        fprintf('\tWave Type                            = Irregular Waves (Arbitrary Random Phase)\n')
                    else
                        fprintf('\tWave Type                            = Irregular Waves (Predefined Random Phase)\n')
                    end
                    obj.printWaveSpectrumType;
                    fprintf('\tSignificant Wave Height, Hs      (m) = %G\n',obj.height)
                    fprintf('\tPeak Wave Period, Tp           (sec) = %G\n',obj.period)
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
                    obj.waveElevIrreg(rampTime, timeseries, obj.dOmega);

                case{'spectrumImportFullDir'}
                    obj.waveElevFullDir(rampTime,timeseries,obj.dOmega);

                case {'elevationImport'}
                    % Wave elevation is a necessary pre-processing step for
                    % the eta import case.
                    % Used by waveClass.setup()
            end
        end

        function Z = waveElevationGrid(obj, t, X, Y, it, g)
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
                    Z = obj.amplitude * cos(-1 * obj.wavenumber * Xt  +  obj.omega * t);
                case {'irregular', 'spectrumImport'}
                    Z = zeros (size (X));
                    for idir=1:length(obj.direction)
                        Xt = X*cos(obj.direction(idir)*pi/180) + Y*sin(obj.direction(idir)*pi/180);
                        for iw = 1:length(obj.omega)
                            Z = Z + sqrt(obj.amplitude(iw)*obj.spread(idir).*obj.dOmega(iw)) * cos(-1*obj.wavenumber(iw)*Xt + obj.omega(iw)*t + obj.phase(iw,idir));
                        end
                    end
                case {'spectrumImportFullDir'} %%%%%
                    [m,n] = size(X);
                    Z = zeros([m,n]);
                    for im = 1:m
                        for in = 1:n
                            Xt(im,in) = X(m,n).*cos(obj.dirBins.*pi/180) + Y*sin(obj.dirBins.*pi/180);
                            temp =  sqrt(repmat(obj.amplitude,[1,obj.nBins]) .* obj.spreadWeights .*repmat(obj.dOmega,[1,obj.nBins])) .* cos(-1.*repmat(obj.wavenumber,[1,obj.nBins]) .* Xt(im,in) ...
                                + repmat(obj.omega,[1,obj.nBins]) + obj.phase);
                            Z(im,in) = sum(temp,'all');
                        end
                    end
                case{'elevationImport'}
                    if it ==1
                        warning('Paraview wave surface discretization for qualitative purposes only.')
                    end
                    Z = zeros(size(X));
                    WaveEle = obj.waveAmpTime(:,2);
                    TimeWaveEle = obj.waveAmpTime(:,1);
                    L = length(TimeWaveEle);
                    Fs = 1/(TimeWaveEle(2)-TimeWaveEle(1));
                    YY = fft(WaveEle);
                    P2 = abs(YY/L);
                    P1 = P2(1:round(L/2)+1);
                    P1(2:end-1) = 2*P1(2:end-1);
                    ff = Fs*(0:round(L/2))/L;
                    PhasesEtaImp2 = angle(YY/L);
                    PhasesEtaImp1 = PhasesEtaImp2(1:round(L/2)+1);
                    kWaveEle = (2*pi.*ff).^2./g; % deep water wave approximation
                    Xt = X*cos(obj.direction*pi/180) + Y*sin(obj.direction*pi/180);
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

            arguments
                obj
                rampTime double {mustBeReal, mustBeNonNan, mustBeFinite} = 0
            end

            waveElevationSum = zeros(size(obj(1).waveAmpTime(:,2)));
            for i = 1:numel(obj)
                waveElevationSum = waveElevationSum + obj(i).waveAmpTime(:,2);
            end
            figure
            plot(obj(1).waveAmpTime(:,1),waveElevationSum)
            title('Wave Surfave Elevation')
            if nargin==2
                hold on
                line([rampTime,rampTime],[1.5*min(obj(1).waveAmpTime(:,2)),1.5*max(obj(1).waveAmpTime(:,2))],'Color','k')
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
            for i = 1:length(obj)
                m0 = trapz(obj(i).omega,obj(i).spectrum);
                Hs(i) = 4*sqrt(m0);
                [sMax(i),I] = max(abs(obj(i).spectrum));
                wp(i) = obj(i).omega(I);
                Tp(i) = 2*pi/wp(i);
            end

            figure
            legendStrings = {};
            hold on
            for i = 1:length(obj)
                plot(obj(i).omega, obj(i).spectrum, 's-', ...
                    [wp(i), wp(i)], [0, sMax(i)], '--');
                legendStrings{end+1} = ['waves(' num2str(i) ') spectrum'];
                legendStrings{end+1} = ['waves(' num2str(i) ') peak period'];
            end
            legend(legendStrings);
            xlim([0 max(obj(1).omega)])
            xlabel('Frequency (rad/s)')
            ylabel('Spectrum (m^2-s/rad)');
            title('Wave Spectra');
        end

    end

    methods (Access = 'protected')
        function setWavePhase(obj)
            % Sets the irregular wave's random phase
            % used by: :meth:`waveClass.setup`.
            if obj.phaseSeed ~= 0
                s = RandStream('Threefry', 'Seed', 1);  % Global fixed seed
                s.Substream = obj.phaseSeed;           % Substream based on phaseSeed
                RandStream.setGlobalStream(s);         % Set globally
            else
                rng('shuffle');         % Phase seed shuffled
            end
            switch obj.bem.option
                case {'EqualEnergy','Traditional'}
                    obj.phase = 2*pi*rand(length(obj.direction),obj.bem.count);
                case {'Imported'}
                    data = importdata(obj.spectrumFile);
                    if size(data,2) == 3
                        freqData = data(:,1);
                        freqLoc = freqData>=min(obj.bem.range)/2/pi & freqData<=max(obj.bem.range)/2/pi;
                        phaseData = data(freqLoc,3);
                        obj.phase = phaseData';
                    else
                        obj.phase = 2*pi*rand(1,obj.bem.count);
                    end
                case {'ImportedFullDir'}
                    data = importdata(obj.spectrumFile);
                    obj.phase = 2 * pi * rand([obj.bem.count,obj.freqDepDirection.nBins]);
            end
            obj.phase = obj.phase';
        end
        function setWaterDepth(obj,bemWaterDepth)
            % Set the water depth. If defined in input file, BEM depth is
            % not used. used by: :meth:`waveClass.setup`.
            if isempty(obj.waterDepth)
                if isempty(bemWaterDepth)
                    error('Must define water depth in waves.waterDepth when zero hydro bodies (no .h5 file).');
                elseif strcmp(bemWaterDepth,'infinite')
                    obj.deepWater = 1;
                    obj.waterDepth = 200;
                    fprintf('\tInfinite water depth specified in BEM and "waves.waterDepth" not specified in input file.\n')
                    fprintf('Set water depth to 200m for visualization.\n')
                else
                    obj.deepWater = 0;
                    obj.waterDepth = double(bemWaterDepth);
                end
            else
                if ~isempty(bemWaterDepth)
                    warning('Because water depth is specified in the wecSimInputFile, the water depth from the BEM data is ignored')
                end
                if isinf(obj.waterDepth)
                    obj.deepWater = 1;
                    obj.waterDepth = 200;
                else
                    obj.deepWater = 0;
                end
            end
        end

        function waveElevNowave(obj,timeseries)
            % Set noWave elevation time-history
            % used by: :meth:`waveClass.setup`.
            % Used by postProcess for variable step solvers
            obj.waveAmpTime         = zeros(length(timeseries),2);
            obj.waveAmpTime(:,1)    = timeseries;

            if ~isempty(obj.marker.location)
                SZwaveAmpTimeViz = size(obj.marker.location);
                obj.waveAmpTimeViz = zeros(length(timeseries),SZwaveAmpTimeViz(1)+1);
                obj.waveAmpTimeViz(:,1) = timeseries;
            end
        end

        function waveElevReg(obj,rampTime,timeseries)
            % Calculate regular wave elevation time history
            % used by: :meth:`waveClass.setup`.
            % Used by postProcess for variable step solvers
            maxIt = length(timeseries);
            rampFunction = (1+cos(pi+pi*timeseries/rampTime))/2;
            rampFunction(timeseries>=rampTime) = 1;

            obj.waveAmpTime = zeros(maxIt,2);
            obj.waveAmpTime(:,1) = timeseries;
            obj.waveAmpTime(:,2) = rampFunction.*(obj.amplitude*cos(obj.omega*timeseries));

            % Wave Marker
            if ~isempty(obj.marker.location)==1
                if width(obj.marker.location)~=2
                    error('The coordinates of the visualization markers should have an ordinate (y-coordinate) and an abscissa (x-coordinate)')
                end
            end
            if ~isempty(obj.marker.location)
                SZwaveAmpTimeViz = size(obj.marker.location);
                obj.waveAmpTimeViz = zeros(maxIt,SZwaveAmpTimeViz(1)+1);
                for j = 1:SZwaveAmpTimeViz(1)
                    obj.waveAmpTimeViz(:,1) = timeseries;
                    obj.waveAmpTimeViz(:,j+1) = rampFunction.*obj.amplitude.*cos(obj.omega*timeseries - obj.wavenumber*(obj.marker.location(j,1).*cos(obj.direction*pi/180) + obj.marker.location(j,2).*sin(obj.direction*pi/180)));
                end
            end
        end

        function wavePowerReg(obj,g,rho)
            % Calculate wave power per unit wave crest for regular waves
            if obj.deepWater == 1
                % Deepwater Approximation
                obj.power = 1/(8*pi)*rho*g^(2)*(obj.amplitude).^(2).*obj.period;
            else
                % Full Wave Power Equation
                obj.power = rho*g*(obj.amplitude).^(2)/4*sqrt(g./obj.wavenumber.*tanh(obj.wavenumber.*obj.waterDepth))*(1+2*obj.wavenumber.*obj.waterDepth./sinh(2*obj.wavenumber.*obj.waterDepth));
            end
        end

        function irregWaveSpectrum(obj,g,rho)
            % Calculate wave spectrum vector (obj.amplitude)
            % Used by wavesIrreg (wavesIrreg used by: :meth:`waveClass.setup`.)
            frequency = obj.omega/(2*pi);
            Tp = obj.period;
            Hs = obj.height;
            switch obj.spectrumType
                case {'PM','JS'}
                    % Pierson-Moskowitz Spectrum from IEC TS 62600-2 ED2 Annex C.2 (2019)
                    bPM = (5/4)*(1/Tp)^(4);
                    aPM =  bPM*(Hs/2)^2;
                    fSpectrum  = (aPM*frequency.^(-5).*exp(-bPM*frequency.^(-4)));            % Wave Spectrum [m^2-s] for 'EqualEnergy'
                    if strcmp(obj.spectrumType,'JS')
                        % JONSWAP Spectrum from IEC TS 62600-2 ED2 Annex C.2 (2019)
                        fp = 1/Tp;
                        siga = 0.07;sigb = 0.09;                                    % cutoff frequencies for gamma function
                        [lind,~] = find(frequency<=fp);
                        [hind,~] = find(frequency>fp);
                        gammaAlpha = zeros(size(frequency));
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
                        gammaAlpha(lind) = obj.gamma.^exp(-(frequency(lind)-fp).^2/(2*siga^2*fp^2));
                        gammaAlpha(hind) = obj.gamma.^exp(-(frequency(hind)-fp).^2/(2*sigb^2*fp^2));
                        C = 1 - 0.287*log(obj.gamma);
                        fSpectrum = C*fSpectrum.*gammaAlpha;                                % Wave Spectrum [m^2-s]
                    end
                    obj.spectrum = fSpectrum./(2*pi);                                       % Wave Spectrum [m^2-s/rad]
                case 'spectrumImport' % Imported Wave Spectrum
                    data = importdata(obj.spectrumFile);
                    freqData = data(:,1);
                    S_data = data(:,2);
                    freqLoc = freqData >= min(obj.bem.range)/2/pi & freqData <= max(obj.bem.range)/2/pi;
                    fSpectrum = S_data(freqLoc);                                    % Wave Spectrum [m^2-s] for 'EqualEnergy'
                    obj.spectrum = fSpectrum./(2*pi);                                       % Wave Spectrum [m^2-s/rad] for 'Traditional'
                    fprintf('\t"spectrumImport" uses the number of imported wave frequencies (not "Traditional" or "EqualEnergy")\n')
                case 'spectrumImportFullDir' % imported wave spectrum, frequency resolved dir and spread
                    data = importdata(obj.spectrumFile);
                    freqData = data(:,1);
                    S_data = data(:,2);
                    freqLoc = freqData >= min(obj.bem.range)/2/pi & freqData <= max(obj.bem.range)/2/pi;
                    fSpectrum = S_data(freqLoc);                                    % Wave Spectrum [m^2-s] for 'EqualEnergy'
                    obj.spectrum = fSpectrum./(2*pi);                                       % Wave Spectrum [m^2-s/rad] for 'Traditional'
                    fprintf('\t"spectrumImportFullDir" uses the number of imported wave frequencies (not "Traditional" or "EqualEnergy")\n')
                case {'BS'}
                    error('Following IEC Standard, our Bretschneider Sprectrum (BS) option is exactly how the Pierson-Moskowitz (PM) Spectrum is defined. Please use PM instead');
            end
            % Power per Unit Wave Crest
            obj.wavenumber = calcWaveNumber(obj.omega,obj.waterDepth,g,obj.deepWater); %Calculate Wave Number for Larger Number of Frequencies Before Down Sampling in Equal Energy Method
            if obj.deepWater == 1
                % Deepwater Approximation
                obj.power = sum(1/2*rho*g^(2)*fSpectrum/(2*pi).*obj.dOmega./obj.omega);
            else
                % Full Wave Power Equation
                obj.power = sum((1/2)*rho*g.*fSpectrum/(2*pi).*obj.dOmega.*sqrt(g./obj.wavenumber.*tanh(obj.wavenumber.*obj.waterDepth)).*(1 + 2.*obj.wavenumber.*obj.waterDepth./sinh(2.*obj.wavenumber.*obj.waterDepth)));
            end
            %
            switch obj.bem.option
                case {'EqualEnergy'}
                    m0 = trapz(frequency,abs(fSpectrum));
                    numBins = obj.bem.count+1;
                    a_targ = m0/(numBins);
                    SfInt = cumtrapz(frequency,fSpectrum);
                    wn(1) = 1;
                    for kk = 1:numBins
                        jj = 1;
                        tmpa{kk}(1) = 0;
                        while tmpa{kk}(jj)-kk*a_targ < 0
                            tmpa{kk}(jj+1) = SfInt(wn(kk)+jj);
                            jj = jj+1;
                            if wn(kk)+jj >=length(fSpectrum)
                                break
                            end
                        end
                        [a_targ_real(kk),wna(kk)] = min(abs(tmpa{kk}-kk*a_targ));
                        wn(kk+1) = wna(kk)+wn(kk);
                        a_bins(kk) = trapz(frequency(wn(kk):wn(kk+1)),abs(fSpectrum(wn(kk):wn(kk+1))));
                    end
                    obj.omega = 2*pi*frequency(wn(2:end-1));
                    obj.dOmega = [obj.omega(1)-2*pi*frequency(wn(1)); diff(obj.omega)];
                    obj.spectrum = obj.spectrum(wn(2:end-1));                             % Wave Spectrum [m^2-s/rad]
            end
            obj.amplitude = 2 * obj.spectrum;                                              % 2*(wave spectrum vector)
        end

        function waveElevIrreg(obj,rampTime,timeseries,df)
            % Calculate irregular wave elevetaion time history
            % used by: :meth:`waveClass.setup`.
            % Used by postProcess for variable time step
            maxIt = length(timeseries);
            rampFunction = (1+cos(pi+pi*timeseries/rampTime))/2;
            rampFunction(timeseries>=rampTime) = 1;

            obj.waveAmpTime = zeros(maxIt,2);
            obj.waveAmpTime(:,1) = timeseries;

            %  Wave Markers
            if ~isempty(obj.marker.location)
                if width(obj.marker.location)~=2
                    error('The coordinates of the visualization markers should have an ordinate (y-coordinate) and an abscissa (x-coordinate)')
                end
            end
            if ~isempty(obj.marker.location)
                SZwaveAmpTimeViz = size(obj.marker.location);
                obj.waveAmpTimeViz = zeros(maxIt,SZwaveAmpTimeViz(1)+1);
                obj.waveAmpTimeViz(:,1) = timeseries;
            end

            % Calculate eta
            for i = 1:length(timeseries)
                tmp  = sqrt(obj.amplitude.*df*obj.spread);
                tmp1 = tmp.*real(exp(sqrt(-1).*(obj.omega.*timeseries(i) + obj.phase)));
                obj.waveAmpTime(i,2) = rampFunction(i)*sum(tmp1,'all');


                % Wave Markers
                if ~isempty(obj.marker.location)
                    for j = 1:SZwaveAmpTimeViz(1)
                        tmp14 = tmp.*real(exp(sqrt(-1).*(obj.omega.*timeseries(i) ...
                            - obj.wavenumber*(obj.marker.location(j,1).*cos(obj.direction*pi/180) ...
                            + obj.marker.location(j,2).*sin(obj.direction*pi/180)) + obj.phase)));
                        obj.waveAmpTimeViz(i,j+1) = rampFunction(i).*sum(tmp14,'all');
                    end
                end
            end
        end

        function waveElevFullDir(obj,rampTime,timeseries,df);
            % Calculate irregular wave elevetaion time history
            % used by: :meth:`waveClass.setup`.
            % Used by postProcess for variable time step
            maxIt = length(timeseries);
            rampFunction = (1+cos(pi+pi*timeseries/rampTime))/2;
            rampFunction(timeseries>=rampTime) = 1;

            obj.waveAmpTime = zeros(maxIt,2);
            obj.waveAmpTime(:,1) = timeseries;
            if ~isempty(obj.marker.location)
                if width(obj.marker.location)~=2
                    error('The coordinates of the visualization markers should have an ordinate (y-coordinate) and an abscissa (x-coordinate)')
                end
            end
            if ~isempty(obj.marker.location)
                SZwaveAmpTimeViz = size(obj.marker.location);
                obj.waveAmpTimeViz = zeros(maxIt,SZwaveAmpTimeViz(1)+1);
                obj.waveAmpTimeViz(:,1) = timeseries;
            end
            % Calculate eta at origin (0,0,0)
            for i = 1:length(timeseries)
                tmp  = sqrt(repmat(obj.amplitude,[1,obj.freqDepDirection.nBins]).*repmat(df,[1,obj.freqDepDirection.nBins]).*obj.freqDepDirection.spreadWeights);
                tmp1 = tmp.*real(exp(sqrt(-1).*(repmat(obj.omega,[1,obj.freqDepDirection.nBins]).*timeseries(i) + obj.phase.')));
                obj.waveAmpTime(i,2) = rampFunction(i)*sum(tmp1,'all');

                if ~isempty(obj.marker.location);
                    for j = 1:SZwaveAmpTimeViz(1)
                        tmp14 = tmp.*real(exp(sqrt(-1).*(repmat(obj.omega,[1,obj.freqDepDirection.nBins]).*timeseries(i) ...
                            - repmat(obj.wavenumber,[1,obj.freqDepDirection.nBins]).*(obj.marker.location(j,1).*cos(obj.freqDepDirection.dirBins*pi/180) ...
                            + obj.marker.location(j,2).*sin(obj.freqDepDirection.dirBins.*pi/180)) + obj.phase.')));
                        obj.waveAmpTimeViz(i,j+1) = rampFunction(i).*sum(tmp14,'all');
                    end
                end
            end
        end

        function waveElevUser(obj,rampTime,maxIt,data,time)
            % Calculate imported wave elevation time history
            % used by: :meth:`waveClass.setup`.
            rampFunction = (1+cos(pi+pi*time/rampTime))/2;
            rampFunction(time>=rampTime) = 1;

            obj.waveAmpTime = zeros(maxIt+1,2);
            data_t = data(:,1)';                    % Data Time [s]
            data_x = data(:,2)';                    % Wave Surface Elevation [m]
            obj.waveAmpTime(:,1) = time;
            obj.waveAmpTime(:,2) = rampFunction.*interp1(data_t,data_x,time);

            if any(~isempty(obj.marker.location))
                warning('Cannot use wave gauges or visualization markers with eta import. Gauges and markers removed.');
                obj.marker.location = [];
            end
        end

        function printWaveSpectrumType(obj)
            % Lists the wave spectrum type
            % Used by  :meth:`waveClass.listInfo`.
            if strcmp(obj.spectrumType,'JS')
                fprintf('\tSpectrum Type                        = JONSWAP \n')
            elseif strcmp(obj.spectrumType,'PM')
                fprintf('\tSpectrum Type                        = Pierson-Moskowitz  \n')
            elseif strcmp(obj.spectrumType,'spectrumImport')
                fprintf('\tSpectrum Type                        = Imported Spectrum \n')
            end
        end

        function spreadFunction(obj)
            % calculates bin weight per direction bins +/- nBins*dirRes around mean direction.
            for k=1:length(obj.freqDepDirection.spreads) % loops over all frequencies
                obj.freqDepDirection.spreadBins = linspace(-obj.freqDepDirection.spreads(k,1) .* obj.freqDepDirection.spreadRange ,obj.freqDepDirection.spreads(k,1) .* obj.freqDepDirection.spreadRange,obj.freqDepDirection.nBins+1); % these are bin endpoints: offset is so centers align w/ BEM data if dirRes and direction do as well.
                temp2 = movmean(obj.freqDepDirection.spreadBins,2);
                energyDist(1,:) = (1./(obj.freqDepDirection.spreads(k).*sqrt(2*pi))) .* exp (-(obj.freqDepDirection.spreadBins.^2) ./ (2.*obj.freqDepDirection.spreads(k).^2));
                checkSum = trapz(obj.freqDepDirection.spreadBins,energyDist);
                if checkSum < 0.95 % if this is true, then less than 95% of the initial energy at this frequency is contained over the considered directions.
                    warning('Number of spread bins inadequate at frequency number %i. Directional approximation weak. \n \r', k);
                end
                energyDist =  energyDist ./checkSum;    % scales to 1 so no energy loss in included directions (bad approx if warning is flagged)
                temp = diff(cumtrapz(obj.freqDepDirection.spreadBins,energyDist));
                obj.freqDepDirection.spreadWeights(k,:) = temp;
                [temp2,I] = sort(wrapTo180(temp2(2:end) + obj.freqDepDirection.directions(k,:)));     % takes bin centers from previous bin endpoints, add mean direction
                % sorted tables necessary for compiled interpn
                obj.freqDepDirection.dirBins(k,:) = temp2;
                obj.freqDepDirection.spreadWeights(k,:) = temp(I);
            end
        end
    end
end
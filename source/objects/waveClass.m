%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 the National Renewable Energy Laboratory and Sandia Corporation
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef waveClass<handle
    properties (SetAccess = 'public', GetAccess = 'public')%input file
        type                        = 'NOT DEFINED'                        % Wave type. Options for this varaibale are 'noWave' (no waves), 'regular' (regular waves), 'regularCIC' (regular waves using convolution integral to calculate radiation effects), 'irregular' (irregular waves), 'irregularPRE' (irregular waves with pre defined phase). The default is 'regular'.
        T                           = 'NOT DEFINED'                        % [s] Wave period (regular waves) or peak period (irregular waves) (default = 8)
        H                           = 'NOT DEFINED'                        % [m] Wave height (regular waves) or significant wave height (irregular waves) (default = 1)
        noWaveHydrodynamicCoeffT    = 'NOT DEFINED'                        % Period of BEM simulation used to determine hydrodynamic coefficients for simulations with no wave. This option is only used with the 'noWave' wave type.
        spectrumType                = 'NOT DEFINED'                        % Type of wave spectrum. Only PM, BS, JS, and Imported spectrum are supported.
        randPreDefined              = 0;                                   % Only used for irregular waves. Default is equal to 0; if equals to 1,2,3,...,etc, the waves pahse is seeded.
        spectrumDataFile            = 'NOT DEFINED'                        % Data file that contains the spectrum data file. See ---- for format specs
        etaDataFile                 = 'NOT DEFINED'                        % Data file that contains the times-series data file. See ---- for format specs
        numFreq                     = 1001                                 % Number of interpolated wave frequencies (default = 'NOT DEFINED')
        waveDir                     = 0                                    % Wave Direction in degrees
        viz                         = struct('numPointsX', 50, ...         % Visualization number of points in x direction.
                                             'numPointsY', 50)             % Visualization number of points in y direction.
        statisticsDataLoad          = [];                                   % File name to load wave statistics data
    end
    
    properties (SetAccess = 'private', GetAccess = 'public')%internal
        typeNum                     = []                                   % Number to represent different type of waves
        bemFreq                     = []                                   % Number of wave frequencies from WAMIT
        waterDepth                  = []                                   % [m] Water depth (from WAMIT)
        deepWaterWave               = []                                   % Deep water or not, depending on input from WAMIT, NEMOH and AQWA
        waveAmpTime                 = []                                   % [m] Wave elevation time history
        A                           = []                                   % [m] Wave amplitude for regular waves or 2*(wave spectrum vector) for irregular waves
        w                           = []                                   % [rad/s] Wave frequency (regular waves) or wave frequency vector (irregular waves)
        phaseRand                   = 0;                                   % [rad] Random wave phase (only used for irregular waves)
        dw                          = 0;                                   % [rad] Frequency spacing for irregular waves.
        k                           = []                                   % Wave Number
    end
    
    methods (Access = 'public')
        function obj = waveClass(type)
            % Initilization function
            % Set wave type and type number
            obj.type = type;
            switch obj.type
                case {'noWave'}        % No/Regular Waves
                    obj.typeNum = 0;
                case {'noWaveCIC'}     % No/Regular Waves w/Convolution Integral Calculation
                    obj.typeNum = 1;
                case {'regular'}       % No/Regular Waves
                    obj.typeNum = 10;
                case {'regularCIC'}    % No/Regular Waves w/Convolution Integral Calculation
                    obj.typeNum = 11;
                case 'irregular'       % Irregular Waves
                    obj.typeNum = 20;
                case 'irregularImport' % Irregular Waves w/Predefined Phase
                    obj.typeNum = 21;
                case 'userDefined'     % Import User-Defined Waves
                    obj.typeNum = 30;
            end
        end
        
        function plotEta(obj)
            figure
            plot(obj.waveAmpTime(:,1),obj.waveAmpTime(:,2))
            xlabel('Time (s)')
            ylabel('Eta (m)')
        end
        
        function waveSetup(obj,bemFreq,wDepth,rampT,dt,maxIt,g,endTime)
            % Calculate and set wave properties based on wave type
            obj.bemFreq    = bemFreq;
            obj.setWaveProps(wDepth,bemFreq)
            switch obj.type
                case {'noWave','noWaveCIC'}
                    if isempty(obj.w)
                        obj.w = 2*pi/obj.T;
                    end
                    obj.A = obj.H/2;
                    obj.waveElevNowave(maxIt,dt);
                case {'regular','regularCIC'}
                    if isempty(obj.w)
                        obj.w = 2*pi/obj.T;
                    end
                    obj.A = obj.H/2;
                    obj.waveElevReg(rampT, dt, maxIt);
                case {'irregular','irregularImport'}
                    WFQSt=min(bemFreq);
                    WFQEd=max(bemFreq);
                    obj.dw=(WFQEd-WFQSt)/(obj.numFreq-1);
                    obj.w = (WFQSt:obj.dw:WFQEd)';
                    obj.setWavePhase;
                    obj.irregWaveSpectrum(g)
                    obj.waveElevIrreg(rampT, dt, maxIt, obj.dw);
                case {'userDefined'}    %  This does not account for wave direction
                    % Import userDefined time-series here and interpolate
                    data = importdata(obj.etaDataFile) ;    % Import time-series
                    t = [0:dt:endTime]';      % WEC-Sim simulation time [s]
                    obj.waveElevUser(rampT, dt, maxIt, data, t);
            end
            obj.waveNumber(g)
        end
        
        function listInfo(obj)
            % List wave info
            fprintf('\nWave Environment: \n')
            switch obj.type
                case 'noWave'
                    fprintf('\tWave Type                            = No Wave\n')
                case 'regular'
                    fprintf('\tWave Type                            = Regular Waves (Sinusoidal Steady-State)\n')
                    fprintf('\tWave Height H (m)                    = %G\n',obj.H)
                    fprintf('\tWave Period T (sec)                  = %G\n',obj.T)
                case 'noWaveCIC'
                    fprintf('\tWave Type                            = No Wave (Convolution Integral Calculation)\n')
                case 'regularCIC'
                    fprintf('\tWave Type                            = Regular Waves (Convolution Integral Calculation)\n')
                    fprintf('\tWave Height H (m)                    = %G\n',obj.H)
                    fprintf('\tWave Period T (sec)                  = %G\n',obj.T)
                case 'irregular'
                    if obj.randPreDefined == 0
                        fprintf('\tWave Type                            = Irregular Waves (Arbitrary Random Phase)\n')
                    else
                        fprintf('\tWave Type                            = Irregular Waves (Predefined Random Phase)\n')
                    end
                    obj.printWaveSpectrumType;
                    fprintf('\tSignificant Wave Height Hs (m)       = %G\n',obj.H)
                    fprintf('\tPeak Wave Period Tp (sec)            = %G\n',obj.T)
                case 'irregularImport'
                    if obj.randPreDefined == 0
                        fprintf('\tWave Type                            = Irregular Waves (Arbitrary Random Phase)\n')
                    else
                        fprintf('\tWave Type                            = Irregular Waves (Predefined Random Phase)\n')
                    end
                    obj.printWaveSpectrumType;
                case 'userDefined'
                    fprintf( '\tWave Type                                = User-Defined Wave Elevation Time-Series\n')
                    fprintf(['\tWave Elevation Time-Series File          = ' obj.etaDataFile '  \n'])
            end
        end
        
        function waveNumber(obj,g)
            obj.k = obj.w.^2./g;
            if obj.deepWaterWave == 0
                for i=1:100
                    obj.k = obj.w.^2./g./tanh(obj.k.*obj.waterDepth);
                end
            end
        end    

        function checkinputs(obj)
            % noWaveHydrodynamicCoeffT defined for noWave case
            if strcmp(obj.type,'noWave')
                if strcmp(obj.noWaveHydrodynamicCoeffT,'NOT DEFINED')
                    error('The noWaveHydrodynamicCoeffT variable must be defined when using the "noWave" wave type');
                end
            end
            % spectrumDataFile defined for irregularImport case
            if strcmp(obj.type,'irregularImport')
                if strcmp(obj.spectrumDataFile,'NOT DEFINED')
                    error('The spectrumDataFile variable must be defined when using the "irregularImport" wave type');
                end
            end
            % types
            types = {'noWave', 'noWaveCIC', 'regular', 'regularCIC', 'irregular', 'irregularImport', 'userDefined'};
            if sum(strcmp(types,obj.type)) ~= 1
                error(['Unexpected wave environment type setting. ' ...
                    'Only noWave, noWaveCIC, regular, regularCIC, irregular, irregularImport, and userDefined waves are supported at this time'])
            end
        end

        function write_paraview_vtp(obj, t, numPointsX, numPointsY, domainSize, model, simdate)
            % ground plane
            filename = ['vtk' filesep 'ground.txt'];
            fid = fopen(filename, 'w');
            fprintf(fid,[num2str(domainSize) '\n']);
            fprintf(fid,[num2str(obj.waterDepth) '\n']);
            fclose(fid);
            % wave
            x = linspace(-domainSize, domainSize, numPointsX);
            y = linspace(-domainSize, domainSize, numPointsY);
            [X,Y] = meshgrid(x,y);
            lx = length(x);
            ly = length(y);
            numVertex = lx * ly;
            numFace = (lx-1) * (ly-1);
            for it = 1:length(t)
                % open file
                filename = ['vtk' filesep 'waves' filesep 'waves_' num2str(it) '.vtp'];
                fid = fopen(filename, 'w');
                % calculate wave elevation
                switch obj.type
                case{'noWave','noWaveCIC','userDefined'}
                    Z = zeros(size(X));
                case{'regular','regularCIC'}
                    Xt = X*cos(obj.waveDir*pi/180) + Y*sin(obj.waveDir*pi/180);
                    Z = obj.A * cos(-1 * obj.k * Xt  +  obj.w * t(it));
                case{'irregular','irregularImport'}
                    Z = zeros(size(X));
                    Xt = X*cos(obj.waveDir*pi/180) + Y*sin(obj.waveDir*pi/180);
                    for iw = 1:length(obj.w)
                        Z = Z + sqrt(obj.A(iw)*obj.dw) * cos(-1*obj.k(iw)*Xt + obj.w(iw)*t(it) + obj.phaseRand(iw));
                    end
                end
                % write header
                fprintf(fid, '<?xml version="1.0"?>\n');
                fprintf(fid, ['<!-- WEC-Sim Visualization using ParaView -->\n']);
                fprintf(fid, ['<!--   model: ' model ' - ran on ' simdate ' -->\n']);
                fprintf(fid, ['<!--   wave:  ' obj.type ' -->\n']);
                fprintf(fid, ['<!--   time:  ' num2str(t(it)) ' -->\n']);
                fprintf(fid, '<VTKFile type="PolyData" version="0.1">\n');
                fprintf(fid, '  <PolyData>\n');
                % write wave info
                fprintf(fid,['    <Piece NumberOfPoints="' num2str(numVertex) '" NumberOfPolys="' num2str(numFace) '">\n']);
                % write points
                fprintf(fid,'      <Points>\n');
                fprintf(fid,'        <DataArray type="Float32" NumberOfComponents="3" format="ascii">\n');
                for jj = 1:length(y)
                    for ii = 1:length(x)
                        pt = [X(jj,ii), Y(jj,ii), Z(jj,ii)];
                        fprintf(fid, '          %5.5f %5.5f %5.5f\n', pt);
                    end; clear ii
                    clear pt
                end; clear jj
                fprintf(fid,'        </DataArray>\n');
                fprintf(fid,'      </Points>\n');
                % write squares connectivity
                fprintf(fid,'      <Polys>\n');
                fprintf(fid,'        <DataArray type="Int32" Name="connectivity" format="ascii">\n');
                for jj = 1:ly-1
                    for ii = 1:lx-1
                        p1 = (jj-1)*lx + (ii-1);
                        p2 = p1+1;
                        p3 = p2 + lx;
                        p4 = p1 + lx;
                        fprintf(fid, '          %i %i %i %i\n', [p1,p2,p3,p4]);
                    end; clear ii
                end; clear jj
                fprintf(fid,'        </DataArray>\n');
                fprintf(fid,'        <DataArray type="Int32" Name="offsets" format="ascii">\n');
                fprintf(fid, '         ');
                for ii = 1:numFace
                    n = ii * 4;
                    fprintf(fid, ' %i', n);
                end; clear ii n
                fprintf(fid, '\n');
                fprintf(fid,'        </DataArray>\n');
                fprintf(fid, '      </Polys>\n');
                % end file
                fprintf(fid, '    </Piece>\n');
                fprintf(fid, '  </PolyData>\n');
                fprintf(fid, '</VTKFile>');
                % close file
                fclose(fid);
            end; clear it
            clear  numPoints numVertex numFace x y lx ly X Y Z fid filename p1 p2 p3 p4
        end
    end
    
    methods (Access = 'protected')
        function setWavePhase(obj)
            % Used by waveSetup
            % Sets the irregular wave's random phase
            if obj.randPreDefined ~= 0  
               rng(obj.randPreDefined); % Phase seed = 1,2,3,...,etc
            else 
                rng('shuffle');         % Phase seed shuffled
            end
            obj.phaseRand = 2*pi*rand(1,obj.numFreq);
            obj.phaseRand = obj.phaseRand';
        end
        
        function setWaveProps(obj,wDepth,bemFreq)
            % Used by waveSetup
            % Sets global and type-specific properties
            if ~isfloat(wDepth)
                obj.deepWaterWave = 1;
                obj.waterDepth = 200;
                warning('Invalid water depth given. waves.waterDepth set to 200m for vizualisation.')
            else
                obj.deepWaterWave = 0;
                obj.waterDepth = wDepth;
            end
            switch obj.type
                case {'noWave'}
                    obj.H = 0;
                    obj.T = obj.noWaveHydrodynamicCoeffT;
                case {'noWaveCIC'}
                    obj.H = 0;
                    obj.w = max(bemFreq);
                    obj.T=2*pi/obj.w;
                case {'irregularImport'}
                    obj.H = 0;
                    obj.T = 0;
                    obj.spectrumType = 'Imported';
            end
        end
        
        function waveElevNowave(obj,maxIt,dt)
            obj.waveAmpTime = zeros(maxIt+1,2);
            obj.waveAmpTime(:,1) = [0:maxIt]*dt;
        end
        
        function waveElevReg(obj, rampT,dt,maxIt)
            % Used by waveSetup
            % Calculate regular wave elevation time history
            obj.waveAmpTime = zeros(maxIt+1,2);
            maxRampIT=round(rampT/dt);
            if rampT==0
                for i=1:maxIt+1
                    t = (i-1)*dt;
                    obj.waveAmpTime(i,1) = t;
                    obj.waveAmpTime(i,2) = obj.A*cos(obj.w*t);
                end
            else
                for i=1:maxRampIT
                    t = (i-1)*dt;
                    obj.waveAmpTime(i,1) = t;
                    obj.waveAmpTime(i,2) = obj.A*cos(obj.w*t)*(1+cos(pi+pi*(i-1)/maxRampIT))/2;
                end
                for i=maxRampIT+1:maxIt+1;
                    t = (i-1)*dt;
                    obj.waveAmpTime(i,1) = t;
                    obj.waveAmpTime(i,2) = obj.A*cos(obj.w*t);
                end
            end
        end
        
        function irregWaveSpectrum(obj,g)
            % Used by wavesIrreg (wavesIrreg used by waveSetup)
            % Calculate sqrt(wave spectrum vector) (obj.A)
            freq = obj.w/(2*pi);
            Tp = obj.T;
            Hs = obj.H;
            switch obj.spectrumType
                case 'BS' % Bretschneider Sprectrum from Tucker and Pitt (2001)
                    B = (1.057/Tp)^4;
                    A_irreg = B*(Hs/2)^2;
                    S_f = (A_irreg*freq.^(-5).*exp(-B*freq.^(-4)));
                    Sf = S_f./(2*pi);
                case 'JS' % JONSWAP Spectrum from Hasselmann et. al (1973)
                    [r,~] = size(freq);
                    if r == 1; freq = sort(freq)';
                    else freq = sort(freq); end
                    fp = 1/Tp;
                    gamma = 3.3;
                    siga = 0.07;sigb = 0.09;
                    [lind,~] = find(freq<=fp);
                    [hind,~] = find(freq>fp);
                    Gf = zeros(size(freq));
                    Gf(lind) = gamma.^exp(-(freq(lind)-fp).^2/(2*siga^2*fp^2));
                    Gf(hind) = gamma.^exp(-(freq(hind)-fp).^2/(2*sigb^2*fp^2));
                    Sf = g^2*(2*pi)^(-4)*freq.^(-5).*exp(-(5/4).*(freq/fp).^(-4));
                    Amp = Hs^(2)/16/trapz(freq,Sf.*Gf);
                    S = Amp*Sf.*Gf;
                    Sf = S./(2*pi);
                case 'PM' % Pierson-Moskowitz Spectrum from Tucker and Pitt (2001)
                    B = (5/4)*(1/Tp)^(4);
                    A_irreg = g^2*(2*pi)^(-4);
                    S_f = (A_irreg*freq.^(-5).*exp(-B*freq.^(-4)));
                    alpha = Hs^(2)/16/trapz(freq,S_f);
                    Sf = alpha*S_f./(2*pi);
                case 'Imported' % Imported Spectrum
                    data = dlmread(obj.spectrumDataFile);
                    freq_data = data(1,:);
                    Sf_data = data(2,:);
                    S_f = interp1(freq_data,Sf_data,freq,'pchip',0);
                    Sf = S_f./(2*pi);
            end
            obj.A = 2 * Sf;
        end
        
        function waveElevIrreg(obj,rampT,dt,maxIt,df)
            % Used by waveSetup
            % Calculate irregular wave elevetaion time history
            obj.waveAmpTime = zeros(maxIt+1,2);
            maxRampIT=round(rampT/dt);
            if rampT==0
                for i=1:maxIt+1;
                    t = (i-1)*dt;
                    tmp=sqrt(obj.A.*df);
                    tmp1 = tmp.*real(exp(sqrt(-1).*(obj.w.*t + obj.phaseRand)));
                    obj.waveAmpTime(i,1) = t;
                    obj.waveAmpTime(i,2) = sum(tmp1);
                end
            else
                for i=1:maxRampIT
                    t = (i-1)*dt;
                    tmp=sqrt(obj.A.*df);
                    tmp1 = tmp.*real(exp(sqrt(-1).*(obj.w.*t + obj.phaseRand)));
                    obj.waveAmpTime(i,1) = t;
                    obj.waveAmpTime(i,2) = sum(tmp1)*(1+cos(pi+pi*(i-1)/maxRampIT))/2;
                end
                for i=maxRampIT+1:maxIt+1
                    t = (i-1)*dt;
                    tmp=sqrt(obj.A.*df);
                    tmp1 = tmp.*real(exp(sqrt(-1).*(obj.w.*t + obj.phaseRand)));
                    obj.waveAmpTime(i,1) = t;
                    obj.waveAmpTime(i,2) = sum(tmp1);
                end
            end
        end
        
        function waveElevUser(obj,rampT,dt,maxIt,data, t)
            % Used by waveSetup
            % Calculate user-defined wave elevation time history
            obj.waveAmpTime = zeros(maxIt+1,2);
            maxRampIT=round(rampT/dt);
            data_t = data(:,1)';                    % Data Time [s]
            data_x = data(:,2)';                    % Wave Surface Elevation [m]
            obj.waveAmpTime(:,1) = t;
            obj.waveAmpTime(:,2) = interp1(data_t,data_x,t);
            if rampT~=0
                for i=1:maxRampIT
                    obj.waveAmpTime(i,2) = obj.waveAmpTime(i,2)*(1+cos(pi+pi*(i-1)/maxRampIT))/2;
                end
            end
        end
        
        function printWaveSpectrumType(obj)
            % Used by listInfo
            % Lists the wave spectrum type
            if strcmp(obj.spectrumType,'BS')
                fprintf('\tSpectrum Type                        = Bretschneider \n')
            elseif strcmp(obj.spectrumType,'JS')
                fprintf('\tSpectrum Type                        = JONSWAP \n')
            elseif strcmp(obj.spectrumType,'PM')
                fprintf('\tSpectrum Type                        = Pierson-Moskowitz  \n')
            elseif strcmp(obj.spectrumType,'Imported')
                fprintf('\tSpectrum Type                        = User-Defined \n')
            end
        end
    end
end

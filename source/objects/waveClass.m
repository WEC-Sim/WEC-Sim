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
        type                        = 'NOT DEFINED'                         % Wave types (Default = 'NOT DEFINED'): 'noWave', 'noWaveCIC', 'regular', 'regularCIC', 'irregular', 'spectrumImport', and 'etaImport'
        T                           = 'NOT DEFINED'                         % [s] Wave period (regular waves), peak period (irregular waves), period of BEM data used for hydrodynamic coefficients ('noWave') (Default = 'NOT DEFINED')
        H                           = 'NOT DEFINED'                         % [m] Wave height (regular waves) or significant wave height (irregular waves) (Default = 'NOT DEFINED')
        spectrumType                = 'NOT DEFINED'                         % Wave spectrum types (Default = 'NOT DEFINED'): 'PM', 'BS', and 'JS'
        gamma                       = 3.3                                   % Only used for 'JS' spectrum type to define gamma (Default = 3.3)
        phaseSeed                   = 0;                                    % Only used for irregular waves (Default = 0); if equals to 1,2,3,...,etc, the waves phase is seeded.
        spectrumDataFile            = 'NOT DEFINED'                         % Data file that contains the spectrum data file (Default = 'NOT DEFINED')
        etaDataFile                 = 'NOT DEFINED'                         % Data file that contains the times-series data file (Default = 'NOT DEFINED')
        freqRange                   = [];                                   % Min and max frequency for irregular waves. 2x1 vector, rad/s, (default = frequency range in BEM data)
        numFreq                     = [];                                   % Number of frequencies used, varies depending on method: 'Traditional, 'EqualEnergy' or 'Imported' (Default=1000 for Traditional and 500 for Equal Energy)
        waveDir                     = 0                                     % [deg] Incident wave direction (Default = 0)
        viz                         = struct(...                            % Structure defining visualization options
            'numPointsX', 50, ...              % Visualization number of points in x direction.
            'numPointsY', 50)                  % Visualization number of points in y direction.
        statisticsDataLoad          = [];                                   % File name to load wave statistics data for wecSimMCR
        freqDisc                    = 'EqualEnergy'                         % Method of frequency discretization for irregular waves. Options for this variable are 'EqualEnergy' or 'Traditional'. (default = 'EqualEnergy').
        wavegaugeloc                = 0;                                    % [m] Wave gauge location assumed to be along the x-axis
    end
    
    properties (SetAccess = 'private', GetAccess = 'public')%internal
        typeNum                     = []                                    % Number to represent different type of waves
        bemFreq                     = []                                    % Number of wave frequencies from BEM
        waterDepth                  = []                                    % [m] Water depth (from BEM)
        deepWaterWave               = []                                    % Deep water, depends on input from WAMIT, NEMOH and AQWA
        waveAmpTime                 = []                                    % [m] Wave elevation time history
        waveAmpTimex                = []                                    % [m] Wave elevation time history at a wave gauge location specified by user
        A                           = []                                    % [m] Wave amplitude for regular waves or 2*(wave spectrum vector) for irregular waves
        w                           = []                                    % [rad/s] Wave frequency (regular waves) or wave frequency vector (irregular waves)
        phase                       = 0;                                    % [rad] Wave phase (only used for irregular waves)
        dw                          = 0;                                    % [rad/s] Frequency spacing for irregular waves.
        k                           = []                                    % [rad/m] Wave number
        Sf                          = [];                                   % Wave Spectrum [m^2-s/rad]
    end
    
    methods (Access = 'public')
        function obj = waveClass(type)
            % Initilization function
            % Set wave type and type number
            obj.type = type;
            switch obj.type
                case {'noWave'}        % No Waves with Constant Hydrodynamic Coefficients
                    obj.typeNum = 0;
                case {'noWaveCIC'}     % No Waves w/Convolution Integral Calculation
                    obj.typeNum = 1;
                case {'regular'}       % Regular Waves with Constant Hydrodynamic Coefficients
                    obj.typeNum = 10;
                case {'regularCIC'}    % Regular Waves w/Convolution Integral Calculation
                    obj.typeNum = 11;
                case 'irregular'       % Irregular Waves with 'PM', BS' or 'JS' wave spectrum
                    obj.typeNum = 20;
                case 'spectrumImport' % Irregular waves with imported wave spectrum
                    obj.typeNum = 21;
                case 'etaImport'     % Waves with imported wave elevation time-history
                    obj.typeNum = 30;
            end
        end
        
        function plotEta(obj,rampTime)
            % Plot wave elevation time-history
            figure
            plot(obj.waveAmpTime(:,1),obj.waveAmpTime(:,2))
            title('Wave Surfave Elevation')
            if nargin==2
                hold on
                line([rampTime,rampTime],[1.5*min(obj.waveAmpTime(:,2)),1.5*max(obj.waveAmpTime(:,2))],'Color','k')
                title(['Wave Surfave Elevation, Ramp Time ' num2str(rampTime) ' (s)'])
            end
            xlabel('Time (s)')
            ylabel('Eta (m)')
        end
        
        function plotSpectrum(obj)
            % Plot wave spetrum
            m0 = trapz(obj.w,obj.Sf);
            HsTest = 4*sqrt(m0);
            [~,I] = max(abs(obj.Sf));
            wp = obj.w(I);
            TpTest = 2*pi/wp;
            
            figure
            plot(obj.w,obj.Sf,'s-')
            hold on
            line([wp,wp],[0,max(obj.Sf)],'Color','k')
            xlim([0 max(obj.w)])
            title([obj.spectrumType, ' Spectrum, T_p= ' num2str(TpTest) ' [s], '  'H_m_0= ' num2str(HsTest), ' [m]'])
            if obj.spectrumType == 'JS'
                title([obj.spectrumType, ' Spectrum, T_p= ' num2str(TpTest) ' [s], H_m_0= ' num2str(HsTest), ' [m], gamma = ' num2str(obj.gamma)])
            end
            xlabel('Frequency (rad/s)')
            ylabel('Spectrum (m^2-s/rad)');
        end
        
        function waveSetup(obj,bemFreq,wDepth,rampTime,dt,maxIt,g,endTime)
            % Calculate and set wave properties based on wave type
            obj.bemFreq    = bemFreq;
            obj.setWaveProps(wDepth)
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
                    obj.waveNumber(g)
                    obj.waveElevReg(rampTime, dt, maxIt);
                case {'irregular','spectrumImport'}
                    WFQSt=min(bemFreq);
                    WFQEd=max(bemFreq);
                    if ~isempty(obj.freqRange)
                        if obj.freqRange(1) > WFQSt && obj.freqRange(1) > 0
                            WFQSt = obj.freqRange(1);
                        else
                            warning('Min frequency range outside BEM data, min frequency set to min BEM frequency')
                        end
                        if obj.freqRange(2) < WFQEd && obj.freqRange(2) > WFQSt
                            WFQEd = obj.freqRange(2);
                        else
                            warning('Max frequency range outside BEM data, max frequency set to max BEM frequency')
                        end
                    end
                    switch obj.freqDisc
                        case {'Traditional'}
                            if isempty(obj.numFreq)
                                obj.numFreq = 1000;
                            end
                            obj.w = (WFQSt:(WFQEd-WFQSt)/(obj.numFreq-1):WFQEd)';
                            obj.dw= ones(obj.numFreq,1).*(WFQEd-WFQSt)./(obj.numFreq-1);
                        case {'EqualEnergy'}
                            numFreq_interp = 500000;
                            obj.w = WFQSt:(WFQEd-WFQSt)/numFreq_interp:WFQEd;
                            obj.dw = mean(diff(obj.w));
                            if isempty(obj.numFreq)
                                obj.numFreq = 500;
                            end
                        case {'Imported'}
                            data = dlmread(obj.spectrumDataFile);
                            freq_data = data(1,:);
                            freq_loc = freq_data>=min(obj.bemFreq)/2/pi & freq_data<=max(obj.bemFreq)/2/pi;
                            obj.w    = freq_data(freq_loc)'.*2.*pi;
                            obj.numFreq = length(obj.w);
                            obj.dw(1              ,1)= obj.w(2)-obj.w(1);
                            obj.dw(2:obj.numFreq-1,1)=(obj.w(3:end)-obj.w(1:end-2))/2;
                            obj.dw(obj.numFreq    ,1)= obj.w(end)-obj.w(end-1);
                    end
                    obj.setWavePhase;
                    obj.irregWaveSpectrum(g)
                    obj.waveNumber(g)
                    obj.waveElevIrreg(rampTime, dt, maxIt, obj.dw);
                case {'etaImport'}    %  This does not account for wave direction
                    % Import 'etaImport' time-series here and interpolate
                    data = importdata(obj.etaDataFile) ;    % Import time-series
                    t = [0:dt:endTime]';      % WEC-Sim simulation time [s]
                    obj.waveElevUser(rampTime, dt, maxIt, data, t);
                    obj.waveAmpTimex        = zeros(maxIt+1,2);
                    obj.waveAmpTimex(:,1)   = [0:maxIt]*dt;
            end
            %obj.waveNumber(g)
        end
        
        function listInfo(obj)
            % List wave info
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
                    if size(dlmread(obj.spectrumDataFile),1) == 3
                        fprintf('\tWave Type                            = Irregular waves with imported wave spectrum (Imported Phase)\n')
                    elseif obj.phaseSeed == 0
                        fprintf('\tWave Type                            = Irregular waves with imported wave spectrum (Random Phase)\n')
                    else
                        fprintf('\tWave Type                            = Irregular waves with imported wave spectrum (Seeded Phase)\n')
                    end
                    obj.printWaveSpectrumType;
                case 'etaImport'
                    fprintf( '\tWave Type                           = Waves with imported wave elevation time-history\n')
                    fprintf(['\tWave Elevation Time-Series File    	= ' obj.etaDataFile '  \n'])
            end
        end
        
        function waveNumber(obj,g)
            % Calculate wave number
            obj.k = obj.w.^2./g;
            if obj.deepWaterWave == 0
                for i=1:100
                    obj.k = obj.w.^2./g./tanh(obj.k.*obj.waterDepth);
                end
            end
        end
        
        function checkinputs(obj)
            % Check user inputs
            % 'noWave' period undefined for hydro data
            if strcmp(obj.type,'noWave')
                if strcmp(obj.T,'NOT DEFINED')
                    error('"waves.T" must be defined for the hydrodynamic data period when using the "noWave" wave type');
                end
            end
            % spectrumDataFile defined for 'spectrumImport' case
            if strcmp(obj.type,'spectrumImport')
                if strcmp(obj.spectrumDataFile,'NOT DEFINED')
                    error('The spectrumDataFile variable must be defined when using the "spectrumImport" wave type');
                end
            end
            % check waves types
            types = {'noWave', 'noWaveCIC', 'regular', 'regularCIC', 'irregular', 'spectrumImport', 'etaImport'};
            if sum(strcmp(types,obj.type)) ~= 1
                error(['Unexpected wave environment type setting, choose from: ' ...
                    '"noWave", "noWaveCIC", "regular", "regularCIC", "irregular", "spectrumImport", and "etaImport".'])
            end
        end
        
        function write_paraview_vtp(obj, t, numPointsX, numPointsY, domainSize, model, simdate, mooring)
            % Write vtp files for visualization using Paraview
            % ground plane
            filename = ['vtk' filesep 'ground.txt'];
            fid = fopen(filename, 'w');
            fprintf(fid,[num2str(domainSize) '\n']);
            fprintf(fid,[num2str(obj.waterDepth) '\n']);
            fprintf(fid,[num2str(mooring) '\n']);
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
                    case{'noWave','noWaveCIC','etaImport'}
                        Z = zeros(size(X));
                    case{'regular','regularCIC'}
                        Xt = X*cos(obj.waveDir*pi/180) + Y*sin(obj.waveDir*pi/180);
                        Z = obj.A * cos(-1 * obj.k * Xt  +  obj.w * t(it));
                    case{'irregular','spectrumImport'}
                        Z = zeros(size(X));
                        Xt = X*cos(obj.waveDir*pi/180) + Y*sin(obj.waveDir*pi/180);
                        for iw = 1:length(obj.w)
                            Z = Z + sqrt(obj.A(iw).*obj.dw(iw)) * cos(-1*obj.k(iw)*Xt + obj.w(iw)*t(it) + obj.phase(iw));
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
            % Sets the irregular wave's random phase
            % Used by waveSetup
            if obj.phaseSeed ~= 0
                rng(obj.phaseSeed); % Phase seed = 1,2,3,...,etc
            else
                rng('shuffle');         % Phase seed shuffled
            end
            switch obj.freqDisc
                case {'EqualEnergy','Traditional'}
                    obj.phase = 2*pi*rand(1,obj.numFreq);
                case {'Imported'}
                    data = dlmread(obj.spectrumDataFile);
                    if size(data,1) == 3
                        freq_data = data(1,:);
                        freq_loc = freq_data>=min(obj.bemFreq)/2/pi & freq_data<=max(obj.bemFreq)/2/pi;
                        phase_data = data(3,freq_loc);
                        obj.phase = phase_data;
                    else
                        obj.phase = 2*pi*rand(1,obj.numFreq);
                    end
            end
            obj.phase = obj.phase';
        end
        
        function setWaveProps(obj,wDepth)
            % Sets global and type-specific properties
            % Used by waveSetup
            if strcmp(wDepth,'infinite')
                obj.deepWaterWave = 1;
                obj.waterDepth = 200;
                fprintf('\tInfinite water depth specified in BEM, "waves.waterDepth" set to 200m for vizualisation.\n')
            else
                obj.deepWaterWave = 0;
                obj.waterDepth = double(wDepth);
            end
            switch obj.type
                case {'noWave'}
                    obj.H = 0;
                    obj.T = obj.T;
                case {'noWaveCIC'}
                    obj.H = 0;
                    obj.w = max(obj.bemFreq);
                    obj.T=2*pi/obj.w;
                case {'spectrumImport'}
                    obj.H = 0;
                    obj.T = 0;
                    obj.freqDisc = 'Imported';
                    obj.spectrumType = 'spectrumImport';
            end
        end
        
        function waveElevNowave(obj,maxIt,dt)
            % Set noWave levation time-history
            obj.waveAmpTime         = zeros(maxIt+1,2);
            obj.waveAmpTimex        = zeros(maxIt+1,2);
            obj.waveAmpTime(:,1)    = [0:maxIt]*dt;
            obj.waveAmpTimex(:,1)   = [0:maxIt]*dt;
        end
        
        function waveElevReg(obj, rampTime,dt,maxIt)
            % Calculate regular wave elevation time history
            % Used by waveSetup
            obj.waveAmpTime = zeros(maxIt+1,2);
            maxRampIT=round(rampTime/dt);
            if rampTime==0
                for i=1:maxIt+1
                    t = (i-1)*dt;
                    obj.waveAmpTime(i,1)    = t;
                    obj.waveAmpTime(i,2)    = obj.A*cos(obj.w*t);
                    obj.waveAmpTimex(i,1)   = t;
                    obj.waveAmpTimex(i,2)   = obj.A*cos(obj.w*t-obj.k*obj.wavegaugeloc);
                end
            else
                for i=1:maxRampIT
                    t = (i-1)*dt;
                    obj.waveAmpTime(i,1)    = t;
                    obj.waveAmpTime(i,2)    = obj.A*cos(obj.w*t)*(1+cos(pi+pi*(i-1)/maxRampIT))/2;
                    obj.waveAmpTimex(i,1)   = t;
                    obj.waveAmpTimex(i,2)   = obj.A*cos(obj.w*t-obj.k*obj.wavegaugeloc)*(1+cos(pi+pi*(i-1)/maxRampIT))/2;
                end
                for i=maxRampIT+1:maxIt+1
                    t = (i-1)*dt;
                    obj.waveAmpTime(i,1)    = t;
                    obj.waveAmpTime(i,2)    = obj.A*cos(obj.w*t);
                    obj.waveAmpTimex(i,1)   = t;
                    obj.waveAmpTimex(i,2)   = obj.A*cos(obj.w*t-obj.k*obj.wavegaugeloc);
                end
            end
        end
        
        function irregWaveSpectrum(obj,g)
            % Calculate wave spectrum vector (obj.A)
            % Used by wavesIrreg (wavesIrreg used by waveSetup)
            freq = obj.w/(2*pi);
            Tp = obj.T;
            Hs = obj.H;
            switch obj.spectrumType
                case 'PM' % Pierson-Moskowitz Spectrum from Tucker and Pitt (2001)
                    B_PM = (5/4)*(1/Tp)^(4);
                    A_PM = g^2*(2*pi)^(-4);
                    S_f_temp = (A_PM*freq.^(-5).*exp(-B_PM*freq.^(-4)));
                    alpha_PM = Hs^(2)/16/trapz(freq,S_f_temp);
                    obj.Sf = alpha_PM*S_f_temp./(2*pi);                              % Wave Spectrum [m^2-s/rad] for 'Traditional'
                    S_f = obj.Sf*2*pi;                                          % Wave Spectrum [m^2-s]
                case 'BS' % Bretschneider Sprectrum from Tucker and Pitt (2001)
                    B_BS = (1.057/Tp)^4;
                    A_BS = B_BS*(Hs/2)^2;
                    S_f = (A_BS*freq.^(-5).*exp(-B_BS*freq.^(-4)));             % Wave Spectrum [m^2-s]
                    obj.Sf = S_f./(2*pi);                                       % Wave Spectrum [m^2-s/rad] for 'Traditional'
                case 'JS' % JONSWAP Spectrum from Hasselmann et. al (1973)
                    [r,~] = size(freq);
                    if r == 1; freq = sort(freq)';
                    else freq = sort(freq); end
                    fp = 1/Tp;
                    siga = 0.07;sigb = 0.09;                                    % cutoff frequencies for gamma function
                    [lind,~] = find(freq<=fp);
                    [hind,~] = find(freq>fp);
                    Gf = zeros(size(freq));
                    Gf(lind) = obj.gamma.^exp(-(freq(lind)-fp).^2/(2*siga^2*fp^2));
                    Gf(hind) = obj.gamma.^exp(-(freq(hind)-fp).^2/(2*sigb^2*fp^2));
                    Sf_temp = g^2*(2*pi)^(-4)*freq.^(-5).*exp(-(5/4).*(freq/fp).^(-4));
                    alpha_JS = Hs^(2)/16/trapz(freq,Sf_temp.*Gf);
                    S_f = alpha_JS*Sf_temp.*Gf;                                 % Wave Spectrum [m^2-s]
                    obj.Sf = S_f./(2*pi);                                       % Wave Spectrum [m^2-s/rad] for 'Traditional'
                    freq = freq';
                case 'spectrumImport' % Imported Wave Spectrum
                    data = dlmread(obj.spectrumDataFile);
                    freq_data = data(1,:);
                    Sf_data = data(2,:);
                    freq_loc = freq_data>=min(obj.bemFreq)/2/pi & freq_data<=max(obj.bemFreq)/2/pi;
                    S_f = Sf_data(freq_loc)';
                    obj.Sf = S_f./(2*pi);                                       % Wave Spectrum [m^2-s/rad] for 'Traditional'
                    fprintf('\t"spectrumImport" uses the number of imported wave frequencies (not "Traditional" or "EqualEnergy")\n')
            end
            switch obj.freqDisc
                case {'EqualEnergy'}
                    m0 = trapz(freq,abs(S_f));
                    numBins = obj.numFreq+1;
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
                    obj.w = 2*pi*freq(wn(2:end-1))';
                    obj.dw = [obj.w(1)-2*pi*freq(wn(1)); diff(obj.w)];
                    if strcmp(obj.spectrumType,'JS') ==1
                        obj.Sf = obj.Sf(wn(2:end-1));                           % Wave Spectrum [m^2-s/rad] for 'EqualEnergy'
                    else
                        obj.Sf = obj.Sf(wn(2:end-1))';                          % Wave Spectrum [m^2-s/rad] for 'EqualEnergy'
                    end
            end
            obj.A = 2 * obj.Sf;                                                 % Wave Amplitude [m]
        end
        
        function waveElevIrreg(obj,rampTime,dt,maxIt,df,wavegaugeloc)
            % Calculate irregular wave elevetaion time history
            % Used by waveSetup
            obj.waveAmpTime = zeros(maxIt+1,2);
            maxRampIT=round(rampTime/dt);
            if rampTime==0
                for i=1:maxIt+1
                    t       = (i-1)*dt;
                    tmp     = sqrt(obj.A.*df);
                    tmp1    = tmp.*real(exp(sqrt(-1).*(obj.w.*t + obj.phase)));
                    tmp1x   = tmp.*real(exp(sqrt(-1).*(obj.w.*t - obj.k*obj.wavegaugeloc + obj.phase)));
                    obj.waveAmpTime(i,1)    = t;
                    obj.waveAmpTime(i,2)    = sum(tmp1);
                    obj.waveAmpTimex(i,1)   = t;
                    obj.waveAmpTimex(i,2)   = sum(tmp1x);
                end
            else
                for i=1:maxRampIT
                    t = (i-1)*dt;
                    tmp=sqrt(obj.A.*df);
                    tmp1    = tmp.*real(exp(sqrt(-1).*(obj.w.*t + obj.phase)));
                    tmp1x   = tmp.*real(exp(sqrt(-1).*(obj.w.*t - obj.k*obj.wavegaugeloc + obj.phase)));
                    obj.waveAmpTime(i,1)    = t;
                    obj.waveAmpTime(i,2)    = sum(tmp1)*(1+cos(pi+pi*(i-1)/maxRampIT))/2;
                    obj.waveAmpTimex(i,1)   = t;
                    obj.waveAmpTimex(i,2)   = sum(tmp1x)*(1+cos(pi+pi*(i-1)/maxRampIT))/2;
                end
                for i=maxRampIT+1:maxIt+1
                    t = (i-1)*dt;
                    tmp=sqrt(obj.A.*df);
                    tmp1  = tmp.*real(exp(sqrt(-1).*(obj.w.*t + obj.phase)));
                    tmp1x = tmp.*real(exp(sqrt(-1).*(obj.w.*t - obj.k*obj.wavegaugeloc + obj.phase)));
                    obj.waveAmpTime(i,1)    = t;
                    obj.waveAmpTime(i,2)    = sum(tmp1);
                    obj.waveAmpTimex(i,1)   = t;
                    obj.waveAmpTimex(i,2)   = sum(tmp1x);
                end
            end
        end
        
        function waveElevUser(obj,rampTime,dt,maxIt,data, t)
            % Calculate imported wave elevation time history
            % Used by waveSetup
            obj.waveAmpTime = zeros(maxIt+1,2);
            maxRampIT=round(rampTime/dt);
            data_t = data(:,1)';                    % Data Time [s]
            data_x = data(:,2)';                    % Wave Surface Elevation [m]
            obj.waveAmpTime(:,1) = t;
            obj.waveAmpTime(:,2) = interp1(data_t,data_x,t);
            if rampTime~=0
                for i=1:maxRampIT
                    obj.waveAmpTime(i,2) = obj.waveAmpTime(i,2)*(1+cos(pi+pi*(i-1)/maxRampIT))/2;
                end
            end
        end
        
        function printWaveSpectrumType(obj)
            % Lists the wave spectrum type
            % Used by listInfo
            if strcmp(obj.spectrumType,'BS')
                fprintf('\tSpectrum Type                        = Bretschneider \n')
            elseif strcmp(obj.spectrumType,'JS')
                fprintf('\tSpectrum Type                        = JONSWAP \n')
            elseif strcmp(obj.spectrumType,'PM')
                fprintf('\tSpectrum Type                        = Pierson-Moskowitz  \n')
            elseif strcmp(obj.spectrumType,'spectrumImport')
                fprintf('\tSpectrum Type                        = Imported Spectrum \n')
            end
        end
    end
end

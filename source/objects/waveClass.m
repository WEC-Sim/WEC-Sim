%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef waveClass<handle  
    properties
        type                        = 'NOT DEFINED'                        % Wave type. Options for this varaibale are 'noWave' (no waves), 'regular' (regular waves), 'regularCIC' (regular waves using convolution integral to calculate radiation effects), 'irregular' (irregular waves), 'irregularPRE' (irregular waves with pre defined phase). The default is 'regular'.
        spectrumDataFile            = 'NOT DEFINED'                        % Data file that contains the spectrum data file        
        typeNum                     = [] % make dependent                  % Number to represent different type of waves
        T                           = 'NOT DEFINED'                        % [s] Wave period (regular waves) or peak period (irregular waves) (default = 8)
        H                           = 'NOT DEFINED'                        % [m] Wave height (regular waves) or significant wave height (irregular waves) (default = 1)
        A                           = [] % make dependent                  % [m] Wave amplitude for regular waves or sqrt(wave spectrum vector) for irregular waves
        w                           = [] % make dependent                  % [rad/s] Wave frequency (regular waves) or wave frequency vector (irregular waves)
        waveAmpTime                 = 999                                  % [m] Wave elevation time history
        phaseRand                   = 999                                  % [rad] Random wave phase (only used for irregular waves)
        numFreq                     = [] % make dependent                  % Number of interpolated wave frequencies (default = 'NOT DEFINED') 
        bemFreq                     = [] % make dependent                  % Number of wave frequencies from WAMIT
        waterDepth                  = [] % make dependent                  % [m] Water depth (from WAMIT)
        spectrumType                = 'NOT DEFINED'                        % Type of wave spectrum. Only PM, BS, JS, and Imported spectrum are supported.
        noWaveHydrodynamicCoeffT    = 'NOT DEFINED'                        % Period of BEM simulation used to determine hydrodynamic coefficients for simulations with no wave. This option is only used with the 'noWave' wave type.
        randPreDefined              = 0;                                   % Only used for irregular waves. Default is equal to 0; if it equals to 1, the waves pahse is pre-defined
    end
    
    methods
        
        function obj = waveClass(type,H,T,simu,spectrumType,randPreDefined,spectrumDataFile)                % Wave class function
            fprintf('Initializing the Wave Class...\n')
            obj.numFreq = simu.numFreq;
            obj.T = T;
            obj.H = H;
            obj.type = type;
            if nargin == 7                
               obj.spectrumType = spectrumType;
               obj.randPreDefined = randPreDefined;
               obj.spectrumDataFile = spectrumDataFile;
            end  
            fprintf('\nWave Environment: \n')
            switch type
                case 'noWave'           % No Wave 
                    obj.typeNum = 10;
                    fprintf('\tWave Type                            = No Wave\n')                    
                case 'regular'          % Regular Waves
                    obj.typeNum = 10;
                    fprintf('\tWave Type                            = Regular Waves (Sinusoidal Steady-State)\n')                    
                    fprintf('\tWave Height H                    (m) = %G\n',obj.H)                    
                    fprintf('\tWave Period T                  (sec) = %G\n',obj.T)                    
                case 'noWaveCIC'           % No Wave CIC
                    obj.typeNum = 11;
                    fprintf('\tWave Type                            = No Wave\n')                    
                case 'regularCIC'       % Regular Waves w/Convulition Integral Calculation
                    obj.typeNum = 11;
                    fprintf('\tWave Type                            = Regular Waves (Convulition Integral Calculation)\n')                    
                    fprintf('\tWave Height H                    (m) = %G\n',obj.H)                    
                    fprintf('\tWave Period T                  (sec) = %G\n',obj.T)                    
                case 'irregular'        % Irregular Waves
                    obj.typeNum = 20; 
                    if obj.randPreDefined ==0
                       obj.setWavePhase;    
                       fprintf('\tWave Type                            = Irregular Waves (Arbitrary Random Phase)\n')                    
                    elseif obj.randPreDefined ==1
                       obj.setWavePhasePRE(1);  
                       fprintf('\tWave Type                            = Irregular Waves (Predefined Random Phase)\n')                    
                    else
                        error('0 or 1 can be used for waves.randPreDefined')                    
                    end
                    obj.printWaveSpectrumType;   
                    fprintf('\tSignificant Wave Height Hs       (m) = %G\n',obj.H)                    
                    fprintf('\tPeak Wave Period Tp            (sec) = %G\n',obj.T)                         
                case 'irregularImport'      %  Irregular Waves w/Predefined Phase
                    obj.typeNum = 21;
                    if obj.randPreDefined ==0
                       obj.setWavePhase;    
                       fprintf('\tWave Type                            = Irregular Waves (Arbitrary Random Phase)\n')                    
                    elseif obj.randPreDefined ==1
                       obj.setWavePhasePRE(1);  
                       fprintf('\tWave Type                            = Irregular Waves (Predefined Random Phase)\n')                    
                    else
                        error('0 or 1 can be used for waves.randPreDefined')                    
                    end
                    obj.printWaveSpectrumType;      
            end
        end

        function obj = printWaveSpectrumType(obj)
        % Print out wave spectra type
               if strcmp(obj.spectrumType,'BS')
                    fprintf('\tSpectrum Type                        = Bretschneider \n')                    
               elseif strcmp(obj.spectrumType,'JS')
                    fprintf('\tSpectrum Type                        = JONSWAP \n')                    
               elseif strcmp(obj.spectrumType,'PM')
                    fprintf('\tSpectrum Type                        = Pierson-Moskowitz  \n')                    
               elseif strcmp(obj.spectrumType,'Imported')
                    fprintf('\tSpectrum Type                        = User-Defined \n')                    
               else
                    error('Only PM, BS, JS, and User-Defined spectrum are supported at this time')                    
               end            
        end
        
        function obj = setWavePhase(obj)
        % function for setup wave random phase
            obj.phaseRand = 2*pi*rand(1,obj.numFreq);
        end

        function obj = setWavePhasePRE(obj,seed)
        % function for setup wave random phase with fixed seed (same random function everytime)
            rng(seed);
            obj.phaseRand = 2*pi*rand(1,obj.numFreq);
        end

    end
end
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
% Set Wave Environment
switch waves.type
    case {'noWave'}       % No Wave
            if strcmp(waves.noWaveHydrodynamicCoeffT,'NOT DEFINED')
                error('The noWaveHydrodynamicCoeffT variable must be defined when using the "noWave" wave type');
            end
            waves = waveClass(waves.type,0,waves.noWaveHydrodynamicCoeffT,simu); %H is equal to 0.
            waves.bemFreq    = body(1).hydro.data.frequency;    % Frequencies from WAMIT
            waves.waterDepth = body(1).hydro.data.waterDepth;   % Water Depth from WAMIT
            [waves.waveAmpTime,waves.A,waves.w]=wavesReg(waves,simu);
     case {'noWaveCIC'}       % No WaveCIC
            waves = waveClass(waves.type,0,0,simu); %H is equal to 0.
            waves.bemFreq    = body(1).hydro.data.frequency;    % Frequencies from WAMIT
            waves.waterDepth = body(1).hydro.data.waterDepth;   % Water Depth from WAMIT
            [waves.waveAmpTime,waves.A,waves.w]=wavesReg(waves,simu);
            waves.w = 0;                            %w is equal to 0 to avoid infinity             
    case {'regular','regularCIC'}        % Regular Waves
            waves = waveClass(waves.type,waves.H,waves.T,simu);
            waves.bemFreq    = body(1).hydro.data.frequency;    % Frequencies from WAMIT
            waves.waterDepth = body(1).hydro.data.waterDepth;   % Water Depth from WAMIT
            [waves.waveAmpTime,waves.A,waves.w]=wavesReg(waves,simu);
    case {'irregular'}      % Irregular Waves
            waves = waveClass(waves.type,waves.H,waves.T,simu,waves.spectrumType,waves.randPreDefined,'none');
            waves.bemFreq    = body(1).hydro.data.frequency;    % Frequencies from WAMIT
            waves.waterDepth = body(1).hydro.data.waterDepth;   % Water Depth from WAMIT
            [waves.waveAmpTime,waves.A,waves.w]=wavesIrreg(waves,simu);
    case {'irregularImport'}      % Irregular Waves
            waves = waveClass(waves.type,0,0,simu,'Imported',waves.randPreDefined,waves.spectrumDataFile);
            waves.bemFreq    = body(1).hydro.data.frequency;    % Frequencies from WAMIT
            waves.waterDepth = body(1).hydro.data.waterDepth;   % Water Depth from WAMIT
            [waves.waveAmpTime,waves.A,waves.w]=wavesIrreg(waves,simu);
    otherwise
            error('Unexpected wave environment type setting');
end

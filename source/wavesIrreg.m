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

function [waveAmpTime,Sf,frequency] = wavesIrreg(waves,simu)
% Define Function Inputs
maxRampIT=round(simu.rampT/simu.dt);% Max Wave Ramp Iteration
numFqs=waves.numFreq;               % Number of Wave Frequencies
WFQSt=min(waves.bemFreq);           % Min BEM Frequnecy [rad/s]
WFQEd=max(waves.bemFreq);           % Max BEM Frequnecy [rad/s]
df  = (WFQEd-WFQSt)/(numFqs-1);     % Delta Frequency [rad/s]

% Define Hs and Tp for Spectrum Definition
frequency = (WFQSt:df:WFQEd)';      % [rad/s]
freq = frequency/(2*pi);            % [Hz]
Tp = waves.T;                       % Peak Period[s]
Hs = waves.H;                       % Sig Wave Height[m]
g = 9.81;                           % Gravity [m/s/s]

switch waves.spectrumType
    case 'BS'       
        % Bretschneider Sprectrum from Tucker and Pitt (2001)
        B = (1.057/Tp)^4;
        A = B*(Hs/2)^2;
        S_f = (A*freq.^(-5).*exp(-B*freq.^(-4)));    
        Sf = S_f./(2*pi);                            

    case 'JS'      
        % JONSWAP Spectrum from Hasselmann et. al (1973)
        [S] = wecSimJonswap(freq,Hs,Tp); 
        Sf = S./(2*pi);
              
    case 'PM' 
        % Pierson-Moskowitz Spectrum from Tucker and Pitt (2001)
        B = (5/4)*(1/Tp)^(4);
        A = g^2*(2*pi)^(-4);
        S_f = (A*freq.^(-5).*exp(-B*freq.^(-4)));    
        %alpha = 0.0081;
        %% Alpha Coefficient
        alpha = Hs^(2)/16/trapz(freq,S_f);%Calculates the required \alpha_{j} coefficient to achieve the desired Hs
                                 %freq must be in ascending order, i.e., 1,2,3,4 or integration will result in negative summation
        Sf = alpha*S_f./(2*pi);          
                           
    case 'Imported' 
        %Imported Spectrum
        data = dlmread(waves.spectrumDataFile);
        freq_data = data(1,:);       % Buoy Freuqnecies [Hz]
        Sf_data = data(2,:);        % Buoy Sprectal Data [m^2-s]
        S_f = interp1(freq_data,Sf_data,freq,'pchip',0);   % Interpolated Spectral Data [m^2-s]
        Sf = S_f./(2*pi); 
end


%%  Calulate wave history
waveAmpTime = zeros(simu.maxIt+1,1);
% No wave ramping defined
if simu.rampT==0    
   for i=1:simu.maxIt+1;
       t = (i-1)*simu.dt;
       for j=1:numFqs
           tmp=sqrt(2*Sf(j)*df);
           waveAmpTime(i) = waveAmpTime(i) + tmp*real(exp(sqrt(-1)*(frequency(j)*t + waves.phaseRand(j))));
       end

   end
% If wave ramping defined
else    
   for i=1:maxRampIT
       t = (i-1)*simu.dt;

       for j=1:numFqs
           tmp=sqrt(2*Sf(j)*df);
           waveAmpTime(i) = waveAmpTime(i) + tmp*real(exp(sqrt(-1)*(frequency(j)*t + waves.phaseRand(j))));
       end
       waveAmpTime(i) = waveAmpTime(i)*(1+cos(pi+pi*(i-1)/maxRampIT))/2;
   end
   for i=maxRampIT+1:simu.maxIt+1
       t = (i-1)*simu.dt;

       for j=1:numFqs
           tmp=sqrt(2*Sf(j)*df);
           waveAmpTime(i) = waveAmpTime(i) + tmp*real(exp(sqrt(-1)*(frequency(j)*t + waves.phaseRand(j))));
       end
   end   
end


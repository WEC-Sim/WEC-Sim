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

function [hydro, hydroForce] = hydroForce_Reg(HH, TT, hydro, system)

w=2*pi/TT;
waveAmp=HH/2;

% Calulate wave history
if system.rampT==0
   for i=1:system.maxIt+1;
       t = (i-1)*system.dt;
       hydroForce.waveAmpTime(i) = waveAmp*cos(w*t);
   end
else
   for i=1:system.maxIt+1;
       t = (i-1)*system.dt;
       hydroForce.waveAmpTime(i) = waveAmp*cos(w*t)*tanh(3.141592654*t/system.rampT);
   end    
end

% Interpolate the hydrodynamic coefficients based on the given wave period
for i=1:hydro.WAMIT.NBODY
    for kd=1:6
        num=kd+(i-1)*6;
        for kk=1:6
            num2=kk+(i-1)*6;
            tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fadm(num,num2,1:hydro.WAMIT.NPER);
            hydro.intp.Fadm(kd,kk) = interp1(hydro.WAMIT.frequency,tmp,w,'spline');
        end
        
        for kk=1:6
            num2=kk+(i-1)*6;
            tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fdmp(num,num2,1:hydro.WAMIT.NPER);
            hydro.intp.Fdmp(kd,kk) = interp1(hydro.WAMIT.frequency,tmp,w,'spline');
        end
        
    end
    evalc(['hydroForce.Fadm_' num2str(i) '=  hydro.intp.Fadm']);
    evalc(['hydroForce.Fdmp_' num2str(i) '=  hydro.intp.Fdmp']);
end

%  Interpolate the hydrodynamic exciataion force coefficients based on 
%  the given wave period and Calculate excitation force time series
for i=1:hydro.WAMIT.NBODY
    for kd=1:6
        num=kd+(i-1)*6;
        tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fext.Re(num,1:hydro.WAMIT.NPER,1);
        hydro.intp.Fext.Re(num) = interp1(hydro.WAMIT.frequency,tmp,w,'spline');
        
        tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fext.Im(num,1:hydro.WAMIT.NPER,1);
        hydro.intp.Fext.Im(num) = interp1(hydro.WAMIT.frequency,tmp,w,'spline');        
    end

    temp = zeros(system.maxIt+1,6);
    if system.rampT==0
       for j=1:system.maxIt;
           t = (j-1)*system.dt;
           for kd=1:6
               num=kd+(i-1)*6;
               temp(j,kd) = waveAmp*(hydro.intp.Fext.Re(num)*cos(w*t)  ...
                                   - hydro.intp.Fext.Im(num)*sin(w*t));
           end
       end
    else
       for j=1:system.maxIt;
           t = (j-1)*system.dt;
           for kd=1:6
               num=kd+(i-1)*6;
               temp(j,kd) = waveAmp*(hydro.intp.Fext.Re(num)*cos(w*t)  ...
                                   - hydro.intp.Fext.Im(num)*sin(w*t)) ...
                          * tanh(3.141592654*t/system.rampT);
           end
       end        
    end
    evalc(['hydroForce.F_extTime_' num2str(i) '= temp']);    
    clear temp;
end

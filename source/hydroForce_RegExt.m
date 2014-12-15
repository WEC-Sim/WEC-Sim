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

function [hydroForce] = hydroForce_RegExt(hydro,waves)

%% Excitation force
%  Interpolate the hydrodynamic exciataion force coefficients based on 
%  the given wave period and Calculate excitation force time series
w=waves.w;
for i=1:hydro.WAMIT.NBODY
    for kd=1:6
        num=kd+(i-1)*6;
        tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fext.Re(num,1:hydro.WAMIT.NPER,1);
        hydroForce.Fext.Re(kd,i) = interp1(hydro.WAMIT.frequency,tmp,w,'spline');
        
        tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fext.Im(num,1:hydro.WAMIT.NPER,1);
        hydroForce.Fext.Im(kd,i) = interp1(hydro.WAMIT.frequency,tmp,w,'spline');        
    end
end

%% Added mass and damping

w=waveEnv.w;
% Interpolate the hydrodynamic coefficients based on the given wave period
for i=1:hydro.WAMIT.NBODY
    for kd=1:6
        num=kd+(i-1)*6;
        for kk=1:6
            num2=kk+(i-1)*6;
            tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fadm(num,num2,1:hydro.WAMIT.NPER);
            hydroForce.Fadm(kd,kk,i) = interp1(hydro.WAMIT.frequency,tmp,w,'spline');
        end
        
        for kk=1:6
            num2=kk+(i-1)*6;
            tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fdmp(num,num2,1:hydro.WAMIT.NPER);
            hydroForce.Fdmp(kd,kk,i) = interp1(hydro.WAMIT.frequency,tmp,w,'spline');
        end
        
    end
end

hydroForce.IRKA=zeros(CIkt+1,6,6,hydro.WAMIT.NBODY);
hydroForce.IRKB=zeros(CIkt+1,6,6,hydro.WAMIT.NBODY);
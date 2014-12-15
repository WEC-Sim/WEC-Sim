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

function [hydroForce] = hydroForce_IRK(hydro, hydroForce, simulation, numFqs)

CIkt= simulation.CIkt;
dt  = simulation.dt;

%  Interpolate the hydrodynamic coefficients based on the given wave period
%  *** NEED TO UPDATE DIRECTIONAL WAVE CAPABILITY ***
WFQSt=min(hydro.WAMIT.frequency);
WFQEd=max(hydro.WAMIT.frequency);

df  = (WFQEd-WFQSt)/(numFqs-1);
fq = WFQSt:df:WFQEd;

for i=1:hydro.WAMIT.NBODY
    for j = 1:numFqs

        w = fq(j);
        for kd=1:6
            num=kd+(i-1)*6;
            for kk=1:6
                num2=kk+(i-1)*6;
                tmp(1:hydro.WAMIT.NPER)= hydro.WAMIT.Fadm   (num,num2,1:hydro.WAMIT.NPER);
                Fadm(j,kd,kk) = interp1(hydro.WAMIT.frequency,tmp,w,'linear','extrap');
            end
            for kk=1:6
                num2=kk+(i-1)*6;            
                tmp(1:hydro.WAMIT.NPER)= hydro.WAMIT.Fdmp   (num,num2,1:hydro.WAMIT.NPER);
                Fdmp(j,kd,kk) = interp1(hydro.WAMIT.frequency,tmp,w,'linear','extrap');
            end
        end
    end
    for kt=1:CIkt+1;
        t = dt*(kt-1);
        for kd=1:6
            num=kd+(i-1)*6;
            for kk=1:6
                num2=kk+(i-1)*6;                       
                tmpY=fq(:).*(Fadm(:,kd,kk)-hydro.WAMIT.Fadm_ZoP(num,num2)).*sin(fq(:)*t);
                hydroForce.IRKA(kt,kd,kk,i) =-2./pi*trapz(fq,tmpY);
                tmpY=Fdmp(:,kd,kk).*cos(fq(:)*t);
                hydroForce.IRKB(kt,kd,kk,i) = 2./pi*trapz(fq,tmpY);
           end
        end
    end; clear tmp tmpY;

    for kd=1:6
        num=kd+(i-1)*6;
        for kk=1:6
            num2=kk+(i-1)*6;                  
            hydroForce.Fadm(kd,kk,i)=hydro.WAMIT.Fadm_ZoP(num,num2);
        end
    end
    hydroForce.Fdmp(:,:,i)=zeros(6,6);    
end

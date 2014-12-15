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

function [hydro, hydroForce] = hydroForce_Irr(HH, TT, hydro, system,waves)

string=['Hs=',num2str(HH),' m, Tp=',num2str(TT),' sec'];
disp(string);

hydro.waves.WFQSt=min(hydro.WAMIT.frequency);
hydro.waves.WFQEd=max(hydro.WAMIT.frequency);
hydro.intp.df  = (hydro.waves.WFQEd-hydro.waves.WFQSt)/(waves.numPeriods-1);
hydro.intp.frequency = [hydro.waves.WFQSt:hydro.intp.df:hydro.waves.WFQEd]';
hydro.intp.period    = 2*pi./hydro.intp.frequency;

%call JONSWAP frequency from WAFO
IrrSeaStates = bretschneider(linspace(hydro.waves.WFQSt,hydro.waves.WFQEd,400), [HH TT], []);

for i=1:waves.numPeriods
    hydro.waves.Sf(i) = interp1(IrrSeaStates.w, IrrSeaStates.S, hydro.intp.frequency(i));
end

%  Calulate wave history
if system.numerical.rampTime==0
   for i=1:system.numerical.maxIt+1;
       hydroForce.waveAmpTime(i) = 0;
       t = (i-1)*system.numerical.dt;
       for j=1:waves.numPeriods
           w = hydro.intp.frequency(j);
           tmp=sqrt(2*hydro.waves.Sf(j)*hydro.intp.df);
           hydroForce.waveAmpTime(i) = hydroForce.waveAmpTime(i) + tmp*real(exp(sqrt(-1)*(w*t + waves.randPhase(j))));
       end
       
   end
else
   for i=1:system.numerical.maxIt+1;
       hydroForce.waveAmpTime(i) = 0;
       t = (i-1)*system.numerical.dt;
       for j=1:waves.numPeriods
           w = hydro.intp.frequency(j);
           tmp=sqrt(2*hydro.waves.Sf(j)*hydro.intp.df);
           hydroForce.waveAmpTime(i) = hydroForce.waveAmpTime(i) + tmp*real(exp(sqrt(-1)*(w*t + waves.randPhase(j))));
       end
       hydroForce.waveAmpTime(i) = hydroForce.waveAmpTime(i)*tanh(3.141592654*t/system.numerical.rampTime);
   end    
end

%  Interpolate the hydrodynamic coefficients based on the given wave period
%  *** NEED TO UPDATE DIRECTIONAL WAVE CAPABILITY ***
for i=1:hydro.WAMIT.NBODY
    for j = 1:waves.numPeriods
        w = hydro.intp.frequency(j);
        for kd=1:6
            num=kd+(i-1)*6;
            
            tmp(1:hydro.WAMIT.NPER)= hydro.WAMIT.Fadm   (num,num,1:hydro.WAMIT.NPER);
            hydro.intp.Fadm(j,num) = interp1(hydro.WAMIT.frequency,tmp,w,'spline','extrap');

            tmp(1:hydro.WAMIT.NPER)= hydro.WAMIT.Fdmp   (num,num,1:hydro.WAMIT.NPER);
            hydro.intp.Fdmp(j,num) = interp1(hydro.WAMIT.frequency,tmp,w,'spline','extrap');

            tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fext.Re(num,1:hydro.WAMIT.NPER,1);
            hydro.intp.Fext_Re (j,num) = interp1(hydro.WAMIT.frequency,tmp,w,'spline','extrap');

            tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fext.Im(num,1:hydro.WAMIT.NPER,1);
            hydro.intp.Fext_Im (j,num) = interp1(hydro.WAMIT.frequency,tmp,w,'spline','extrap');

%             hydro.intp.Fadm(num)       = hydro.WAMIT.Fadm_ZoP(num,num);
%             hydro.intp.Fadm(j,num)     = hydro.intp.Fadm_tmp;
%             hydro.intp.Fdmp(j,num)     = hydro.intp.Fdmp_tmp;
%             hydro.intp.Fext.Re(j,num)  = hydro.intp.Fext_Re;
%             hydro.intp.Fext.Im(j,num)  = hydro.intp.Fext_Im;
        end
    end
    for kd=1:6
        num=kd+(i-1)*6;
        Adm_tmp(kd)=hydro.WAMIT.Fadm_ZoP(num,num);
        Dmp_tmp(kd)=hydro.WAMIT.Fdmp_ZoP(num,num);
    end
    Adm_tmp=Adm_tmp';
    Dmp_tmp=Dmp_tmp';
    evalc(['hydroForce.Fadm_' num2str(i) '=  Adm_tmp']);
    evalc(['hydroForce.Fdmp_' num2str(i) '=  Dmp_tmp']);
end

%  Calculate wave excitation force
for j=1:hydro.WAMIT.NBODY
    temp = zeros(system.numerical.maxIt+1,6);    
    for i=1:system.numerical.maxIt+1;
        t = (i-1)*system.numerical.dt;
        for kd=1:6
            num=kd+(j-1)*6;
            F_ext=0;
            for k=1:waves.numPeriods
                w  = hydro.intp.frequency(k);
                tmp= sqrt(2*hydro.waves.Sf(k)*hydro.intp.df);
                F_ext = F_ext + tmp*(hydro.intp.Fext_Re(k,num)*cos(w*t+waves.randPhase(k)) ...
                    -hydro.intp.Fext_Im(k,num)*sin(w*t+waves.randPhase(k)));
            end
            temp(i,kd) = F_ext;
        end
    end
    evalc(['hydroForce.F_extTime_' num2str(j) '= temp']);    
    clear temp;    
end

% Impulse Response calculation
hydro.CI.time = 100;
hydro.CI.kt   = hydro.CI.time/system.numerical.dt;
for i=1:hydro.WAMIT.NBODY
    tempS = zeros(hydro.CI.kt+1,6); 
    tempC = zeros(hydro.CI.kt+1,6); 
    for kt=1:hydro.CI.kt;
        dt=system.numerical.dt;
        t = dt*(kt-1);
        for kd=1:6
            num=kd+(i-1)*6;
            tmp=0*(hydro.WAMIT.Fadm_InP(num,num)-hydro.WAMIT.Fadm_ZoP(num,num))*sin(0*t);
            for k=1:1:waves.numPeriods
                tmp=tmp+2*hydro.intp.frequency(k)*(hydro.intp.Fadm(k,num)-hydro.WAMIT.Fadm_ZoP(num,num))*sin(hydro.intp.frequency(k)*t);
            end
            tempS(kt,kd) =-2./pi.*tmp*(hydro.intp.frequency(2)-hydro.intp.frequency(1))/2;
            tmp=0*cos(0*t);
            for k=1:1:waves.numPeriods
                tmp= tmp+2*hydro.intp.Fdmp(k,num)*cos(hydro.intp.frequency(k)*t);
            end
            tempC(kt,kd) = 2./pi.*tmp*(hydro.intp.frequency(2)-hydro.intp.frequency(1))/2;
        end
    end
    evalc(['hydroForce.IRKS_' num2str(j) '= tempS']);    
    evalc(['hydroForce.IRKC_' num2str(j) '= tempC']);    
    clear tempS;
    clear tempC;    
end; clear tmp;

% trapz(system.Res.time(maxIt/2+1:maxIt),system.Res.PowerTime(maxIt/2+1:maxIt))

%  Calculate all the force coefficients
% for i=1:hydro.WAMIT.NBODY
%     for kd=1:6
%         hydro.td.C_Res(kd,i)= hydro.model.HGRes(kd,i);                     % Restoring
%         hydro.td.C_Dmp(kd,i)= 0;                                           % Radiation damping
%         hydro.td.C_vis(kd,i)= hydro.visDmp.Cd(kd,i) ...
%             / 2*hydro.model.area(kd,i)*hydro.properties.density;           % Viscous damping
%     end
% end


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

function bodyTemp = irfInfAddedMassAndDamping(bodyTemp,simu)

%  *** NEED TO UPDATE DIRECTIONAL WAVE CAPABILITY ***
WFQSt=min(bodyTemp.hydro.data.frequency);
WFQEd=max(bodyTemp.hydro.data.frequency);
df  = (WFQEd-WFQSt)/(simu.numFreq-1);
w = WFQSt:df:WFQEd;

% fAddedMass=zeros(simu.numFreq,6,6);
fDamping  =zeros(simu.numFreq,6,6);
for j = 1:simu.numFreq
    for ii=1:6
        for jj=1:6
%                 tmp = reshape(bodyTemp.hydro.data.fAddedMass(ii,jj,:),1,length(bodyTemp.hydro.data.period));
%                 fAddedMass(j,ii,jj) = interp1(bodyTemp.hydro.data.frequency,tmp,w(j),'linear');

                tmp = reshape(bodyTemp.hydro.data.fDamping  (ii,jj,:),1,length(bodyTemp.hydro.data.period));
                fDamping  (j,ii,jj) = interp1(bodyTemp.hydro.data.frequency,tmp,w(j),'linear');
                
        end; clear tmp;
    end
end    

% bodyTemp.hydroForce.irka=zeros(simu.CIkt+1,6,6);
bodyTemp.hydroForce.irkb=zeros(simu.CIkt+1,6,6);
for kt=1:simu.CIkt+1;
    t = simu.dt*(kt-1);
    for ii=1:6
        for jj=1:6
%             tmp = w(:).*(fAddedMass(:,ii,jj)-bodyTemp.hydro.data.fAddedMassZero(ii,jj)).*sin(w(:)*t);
%             bodyTemp.hydroForce.irka(kt,ii,jj) =-2./pi*trapz(w,tmp);
            tmp=fDamping(:,ii,jj).*cos(w(:)*t);
            bodyTemp.hydroForce.irkb(kt,ii,jj) = 2./pi*trapz(w,tmp);
        end
    end; clear tmp;
end

bodyTemp.hydroForce.fAddedMass=bodyTemp.hydro.data.fAddedMassZero;
bodyTemp.hydroForce.fDamping=zeros(6,6);    

end
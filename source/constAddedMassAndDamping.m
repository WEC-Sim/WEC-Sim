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

function bodyTemp = constAddedMassAndDamping(bodyTemp,waves,simu)
bodyTemp.hydroForce.fAddedMass=zeros(6,6);
bodyTemp.hydroForce.fDamping  =zeros(6,6);
for ii=1:6
    for jj=1:6
        tmp = reshape(bodyTemp.hydro.data.fAddedMass(ii,jj,:),1,length(bodyTemp.hydro.data.period));
        bodyTemp.hydroForce.fAddedMass(ii,jj) = interp1(bodyTemp.hydro.data.frequency,tmp,waves.w,'spline');

        tmp = reshape(bodyTemp.hydro.data.fDamping  (ii,jj,:),1,length(bodyTemp.hydro.data.period));
        bodyTemp.hydroForce.fDamping  (ii,jj) = interp1(bodyTemp.hydro.data.frequency,tmp,waves.w,'spline');
    end
end

bodyTemp.hydroForce.irka=zeros(simu.CIkt+1,6,6);
bodyTemp.hydroForce.irkb=zeros(simu.CIkt+1,6,6);
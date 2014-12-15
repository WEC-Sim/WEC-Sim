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

function bodyTemp = irrExcitation(bodyTemp,waves)
bodyTemp.hydroForce.fExt.re=zeros(waves.numFreq,6);
bodyTemp.hydroForce.fExt.im=zeros(waves.numFreq,6);
for i = 1:waves.numFreq
    w = waves.w(i);
    for ii=1:6
        bodyTemp.hydroForce.fExt.re(i,ii) = interp1(bodyTemp.hydro.data.frequency,bodyTemp.hydro.data.fExt.Re(ii,:),w,'linear');    
        bodyTemp.hydroForce.fExt.im(i,ii) = interp1(bodyTemp.hydro.data.frequency,bodyTemp.hydro.data.fExt.Im(ii,:),w,'linear');      
    end
end

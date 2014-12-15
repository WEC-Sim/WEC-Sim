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

function bodyTemp = regExcitation(bodyTemp,waves)
bodyTemp.hydroForce.fExt.re=zeros(1,6);
bodyTemp.hydroForce.fExt.im=zeros(1,6);
for ii=1:6
    bodyTemp.hydroForce.fExt.re(ii) = interp1(bodyTemp.hydro.data.frequency,bodyTemp.hydro.data.fExt.Re(ii,:),waves.w,'spline');
    bodyTemp.hydroForce.fExt.im(ii) = interp1(bodyTemp.hydro.data.frequency,bodyTemp.hydro.data.fExt.Im(ii,:),waves.w,'spline');      
end
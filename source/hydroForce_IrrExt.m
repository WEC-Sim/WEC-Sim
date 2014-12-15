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

function [hydroForce] = hydroForce_IrrExt(hydro,waves)


%  Calculate wave excitation force Re and Im parts
for j=1:hydro.WAMIT.NBODY
    for i = 1:waves.numFqs

        w = waves.w(i);
        for kd=1:6
            num=kd+(j-1)*6;
            
            tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fext.Re(num,1:hydro.WAMIT.NPER,1);
            hydroForce.Fext.Re (i,kd,j) = interp1(hydro.WAMIT.frequency,tmp,w,'linear','extrap');

            tmp(1:hydro.WAMIT.NPER)=hydro.WAMIT.Fext.Im(num,1:hydro.WAMIT.NPER,1);
            hydroForce.Fext.Im (i,kd,j) = interp1(hydro.WAMIT.frequency,tmp,w,'linear','extrap');

        end
    end
end
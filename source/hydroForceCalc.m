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

function [hydro,hydroForce, system] = hydroForceCalc(HH, TT, hydro, system, body)

CPUTime_tmp = cputime;
disp('Calculate Hydrodynamic Loads')

if strcmp (hydro.waves.RegIregCon, 'Regular')
    [hydro, hydroForce] = hydroForce_Reg(HH, TT, hydro, system);
else
    [hydro, hydroForce] = hydroForce_Irr(HH, TT, hydro, system);
end
    
for i=1:hydro.WAMIT.NBODY
    temp(:,:)=hydro.model.HGRes(:,:,i);
    evalc(['hydroForce.HGRes_' num2str(i) '= temp']); 
end
clear temp

for i=1:hydro.WAMIT.NBODY
    %temp(:,:)=hydro.model.DOF(:,i);
    evalc(['hydro.model.DOF_' num2str(i) '= body(i).dof']); 
end
clear temp

for i=1:hydro.WAMIT.NBODY
    temp(:,:)=hydro.model.CG(1:3,i);
    evalc(['hydro.model.CG_' num2str(i) '= temp']); 
end
clear temp

% for i=1:hydro.WAMIT.NBODY
%     temp=hydro.model.Mass(i);
%     evalc(['hydro.model.Mass_' num2str(i) '= temp']); 
% end
clear temp

system.CPUTime.hydroForce =cputime-CPUTime_tmp;
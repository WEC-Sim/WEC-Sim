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

% Listing Body Info
fprintf('\nList of Body: ');
fprintf('Number of Bodies = %u \n',simu.numWecBodies)
for i=1:simu.numWecBodies
     if body(i).fixed==0
        fprintf('\n\t***** Body Number %G, Name: %s *****\n',i,body(i).name)
        fprintf('\tBody CG                          (m) = [%G,%G,%G]\n',body(i).cg)
        fprintf('\tBody Mass                       (kg) = %G \n',body(i).mass);
        fprintf('\tBody Diagonal MOI              (kgm2)= [%G,%G,%G]\n',body(i).momOfInertia)
     else
        fprintf('\n\t***** Body Number %G, Name: %s (fixed to the global reference frame) *****\n',i,body(i).name)
     end
end
clear i;

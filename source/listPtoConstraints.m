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

% Listing PTOs and Constraints
fprintf('\nList of PTO(s): ');
if (exist('pto','var') == 0)
    fprintf('No PTO in the system\n')
else
    fprintf('Number of PTOs = %G \n',length(pto(1,:)))
    for i=1:length(pto(1,:))
        fprintf('\n\t***** PTO Name: %s *****\n',pto(i).name)
        fprintf('\tPTO Stiffness           (N/m;Nm/rad) = %G\n',pto(i).k)
        fprintf('\tPTO Damping           (Ns/m;Nsm/rad) = %G\n',pto(i).c)
    end
    clear i;
end

fprintf('\nList of Constraint(s): ');
if (exist('constraint','var') == 0)
    fprintf('No Constraint in the system\n')
else
    fprintf('Number of Constraints = %G \n',length(constraint(1,:)))
    for i=1:length(constraint(1,:))
        fprintf('\n\t***** Constraint Name: %s *****\n',constraint(i).name)
    end
    clear i;
end

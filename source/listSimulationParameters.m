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

% Listing Simulation Parameters
fprintf('\nWEC-Sim Simulation Settings:\n');
fprintf('\tTime Marching Solver                 = Fourth-Order Runge-Kutta Formula \n')
fprintf('\tStart Time                     (sec) = %G\n',simu.startTime) 
fprintf('\tEnd Time                       (sec) = %G\n',simu.endTime) 
fprintf('\tTime Step Size                 (sec) = %G\n',simu.dt)
fprintf('\tRamp Function Time             (sec) = %G\n',simu.rampT) 
if waves.typeNum > 10
    fprintf('\tConvolution Integral Interval  (sec) = %G\n',simu.CITime) 
end
fprintf('\tTotal Number of Time Step            = %u \n',simu.maxIt) 



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

function [] = checkBEM(body)
% BEM check for correct format

for ii = 1:length(body)
    if length(body(1).hydro.data.frequency) ~= ...
            length(body(ii).hydro.data.frequency)
       error(['BEM simulations for each body must have the same number '...
           'of frequencies'])
    else
       for jj = 1:length(body(1).hydro.data.frequency)
           if body(1).hydro.data.frequency(jj) ~= ...
                   body(ii).hydro.data.frequency(jj)
              error(['BEM simulations must be run with the same '...
                  'frequencies.'])
           end; clear jj;
       end
    end                 
end; clear ii;

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2023 MOREnergy Lab

% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
% http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef windClass<handle
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The  ``windClass`` creates a ``wind`` object saved to the MATLAB
    % workspace. 
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    
    properties (SetAccess = 'public', GetAccess = 'public') %input file
        WindTable = '';                           % Wind table of turbolent wind from Turbsim.           
        ConstantWindFlag = 0;                     % Choice of constant wind (ConstantWindFlag=1) or turbolent wind (ConstantWindFlag=0).
    end
    properties (SetAccess = 'private', GetAccess = 'public')
        SpatialDiscrU = [];                       % Wind speed from look-up table.
        Zdiscr = [];                              % Z discretisation from look-up table.
        Ydiscr = [];                              % Y discretisation from look-up table.
        t = [];                                   % t discretisation from look-up table.
        
    end
     methods (Access = 'public')
         function ImportTableWind(obj)
            data = importdata(obj.WindTable);
            obj.SpatialDiscrU = (data.SpatialDiscrU);
            %obj.SpatialDiscrU = flip(data.SpatialDiscrU,2);
            obj.Zdiscr = data.Zdiscr;
            obj.Ydiscr = data.Ydiscr;
            obj.t=data.t;
         end
                 
     end
    
end
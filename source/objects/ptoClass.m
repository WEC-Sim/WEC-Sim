%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
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
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef ptoClass<handle
    properties (SetAccess = 'public', GetAccess = 'public')%input file 
        name                    = 'NOT DEFINED'                                 % Name of the pto 
        k                       = 0                                             % PTO stiffness. Default = 0
        c                       = 0                                             % PTO damping. Default = 0
        loc                     = [999 999 999]                                 % PTO location. Default = [0 0 0]        
    end 
    
    properties (SetAccess = 'public', GetAccess = 'public')%internal
        ptoNum                  = []                                            % PTO number.
    end
    
    methods                                                            
        function obj = ptoClass(name)                                  
        % Initilization function
             obj.name = name;
        end
        
        function obj = checkLoc(obj,action)                            
        % Used in mask Initialization.
        % Checks if location is set and outputs a warning or error.
            switch action
              case 'W'
                if obj.loc == 999 % Because "Allow library block to modify its content" is selected in block's mask initialization, this command runs twice, but warnings cannot be displayed during the first initialization. 
                    obj.loc = [888 888 888];
                elseif obj.loc == 888
                    obj.loc = [0 0 0];
                    s1= ['For ' obj.name ': pto.loc was changed from [999 999 999] to [0 0 0].'];
                    warning(s1)
                end
              case 'E'
                  try
                      if obj.loc == 999
                        s1 = ['For ' obj.name ': pto(#).loc needs to be specified in the WEC-Sim input file.'...
                          ' pto.loc is the [x y z] location, in meters, for the rotational PTO.'];
                        error(s1)
                      end
                  catch exception
                      throwAsCaller(exception)
                  end
            end
        end
        
        function listInfo(obj)                                         
        % List PTO info
            fprintf('\n\t***** PTO Name: %s *****\n',obj.name)
            fprintf('\tPTO Stiffness           (N/m;Nm/rad) = %G\n',obj.k)
            fprintf('\tPTO Damping           (Ns/m;Nsm/rad) = %G\n',obj.c)
        end
    end    
end
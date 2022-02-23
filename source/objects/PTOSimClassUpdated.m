%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Renewable Energy Laboratory and National 
% Technology & Engineering Solutions of Sandia, LLC (NTESS). 
% Under the terms of Contract DE-NA0003525 with NTESS, 
% the U.S. Government retains certain rights in this software.
% 
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

classdef PTOSimClassUpdated<handle
    % This class contains PTO-Sim parameters and settings
    properties
        name = 'NOT DEFINED'                                                        % Electric Block Name
        ElectricMachineEC               = struct(...                                    % Electric Machine - Equivalent Circuit
            'Ra'              ,0.1,...            % [ohm]       Initial displacement of the piston measured from port A
            'La'              ,0.1,...            % [H]         Piston Area, side A
            'Ke'              ,0.1,...            % [V/(rad/s)] Back emf constant
            'Jem'             ,0.1,...            % [kg*m^2]    Bulk modulus of the hydraulic fluid
            'bShaft'          ,0.1)               % [N*m*s]     Bulk modulus of the hydraulic fluid
        HydPistonCompressible           = struct(...                                         % hydraulic Block properties
            'xi_piston'       ,'NOT DEFINED',...            % [m]     Initial displacement of the piston measured from port A
            'Ap_A'            ,'NOT DEFINED',...            % [m^2]   Piston Area, side A
            'Ap_B'            ,'NOT DEFINED',...            % [m^2]   Piston Area, side B
            'BulkModulus'     ,'NOT DEFINED',...            % [Pa]    Bulk modulus of the hydraulic fluid
            'PistonStroke'    ,'NOT DEFINED',...            % [m]     Piston Stroke
            'pAi'             ,'NOT DEFINED',...            % [pa]    Side A initial pressure
            'pBi'             ,'NOT DEFINED')               % [pa]    Side B initial pressure
        GasHydAccumulator               = struct(...                                         % hydraulic Block properties
            'VI0'             ,0.1,...            % [m^3]   Initial gas volume
            'pIprecharge'     ,0.1)               % [pa]    Accumulator Precharge
        RectifyingCheckValve           = struct(...                                         % hydraulic Block properties
            'Cd'              ,'NOT DEFINED',...            % Discharge accumulator
            'Amax'            ,'NOT DEFINED',...            % Maximum opening area of the valve
            'Amin'            ,'NOT DEFINED',...            % Minimum opening area of the valve
            'pMax'            ,'NOT DEFINED',...            % Pressure at maximum opening
            'pMin'            ,'NOT DEFINED',...            % Cracking pressure
            'rho'             ,'NOT DEFINED',...            % Fluid density
            'k1'              ,'NOT DEFINED',...            % Valve coefficiente
             'k2'              ,'NOT DEFINED')               % Valve coefficient, it's a function of the other valve variables
        HydraulicMotor               = struct(...                           % hydraulic Block properties
            'Displacement'                    ,'NOT DEFINED',...            % [cc/rev] Volumetric displacement
            'EffTableShaftSpeed'              ,'NOT DEFINED',...            % Vector with shaft speed data for efficiency
            'EffTableDeltaP'                  ,'NOT DEFINED',...            % Vector with pressure data for efficiency
            'EffTableVolEff'                  ,'NOT DEFINED',...            % Matrix with vol. efficiency data
            'EffTableMechEff'                 ,'NOT DEFINED')               % Matrix with mech. efficiency data
        HydraulicMotorV2               = struct(...                           % hydraulic Block properties
            'Displacement'                    ,'NOT DEFINED',...            % [cc/rev] Volumetric displacement
            'EffModel'                    ,'NOT DEFINED',...            % 1 for Analytical or 2 for tabulated
            'EffTableShaftSpeed'              ,'NOT DEFINED',...            % Vector with shaft speed data for efficiency
            'EffTableDeltaP'                  ,'NOT DEFINED',...            % Vector with pressure data for efficiency
            'EffTableVolEff'                  ,'NOT DEFINED',...            % Matrix with vol. efficiency data
            'EffTableMechEff'                 ,'NOT DEFINED',...            % Matrix with mech. efficiency data
            'Aplha1'                  ,'NOT DEFINED',...            % Matrix with vol. efficiency data
            'Aplha2'                  ,'NOT DEFINED',...            % Matrix with vol. efficiency data
            'Aplha3'                  ,'NOT DEFINED')            % Matrix with vol. efficiency data
    end
    
    properties (SetAccess = 'public', GetAccess = 'public')%internal
        PTOSimBlockNum           = []                                            % Constraint number
    end
    
    methods
        function obj        = PTOSimClassUpdated(name)
            % Initilization function
            obj.name   = name;
        end
        
%         function countblocks(obj)
%             % Counts and numbers the instances of each type of block
%             names = {'HydraulicBlock'};%,'GasHydAccumulator'};
%             for jj = 1:length(names)
%                 for kk = 1:length(obj.(names{jj}))
%                     obj.(names{jj})(kk).number = kk;
%                 end
%             end
%         end
        function ptosimOutput = response(obj)
            % Create PTO-Sim output
            names = {'HydPistonCompressible','GasHydAccumulator','RectifyingCheckValve','HydraulicMotorV2','ElectricMachineEC'};
            
            signals.HydPistonCompressible = {'PressureA','ForcePTO','PressureB'};
            signals.GasHydAccumulator = {'Pressure','FlowRate'};
            signals.RectifyingCheckValve = {'QA','QB','QC','QD'};
            signals.HydraulicMotorV2 = {'ShaftSpeed','Torque','DeltaP','FlowRate'};
            signals.ElectricMachineEC = {'Tem','ShaftSpeed','Current','Voltage'};
            
            
            ptosimOutput = struct;
            for ii = 1:length(names)
                for jj = 1:length(obj.(names{ii}))
                    for kk = 1:length(signals.(names{ii}))
                        try
                            tmp = evalin('caller',[names{ii} num2str(jj) '_out.signals.values(:,' num2str(kk) ')']);
                            ptosimOutput.(names{ii})(jj).(signals.(names{ii}){kk}) = tmp;
                        end
                    end
                    evalin('caller',['clear ' names{ii} num2str(jj) '_out']);
                end
            end
        end
    end
end

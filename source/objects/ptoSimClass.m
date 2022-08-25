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

classdef ptoSimClass<handle
    % This class contains PTO-Sim parameters and settings
    properties
        adjustableRod (1,1) struct              = struct(...                % Adjustable rod block properties
            'crank',                            'NOT DEFINED',...           % [m] Crank length
            'offset',                           'NOT DEFINED',...           % [m] Offset length
            'rodInit',                          'NOT DEFINED')              % [m] Rod initial length
        checkValve (1,1) struct                 = struct(...                % Linear crank block properties
            'k1',                               'NOT DEFINED',...           % [m^2/N] Valve coefficient
            'rho',                              'NOT DEFINED',...           % [kg/m^3] Fluid density
            'pMax',                             'NOT DEFINED',...           % [Pa] Valve pressure at maximum opening area
            'pMin',                             'NOT DEFINED',...           % [Pa] Valve pressure at minimum opening area
            'k2',                               'NOT DEFINED',...           % [m^2/N] Valve coefficient
            'Amin',                             'NOT DEFINED',...           % [m^2] Minimum valve area
            'Amax',                             'NOT DEFINED',...           % [m^2] Maximum valve area
            'Cd',                               'NOT DEFINED')              % [1] Discharge coefficient
        directLinearGenerator (1,1) struct      = struct(...                % Linear crank block properties
            'tau_p',                            'NOT DEFINED',...           % Magnet pole pitch
            'theta_d_0',                        'NOT DEFINED',...           % Initial theta value
            'Bfric',                            'NOT DEFINED',...           % Friction coeeficient
            'lambda_sd_0',                      'NOT DEFINED',...           % Stator d-axis flow linkage
            'Rs',                               'NOT DEFINED',...           % Winding resistance
            'lambda_fd',                       'NOT DEFINED',...           % Flux linkage of the stator d winding due to flux produced by the rotor magnets [Wb-turns]
            'Ls',                               'NOT DEFINED',...           % Winding inductance
            'lambda_sq_0',                      'NOT DEFINED',...           % Stator q-axis flow linkage
            'Rload',                            'NOT DEFINED')              % External load
        directRotaryGenerator (1,1) struct      = struct(...                % Linear crank block properties
            'radius',                           'NOT DEFINED',...           % Rotary generator radius
            'tau_p',                            'NOT DEFINED',...           % Magnet pole pitch
            'theta_d_0',                        'NOT DEFINED',...           % Initial theta value
            'Bfric',                            'NOT DEFINED',...           % Friction coeeficient
            'lambda_sd_0',                      'NOT DEFINED',...           % Stator d-axis flow linkage
            'Rs',                               'NOT DEFINED',...           % Winding resistance
            'lambda_fd',                        'NOT DEFINED',...           % Flux linkage of the stator d winding due to flux produced by the rotor magnets [Wb-turns]
            'Ls',                               'NOT DEFINED',...           % Winding inductance
            'lambda_sq_0',                      'NOT DEFINED',...           % Stator q-axis flow linkage
            'Rload',                            'NOT DEFINED')              % External load
        electricGeneratorEC (1,1) struct        = struct(...                % Electric Machine - Equivalent Circuit
            'Ra',                               0.1,...                     % [ohm]       Initial displacement of the piston measured from port A
            'La',                               0.1,...                     % [H]         Piston Area, side A
            'Ke',                               0.1,...                     % [V/(rad/s)] Back emf constant
            'Jem',                              0.1,...                     % [kg*m^2]    Bulk modulus of the hydraulic fluid
            'bShaft',                           0.1,...                     % [N*m*s]     Bulk modulus of the hydraulic fluid
            'currentIni',                       0.0,...                     % [A]         Electric motor current initial value
            'wShaftIni',                        0.0)                        % [rpm]       Shaft speed initial value
        gasHydAccumulator (1,1) struct          = struct(...                % hydraulic Block properties
            'vI0',                              0.1,...                     % [m^3]   Initial gas volume
            'pIprecharge',                      0.1)                        % [pa]    Accumulator Precharge
        hydPistonCompressible (1,1) struct      = struct(...                % hydraulic Block properties
            'xi_piston',                        'NOT DEFINED',...           % [m]     Initial displacement of the piston measured from port A
            'Ap_A',                             'NOT DEFINED',...           % [m^2]   Piston Area, side A
            'Ap_B',                             'NOT DEFINED',...           % [m^2]   Piston Area, side B
            'bulkModulus',                      'NOT DEFINED',...           % [Pa]    Bulk modulus of the hydraulic fluid
            'pistonStroke',                     'NOT DEFINED',...           % [m]     Piston Stroke
            'pAi',                              'NOT DEFINED',...           % [pa]    Side A initial pressure
            'pBi',                              'NOT DEFINED')              % [pa]    Side B initial pressure
        hydraulicMotor (1,1) struct             = struct(...                % hydraulic Block properties
            'displacement',                     'NOT DEFINED',...           % [cc/rev] Volumetric displacement
            'effModel',                         'NOT DEFINED',...           % 1 for Analytical or 2 for tabulated
            'effTableShaftSpeed',               'NOT DEFINED',...           % Vector with shaft speed data for efficiency
            'effTableDeltaP',                   'NOT DEFINED',...           % Vector with pressure data for efficiency
            'effTableVolEff',                   'NOT DEFINED',...           % Matrix with vol. efficiency data
            'effTableMechEff',                  'NOT DEFINED',...           % Matrix with mech. efficiency data
            'wNominal',                         'NOT DEFINED',...           % [rpm] Nominal shaft angular velocity
            'deltaPNominal',                    'NOT DEFINED',...           % [Pa] Matrix with vol. efficiency data
            'visNominal',                       'NOT DEFINED',...           % [m^2/s] Nominal kinematic viscosity at which the nominal efficiency is measured
            'densityNominal',                   'NOT DEFINED',...           % [kg/m^3] Nominal fluid density at which the nominal efficiency is measured
            'effVolNom',                        'NOT DEFINED',...           % [1] Volumetric efficiency at nominal conditions
            'torqueNoLoad',                     'NOT DEFINED',...           % [Nm] No load torque
            'torqueVsPressure',                 'NOT DEFINED',...           % [Nm/Pa] Friction torque vs pressure drop coefficient
            'rho',                              'NOT DEFINED',...           % [kg/m^3] Actual fluid density. It could be different than the nominal fluid density
            'viscosity',                        'NOT DEFINED')              % [m^2/s] Actual viscosity. It could be different than the nominal viscosity
        linearCrank (1,1) struct                = struct(...                % Linear crank block properties
            'crank',                            'NOT DEFINED',...           % [m] Crank length
            'offset',                           'NOT DEFINED',...           % [m] Offset length
            'rodLength',                        'NOT DEFINED')              % [m] Rod length
        name (1,:) {mustBeText}                 = 'NOT DEFINED'             % Electric Block Name
        rectifyingCheckValve (1,1) struct       = struct(...                % hydraulic Block properties
            'Cd',                               'NOT DEFINED',...           % Discharge accumulator
            'Amax',                             'NOT DEFINED',...           % Maximum opening area of the valve
            'Amin',                             'NOT DEFINED',...           % Minimum opening area of the valve
            'pMax',                             'NOT DEFINED',...           % Pressure at maximum opening
            'pMin',                             'NOT DEFINED',...           % Cracking pressure
            'rho',                              'NOT DEFINED',...           % Fluid density
            'k1',                               'NOT DEFINED',...           % Valve coefficiente
            'k2',                               'NOT DEFINED')              % Valve coefficient, it's a function of the other valve variables
    end
    
    properties (SetAccess = 'public', GetAccess = 'public')%internal
%         type: This property must be defined to specify the
%         type of block that will be used. The type value of each block is
%         presented below:
%         Type = 1 ---- Electric generator equivalent circuit
%         Type = 2 ---- Hydraulic cylinder
%         Type = 3 ---- Hydraulic accumulator
%         Type = 4 ---- Rectifying check valve
%         Type = 5 ---- Hydraulic motor
%         Type = 6 ---- Linear crank 
%         Type = 7 ---- Adjustable rod 
%         Type = 8 ---- Check valve 
%         Type = 9 ---- Direct drive linear generator 
%         Type = 10 ---- Direct drive Rotary generator
        type    = []                                                        % PTOSim Block type
        number  = []                                                        % PTOSim number
    end
    
    methods
        function obj        = ptoSimClass(name)
            % Initilization function
            if exist('name','var')
                obj.name = name;
            else
                error('The ptoSim class number(s) in the wecSimInputFile must be specified in ascending order starting from 1. The ptoSimClass() function should be called first to initialize each ptoSim block with a name.')
            end
        end

        function checkInputs(obj)
            % This method checks WEC-Sim user inputs and generates error messages if parameters are not properly defined. 
            
            % Check struct inputs:
            % Electric Generator
            mustBeScalarOrEmpty(obj.electricGeneratorEC.Ra)
            mustBeScalarOrEmpty(obj.electricGeneratorEC.La)
            mustBeScalarOrEmpty(obj.electricGeneratorEC.Ke)
            mustBeScalarOrEmpty(obj.electricGeneratorEC.Jem)
            mustBeScalarOrEmpty(obj.electricGeneratorEC.bShaft)
            mustBeScalarOrEmpty(obj.electricGeneratorEC.currentIni)
            mustBeScalarOrEmpty(obj.electricGeneratorEC.wShaftIni)
            % Gas Hydraulic Accumulator
            mustBeScalarOrEmpty(obj.gasHydAccumulator.vI0)
            mustBeScalarOrEmpty(obj.gasHydAccumulator.pIprecharge)
        end
    end
end

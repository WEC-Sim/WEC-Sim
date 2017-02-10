% This class contains WEC-Sim simulation parameters and settings
%
% Copyright 2014 the National Renewable Energy Laboratory and Sandia Corporation
%
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
%
%     http://www.apache.org/licenses/LICENSE-2.0
%
% Unless required by applicable law or agreed to in writing, software
% distributed und   er the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

classdef simulationClass<handle

    properties (SetAccess = 'public', GetAccess = 'public')%input file
        multibodySolver     = 'SimMechanics';                              % solver to use for mulitbody dynamics, can be SimMechanics or MBDyn
        simMechanicsFile    = ''                                           % Simulink/SimMechanics model file (default = '', first .slx file found in dir will be used)
        mBDynFile           = ''                                           % Simulink/SimMechanics model file (default = '', first .mbd file found in dir will be used)
        startTime           = 0                                            % Simulation start time (default = 0 s)
        endTime             = 500                                          % Simulation end time (default = 500 s)
        dt                  = 0.1                                          % Simulation time step (default = 0.1 s)
        dtMax               = []                                           % Maximum simulation time step for variable step (default = 0.1 s) 
        dtOut               = []                                           % Output sampling time (default = dt)
        dtFeNonlin          = []                                           % Sample time to calculate nonlinear forces (default = dt)
        dtCITime            = []                                           % Sample time to calculate Convolution Integral (default = dt)
        rampT               = 100                                          % Ramp time for wave forcing (default = 100 s)
        domainSize          = 200                                          % Size of free surface and seabed. This variable is only used for visualization (default = 200 m)
        CITime              = 60                                           % Convolution integral time (default = 60 s)
        ssCalc              = 0                                            % Option for convolution integral or state-space calculation: convolution integral->'0', state-space->'1', (default = 0)
        mode                = 'normal'                                     %'normal','accelerator','rapid-accelerator' (default = 'normal')
        solver              = 'ode4'                                       % PDE solver used by the Simulink/SimMechanics simulation (default = 'ode4')
        autoRateTranBlk     = 'on'                                         % Automatically handle rate transition for data transfer
        zeroCrossCont       = 'DisableAll'                                 % Disable zero cross control 
        explorer            = 'on'                                         % SimMechanics Explorer 'on' or 'off' (default = 'on'
        rho                 = 1000                                         % Density of water (default = 1000 kg/m^3)
        g                   = 9.81                                         % Acceleration due to gravity (default = 9.81 m/s)
        nlHydro             = 0                                            % Option for nonlinear hydrohanamics calculation: linear->'0', nonlinear->'1', (default = 0)
        b2b                 = 0                                            % Option for body2body interactions: off->'0', on->'1', (default = 0)
        paraview            = 0                                            % Option for writing vtp files for paraview visualization.
        adjMassWeightFun    = 2                                            % Weighting function for adjusting added mass term in the translational direction (default = 2)
        numIntMidTimeSteps  = 5                                            % Number of intermidiate time steps (default = 5 for ode4 method)
        mcrCaseFile         = []                                           % mat file that contain a list of the multiple conditions runs with given conditions  
        morrisonElement     = 0                                            % Option for Morrison Element calculation: Off->'0', On->'1', (default = 0)
        outputtxt           = 0                                            % Option to save results as ASCII files.
        reloadH5Data        = 0                                            % Option to re-load hydro data from hf5 file between runs: Off->'0', On->'1', (default = 0)
        numWecBodies        = []                                           % Number of hydrodynamic bodies that comprise the WEC device (default = 'NOT DEFINED')
        numPtos             = []                                           % Number of power take-off elements in the model (default = 'NOT DEFINED')
        numConstraints      = []                                           % Number of contraints in the wec model (default = 'NOT DEFINED')
        numMoorings         = []                                           % Number of moorings in the wec model (default = 'NOT DEFINED')
    end

    properties (SetAccess = 'protected', GetAccess = 'public')%internal
        simMechanicsModel   = '';
        version             = 'NOT DEFINED'                                % WEC-Sim version
        simulationDate      = datetime                                     % Simulation date and time
        outputDir           = 'output'                                     % Data output directory name
        time                = 0                                            % Simulation time [s] (default = 0 s)
        inputFile           = 'wecSimInputFile'                            % Name of WEC-Sim input file (default = 'wecSimInputFile')
        logFile             = []                                           % File with run information summary
        caseFile            = []                                           % .mat file with all simulation information
        caseDir             = []                                           % WEC-Sim case directory
        CIkt                = []                                           % Number of timesteps in the convolution integral length
        maxIt               = []                                           % Total number of simulation time steps (default = dependent)        CIkt                                                               % Calculate the number of convolution integral timesteps (default = dependent)
        CTTime              = []                                           % Convolution integral time series (default = dependent)
    end

    methods
        function obj = simulationClass(casedir)
            % Initilization function
            fprintf('WEC-Sim: An open-source code for simulating wave energy converters\n')
            fprintf('Version: %s\n\n',obj.version)
            fprintf('Initializing the Simulation Class...\n')
            
            if nargin < 1
                obj.caseDir = pwd ();
            else
                obj.caseDir = casedir;
            end
            
            fprintf('\tCase Dir: %s \n', obj.caseDir)
            
            if exist (obj.caseDir, 'dir') ~= 7
                error ('The WEC case directory, %s, does not appear to exist', obj.caseDir);
            end
            
            obj.outputDir = fullfile (obj.caseDir, obj.outputDir);
            
        end

        function obj = loadSimMechModel(obj)
            % Loads the model and sets the simulation parameters
            load_system (obj.simMechanicsFile);
            
            set_param ( obj.simMechanicsModel, ...
                        'Solver', obj.solver,...
                        'StopTime', num2str(obj.endTime),...
                        'SimulationMode', obj.mode,...
                        'StartTime', num2str(obj.startTime),...
                        'FixedStep', num2str(obj.dt),...
                        'MaxStep', num2str(obj.dtMax),...
                        'AutoInsertRateTranBlk', obj.autoRateTranBlk,...
                        'ZeroCrossControl', obj.zeroCrossCont,...
                        'SimMechanicsOpenEditorOnUpdate', obj.explorer );
        end

        function setupSim(obj)
            % Sets simulation properties based on values specified in input file
            obj.time = obj.startTime:obj.dt:obj.endTime;
            obj.maxIt = floor((obj.endTime - obj.startTime) / obj.dt);
            % Set dtOut if it was not specificed in input file
            if isempty(obj.dtOut) || obj.dtOut < obj.dt
                obj.dtOut = obj.dt;
            end
            % Set dtFeNonlin if it was not specificed in input file
            if isempty(obj.dtFeNonlin) || obj.dtFeNonlin < obj.dt
                obj.dtFeNonlin = obj.dt;
            end
            % Set dtCITime if it was not specificed in input file
            if isempty(obj.dtCITime) || obj.dtCITime < obj.dt
                obj.dtCITime = obj.dt;
            end
            % Set dtMax if it was not specificed in input file
            if isempty(obj.dtMax) || obj.dtMax < obj.dt
                obj.dtMax = obj.dt;
            end
            obj.CTTime = 0:obj.dtCITime:obj.CITime;            
            obj.CIkt = length(obj.CTTime);
            obj.caseFile = fullfile (obj.caseDir, 'output', [obj.simMechanicsModel, '_matlabWorkspace.mat']);
            obj.logFile = fullfile (obj.caseDir, 'output', [obj.simMechanicsModel, '_simulationLog.txt']);
            mkdir(obj.outputDir)
            obj.getWecSimVer;
        end

        function checkinputs(obj)
            % Validate user input for simulation
            
            if exist (obj.caseDir, 'dir') ~= 7
                error ('The WEC input data directory, %s, does not appear exist', obj.caseDir);
            end
            
            if strcmpi (obj.multibodySolver, 'SimMechanics')
                
                if isempty (obj.simMechanicsFile)
                    % find all slx files
                    slxfiles = dir (fullfile (obj.caseDir, '*.slx'));
                    
                    if isempty (slxfiles)
                        error ('No simMechanics files were found in the case directory %s', obj.caseDir)
                    end
                    
                    % if any found use the first one (warn if multiple)
                    obj.simMechanicsFile = fullfile (slxfiles(1).folder, slxfiles(1).name);
                    
                    if numel (slxfiles) > 1
                        warning ('You did not specify a specific SimMechanics slx file and multiple were found in the case directory, the following file will be used:\n%s', ...
                            obj.simMechanicsFile);
                    end
                    
                end
                
                % Check simMechanics file exists
                exf = exist(obj.simMechanicsFile, 'file');
                if ~(exf == 4 || exf == 2)
                    error ('The simMechanics file:\n\t%s\ndoes not appear to exist.', obj.simMechanicsFile)
                end
                
                if exf == 2
                    warning ('The simMechanics file:\n\t%s\nis not in your matlab path');
                end
                
                [~,obj.simMechanicsModel,~] = fileparts (obj.simMechanicsFile);
                
            elseif strcmpi (obj.multibodySolver, 'MBDyn')
                
                if isempty (obj.mBDynFile)
                    % find all slx files
                    mbdfiles = dir (fullfile (obj.caseDir, '*.mbd'));
                    
                    if isempty (mbdfiles)
                        error ('No MBDyn input files were found in the case directory %s', obj.caseDir)
                    end
                    
                    % if any found use the first one (warn if multiple)
                    obj.mBDynFile = fullfile (mbdfiles(1).folder, mbdfiles(1).name);
                    
                    if numel (mbdfiles) > 1
                        warning ('You did not specify a specific MBDyn mbd file and multiple were found in the case directory, the following file will be used:\n%s', ...
                            obj.mBDynFile);
                    end
                    
                end
                
                if exist(obj.mBDynFile, 'file') ~= 2
                    error ('The mBDynFile file, %s, does not exist in the case directory', obj.mBDynFile)
                end
            end
            
            % Remove existing output folder
            if exist(obj.outputDir,'dir') ~= 0
                try
                    rmdir(obj.outputDir,'s')
                catch
                    error('The output directory could not be removed. Please close any files in the output directory and try running WEC-Sim again')
                end
             end
        end

        function rhoDensitySetup(obj,rho,g)
            % Assigns density and gravity values
            obj.rho = rho;
            obj.g   = g;
        end

        function listInfo(obj,waveTypeNum)
            % Lists simulation info
            fprintf('\nWEC-Sim Simulation Settings:\n');
            %fprintf('\tTime Marching Solver                 = Fourth-Order Runge-Kutta Formula \n')
            fprintf('\tStart Time                     (sec) = %G\n',obj.startTime)
            fprintf('\tEnd Time                       (sec) = %G\n',obj.endTime)
            fprintf('\tTime Step Size                 (sec) = %G\n',obj.dt)
            fprintf('\tRamp Function Time             (sec) = %G\n',obj.rampT)
            if waveTypeNum > 10
                fprintf('\tConvolution Integral Interval  (sec) = %G\n',obj.CITime)
            end
            fprintf('\tTotal Number of Time Step            = %u \n',obj.maxIt)
        end

        function getWecSimVer(obj)
            % Determines WEC-Sim version used
            try
                ws_exe = which('wecSim');
                ws_dir = fileparts(ws_exe);
                git_ver_file = [ws_dir '/../.git/refs/heads/master'];
                obj.version = textread(git_ver_file,'%s');
            catch
                obj.version = 'No git version available';
            end
        end
    end
end

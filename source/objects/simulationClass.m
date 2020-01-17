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


classdef simulationClass<handle
    % This class contains WEC-Sim simulation parameters and settings
    properties (SetAccess = 'public', GetAccess = 'public')%input file
        simMechanicsFile    = 'NOT DEFINED'                                % Simulink/SimMecahnics model file (default = 'NOT DEFINED')
        startTime           = 0                                            % Simulation start time (default = 0 s)
        rampTime            = 100                                          % Ramp time for wave forcing (default = 100 s)
        endTime             = []                                           % Simulation end time ((default = 'NOT DEFINED')
        dt                  = 0.1                                          % Simulation time step (default = 0.1 s)
        dtOut               = []                                           % Output sampling time (default = dt)
        dtNL                = []                                           % Sample time to calculate nonlinear forces (default = dt)
        dtCITime            = []                                           % Sample time to calculate Convolution Integral (default = dt)
        dtME                = []                                           % Sample time to calculate Morison Element forces (default = dt)
        CITime              = 60                                           % Convolution integral time (default = 60 s)
        domainSize          = 200                                          % Size of free surface and seabed. This variable is only used for visualization (default = 200 m)
        ssCalc              = 0                                            % Option for convolution integral or state-space calculation: convolution integral->'0', state-space->'1', (default = 0)
        mode                = 'normal'                                     %'normal','accelerator','rapid-accelerator' (default = 'normal')
        solver              = 'ode4'                                       % PDE solver used by the Simulink/SimMechanics simulation (default = 'ode4')
        numIntMidTimeSteps  = 5                                            % Number of intermidiate time steps (default = 5 for ode4 method)
        autoRateTranBlk     = 'on'                                         % Automatically handle rate transition for data transfer
        zeroCrossCont       = 'DisableAll'                                 % Disable zero cross control 
        explorer            = 'on'                                         % SimMechanics Explorer 'on' or 'off' (default = 'on'
        rho                 = 1000                                         % Density of water (default = 1000 kg/m^3)
        g                   = 9.81                                         % Acceleration due to gravity (default = 9.81 m/s)
        nlHydro             = 0                                            % Option for nonlinear hydrohanamics calculation: linear->'0', nonlinear->'1', (default = 0)
        yawNonLin           = 0                                            % Option for non-linear yaw calculation (=0 for linear, =1 for nonlinear) 
        yawThresh           = 1                                            % Yaw position threshold (in degrees) above which excitation coefficients will be interpolated
        b2b                 = 0                                            % Option for body2body interactions: off->'0', on->'1', (default = 0)
        paraview            = 0                                            % Option for writing vtp files for paraview visualization.
        adjMassWeightFun    = 2                                            % Weighting function for adjusting added mass term in the translational direction (default = 2)
        mcrCaseFile         = []                                           % mat file that contain a list of the multiple conditions runs with given conditions  
        morisonElement     = 0                                             % Option for Morrison Element calculation: Off->'0', On->'1', (default = 0)
        outputtxt           = 0                                            % Option to save results as ASCII files.
        reloadH5Data        = 0                                            % Option to re-load hydro data from hf5 file between runs: Off->'0', On->'1', (default = 0)     
        saveMat             = 1                                            % Option to save *.mat file for each run: Off->'0', On->'1', (default = 1)   
        pressureDis         = 0                                            % Option to save pressure distribution: Off->'0', On->'1', (default = 0)
    end

    properties (SetAccess = 'public', GetAccess = 'public')%internal
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
        numWecBodies        = []                                           % Number of hydrodynamic bodies that comprise the WEC device (default = 'NOT DEFINED')
        numPtos             = []                                           % Number of power take-off elements in the model (default = 'NOT DEFINED')
        numConstraints      = []                                           % Number of contraints in the wec model (default = 'NOT DEFINED')
        numMoorings         = []                                           % Number of moorings in the wec model (default = 'NOT DEFINED')
    end

    methods
        function obj = simulationClass()
            % Initilization function
            fprintf('WEC-Sim: An open-source code for simulating wave energy converters\n')
            fprintf('Version: %s\n\n',obj.version)
            fprintf('Initializing the Simulation Class...\n')
            obj.caseDir = pwd; 
            fprintf('\tCase Dir: %s \n',obj.caseDir)
            obj.outputDir = ['.' filesep obj.outputDir];
        end

        function obj = loadSimMechModel(obj,fName)
            % Loads the model and sets the simulation parameters
            load_system(fName);
                 obj.simMechanicsFile = fName;
                 [~,modelName,~] = fileparts(obj.simMechanicsFile);
                 set_param(modelName,'Solver',obj.solver,...
                 'StopTime',num2str(obj.endTime),...
                 'SimulationMode',obj.mode,...
                 'StartTime',num2str(obj.startTime),...
                 'FixedStep',num2str(obj.dt),...
                 'MaxStep',num2str(obj.dt),...
                 'AutoInsertRateTranBlk',obj.autoRateTranBlk,...
                 'ZeroCrossControl',obj.zeroCrossCont,...
                 'SimCompilerOptimization','on',...                 
                 'SimMechanicsOpenEditorOnUpdate',obj.explorer);
        end

        function setupSim(obj)
            % Sets simulation properties based on values specified in input file
            obj.time = obj.startTime:obj.dt:obj.endTime;
            obj.maxIt = floor((obj.endTime - obj.startTime) / obj.dt);
            % Set dtOut if it was not specificed in input file
            if isempty(obj.dtOut) || obj.dtOut < obj.dt
                obj.dtOut = obj.dt;
            end
            % Set dtNL if it was not specificed in input file
            if isempty(obj.dtNL) || obj.dtNL < obj.dt
                obj.dtNL = obj.dt;
            end
            % Set dtCITime if it was not specificed in input file
            if isempty(obj.dtCITime) || obj.dtCITime < obj.dt
                obj.dtCITime = obj.dt;
            end
            % Set dtME if it was not specificed in input file
            if isempty(obj.dtME) || obj.dtME < obj.dt
                obj.dtME = obj.dt;
            end            
            obj.CTTime = 0:obj.dtCITime:obj.CITime;            
            obj.CIkt = length(obj.CTTime);
            obj.caseFile = [obj.caseDir filesep 'output' filesep obj.simMechanicsFile(1:end-4) '_matlabWorkspace.mat'];
            obj.logFile = [obj.caseDir filesep 'output' filesep obj.simMechanicsFile(1:end-4) '_simulationLog.txt'];
            mkdir(obj.outputDir)
            obj.getWecSimVer;
        end

        function checkinputs(obj)
            % Checks user input
            % Check that simu.endTime was specified
            if isempty(obj.endTime)
                error('simu.endTime, the simulation end time must be specified in the wecSimInputFile')
            end            
            % Check simMechanics file exists
            if exist(obj.simMechanicsFile,'file') ~= 4
                error('The simMecahnics file, %s, does not exist in the case directory',value)
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
            fprintf('\tRamp Function Time             (sec) = %G\n',obj.rampTime)
            if waveTypeNum > 10
                fprintf('\tConvolution Integral Interval  (sec) = %G\n',obj.CITime)
            end
            fprintf('\tTotal Number of Time Steps           = %u \n',obj.maxIt)
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

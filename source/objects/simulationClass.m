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
classdef simulationClass<handle
    properties (Access = protected)
        version             = 'Version 1.0'                                % WEC-Sim version
        outputDir           = 'output'                                     % Data output directory name
        time                = 0                                            % Simulation time [s] (default = 0 s)
    end

    properties (Access = public)
        numWecBodies        = [] % make these dependent variables          % Number of hydrodynamic bodies that comprise the WEC device (default = 'NOT DEFINED')
        numPtos             = []                                           % Number of power take-off elements in the model (default = 'NOT DEFINED')
        numConstraints      = []                                           % Number of contraints in the wec model (default = 'NOT DEFINED')
        caseDir             = []                                           % WEC-Sim case directory (default = 'NOT DEFINED')
        simMechanicsFile    = 'NOT DEFINED'                                % Simulink/SimMecahnics model file (default = 'NOT DEFINED')
        inputFile           = 'wecSimInputFile'                            % Name of WEC-Sim input file (default = 'wecSimInputFile')
        hydroDataWamit      = 0                                            % Equal to 1 if data from 1 WAMIT file, Equal to 0 if data from more than 1 input file (default = 0)
        startTime           = 0                                            % Simulation start time (default = 0 s)
        endTime             = 500                                          % Simulation end time (default = 500 s)
        dt                  = 0.1                                          % Simulation time step (default = 0.1 s)
        rampT               = 100                                          % Ramp time for wave forcing (default = 100 s)
        domainSize          = 200                                          % Size of free surface and seabed. This variable is only used for visualization (default = 200 m)
        CITime              = 60                                           % Convolution integral time (default = 60 s)
        ssCalc              = 0                                            % Option for converlution integral or state-space calculation: converlution integral->'0', state-space->'1', (default = 0)
%        ssReal              = 'TD'
%        ssImport            = [];
%        ssMax               = 10
%        R2Thresh            = 0.95
        mode                = 'normal'                                     %'normal','accelerator','rapid-accelerator' (default = 'normal')
        solver              = 'ode4'                                       % PDE solver used by the Simulink/SimMechanics simulation (default = 'ode4')
        explorer            = 'on'                                         % SimMechanics Explorer 'on' or 'off' (default = 'on'
        numT                = []
        numDTPerT           = []
        numRampT            = []
        rho                 = 1000                                           % Density of water (default = 1000 kg/m^3)
        g                   = 9.81                                           % Acceleration due to gravity (default = 9.81 m/s)
        nlHydro             = 0                                            % Option for nonlinear hydrohanamics calculation: linear->'0', nonlinear->'1', (default = 0)
        
        wecSimVersion       = 'NOT DEFINED'
        simulationDate      = datetime
    end

    properties (Dependent)
        maxIt                                                              % Total number of simulation time steps (default = dependent)        CIkt                                                               % Calculate the number of convolution integral timesteps (default = dependent)
        CTTime                                                             % Convolution integral time series (default = dependent)
        logFile                                                            % File with run information summary
        caseFile                                                           % .mat file with all simulation information
        outputFileName
        CIkt                                                               % Number of timesteps in the convolution integral length
    end

    methods

        function obj = simulationClass(file)
             if nargin >= 1
                 obj.inputFile = file; % Function to change the name of the input file if desired (not reccomended)
             end
             if exist(obj.inputFile,'file') ~= 2
                 error('The input file %s does not exist in the directory %s',file,pwd)
             end
             
             try
                obj.wecSimVersion = getWecSimVer
             catch
                obj.wecSimVersion = 'No git ver available'
             end
             
             fprintf(['WEC-Sim: An open-source code for simulating '...
                      'wave energy converters\n'])
             fprintf('Version: %s\n\n',obj.version)
             fprintf('Initializing the Simulation Class...\n')

             obj.caseDir = pwd; cd(obj.caseDir);
             fprintf('\tCase Dir: %s \n',obj.caseDir)

             obj.time = [obj.startTime:obj.dt:obj.endTime];

             obj.outputDir = ['.' filesep obj.outputDir];

             % Create the output directory. If the dir exists it will be
             % moved to the directory "output_previous"
             if exist(obj.outputDir,'dir') == 0
                mkdir(obj.outputDir)
             else
                try
                    rmdir(obj.outputDir,'s')
                catch
                    error('The output directory could not be removed. Please close any files in the output directory and try running WEC-Sim again')
                end
                mkdir(obj.outputDir)
             end
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
                 'SimMechanicsOpenEditorOnUpdate',obj.explorer);
        end

        function maxIt = get.maxIt(obj)
        % Calculates the number of time-steps
            maxIt = floor((obj.endTime - obj.startTime) / obj.dt);
        end

        function CIkt = get.CIkt(obj)
        % Function to calculate number of timesteps in the convolution integral length
            CIkt = ceil(obj.CITime/obj.dt);
        end

        function CTTime = get.CTTime(obj)
        % Function to calculate the convolution integral time series
            CTTime = 0:obj.dt:obj.dt*obj.CIkt;
        end

        function logFile = get.logFile(obj)
            if exist(obj.simMechanicsFile) ~=4
                error('The simMecahnics file, %s, does not exist in the case directory',value)
            end
            logFile = [obj.caseDir filesep 'output' filesep obj.simMechanicsFile(1:end-4) '_simulationLog.txt'];
        end

        function caseFile = get.caseFile(obj)
            if exist(obj.simMechanicsFile) ~=4
                error('The simMecahnics file, %s, does not exist in the case directory',value)
            end
            caseFile = [obj.caseDir filesep 'output' filesep obj.simMechanicsFile(1:end-4) '_matlabWorkspace.mat'];
        end

        function outputFileName = get.outputFileName(obj)
            if exist(obj.simMechanicsFile) ~=4
                error('The simMecahnics file, %s, does not exist in the case directory',value)
            end
            outputFileName = [obj.caseDir filesep 'output' filesep obj.simMechanicsFile(1:end-4) '_output.mat'];
        end

        function obj = set.simMechanicsFile(obj,value)
            if exist(value,'file') ~= 4
                error('The simMecahnics file, %s, does not exist in the case directory',value)
            end
                obj.simMechanicsFile = value;
        end

        function rhoDensitySetup(obj,rho,g)
                obj.rho = rho;
                obj.g   = g;
        end

        function listInfo(obj,waveTypeNum)
            fprintf('\nWEC-Sim Simulation Settings:\n');
            fprintf('\tTime Marching Solver                 = Fourth-Order Runge-Kutta Formula \n')
            fprintf('\tStart Time                     (sec) = %G\n',obj.startTime)
            fprintf('\tEnd Time                       (sec) = %G\n',obj.endTime)
            fprintf('\tTime Step Size                 (sec) = %G\n',obj.dt)
            fprintf('\tRamp Function Time             (sec) = %G\n',obj.rampT)
            if waveTypeNum > 10
                fprintf('\tConvolution Integral Interval  (sec) = %G\n',obj.CITime)
            end
            fprintf('\tTotal Number of Time Step            = %u \n',obj.maxIt)
        end
    end
end

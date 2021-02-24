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
        simMechanicsFile    = 'NOT DEFINED'                                % (`string`) Simulink/SimMecahnics model file. Default = ``'NOT DEFINED'``
        startTime           = 0                                            % (`float`) Simulation start time. Default = ``0`` s
        rampTime            = 100                                          % (`float`) Ramp time for wave forcing. Default = ``100`` s
        endTime             = []                                           % (`float`) Simulation end time. Default = ``'NOT DEFINED'``
        dt                  = 0.1                                          % (`float`) Simulation time step. Default = ``0.1`` s
        dtOut               = []                                           % (`float`) Output sampling time. Default = ``dt``
        dtNL                = []                                           % (`float`) Sample time to calculate nonlinear forces. Default = ``dt``
        dtCITime            = []                                           % (`float`) Sample time to calculate Convolution Integral. Default = ``dt``
        dtME                = []                                           % (`float`) Sample time to calculate Morison Element forces. Default = ``dt``
        CITime              = 60                                           % (`float`) Convolution integral time. Default = ``60`` s
        domainSize          = 200                                          % (`float`) Size of free surface and seabed. This variable is only used for visualization. Default = ``200`` m
        ssCalc              = 0                                            % (`integer`) Option for convolution integral or state-space calculation: convolution integral->0, state-space->1. Default = ``0``
        mode                = 'normal'                                     % (`string`) Simulation execution mode, 'normal', 'accelerator', 'rapid-accelerator'. Default = ``'normal'``
        solver              = 'ode4'                                      % (`string`) PDE solver used by the Simulink/SimMechanics simulation, 'ode4, 'ode45'. Default = ``'ode45'``
        numIntMidTimeSteps  = 5                                            % (`integer`) Number of intermediate time steps. Default = ``5`` for ode4 method
        autoRateTranBlk     = 'on'                                         % (`string`) Automatically handle rate transition for data transfer, 'on', 'off'. Default = ``'on'``
        zeroCrossCont       = 'DisableAll'                                 % (`string`) Disable zero cross control. Default = ``'DisableAll'``
        explorer            = 'on'                                         % (`string`) SimMechanics Explorer 'on' or 'off'. Default = ``'on'``
        rho                 = 1000                                         % (`float`) Density of water. Default = ``1000`` kg/m^3
        g                   = 9.81                                         % (`float`) Acceleration due to gravity. Default = ``9.81`` m/s
        nlHydro             = 0                                            % (`integer`) Option for nonlinear hydrohanamics calculation: linear->0, nonlinear->1. Default = ``0``
        yawNonLin           = 0                                            % (`integer`) Option for nonlinear yaw calculation linear->0, nonlinear->1 for nonlinear. Default = ``0`` 
        yawThresh           = 1                                            % (`float`) Yaw position threshold (in degrees) above which excitation coefficients will be interpolated in non-linear yaw. Default = ``1`` dg
        b2b                 = 0                                            % (`integer`) Option for body2body interactions: off->0, on->1. Default = ``0``
        paraview            = 0                                            % (`integer`) Option for writing vtp files for paraview visualization, off->0, on->1. Default = ``0``
        StartTimeParaview   = 0;                                           % (`float`) Start time for the vtk file of Paraview. Default = ``0``                                    
        EndTimeParaview     = 100;                                         % (`float`) End time for the vtk file of Paraview. Default = ``0``                                      
        dtParaview          = 0.1;                                         % (`float`) Timestep for Paraview. Default = ``0.1``         
        pathParaviewVideo = 'vtk';                                         % (`string`) Path of the folder for Paraview vtk files. Default = ``'vtk'``     
        adjMassWeightFun    = 2                                            % (`integer`) Weighting function for adjusting added mass term in the translational direction. Default = ``2``
        mcrCaseFile         = []                                           % (`string`) mat file that contain a list of the multiple conditions runs with given conditions. Default = ``'NOT DEFINED'``  
        morisonElement      = 0                                            % (`integer`) Option for Morison Element calculation: off->0, on->1 or 2. Default = ``0``. Option 1 uses an approach that allows the user to define drag and inertial coefficients along the x-, y-, and z-axes and Option 2 uses an approach that defines the Morison Element with normal and tangential tangential drag and interial coefficients.. 
        outputtxt           = 0                                            % (`integer`) Option to save results as ASCII files off->0, on->1. Default = ``0``
        outputStructure     = 1                                            % (`integer`) Option to save results as a MATLAB structure: off->0, on->1. Default = ``1``
        reloadH5Data        = 0                                            % (`integer`) Option to re-load hydro data from hf5 file between runs: off->0, on->1. Default = ``0``
        saveMat             = 1                                            % (`integer`) Option to save .mat file for each run: off->0, on->1. Default = ``1``
        pressureDis         = 0                                            % (`integer`) Option to save pressure distribution: off->0, on->1. Default = ``0``
    end

    properties (SetAccess = 'public', GetAccess = 'public')%internal
        version             = '4.2'                                        % (`string`) WEC-Sim version
        simulationDate      = datetime                                     % (`string`) Simulation date and time
        outputDir           = 'output'                                     % (`string`) Data output directory name. Default = ``'output'``
        time                = 0                                            % (`float`) Simulation time [s]. Default = ``0`` s
        inputFile           = 'wecSimInputFile'                            % (`string`) Name of WEC-Sim input file. Default = ``'wecSimInputFile'``
        logFile             = []                                           % (`string`) File with run information summary. Default = ``'log'``
        caseFile            = []                                           % (`string`) .mat file with all simulation information. Default = dependent
        caseDir             = []                                           % (`string`) WEC-Sim case directory. Default = dependent
        CIkt                = []                                           % (`integer`) Number of timesteps in the convolution integral length. Default = dependent
        maxIt               = []                                           % (`integer`) Total number of simulation time steps. Default = dependent
        CTTime              = []                                           % (`float vector`) Convolution integral time series. Default = dependent
        numWecBodies        = []                                           % (`integer`) Number of hydrodynamic bodies that comprise the WEC device. Default = ``'NOT DEFINED'``
        numDragBodies       = []                                           % (`integer`) Number of drag bodies that comprise the WEC device (excluding hydrodynamic bodies). Default = ``'NOT DEFINED'``
        numPtos             = []                                           % (`integer`) Number of power take-off elements in the model. Default = ``'NOT DEFINED'``
        numConstraints      = []                                           % (`integer`) Number of contraints in the wec model. Default = ``'NOT DEFINED'``
        numMoorings         = []                                           % (`integer`) Number of moorings in the wec model. Default = ``'NOT DEFINED'``
    end

    methods
        function obj = simulationClass()
            % This method initializes the ``simulationClass``.
            fprintf('WEC-Sim: An open-source code for simulating wave energy converters\n')
            fprintf('Version: %s\n\n',obj.version)
            fprintf('Initializing the Simulation Class...\n')
            obj.caseDir = pwd; 
            fprintf('\tCase Dir: %s \n',obj.caseDir)
            obj.outputDir = ['.' filesep obj.outputDir];
        end

        function obj = loadSimMechModel(obj,fName)
            % This method loads the simulink model and sets parameters
            % 
            % Parameters
            % ------------
            %   fname : string
            %       the name of the SimMechanics ``.slx`` file
            %
           
            modelName = gcs;
            set_param(modelName,'Solver',obj.solver,...
            'StopTime',num2str(obj.endTime),...
            'SimulationMode',obj.mode,...
            'StartTime',num2str(obj.startTime),...
            'FixedStep',num2str(obj.dt),...
            'MaxStep',num2str(obj.dt),...
            'AutoInsertRateTranBlk',obj.autoRateTranBlk,...
            'ZeroCrossControl',obj.zeroCrossCont,...
            'SimCompilerOptimization','on',...            
            'ReturnWorkspaceOutputs','off',...
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
            obj.caseFile = [obj.simMechanicsFile(length(obj.caseDir)+1:end-4) '_matlabWorkspace.mat'];            
            % Remove existing output folder
            if exist(obj.outputDir,'dir') ~= 0
                try
                    rmdir(obj.outputDir,'s')
                catch
                    warning('The output directory could not be removed. Please close any files in the output directory and try running WEC-Sim again')
                end
            end
            mkdir(obj.outputDir)
            obj.getWecSimVer;
        end

        function checkinputs(obj)
            % Checks user input to ensure that ``simu.endTime`` is specified and that the SimMechanics model exists
            
            if isempty(obj.endTime)
                error('simu.endTime, the simulation end time must be specified in the wecSimInputFile')
            end            
            % Check simMechanics file exists
            obj.simMechanicsFile = [obj.caseDir filesep obj.simMechanicsFile];     
            if exist(obj.simMechanicsFile,'file') ~= 4
                error('The simMechanics file, %s, does not exist in the case directory',obj.simMechanicsFile)
            end
        end

        function rhoDensitySetup(obj,rho,g)
            % Assigns density and gravity values
            %
            % Parameters
            % ------------
            %   rho : float
            %       density of the fluid medium (kg/m^3)
            %   g : float
            %       gravitational acceleration constant (m/s^2)
            %
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

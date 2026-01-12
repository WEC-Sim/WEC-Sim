%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 National Laboratory of the Rockies and National 
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
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    % The  ``simulationClass`` creates a ``simu`` object saved to the MATLAB
    % workspace. The ``simulationClass`` includes properties and methods used
    % to define WEC-Sim's simulation parameters and settings.
    %
    %.. autoattribute:: objects.simulationClass.simulationClass
    %
    %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
    
    properties (SetAccess = 'public', GetAccess = 'public') % WEC-Sim input 
        b2b (1,1) {mustBeInteger}                       = 0                 % (`integer`) Flag for body2body interactions, Options: 0 (off), 1 (on). Default = ``0``
        cicDt (1,:) {mustBeScalarOrEmpty}               = []                % (`float`) Time step to calculate the radiation convolution integral. Default = ``dt``
        cicEndTime (1,:) {mustBeScalarOrEmpty}          = 60                % (`float`) Convolution integral time. Default = ``60`` s
        domainSize (1,1) {mustBePositive}               = 200               % (`float`) Size of free surface and seabed. This variable is only used for visualization. Default = ``200`` m
        dt (1,1) {mustBePositive}                       = 0.1               % (`float`) Simulation time step. Default = ``0.1`` s
        dtOut (1,:) {mustBeScalarOrEmpty}               = []                % (`float`) Output sampling time. Default = ``dt``
        endTime (1,:) {mustBeScalarOrEmpty}             = []                % (`float`) Simulation end time. Default = ``[]``
        explorer (1,:) {mustBeText}                     = 'on'              % (`string`) SimMechanics Explorer 'on' or 'off'. Default = ``'on'``
        gravity (1,1) {mustBePositive}                  = 9.81              % (`float`) Acceleration due to gravity. Default = ``9.81`` m/s
        keepPool (1,1) logical                          = 1                 % (`logical`) Flag to keep parallel pool open after use of wecSimPCT. Default = ``1``
        mcrMatFile (1,:) {mustBeText}                   = ''                % (`string`) mat file that contain a list of the multiple conditions runs with given conditions. Default = ``[]``  
        mcrExcelFile (1,:) {mustBeText}                 = ''                % (`string`) File name from which to load wave statistics data. Default = ``[]``        
        mode (1,:) {mustBeText}                         = 'normal'          % (`string`) Simulation execution mode, 'normal', 'accelerator', 'rapid-accelerator'. Default = ``'normal'``
        morisonDt (1,:) {mustBeScalarOrEmpty}           = []                % (`float`) Sample time to calculate Morison Element forces. Default = ``dt``
        nonlinearDt (1,:) {mustBeScalarOrEmpty}         = []                % (`float`) Sample time to calculate nonlinear forces. Default = ``dt``
        paraview (1,1) struct                           = struct(...        % (`structure`) Defines the Paraview visualization.
            'option',                                   0,...               % 
            'startTime',                                [], ...             %
            'endTime',                                  [], ...             %
            'dt',                                       [], ...             % 
            'path',                                     'vtk')              % (`structure`) Defines the Paraview visualization. ``option`` (`integer`) Flag for paraview visualization, and writing vtp files, Options: 0 (off) , 1 (on). Default = ``0``. ``startTime`` (`float`) Start time for the vtk file of Paraview. Default = ``0``. ``endTime`` (`float`) End time for the vtk file of Paraview. Default = ``100``.  ``dt`` (`float`) Timestep for Paraview. Default = ``0.1``. ``path`` (`string`) Path of the folder for Paraview vtk files. Default = ``'vtk'``.      
        pressure (1,1) {mustBeInteger}                  = 0                 % (`integer`) Flag to save pressure distribution, Options: 0 (off), 1 (on). Default = ``0``
        rampTime (1,1) {mustBeNumeric}                  = 100               % (`float`) Ramp time for wave forcing. Default = ``100`` s        
        rateTransition (1,:) {mustBeText}               = 'on'              % (`string`) Flag for automatically handling rate transition for data transfer, Opyions: 'on', 'off'. Default = ``'on'``
        reloadH5Data (1,1) {mustBeInteger}              = 0                 % (`integer`) Flag to re-load hydro data from h5 file between runs, Options: 0 (off), 1 (on). Default = ``0``
        rho (1,1) {mustBePositive}                      = 1000              % (`float`) Density of water. Default = ``1000`` kg/m^3
        saveStructure (1,1) {mustBeInteger}             = 0                 % (`integer`) Flag to save results as a MATLAB structure, Options: 0 (off), 1 (on). Default = ``0``
        saveText (1,1) {mustBeInteger}                  = 0                 % (`integer`) Flag to save results as ASCII files, Options: 0 (off), 1 (on). Default = ``0``
        saveWorkspace (1,1) {mustBeInteger}             = 1                 % (`integer`) Flag to save .mat file for each run, Options: 0 (off), 1 (on). Default = ``1``
        simMechanicsFile (1,:) {mustBeText}             = 'NOT DEFINED'     % (`string`) Simulink/SimMechanics model file. Default = ``'NOT DEFINED'``
        solver (1,:) {mustBeText}                       = 'ode4'            % (`string`) PDE solver used by the Simulink/SimMechanics simulation. Any continuous solver in Simulink possible. Recommended to use 'ode4, 'ode45' for WEC-Sim. Default = ``'ode4'``
        stateSpace (1,1) {mustBeInteger}                = 0                 % (`integer`) Flag for convolution integral or state-space calculation, Options: 0 (convolution integral), 1 (state-space). Default = ``0``
        FIR(1,1) {mustBeInteger}                        = 0                 % (`integer`) Flag for FIR calculation, Options: 0 (convolution integral), 1 (FIR). Default = ``0``
        startTime (1,1) {mustBeScalarOrEmpty}           = 0                 % (`float`) Simulation start time. Default = ``0`` s        
        zeroCross (1,:) {mustBeText}                    = 'DisableAll'      % (`string`) Disable zero cross control. Default = ``'DisableAll'``
        outputDir (1,:) {mustBeText}                    = 'output'          % (`string`) Data output directory name. Default = ``'output'``
    end

    properties (SetAccess = 'public', GetAccess = 'public') % internal WEC-Sim
        caseDir             = []                                           % (`string`) WEC-Sim case directory. Default = dependent
        numCables           = 0                                            % (`integer`) Number of cables in the wec model. Default = ``0``
        numConstraints      = 0                                            % (`integer`) Number of contraints in the wec model. Default = ``0``
        numDragBodies       = 0                                            % (`integer`) Number of drag bodies that comprise the WEC device (excluding hydrodynamic bodies). Default = ``0``
        numHydroBodies      = 0                                            % (`integer`) Number of hydrodynamic bodies that comprise the WEC device. Default = ``0``
        numMoorDyn          = 0                                            % (`integer`) Number of moordyn blocks systems in the wec model. Default = ``0``
        numMoorings         = 0                                            % (`integer`) Number of moorings in the wec model. Default = ``0``
        numPtos             = 0                                            % (`integer`) Number of power take-off elements in the model. Default = ``0``
        numPtoSim           = 0                                            % (`integer`) Number of PTO-Sim elements in the model. Default = ``0``        
        time                = 0                                            % (`float`) Simulation time [s]. Default = ``0`` s
    end

    properties (SetAccess = 'private', GetAccess = 'public') % internal WEC-Sim
        caseFile            = []                                           % (`string`) .mat file with all simulation information. Default = dependent
        cicLength           = []                                           % (`integer`) Number of timesteps in the convolution integral length. Default = dependent
        cicTime             = []                                           % (`float vector`) Convolution integral time series. Default = dependent
        date                = datetime                                     % (`string`) Simulation date and time
        gitCommit           = []                                           % (`string`) GitHub commit
        maxIt               = []                                           % (`integer`) Total number of simulation time steps. Approximate for variable step solvers. Default = dependent
        wsVersion           = '7.0.0'                                      % (`string`) WEC-Sim version
    end

    methods
        function obj = simulationClass()
            % This method initializes the ``simulationClass``.
            fprintf('WEC-Sim: An open-source code for simulating wave energy converters\n')
            fprintf('Version: %s\n\n',obj.wsVersion)
            fprintf('Initializing the Simulation Class...\n')
            obj.caseDir = pwd; 
            fprintf('\tCase Dir: %s \n',obj.caseDir)
            obj.outputDir = ['.' filesep obj.outputDir];
        end

        function checkInputs(obj)
            % This method checks WEC-Sim user inputs and generates error messages if parameters are not properly defined. 

            % Check struct inputs:
            mustBeMember(obj.paraview.option, [0 1])
            mustBeScalarOrEmpty(obj.paraview.startTime)
            mustBeScalarOrEmpty(obj.paraview.endTime)
            mustBePositive(obj.paraview.dt)
            mustBeText(obj.paraview.path)
            % Check restricted/boolean variables
            mustBeMember(obj.b2b,[0 1])
            mustBeMember(obj.explorer,{'on','off'})
            mustBeMember(obj.mode,{'normal','accelerator','rapid-accelerator'})
            mustBeMember(obj.pressure,[0 1])
            mustBeMember(obj.rateTransition,{'on','off'})
            mustBeMember(obj.reloadH5Data,[0 1])
            mustBeMember(obj.saveStructure,[0 1])
            mustBeMember(obj.saveText,[0 1])
            mustBeMember(obj.saveWorkspace,[0 1])
            mustBeMember(obj.stateSpace,[0 1])
            mustBeMember(obj.FIR,[0 1])
            mustBeMember(obj.solver,{'ode1', 'ode1be', 'ode2', 'ode3', 'ode4', 'ode5', 'ode8', 'ode14x','ode15s', ...
                'ode23', 'ode23s', 'ode23t', 'ode23tb', 'ode45', 'ode113', 'odeN', 'daessc'})
            
            % Check that simMechanics file exists
            obj.simMechanicsFile = [obj.caseDir filesep obj.simMechanicsFile];     
            if exist(obj.simMechanicsFile,'file') ~= 4
                error('The simMechanics file, %s, does not exist in the case directory',obj.simMechanicsFile)
            end            
            % Check 'simu.paraview' fields
            if length(fieldnames(obj.paraview)) ~=5
                error(['Unrecognized method, property, or field for class "simulationClass", ' ... 
                    '"simulationClass.paraview" structure must only include fields: "option", "startTime", "endTime", "dt", "outputDir"']);
            end

            % Check that visualization is off when using accelerator modes
            if (strcmp(obj.mode,'accelerator') || strcmp(obj.mode,'rapid-accelerator')) ...
                    && strcmp(obj.explorer,'on')
                warning('Mechanics explorer not allowed in accelerator or rapid-accelerator modes. Turning mechanics explorer off.');
                obj.explorer = 'off';
            end
            
             % Checks user input to ensure that ``simu.endTime`` is specified
            if isempty(obj.endTime) || obj.endTime < obj.startTime
                error('simu.endTime, the simulation end time must be specified in the wecSimInputFile and must be greater than simu.startTime.')
            end
            % Checks user input to ensure that output timestep is larger
            % than or equal to simulation timestep
            if obj.dtOut < obj.dt
                warning('Simu.dtOut, the output timestep, should be greater than or equal to simu.dt, the simulation timestep. The smaller output timestep will be overwritten with the value of the simulation timestep to avoid errors.')
            end
        end
        
        function setup(obj)
            % Sets simulation properties based on values specified in input file
            obj.time = obj.startTime:obj.dt:obj.endTime;
            obj.maxIt = floor((obj.endTime - obj.startTime) / obj.dt);            
            % Set dtOut if it was not specificed in input file
            if isempty(obj.dtOut) || obj.dtOut < obj.dt
                obj.dtOut = obj.dt;
            end            
            % Set nonlinearDt if it was not specificed in input file
            if isempty(obj.nonlinearDt) || obj.nonlinearDt < obj.dt
                obj.nonlinearDt = obj.dt;
            end            
            % Set cicDt if it was not specificed in input file
            if isempty(obj.cicDt) || obj.cicDt < obj.dt
                obj.cicDt = obj.dt;
            end            
            % Set morisonDt if it was not specificed in input file
            if isempty(obj.morisonDt) || obj.morisonDt < obj.dt
                obj.morisonDt = obj.dt;
            end            
            % Set paraview.dt if it was not specified in input file
            if isempty(obj.paraview.dt) || obj.paraview.dt < obj.dtOut
                obj.paraview.dt = obj.dtOut;
            end            
            obj.cicTime = 0:obj.cicDt:obj.cicEndTime;            
            obj.cicLength = length(obj.cicTime);
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
            obj.getGitCommit;
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
                fprintf('\tConvolution Integral Interval  (sec) = %G\n',obj.cicEndTime)
            end
            fprintf('\t Number of Time Steps     = %u \n',obj.maxIt)
        end
        
        function obj = loadSimMechModel(obj,fName)
            % This method loads the simulink model and sets parameters
            % 
            % Parameters
            % ------------
            %   fname : string
            %       the name of the SimMechanics ``.slx`` file
            %
            
            load_system(fName);
            [~,modelName,~] = fileparts(fName);
            set_param(modelName,'Solver',obj.solver,...
                'StopTime',num2str(obj.endTime),...
                'SimulationMode',obj.mode,...
                'StartTime',num2str(obj.startTime),...
                'FixedStep',num2str(obj.dt),...
                'MaxStep',num2str(obj.dt),...
                'AutoInsertRateTranBlk',obj.rateTransition,...
                'ZeroCrossControl',obj.zeroCross,...
                'SimCompilerOptimization','on',...            
                'ReturnWorkspaceOutputs','off',...
                'SimMechanicsOpenEditorOnUpdate',obj.explorer);
        end

        function rhoDensitySetup(obj,rho,gravity)
            % Assigns density and gravity values
            %
            % Parameters
            % ------------
            %   rho : float
            %       density of the fluid medium (kg/m^3)
            %   gravity : float
            %       gravitational acceleration constant (m/s^2)
            %
            obj.rho = rho;
            obj.gravity   = gravity;
        end

        function getGitCommit(obj)
            % Determines GitHub commit tag
            try
                ws_exe = which('wecSim');
                ws_dir = fileparts(ws_exe);
                git_ver_file = [ws_dir '/../.git/refs/heads/main'];
                obj.gitCommit = textread(git_ver_file,'%s');
            catch
                obj.gitCommit = 'No git commit tag available';
            end
        end
    end
end

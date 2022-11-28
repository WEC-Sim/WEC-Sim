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

classdef controllerClass<handle
    % This class contains PTO-Sim parameters and settings
    properties
        declutching (1,1) struct                = struct(...                % Declutching Controller Properties
            'declutchTime',                     0,...                       % (`float`) Amount of time device is delutched during each half period of motion
            'Kp',                               0)                          % (`float`) Proportional gain (damping)
        latching (1,1) struct                   = struct(...                % Latching Controller Properties
            'forceCoeff',                       0,...                       % (`float`) Damping force coefficient for latching/braking
            'latchTime',                        0,...                       % (`float`) Amount of time device is latched during each half period of motion
            'Kp',                               0)                          % (`float`) Proportional gain (damping)
        modelPredictiveControl (1,1) struct       = struct(...              % Model Predictive Controller Properties
            'maxPTOForce',                      10e6,...                    % (`float`) Maximum PTO Force (N)
            'maxPTOForceChange',                5e6,...                     % (`float`) Maximum Change in PTO Force (N/timestep)
            'maxPos',                           3,...                       % (`float`) Maximum Position (m)
            'maxVel',                           10,...                      % (`float`) Maximum Velocity (m/s)
            'predictionHorizon',                20,...                      % (`float`) Future time period predicted by plant model (s)
            'dt',                               0.5,...                     % (`float`) Timestep in which MPC is applied (s)
            'rScale',                           1e-7,...                    % (`float`) Scale for penalizing PTO force rate of change
            'Ho',                               100,...                     % (`float`) Number of timesteps before MPC begins
            'order',                            4,...                       % (`float`) Order of the plant model
            'yLen',                             3)                          % (`float`) Length of the output variable
        MPC (1,1)                               = 0                         % (`float`) Option to turn on MPC
        name (1,:) {mustBeText}                 = 'NOT DEFINED'             % Controller Name
        proportional (1,1) struct               = struct(...                % Proportional Controller Properties
            'Kp',                               0)                          % (`float`) Proportional gain (damping)
        proportionalIntegral (1,1) struct       = struct(...                % Proportional-Integral Controller Properties
            'Kp',                               0,...                       % (`float`) Proportional gain (damping)
            'Ki',                               0)                          % (`float`) Integral gain (stiffness)
    end

    properties (SetAccess = 'public', GetAccess = 'public')%internal       
        % The following properties are private, for internal use by WEC-Sim
        bemData (1,1) struct                    = struct(...                % Data from BEM used to create plant model
            'a',                                [],...                      % Added mass 
            'aInf',                             [],...                      % Infinite frequency added mass
            'm',                                [],...                      % Mass
            'k',                                [],...                      % Hydrostatic stiffness
            'b',                                [])                         % Radiation damping
        MPCSetup (1,1) struct                   = struct(...                % Variables used to set up the MPC algorithm
            'HpInk',                            [],...                      % Number of predictions in discrete domain
            'SimTimeToFullBuffer',              [],...                      % Amount of simulation time before MPC initiates
            'currentIteration',                 [],...                      % Current iteration of MPC algorithm
            'infeasibleCount',                  [],...                      % Number of predictions which are infeasible according to quadprog()
            'numSamplesInEntireRun',            [],...                      % Number of MPC timesteps throughout simulation
            'outputSize',                       [],...                      % Size of output vector 
            'Sx',                               [],...                      % Sx for quadratic programming
            'Su',                               [],...                      % Su for quadratic programming
            'Sv',                               [],...                      % Sv for quadratic programming
            'R',                                [],...                      % R for quadratic programming
            'Q',                                [],...                      % Q for quadratic programming
            'H',                                [])                         % H for quadratic programming
        plant (1,1) struct                                                  % plant model for MPC
    end
    
    properties (SetAccess = 'public', GetAccess = 'public') %internal
        number  = []                                                        % Controller number
    end
    
    methods
        function obj        = controllerClass(name)
            % Initilization function
            if exist('name','var')
                obj.name = name;
            else
                error('The controller class number(s) in the wecSimInputFile must be specified in ascending order starting from 1. The controllerClass() function should be called first to initialize each ptoSim block with a name.')
            end
        end

        function checkInputs(obj)
            % This method checks WEC-Sim user inputs and generates error messages if parameters are not properly defined. 
            
            % Check struct inputs:
            mustBeNumeric(obj.proportional.Kp)
        end

        function setUpMPC(obj, body, simu)
            % This method sets up the variables to run model predictive control 
            
            disp('setting up MPC')
            obj.bemData.a = squeeze(body(1).hydroData.hydro_coeffs.added_mass.all(3,3,:)).*simu.rho;
            obj.bemData.aInf = body(1).hydroData.hydro_coeffs.added_mass.inf_freq(3,3)*simu.rho;
            obj.bemData.m = body(1).hydroData.properties.volume*1000;
            obj.bemData.k = body(1).hydroData.hydro_coeffs.linear_restoring_stiffness(3,3)*simu.rho*simu.gravity; 
            obj.bemData.b = squeeze(body(1).hydroData.hydro_coeffs.radiation_damping.all(3,3,:)).*simu.rho.*body(1).hydroData.simulation_parameters.w';
            obj.MPCSetup.HpInk = obj.modelPredictiveControl.predictionHorizon/obj.modelPredictiveControl.dt;
            obj.MPCSetup.qScale = 0.5*obj.modelPredictiveControl.dt;
            obj.MPCSetup.currentIteration = 0;
            obj.MPCSetup.infeasibleCount = 0;
            
            % Tracks # of occurances of non-convergence      
            obj.MPCSetup.numSamplesInEntireRun = simu.endTime/simu.dt;  % Total number of SIM iterations (not neccesarily MPC iterations)
            obj.MPCSetup.timeSamplesPerIteration = obj.modelPredictiveControl.dt/simu.dt;
            
            % Prediction Start
            obj.MPCSetup.SimTimeToFullBuffer = (obj.modelPredictiveControl.order+obj.modelPredictiveControl.Ho)*obj.modelPredictiveControl.dt/simu.dt;  % 0.1 is the simulation time step

            load('coeff.mat');

            % Make Plant Model            
            obj.makePlantModel(obj.bemData,coeff);
            obj.plant.sys_c = ss(obj.plant.A,[obj.plant.Bu obj.plant.Bv],obj.plant.C,[obj.plant.Du obj.plant.Dv]); % still continuous
            
            % Make predictive model for quadratic programming
            obj.makePredictiveModel(obj.plant.sys_c); % Discretizes CT SS object and computes Sx, Su, & Sv. Wrapped up under shared global mpc for ease of access in L2 simulink block
            obj.MPCSetup.H = obj.MPCSetup.Su'*obj.MPCSetup.Q*obj.MPCSetup.Su + obj.MPCSetup.R;

            if all(eig(obj.MPCSetup.H) >= 0) == 0
                eig(obj.MPCSetup.H);
                error('PSD Violated')
            end
           
            % Set output size
            obj.MPCSetup.outputSize = (obj.MPCSetup.HpInk+1)*1;
        end
        
        function makePlantModel(obj,bemData,coeff)
            %This method checks WEC-Sim user inputs and generates error messages if parameters are not properly defined. 
            % For PLANT model: Create A, Bu, & Bv matrices using WEC paramaters obtained from the BEM solution. 

            % Build "Full Fpto" matrices (i.e., not incremental)
            % "A" is multiplied by a buoy state matrix [dzb;zb;fr';intfr']. 
            % Bu is mulitplied by Fpto. Bv = Bu and is multiplied by Fe.    
            % Then these matrices are augmented in the delta formulation to track the
            % new state, Fpto. Then Bu is is multiplied by dFpto instead of just Fpto.
            %
            % preDelta.oneBody.A = [0, -wec.k/(wec.m+wec.Ainf), 1/(wec.m+wec.Ainf), 0; ...
            %      1, 0, 0, 0; ...
            %      -wec.Caa/wec.Cba, -wec.Cab/wec.Cba, -wec.Cbb/wec.Cba, -wec.Cbc/wec.Cba; ...
            %      0, 0, 1, 0];
            %  
            % preDelta.oneBody.Bu = [1/(wec.m+wec.Ainf);  %dZb
            %        0;   % Zb
            %        0;   % Fr
            %        0];  % intFr
            %    
            % preDelta.oneBody.Bv = [1/(wec.m+wec.Ainf);  ...
            %        0;  ...
            %        0;  ...
            %        0];
            % 
            % preDelta.oneBody.C = [1 0 0 0; ... % Map y(1) = dZb
            %          0 1 0 0; ... % Map y(2) = Zb
            %         ];
            %% A, B, C, and D for one body
            obj.plant.A = zeros(8); %% (length of KradNum, length of KradDen-1) order 4 (KradDen = aS^4+bS^3+cS^2+dS+constant)
            obj.plant.A(1,2) = -bemData.k/(bemData.m+bemData.aInf);
            obj.plant.A(1,5) = 1/(bemData.m+bemData.aInf);
            obj.plant.A(2:4,1:3)=eye(3);
            obj.plant.A(5,:)=[-coeff.KradNum -coeff.KradDen(2:end)];
            obj.plant.A(6:end,5:end-1) = eye(3);
            
            obj.plant.Bv = zeros(8,1);
            obj.plant.Bv(1,1) = 1/(bemData.m+bemData.aInf);
            obj.plant.Bu = zeros(8,1);
            obj.plant.Bu(1,1) = 1/(bemData.m+bemData.aInf);% NEW!!!;
            
            obj.plant.C = [1, zeros(1,8-1); ...
                0, 1, zeros(1,8-2)];

            %% Augmenting for the delta formulation which has Fpto in the states and replaces that w/ dFpto as the control input
            obj.plant.A = [obj.plant.A, obj.plant.Bu; zeros(1,8+1)];
            obj.plant.Bu = [zeros(8,1); 1];
            obj.plant.Bv = [obj.plant.Bv; 0];  
            obj.plant.C = [obj.plant.C zeros(2,1); zeros(1,8), 1]; 
            
            obj.plant.Du  = zeros(3,1);   % dFpto has no contripution to output states. [3x1] per each pod since output is Z, dZ, Fpto
            obj.plant.Dv = zeros(3,1);    % Fe has no contripution to output states
        end
        function makePredictiveModel(obj,sys_c)
            % Discretize SS object passed as argument & pull out DISCRETE coeff matrices
            % Important! The coeff matrices (A, Bu, Bv) here are DISCRETE & won't match
            % their continuous time counterparts developed in the main.m file. ZOH does
            % keep states, however, unlike some other methods.
            sys_d = c2d(sys_c,obj.modelPredictiveControl.dt,'zoh');
            [A_d,B_d,C_d,D_d] = ssdata(sys_d);
            A_dis = A_d;    
            C_dis = C_d;
            
            Bu_dis = B_d(:,1);  % SS object has one B matrix w/ 2 columns. First = Bu, Second = Bv.
            Bv_dis = B_d(:,2);
            Du_dis = D_d(:,1);  % SS object has one B matrix w/ 2 columns. First = Du, Second = Dv.
            Dv_dis = D_d(:,2);
            
            
            nx = size(A_dis,1); % #column 
            nu = size(Bu_dis,2); % #column
            nv = size(Bv_dis,2); %
            ny = size(C_dis,1);

            % Create Sx: Coefficient matrix for buoy state, x(k), in predictive plant model
            Sx = [];
            for kp = 0:obj.MPCSetup.HpInk
                Sx = [Sx ; C_dis*A_dis^kp];
            end
            
            % Create Su: Coefficient matrix for PTO, u(k), in predictive plant model
            Su = NaN(ny*(obj.MPCSetup.HpInk+1),nu*(obj.MPCSetup.HpInk+1));
            for rowGroup = 1:obj.MPCSetup.HpInk+1
                activeRows = (1:ny)+ny*(rowGroup-1);
                Su(activeRows,(1:nu)+nu*(rowGroup-1)) = Du_dis;
                Su(activeRows,(1+nu*(rowGroup-1+1):nu*(obj.MPCSetup.HpInk+1))) = 0;
                if rowGroup >= 2
                    for colGroup = 1:(rowGroup-1)
                        activeCols = (1:nu)+nu*(colGroup-1);
                        Su(activeRows,activeCols) = C_dis*A_dis^(rowGroup-colGroup-1)*Bu_dis;
                    end
                end
            end 
            
            %% Create Sv: Coefficient matrix for Fe, v(k), in predictive plant model
            Sv = NaN(ny*(obj.MPCSetup.HpInk+1),nv*(obj.MPCSetup.HpInk+1));
            for rowGroup = 1:obj.MPCSetup.HpInk+1
                activeRows = (1:ny)+ny*(rowGroup-1);
                Sv(activeRows,(1:nv)+nv*(rowGroup-1)) = Dv_dis;
                Sv(activeRows,(1+nv*(rowGroup-1+1):nv*(obj.MPCSetup.HpInk+1))) = 0;
                if rowGroup >= 2
                    for colGroup = 1:(rowGroup-1)
                        activeCols = (1:nv)+nv*(colGroup-1);
                        Sv(activeRows,activeCols) = C_dis*A_dis^(rowGroup-colGroup-1)*Bv_dis;
                    end
                end
            end 
            % Clip top row group so that our matrices begin calculating for y(k+1) instead of y(k)
            % The reason is that y(k) (dZ/Z/Fpto) is a product of x(k) only. We wouldn't want MPC
            % to have a constraint on that, since x(k) is already set. It comes in as
            % an input to the block. Could lead to infeasibilities. 
            obj.MPCSetup.Sx = Sx(ny+1:end,:);
            obj.MPCSetup.Su = Su(ny+1:end,:);
            obj.MPCSetup.Sv = Sv(ny+1:end,:);
            
            % Regardless of which constraint type we use, same size matrix/seed and
            % same R
            blkDiagSeed = eye(obj.MPCSetup.HpInk);% For model w/ no cross coupling, it's just blkdiag for each pod and iteration. Its just HpInK becauuse Su is from k+1 to k+Hp.
            
            % R: Matrix weighting penalization for rate of change of control action.
            R_unscaled = eye(size(Su,2));    % u'*R*u - R is a square matrix matching rows in u rows
            obj.MPCSetup.R = obj.modelPredictiveControl.rScale*R_unscaled;
            
                % Q: Matrix weighting product of dZ * dFpto!
                minorQ = [0,0,1; 0,0,0; 1,0,0];
            
            Q_unscaled = kron(blkDiagSeed,minorQ);
            obj.MPCSetup.Q = obj.MPCSetup.qScale*Q_unscaled;
        end
    end
end

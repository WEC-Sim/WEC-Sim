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
controller(1).plant.A = zeros(8); %% (length of KradNum, length of KradDen-1) order 4 (KradDen = aS^4+bS^3+cS^2+dS+constant)
controller(1).plant.A(1,2) = -controller(1).bemData.k/(controller(1).bemData.m+controller(1).bemData.aInf);
controller(1).plant.A(1,5) = 1/(controller(1).bemData.m+controller(1).bemData.aInf);
controller(1).plant.A(2:4,1:3)=eye(3);
controller(1).plant.A(5,:)=[-coeff.KradNum -coeff.KradDen(2:end)];
controller(1).plant.A(6:end,5:end-1) = eye(3);

controller(1).plant.Bv = zeros(8,1);
controller(1).plant.Bv(1,1) = 1/(controller(1).bemData.m+controller(1).bemData.aInf);
controller(1).plant.Bu = zeros(8,1);
controller(1).plant.Bu(1,1) = 1/(controller(1).bemData.m+controller(1).bemData.aInf);% NEW!!!;

controller(1).plant.C = [1, zeros(1,8-1); ...
    0, 1, zeros(1,8-2)];

%% Augmenting for the delta formulation which has Fpto in the states and replaces that w/ dFpto as the control input
controller(1).plant.A = [controller(1).plant.A, controller(1).plant.Bu; zeros(1,8+1)];
controller(1).plant.Bu = [zeros(8,1); 1];
controller(1).plant.Bv = [controller(1).plant.Bv; 0];  
controller(1).plant.C = [controller(1).plant.C zeros(2,1); zeros(1,8), 1]; 

controller(1).plant.Du  = zeros(3,1);   % dFpto has no contripution to output states. [3x1] per each pod since output is Z, dZ, Fpto
controller(1).plant.Dv = zeros(3,1);    % Fe has no contripution to output states

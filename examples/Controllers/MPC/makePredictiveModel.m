% Discretize SS object passed as argument & pull out DISCRETE coeff matrices
% Important! The coeff matrices (A, Bu, Bv) here are DISCRETE & won't match
% their continuous time counterparts developed in the main.m file. ZOH does
% keep states, however, unlike some other methods.
sys_d = c2d(controller(1).plant.sys_c,controller(1).modelPredictiveControl.dt,'zoh');
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
for kp = 0:controller(1).MPCSetup.HpInk
    Sx = [Sx ; C_dis*A_dis^kp];
end

% Create Su: Coefficient matrix for PTO, u(k), in predictive plant model
Su = NaN(ny*(controller(1).MPCSetup.HpInk+1),nu*(controller(1).MPCSetup.HpInk+1));
for rowGroup = 1:controller(1).MPCSetup.HpInk+1
    activeRows = (1:ny)+ny*(rowGroup-1);
    Su(activeRows,(1:nu)+nu*(rowGroup-1)) = Du_dis;
    Su(activeRows,(1+nu*(rowGroup-1+1):nu*(controller(1).MPCSetup.HpInk+1))) = 0;
    if rowGroup >= 2
        for colGroup = 1:(rowGroup-1)
            activeCols = (1:nu)+nu*(colGroup-1);
            Su(activeRows,activeCols) = C_dis*A_dis^(rowGroup-colGroup-1)*Bu_dis;
        end
    end
end 

%% Create Sv: Coefficient matrix for Fe, v(k), in predictive plant model
Sv = NaN(ny*(controller(1).MPCSetup.HpInk+1),nv*(controller(1).MPCSetup.HpInk+1));
for rowGroup = 1:controller(1).MPCSetup.HpInk+1
    activeRows = (1:ny)+ny*(rowGroup-1);
    Sv(activeRows,(1:nv)+nv*(rowGroup-1)) = Dv_dis;
    Sv(activeRows,(1+nv*(rowGroup-1+1):nv*(controller(1).MPCSetup.HpInk+1))) = 0;
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
controller(1).MPCSetup.Sx = Sx(ny+1:end,:);
controller(1).MPCSetup.Su = Su(ny+1:end,:);
controller(1).MPCSetup.Sv = Sv(ny+1:end,:);

% Regardless of which constraint type we use, same size matrix/seed and
% same R
blkDiagSeed = eye(controller(1).MPCSetup.HpInk);% For model w/ no cross coupling, it's just blkdiag for each pod and iteration. Its just HpInK becauuse Su is from k+1 to k+Hp.

% R: Matrix weighting penalization for rate of change of control action.
R_unscaled = eye(size(Su,2));    % u'*R*u - R is a square matrix matching rows in u rows
controller(1).MPCSetup.R = controller(1).modelPredictiveControl.rScale*R_unscaled;

    % Q: Matrix weighting product of dZ * dFpto!
    minorQ = [0,0,1; 0,0,0; 1,0,0];

Q_unscaled = kron(blkDiagSeed,minorQ);
controller(1).MPCSetup.Q = controller(1).MPCSetup.qScale*Q_unscaled;
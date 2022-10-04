function [Sx,Su,Sv, Q, R] = fnMakePredictiveModel(sys_c, mpc, wec)
%% Discretize SS object passed as argument & pull out DISCRETE coeff matrices
% Important! The coeff matrices (A, Bu, Bv) here are DISCRETE & won't match
% their continuous time counterparts developed in the main.m file. ZOH does
% keep states, however, unlike some other methods.
sys_d = c2d(sys_c,mpc.Ts,'zoh');
[A_d,B_d,C_d,D_d] = ssdata(sys_d);
A_dis = A_d;    
C_dis = C_d;

Bu_dis = B_d(:,1);  % SS object has one B matrix w/ 2 columns. First = Bu, Second = Bv.
Bv_dis1 = B_d(:,2);
Bv_dis2 = B_d(:,3);
Du_dis = D_d(:,1);  % SS object has one B matrix w/ 2 columns. First = Du, Second = Dv.
Dv_dis1 = D_d(:,2);
Dv_dis2 = D_d(:,3);


nx = size(A_dis,1); % #column 
nu = size(Bu_dis,2); % #column
nv = size(Bv_dis1,2); %size of Bv_dis1=Bv_dis2
ny = size(C_dis,1);

%% Create Sx: Coefficient matrix for buoy state, x(k), in predictive plant model
Sx = [];
for kp = 0:mpc.HpInK
    Sx = [Sx ; C_dis*A_dis^kp];
end

%% Create Su: Coefficient matrix for PTO, u(k), in predictive plant model
Su = NaN(ny*(mpc.HpInK+1),nu*(mpc.HpInK+1));
for rowGroup = 1:mpc.HpInK+1
    activeRows = (1:ny)+ny*(rowGroup-1);
    Su(activeRows,(1:nu)+nu*(rowGroup-1)) = Du_dis;
    Su(activeRows,(1+nu*(rowGroup-1+1):nu*(mpc.HpInK+1))) = 0;
    if rowGroup >= 2
        for colGroup = 1:(rowGroup-1)
            activeCols = (1:nu)+nu*(colGroup-1);
            Su(activeRows,activeCols) = C_dis*A_dis^(rowGroup-colGroup-1)*Bu_dis;
        end
    end
end 

%% Create Sv1: Coefficient matrix for Fe, v(k), in predictive plant model
Sv1 = NaN(ny*(mpc.HpInK+1),nv*(mpc.HpInK+1));
for rowGroup = 1:mpc.HpInK+1
    activeRows = (1:ny)+ny*(rowGroup-1);
    Sv1(activeRows,(1:nv)+nv*(rowGroup-1)) = Dv_dis1;
    Sv1(activeRows,(1+nv*(rowGroup-1+1):nv*(mpc.HpInK+1))) = 0;
    if rowGroup >= 2
        for colGroup = 1:(rowGroup-1)
            activeCols = (1:nv)+nv*(colGroup-1);
            Sv1(activeRows,activeCols) = C_dis*A_dis^(rowGroup-colGroup-1)*Bv_dis1;
        end
    end
end 
%% Create Sv2: Coefficient matrix for Fe, v(k), in predictive plant model
Sv2 = NaN(ny*(mpc.HpInK+1),nv*(mpc.HpInK+1));
for rowGroup = 1:mpc.HpInK+1
    activeRows = (1:ny)+ny*(rowGroup-1);
    Sv2(activeRows,(1:nv)+nv*(rowGroup-1)) = Dv_dis2;
    Sv2(activeRows,(1+nv*(rowGroup-1+1):nv*(mpc.HpInK+1))) = 0;
    if rowGroup >= 2
        for colGroup = 1:(rowGroup-1)
            activeCols = (1:nv)+nv*(colGroup-1);
            Sv2(activeRows,activeCols) = C_dis*A_dis^(rowGroup-colGroup-1)*Bv_dis2;
        end
    end
end 
%% Clip top row group so that our matrices begin calculating for y(k+1) instead of y(k)
% The reason is that y(k) (dZ/Z/Fpto) is a product of x(k) only. We wouldn't want MPC
% to have a constraint on that, since x(k) is already set. It comes in as
% an input to the block. Could lead to infeasibilities. 
Sx = Sx(ny+1:end,:);
Su = Su(ny+1:end,:);
Sv = [Sv1(ny+1:end,:) Sv2(ny+1:end,:)];

%% Create penalizing matrices Q & R  for MPC formulation (not predictive model)
% In multibody predictive model w/ clipped top row, output is:
% y = [dZ1(k+1);Z1(k+1);Fpto1(k+1);dZ2(k+1);Z2(k+1);Fpto2(k+1); ...
%      dZ1(k+2);Z1(k+2);Fpto1(k+2);dZ2(k+2);Z2(k+2);Fpto2(k+2); ..
%      etc. ];
% And the input is:
% u = [dFpto1(k+1);dFpto2(k+1); ...
%      dFpto2(k+2);dFpto2(k+2); ...
%     etc. ];
% So we need to make a matrix Q that multiplies the dFpto*dZb for the same
% buoy AND time step! i.e. dZ1(k+1)*dFpto1(k+1) and dZ2(k+1)*dFpto2(k+1)
% and dZ1(k+2)*dFpto1(k+2) etc.

% y'*Q*y so [dZ,Z,dFpto]*Q*[dZ;Z;dFpto]

% Regardless of which constraint type we use, same size matrix/seed and
% same R
blkDiagSeed = eye(wec.numWECs*(mpc.HpInK));% For model w/ no cross coupling, it's just blkdiag for each pod and iteration. Its just HpInK becauuse Su is from k+1 to k+Hp.

% R: Matrix weighting penalization for rate of change of control action.
R_unscaled = eye(size(Su,2));    % u'*R*u - R is a square matrix matching rows in u rows
R = mpc.RScale*R_unscaled;


    % Q: Matrix weighting product of dZ * dFpto!
    minorQ = [ ...  
              0,0,0,0,1; ... 
              0,0,0,0,0; ... 
              0,0,0,0,-1;...
              0,0,0,0,0;
              1,0,-1,0,0; ...
              ];


Q_unscaled = kron(blkDiagSeed,minorQ);
Q = mpc.QScale*Q_unscaled;

end
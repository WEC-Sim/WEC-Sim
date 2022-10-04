function [preDelta,plant] = fnMakePlantAndPreDeltaModel(wec,coeff)
%% For PLANT model: Create A, Bu, & Bv matrices using WEC paramaters obtained from the BEM solution. 

%% Build "Full Fpto" matrices (i.e., not incremental)
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
%% A, B, C, and D for both float and spar 
plant1.A = zeros(4+4); %% (length of KradNum, length of KradDen-1) order 4 (KradDen = aS^4+bS^3+cS^2+dS+constant)
plant1.A(1,2) = -wec.kFloat/(wec.mFloat+wec.AinfFloat);
plant1.A(1,5) = 1/(wec.mFloat+wec.AinfFloat);
plant1.A(2:4,1:3)=eye(3);
plant1.A(5,:)=[-coeff.KradNumFloat -coeff.KradDenFloat(2:end)];
plant1.A(6:end,5:end-1) = eye(3);

plant1.B = zeros(4+4,1);
plant1.B(1,1) = 1/(wec.mFloat+wec.AinfFloat);

plant1.C = eye(4+4);
plant1.D = zeros(4+4,1);

plant1.ASpar = zeros(4+4); %% (length of KradNum, length of KradDen-1) order 4 (KradDen = aS^4+bS^3+cS^2+dS+constant)
plant1.ASpar(1,2) = -wec.kSpar/(wec.mSpar+wec.AinfSpar);
plant1.ASpar(1,5) = 1/(wec.mSpar+wec.AinfSpar);
plant1.ASpar(2:4,1:3)=eye(3);
plant1.ASpar(5,:)=[-coeff.KradNumSpar -coeff.KradDenSpar(2:end)];
plant1.ASpar(6:end,5:end-1) = eye(3);

plant1.BSpar = zeros(4+4,1);
plant1.BSpar(1,1) = 1/(wec.mSpar+wec.AinfSpar);

plant1.CSpar = eye(4+4);
plant1.DSpar = zeros(4+4,1);

% plantCross puts A, B, C, and D together for the two bodies and adds
% interactions
plantCross.A=zeros(3*8);
plantCross.A(1:8,1:8)=plant1.A;
plantCross.A(9:16,9:16)=plant1.ASpar;
plantCross.A(1,17)=1/(wec.mFloat+wec.AinfFloat);

temp = zeros(4);
temp(1,:)=[-coeff.KradNum12Float];
plantCross.A(17:20,9:12)=temp;
clear temp
temp = zeros(4);
temp(1,:)=[-coeff.KradDen12Float(2:end)];
temp(2:end,1:end-1)=eye(3);
plantCross.A(17:20,17:20)=temp;
clear temp

temp = zeros(4);
temp(1,:)=[-coeff.KradNum21Spar];
plantCross.A(21:24,1:4)=temp;
clear temp

temp = zeros(4);
temp(1,:)=[-coeff.KradDen21Spar(2:end)];
temp(2:end,1:end-1)=eye(3);
plantCross.A(21:24,21:end)=temp;
clear temp
plantCross.A(9,21)=1/(wec.mSpar+wec.AinfSpar);

plantCross.Bv=zeros(3*8,2);
plantCross.Bv(1,1) = 1/(wec.mFloat+wec.AinfFloat); 
plantCross.Bv(9,2) = 1/(wec.mSpar+wec.AinfSpar); 
plantCross.Bu=zeros(24,1);
plantCross.Bu(1,1)=1/(wec.mFloat+wec.AinfFloat)+(-wec.Ainf12Float/(wec.mFloat+wec.AinfFloat))*(-1/(wec.mSpar+wec.AinfSpar));% NEW!!!
plantCross.Bu(9,1)=-1/(wec.mSpar+wec.AinfSpar)+(-wec.Ainf21Spar/(wec.mSpar+wec.AinfSpar))*(1/(wec.mFloat+wec.AinfFloat));% NEW!!!

plantCross.C = [1 zeros(1,3*8-1);...
                0 1 zeros(1,3*8-2);...
                zeros(1,8) 1 zeros(1,3*8-9);...
                zeros(1,9) 1 zeros(1,3*8-10)];
            
plantCross.Dv = zeros(3*8,2);
plantCross.Du = zeros(3*8,1);

plantNew=plantCross;
plantNew.A(1,:)=plantNew.A(1,:)-(wec.Ainf12Float/(wec.mFloat+wec.AinfFloat))*plantNew.A(9,:);
plantNew.A(9,:)=-(wec.Ainf21Spar/(wec.mSpar+wec.AinfSpar))*plantNew.A(1,:)+plantNew.A(9,:);

plantNew.Bv(1,2)=-(wec.Ainf12Float/(wec.mFloat+wec.AinfFloat))*(1/(wec.mSpar+wec.AinfSpar));
plantNew.Bv(9,1)=-(wec.Ainf21Spar/(wec.mSpar+wec.AinfSpar))*(1/(wec.mFloat+wec.AinfFloat));

preDelta.oneBody=plantNew;
clear plant1 plantCross plantNew
       
blkDiagSeed = eye(wec.numWECs); % This creates the seed for kron. Kron replaces each "1" w/ a whole matrix, and fills in zeros for the rest.  

preDelta.A  = kron(blkDiagSeed,preDelta.oneBody.A);     % Dynamic blkdiag. See "Block Diagonal Matrix" example on Matlab's website for kron. 
preDelta.Bu  = kron(blkDiagSeed,preDelta.oneBody.Bu);
preDelta.Bv  = kron(blkDiagSeed,preDelta.oneBody.Bv);
preDelta.C  = kron(blkDiagSeed,preDelta.oneBody.C);

% Output matrices
preDelta.Du = zeros(4*wec.numWECs,wec.numWECs);    % Fpto has no contripution to output states. [2x1] per each pod since output is Z and dZ
preDelta.Dv = zeros(4*wec.numWECs,2*wec.numWECs);    % Fe has no contripution to output states

%% Augmenting for the delta formulation which has Fpto in the states and replaces that w/ dFpto as the control input

plant.oneBody.A= [preDelta.oneBody.A, preDelta.oneBody.Bu;...
                  zeros(1,3*8+1)];

plant.oneBody.Bu = [zeros(24,1);...
                    1];
plant.oneBody.Bv = [preDelta.oneBody.Bv;...
                    0 0];  
plant.oneBody.C = [preDelta.oneBody.C zeros(4,1);...
                   zeros(1,3*8), 1]; 
    
plant.A  = kron(blkDiagSeed,plant.oneBody.A);
plant.Bu  = kron(blkDiagSeed,plant.oneBody.Bu);
plant.Bv  = kron(blkDiagSeed,plant.oneBody.Bv);
plant.C  = kron(blkDiagSeed,plant.oneBody.C);

% Output matrices - in multibody, its [dZ1;Z1;Fpto1;dZ2;Z2;Fpto2; ...]
% and input is [dFpto1;dFpto2; ...]
plant.Du  = zeros(wec.yLen*wec.numWECs,wec.numWECs);   % dFpto has no contripution to output states. [3x1] per each pod since output is Z, dZ, Fpto
plant.Dv = zeros(wec.yLen*wec.numWECs,wec.Slack*wec.numWECs);    % Fe has no contripution to output states
clear plant.oneBody;
end
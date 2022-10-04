function [preDelta,plant] = fnMakePlantAndPreDeltaModel(wec)
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
plant1.A = zeros(3); %% (length of KradNum, length of KradDen-1) order 4 (KradDen = aS^4+bS^3+cS^2+dS+constant)
plant1.A(1,1) = -wec.bFloat/(wec.mFloat+wec.AinfFloat);
plant1.A(1,2) = -wec.kFloat/(wec.mFloat+wec.AinfFloat);
plant1.A(1,3) = 1/(wec.mFloat+wec.AinfFloat);
plant1.A(2,1) = eye(1);

plant1.B = zeros(3,1);
plant1.B(1,1) = 1/(wec.mFloat+wec.AinfFloat);

plant1.C = eye(3);
plant1.D = zeros(3,1);

preDelta.oneBody=plant1;
clear plant1

end
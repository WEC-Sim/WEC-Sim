function E = quaternion2EulXYZ(Q)
% Euler/Tait-Bryan angles; x-y-z extrinsic convention
%
% Parameters
% ------------
%   Q : 1 x 4 float vector
%       Quaternion
%
% Returns
% ------------
%   E : 1 x 3 float vector 
%       Euler angles equivalent of the quaternion (radian)
%       E(1) rotation about x, E(2) rotation about y, E(3) rotation about z
% 
E = zeros(3,1);
E(1) = atan2((2*(Q(1)*Q(2)+Q(3)*Q(4))), (1-2*(Q(2)^2+Q(3)^2)));
E(2) = asin(  2*(Q(1)*Q(3)-Q(4)*Q(2)));
E(3) = atan2((2*(Q(1)*Q(4)+Q(2)*Q(3))), (1-2*(Q(3)^2+Q(4)^2)));
end

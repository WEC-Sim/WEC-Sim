function E = quaternion2EulXYZ(Q)
% Euler Angle Type II or Tait-Bryan Angle for sequence 321 or zyx (Nautical or Cardan angles).
% Yaw [-180,180], followed by pitch [-90,90], followed by roll [-180,180]
%
% Parameters
% ------------
%   Q : 1 x 4 float vector
%       List of quarternions
%
% Returns
% ------------
%   E : 1 x 3 float vector 
%       Euler angles equivalent of the quarternion (radian)
%       E(1) rotation about x, E(2) rotation about y, E(3) rotation about z
%

% method used for mooring matrix, moorDyn, drag body, nonhydro body, flex body
% E = zeros(3,1);
% E(1) = atan2((2*(Q(1)*Q(2)+Q(3)*Q(4))), (1-2*(Q(2)^2+Q(3)^2)));
% E(2) = asin(  2*(Q(1)*Q(3)-Q(4)*Q(2)));
% E(3) = atan2((2*(Q(1)*Q(4)+Q(2)*Q(3))), (1-2*(Q(3)^2+Q(4)^2)));

% method used for hydro body
% apparently they end up the same... 
E = zeros(3,1);
E(1) = atan2(-2 * (Q(3)*Q(4) - Q(1)*Q(2)), (Q(1)^2 - Q(2)^2 - Q(3)^2 + Q(4)^2));
E(2) = asin(2 *   (Q(2)*Q(4) + Q(1)*Q(3)));
E(3) = atan2(-2 * (Q(2)*Q(3) - Q(1)*Q(4)), (Q(1)^2 + Q(2)^2 - Q(3)^2 - Q(4)^2));

end
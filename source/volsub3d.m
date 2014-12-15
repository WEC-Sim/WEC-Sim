%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Copyright 2014 the National Renewable Energy Laboratory and Sandia Corporation
% 
% Licensed under the Apache License, Version 2.0 (the "License");
% you may not use this file except in compliance with the License.
% You may obtain a copy of the License at
% 
%     http://www.apache.org/licenses/LICENSE-2.0
% 
% Unless required by applicable law or agreed to in writing, software
% distributed under the License is distributed on an "AS IS" BASIS,
% WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
% See the License for the specific language governing permissions and
% limitations under the License.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function [Vsub,COMsub] = volsub3d(STL, dZ, axisRot, angleRot)
%STL(a,b,c)  where a denotes the triangle, b denotes the point (1-3) and c
%            denotes the component (x, y or z)
%dZ          a scalar value describing HEAVE
%axisRot     a vector describing the axis about which the body is rotated
%angleRot    the angle by which the body is rotated about axisRot
%refZ        the location of the

% algorithm for point rotation from http://paulbourke.net/geometry/rotate/
% algorithm for volume calc from
% http://stackoverflow.com/questions/1406029/how-to-calculate-the-volume-of-a-3d-mesh-object-the-surface-of-which-is-made-up
% via  http://amp.ece.cmu.edu/Publication/Cha/icip01_Cha.pdf

%determine size of STL
[a b c] = size(STL);

%make sure angleRot is a unit vector
magAR = sqrt(axisRot(1)^2 + axisRot(2)^2 + axisRot(3)^2);
axisRot = axisRot/magAR;

% update locations of points
for i=1:1:a
    for j=1:1:3
        q = zeros(1,3);
        
        %perform rotation
        if angleRot ~= 0
            
            costheta = cos(angleRot);
            sintheta = sin(angleRot);
            
            q(1) = q(1) + (costheta + (1 - costheta) * axisRot(1) * axisRot(1)) * STL(i,j,1);
            q(1) = q(1) + ((1 - costheta) * axisRot(1) * axisRot(2) - axisRot(3) * sintheta) * STL(i,j,2);
            q(1) = q(1) + ((1 - costheta) * axisRot(1) * axisRot(3) + axisRot(2) * sintheta) * STL(i,j,3);
            
            q(2) = q(2) + ((1 - costheta) * axisRot(1) * axisRot(2) + axisRot(3) * sintheta) * STL(i,j,1);
            q(2) = q(2) + (costheta + (1 - costheta) * axisRot(2) * axisRot(2)) * STL(i,j,2);
            q(2) = q(2) + ((1 - costheta) * axisRot(2) * axisRot(3) - axisRot(1) * sintheta) * STL(i,j,3);
            
            q(3) = q(3) + ((1 - costheta) * axisRot(1) * axisRot(3) - axisRot(2) * sintheta) * STL(i,j,1);
            q(3) = q(3) + ((1 - costheta) * axisRot(2) * axisRot(3) + axisRot(1) * sintheta) * STL(i,j,2);
            q(3) = q(3) + (costheta + (1 - costheta) * axisRot(3) * axisRot(3)) * STL(i,j,3);
            
            q(3) = q(3) + dZ(1);
        else
            %plunge object
            q(1) = STL(i,j,1);
            q(2) = STL(i,j,2);
            q(3) = STL(i,j,3) + dZ(1);
        end
        
        %truncate at water surface
        if q(3) > 0
            q(3) = 0;
        end
        
        %save altered point
        STL(i,j,:) = q;
    end
end

%calculate submerged volume and COM
Vsub = 0;
VsubxCOMsub = 0;
for i=1:1:a
    v321 = STL(i,3,1)*STL(i,2,2)*STL(i,1,3);
    v231 = STL(i,2,1)*STL(i,3,2)*STL(i,1,3);
    v312 = STL(i,3,1)*STL(i,1,2)*STL(i,2,3);
    v132 = STL(i,1,1)*STL(i,3,2)*STL(i,2,3);
    v213 = STL(i,2,1)*STL(i,1,2)*STL(i,3,3);
    v123 = STL(i,1,1)*STL(i,2,2)*STL(i,3,3);
    Vsub1 = (-v321 + v231 + v312 - v132 - v213 + v123)/6;
    
    
    
    Vsub = Vsub + Vsub1;
    
    
    
    COMsub = 3/4*((STL(i,1,1)+STL(i,2,1)+STL(i,3,1))/3);
    VsubxCOMsub = VsubxCOMsub + COMsub*Vsub1;
end

%calculate COM
COMsub = VsubxCOMsub/Vsub;
%COMsub = 0;

% COMsub=-COMsub;
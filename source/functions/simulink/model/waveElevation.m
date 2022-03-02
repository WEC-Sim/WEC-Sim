function f  = waveElevation(x,center,cg,AH,w,dw,k,typeNum,t,rampT,phaseRand,direction)
% Function to calculate the wave elevation at the ceontroids of triangulated surface
% NOTE: This function assumes that the STL file is imported with its CG at 0,0,0
f = calc_elev(x,center,cg,AH,w,dw,k,typeNum,t,rampT,phaseRand, direction);
end

function f = calc_elev(x,center,cg,AH,w,dw,k,typeNum,t,rampT,phaseRand,direction)
% Function to rotate and translate body and call wave elevation function at new locations

% Compute new tri center coords after cog rotation and translation
center = rotateXYZ(center,[1 0 0],x(4));
center = rotateXYZ(center,[0 1 0],x(5));
center = rotateXYZ(center,[0 0 1],x(6));
center = offsetXYZ(center,x);
center = offsetXYZ(center,cg);
% Calculate the free surface
f=waveElev(center,AH,w,dw,t,k,rampT,phaseRand,typeNum,direction);
end

function f=waveElev(center,AH,w,dw,t,k,rampT,phaseRand,typeNum,direction)
% Function to calculate the wave elevation at an array of points
f = zeros(length(center(:,3)),1);
cx = center(:,1);
cy = center(:,2);
X = cx*cos(direction*pi/180) + cy*sin(direction*pi/180);
if typeNum <10
elseif typeNum <20
    f = AH(1).*cos(k(1).*X-w(1)*t);
elseif typeNum <30
    tmp=sqrt(AH.*dw);
    tmp1 = ones(1,length(center(:,1)));
    tmp2 = (w.*t+phaseRand)*tmp1;
    tmp3 = cos(k*X'- tmp2);
    f(:,1) = tmp3'*tmp;
end
if t<=rampT
    rampF = (1+cos(pi+pi*t/rampT))/2;
    f = f.*rampF;
end
end
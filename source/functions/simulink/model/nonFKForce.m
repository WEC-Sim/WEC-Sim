function [f, wp, wpMeanFS]  = nonFKForce(x,elv,center,tnorm,area,rho,g,cg,AH,w,dw,wDepth,deepWater,k,typeNum,t,phaseRand)
% Function to calculate the wave excitation force and moment on a
% triangulated surface. The nonlinear excitation forces are calculated by
% intergrating the pressure over the triangulated surface and subtracting
% the linear excitation force (this is added back in later):
%    F_exc_nonlinear = F_exc_total - F_exc_linear
% NOTE: This function assumes that the STL file is imported with its CG at 0,0,0

% Logic to calculate nonFKForce at reduced sample time
[f, wp, wpMeanFS] = calc_force(x,elv,center,tnorm,area,rho,g,cg,AH,w,dw,wDepth,deepWater,k,typeNum,t,phaseRand);
end

function [f, wp, wpMeanFS]  = calc_force(x,elv,center,tnorm,area,rho,g,cg,AH,w,dw,wDepth,deepWater,k,typeNum,t,phaseRand)
% Function to apply translation and rotation, and calculate forces.

% Compute new tri coords after cog rotation and translation
centerMeanFS = offsetXYZ(center,cg);
avMeanFS     = tnorm .* [area area area];

% Compute new tri coords after cog rotation and translation
center = rotateXYZ(center,[1 0 0],x(4));
center = rotateXYZ(center,[0 1 0],x(5));
center = rotateXYZ(center,[0 0 1],x(6));
center = offsetXYZ(center,x);
center = offsetXYZ(center,cg);
% Compute new normal vectors coords after cog rotation and translation
tnorm = rotateXYZ(tnorm,[1 0 0],x(4));
tnorm = rotateXYZ(tnorm,[0 1 0],x(5));
tnorm = rotateXYZ(tnorm,[0 0 1],x(6));

% Copute area vectors
av = tnorm .* [area area area];

% Calculate the free surface
wpMeanFS = pDis(centerMeanFS,0,AH,w,dw,wDepth,deepWater,t,k,phaseRand,typeNum,rho,g);
wp = pDis(center,elv,AH,w,dw,wDepth,deepWater,t,k,phaseRand,typeNum,rho,g);

% Calculate forces
f_linear   =FK(centerMeanFS,       cg,avMeanFS,wpMeanFS);
f_nonLinear=FK(center      ,x(1:3)+cg,av      ,wp      );
f = f_nonLinear-f_linear;
end

function f=pDis(center,elv,AH,w,dw,wDepth,deepWater,t,k,phaseRand,typeNum,rho,g)
% Function to calculate pressure distribution
f = zeros(length(center(:,3)),1);
z=zeros(length(center(:,1)),1);
if typeNum <10
elseif typeNum <20
    f = rho.*g.*AH(1).*cos(k(1).*center(:,1)-w(1)*t);
    if deepWater == 0
        z=(center(:,3)-elv).*wDepth./(wDepth+elv);
        f = f.*(cosh(k(1).*(z+wDepth))./cosh(k(1)*wDepth));
    else
        z=(center(:,3)-elv);
        f = f.*exp(k(1).*z);
    end
elseif typeNum <30
    for i=1:length(AH)
        if deepWater == 0 && wDepth <= 0.5*pi/k(i)
            z=(center(:,3)-elv).*wDepth./(wDepth+elv);
            f_tmp = rho.*g.*sqrt(AH(i)*dw(i)).*cos(k(i).*center(:,1)-w(i)*t-phaseRand(i));
            f = f + f_tmp.*(cosh(k(i).*(z+wDepth))./cosh(k(i).*wDepth));
        else
            z=(center(:,3)-elv);
            f_tmp = rho.*g.*sqrt(AH(i)*dw(i)).*cos(k(i).*center(:,1)-w(i)*t-phaseRand(i));
            f = f + f_tmp.*exp(k(i).*z);
        end
    end
end
f(z>0)=0;
end

function f = FK(center,instcg,av,wp)
% Function to calculate the force and moment about the cog due to Froude-Krylov pressure
f = zeros(6,1);

% Calculate the hydrostatic pressure at each triangle center
pressureVect = [wp wp wp].*-av;

% Compute force about cog
f(1:3) = sum(pressureVect);

% Compute moment about cog
tmp1 = ones(length(center(:,1)),1);
tmp2 = tmp1*instcg';
center2cgVec = center-tmp2;

f(4:6)= sum(cross(center2cgVec,pressureVect));
end
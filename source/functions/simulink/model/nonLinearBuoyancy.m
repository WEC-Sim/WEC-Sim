function [f,p]  = nonLinearBuoyancy(x,elv,center,tnorm,area,rho,g,cg,mass)
% Function to calculate buoyancy force and moment on a triangulated surface
% NOTE: This function assumes that the STL file is imported with its CG at 0,0,0
[f,p] = calc_buoyancy(x,elv,center,tnorm,area,rho,g,cg);
f = -f + [0 0 g*mass 0 0 0]';
end


function [f,p] = calc_buoyancy(x,elv,center,tnorm,area,rho,g,cg)
% Function to apply translation and rotation and calculate forces

% Compute new tri coords after cog rotation and translation
center = rotateXYZ(center,[1 0 0],x(4));
center = rotateXYZ(center,[0 1 0],x(5));
center = rotateXYZ(center,[0 0 1],x(6));
center = offsetXYZ(center,x);
center = offsetXYZ(center,cg);
% Compute new normal vectors coords after cog rotation
tnorm = rotateXYZ(tnorm,[1 0 0],x(4));
tnorm = rotateXYZ(tnorm,[0 1 0],x(5));
tnorm = rotateXYZ(tnorm,[0 0 1],x(6));

% Calculate the hydrostatic forces
av = tnorm .* [area area area];
[f,p]=fHydrostatic(center,elv,x(1:3)+cg,av,rho,g);
end

function [f,p] = fHydrostatic(center,elv,instcg,av,rho,g)
% Function to calculate the force and moment about the cog due to hydrostatic pressure
f = zeros(6,1);

% Zeor out regions above the mean free surface
z=center(:,3); idx = find((z-elv)>0);

% Calculate the hydrostatic pressure at each triangle center
pressureVect = -rho*g.*[(z) (z) (z)].*-av;
p = -rho*g.*(z);
p(idx) = 0;
pressureVect(idx,:) = 0; 
% Compute force about cog
f(1:3) = sum(pressureVect);

tmp1 = ones(length(center(:,1)),1);
tmp2 = tmp1*instcg';
center2cgVec = center-tmp2;

f(4:6)= sum(cross(center2cgVec,pressureVect));
end

function [f, wp, wpMeanFS, fk]  = calcFKforce(x,elv,center,tnorm,area,rho,g,cg,AH,w,dw,wDepth,deepWaterWave,k,typeNum,t,phaseRand)
    % Function to apply translation and rotation, and calculate forces.
        
    % Compute new tri coords after cog rotation and translation
    
    centerMeanFS = center;
    delXY = [x(1) x(2) 0];
    centerMeanFS = offsetXYZ(centerMeanFS, delXY);
    centerMeanFS = offsetXYZ(centerMeanFS,cg);
    avMeanFS     = tnorm .* [area area area];
    wpMeanFS=pDis(centerMeanFS,       0,AH,w,dw,wDepth,deepWaterWave,t,k,phaseRand,typeNum,rho,g);

    f_linear   =FK(centerMeanFS,       cg,avMeanFS,wpMeanFS);
    
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
    wp      =pDis(center      ,     elv,AH,w,dw,wDepth,deepWaterWave,t,k,phaseRand,typeNum,rho,g);
    
    % Calculate forces
    f_nonLinear=FK(center      ,x(1:3)+cg,av      ,wp      ); 
    f = f_nonLinear-f_linear;
    fk = f_linear;
end

function verts = offsetXYZ(verts,x)
    % Function to move the position vertices
    verts(:,1) = verts(:,1) + x(1);
    verts(:,2) = verts(:,2) + x(2);
    verts(:,3) = verts(:,3) + x(3);
end

function xn = rotateXYZ(x,ax,t)
	% Function to rotate a point about an arbitrary axis
	% x: 3-componenet coordinates
	% ax: axis about which to rotate (must be a vector length 1)
	% t: rotation angle
	% xn: new coordinates after rotation
	rotMat = zeros(3);
	rotMat(1,1) = ax(1)*ax(1)*(1-cos(t))    + cos(t);
	rotMat(1,2) = ax(2)*ax(1)*(1-cos(t))    + ax(3)*sin(t);
	rotMat(1,3) = ax(3)*ax(1)*(1-cos(t))    - ax(2)*sin(t);
	rotMat(2,1) = ax(1)*ax(2)*(1-cos(t))    - ax(3)*sin(t);
	rotMat(2,2) = ax(2)*ax(2)*(1-cos(t))    + cos(t);
	rotMat(2,3) = ax(3)*ax(2)*(1-cos(t))    + ax(1)*sin(t);
	rotMat(3,1) = ax(1)*ax(3)*(1-cos(t))    + ax(2)*sin(t);
	rotMat(3,2) = ax(2)*ax(3)*(1-cos(t))    - ax(1)*sin(t);
	rotMat(3,3) = ax(3)*ax(3)*(1-cos(t))    + cos(t);
	xn = x*rotMat;
end

function f=pDis(center,elv,AH,w,dw,wDepth,deepWaterWave,t,k,phaseRand,typeNum,rho,g)
    % Function to calculate pressure distribution
    f = zeros(length(center(:,3)),1);
    z=zeros(length(center(:,1)),1);
    if typeNum <10
    elseif typeNum <20
        f = rho.*g.*AH(1).*cos(k(1).*center(:,1)-w(1)*t);
        if deepWaterWave == 0
            z=(center(:,3)-elv).*wDepth./(wDepth+elv);
            f = f.*(cosh(k(1).*(z+wDepth))./cosh(k(1)*wDepth));
        else
            z=(center(:,3)-elv);
            f = f.*exp(k(1).*z);
        end
    elseif typeNum <30
        for i=1:length(AH)
            if deepWaterWave == 0 && wDepth <= 0.5*pi/k(i)
                z=(center(:,3)-elv).*wDepth./(wDepth+elv);
                f_tmp = rho.*g.*sqrt(AH(i)*dw).*cos(k(i).*center(:,1)-w(i)*t-phaseRand(i));
                f = f + f_tmp.*(cosh(k(i).*(z+wDepth))./cosh(k(i).*wDepth));
            else
                z=(center(:,3)-elv);
                f_tmp = rho.*g.*sqrt(AH(i)*dw).*cos(k(i).*center(:,1)-w(i)*t-phaseRand(i));
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

function [f0] = calcFlin0(center,elv,AH,w,dw,wDepth,deepWaterWave,t,k,phaseRand,typeNum,rho,g)
f0 = 0;
    % Function to calculate pressure distribution
    if typeNum <10
        N = 0;
    elseif typeNum <20
        N = 1;
    elseif typeNum <30
        N = length(AH);
    end
    
    z = zeros(length(center(:,1)),1);
    f0 = zeros(length(AH));
%     
     for i=1:N
          if deepWaterWave == 0 && wDepth <= 0.5*pi/k(i)
                z=(center(:,3)-elv).*wDepth./(wDepth+elv);
                f_tmp = rho.*g.*sqrt(AH(i)*dw).*cos(k(i).*center(:,1)-w(i)*t-phaseRand(i));
                f0(i) = f_tmp.*(cosh(k(i).*(z+wDepth))./cosh(k(i).*wDepth));
            else
                z=(center(:,3)-elv);
                f_tmp = rho.*g.*sqrt(AH(i)*dw).*cos(k(i).*center(:,1)-w(i)*t-phaseRand(i));
                f0(i) = f_tmp.*exp(k(i).*z);
            end
     end
end
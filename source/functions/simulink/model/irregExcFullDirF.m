function [Fext, relYawLast, coeffsLastMD,coeffsLastRE,coeffsLastIM] = irregExcFullDirF(pYaw, nBins, A,w, nW, dofGRD,dirGRD,wGRD,qDofGRD,qWGRD,fEHRE,fEHIM, fEHMD, phaseRand,dw,time,spreadBins, dirBins, Disp, intThresh, prevYaw, prevCoeffMD, prevCoeffRE, prevCoeffIM)


[M,N]=size(dirBins);
A1=bsxfun(@plus,w*time,pi/2);
A1=repmat(A1,1,nBins);
A = repmat(A,1,nBins);
%initialize outputs
Fext = zeros(1,size(dofGRD,1));
relYawLast=zeros(M,N);
coeffsLastMD=zeros(N,M,size(dofGRD,1)); %  dirBins, freq, dof
coeffsLastRE=zeros(N,M,size(dofGRD,1));
coeffsLastIM=zeros(N,M,size(dofGRD,1));

relYaw = dirBins-(Disp(6)*180/pi); % relative yaw angle, size = dirBins = [length(w) nBins]


% compare relYaw to available direction data Direction data must
% span 360 deg, inclusive (i.e [-180 180])
if max(relYaw,[],'all')>max(dirGRD,[],'all') % handle interpolation out of BEM range by wrapping other bound
    relYaw=wrapTo180(relYaw);
    [relYaw,I]=sort(relYaw,2); % grid must be in ascending order
   
elseif min(relYaw,[],'all')<min(dirGRD,[],'all') 
    relYaw=wrapTo180(relYaw);
    [relYaw,I]=sort(relYaw,2); % grid must be in ascending order
else
    I=1:length(relYaw(1,:));
end

 relYawGRD = zeros([size(dofGRD,1) size(relYaw.')]);
 for k=1:6
     relYawGRD(k,:,:) = relYaw.';
 end

yawError = zeros(M,N);
if pYaw ==1 % fewer cases here because you WILL have to interpolate for any new yaw position, no chance it aligns with precalc'd grid
    yawDiff = abs(relYaw - prevYaw);
    if max(yawDiff,[],'all')>intThresh% interpolate for nonlinear yaw

        % performs 1D interpolation in wave direction
        fExtMDint=interpn(dofGRD,dirGRD,wGRD,fEHMD,qDofGRD,relYawGRD,qWGRD);
        fExtREint=interpn(dofGRD,dirGRD,wGRD,fEHRE,qDofGRD,relYawGRD,qWGRD);
        fExtIMint=interpn(dofGRD,dirGRD,wGRD,fEHIM,qDofGRD,relYawGRD,qWGRD);

        % permute for dimensional consistency with linear yaw
        fExtMDint=permute(fExtMDint,[2 3 1]);
        fExtREint=permute(fExtREint,[2 3 1]);
        fExtIMint=permute(fExtIMint,[2 3 1]);

        relYawLast=relYaw;
        coeffsLastMD=fExtMDint;
        coeffsLastRE=fExtREint;
        coeffsLastIM=fExtIMint;

    else  % significant yaw maybe present, but close to previous value
        fExtMDint=prevCoeffMD;
        fExtREint=prevCoeffRE;
        fExtIMint=prevCoeffIM;

        relYawLast=prevYaw;
        coeffsLastMD=prevCoeffMD;
        coeffsLastRE=prevCoeffRE;
        coeffsLastIM=prevCoeffIM;
      
    end
else
    if sum(sum(prevYaw)) ==0; %abs(relYaw-prevYaw)>intThresh % this should only execute on the first run through
        fExtMDint=interpn(dofGRD,dirGRD,wGRD,fEHMD,qDofGRD,relYawGRD,qWGRD);
        fExtREint=interpn(dofGRD,dirGRD,wGRD,fEHRE,qDofGRD,relYawGRD,qWGRD);
        fExtIMint=interpn(dofGRD,dirGRD,wGRD,fEHIM,qDofGRD,relYawGRD,qWGRD);
        fExtMDint=permute(fExtMDint,[2 3 1]);
        fExtREint=permute(fExtREint,[2 3 1]);
        fExtIMint=permute(fExtIMint,[2 3 1]);

        coeffsLastMD=fExtMDint;
        coeffsLastRE=fExtREint;
        coeffsLastIM=fExtIMint;
        relYawLast=relYaw;

    else  % pass-through for all other cases
        fExtMDint = prevCoeffMD;
        fExtREint = prevCoeffRE;
        fExtIMint = prevCoeffIM;
        coeffsLastMD=fExtMDint;
        coeffsLastRE=fExtREint;
        coeffsLastIM=fExtIMint;
        relYawLast=relYaw;
    end


end


B1= sin(bsxfun(@plus,A1,phaseRand(:,:,1)));
B11 = sin(bsxfun(@plus,w*time,phaseRand(:,:,1)));
C0 = bsxfun(@times,A.*spreadBins,dw);
C1 = sqrt(bsxfun(@times,A.*spreadBins,dw));
for k=1:size(dofGRD,1)
    D0 =bsxfun(@times,fExtMDint(:,:,k).',C0);
    D1 =bsxfun(@times,fExtREint(:,:,k).',C1);
    D11 = bsxfun(@times,fExtIMint(:,:,k).',C1);
    E1 = D0+ bsxfun(@times,B1,D1);
    E11 = bsxfun(@times,B11,D11);
    Fext(k) = Fext(k) + sum(sum(bsxfun(@minus,E1,E11)));
end

end

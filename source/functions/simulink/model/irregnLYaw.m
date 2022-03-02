function [Fext,relYawLast,coeffsLastMD,coeffsLastRE,coeffsLastIM] = irregnLYaw(A,w,dofGRD,dirGRD,wGRD,fEHRE,fEHIM, fEHMD, phaseRand,dw,time,direction,spread, Disp, intThresh, prevYaw, prevCoeffMD, prevCoeffRE, prevCoeffIM)
%#codegen
% Fext is the excitation force output, relYawLast is the angle of relative
% yaw at which that last interpolation was performed. If the current
% relative yaw angle - last interpolated > threshold, the interpolation is
% performed again. To interpolate every time step, let threshold=0.

% caseFlag is for debug, delete when satisfied
A1=bsxfun(@plus,w*time,pi/2);
%initialize outputs
Fext = zeros(1,6);
relYawLast=0;
coeffsLastMD=zeros(length(w),6);
coeffsLastRE=zeros(length(w),6);
coeffsLastIM=zeros(length(w),6);

for ii=1:length(direction)
    relYaw=direction(ii)-(Disp(6)*180/pi); % relative yaw angle
    phaseRandint=phaseRand(:,ii);
    WaveSpreadint=spread(ii);
    
       % compare relYaw to available direction data
        if relYaw>max(dirGRD(1,:,1)) % handle interpolation out of BEM range by wrapping other bound
            [~,idx]=min(dirGRD(1,:,1),[],2); % 
            dirGRD(:,idx,:)=dirGRD(:,idx,:)+360;
            [dirGRD,I]=sort(dirGRD,2); % grid must be in ascending order
                      
        elseif relYaw<min(dirGRD(1,:,1))
            [~,idx]=max(dirGRD(1,:,1),[],2); % 
            dirGRD(:,idx,:)=dirGRD(:,idx,:)-360;  
            [dirGRD,I]=sort(dirGRD,2); % grid must be in ascending order

        else 
            I=1:length(dirGRD(1,:,1));
        end
    
    if abs(relYaw-prevYaw)>intThresh && min(abs(relYaw-dirGRD(1,:,1)))>intThresh% interpolate for nonlinear yaw 
            
        % performs 1D interpolation in wave direction
        fExtMDint=interpn(dofGRD,dirGRD,wGRD,fEHMD(:,I(1,:,1),:),dofGRD,relYaw*ones(size(dirGRD)),wGRD);
        fExtREint=interpn(dofGRD,dirGRD,wGRD,fEHRE(:,I(1,:,1),:),dofGRD,relYaw*ones(size(dirGRD)),wGRD);
        fExtIMint=interpn(dofGRD,dirGRD,wGRD,fEHIM(:,I(1,:,1),:),dofGRD,relYaw*ones(size(dirGRD)),wGRD);
        
        % permute for dimensional consistency with linear yaw
        fExtMDint=squeeze(permute(fExtMDint(:,1,:),[2 3 1]));
        fExtREint=squeeze(permute(fExtREint(:,1,:),[2 3 1]));
        fExtIMint=squeeze(permute(fExtIMint(:,1,:),[2 3 1]));
        
        relYawLast=relYaw;
        coeffsLastMD=fExtMDint;
        coeffsLastRE=fExtREint;
        coeffsLastIM=fExtIMint;
        
    elseif min(abs(relYaw-dirGRD(1,:,1)))>intThresh % significant yaw is present, but close to previous value
        fExtMDint=prevCoeffMD;
        fExtREint=prevCoeffRE;
        fExtIMint=prevCoeffIM;
        
        relYawLast=prevYaw;
        coeffsLastMD=prevCoeffMD;
        coeffsLastRE=prevCoeffRE;
        coeffsLastIM=prevCoeffIM;
        
    else    % significant yaw may be is present, but nearby BEM calculated data
        [~,idx]=min(abs(relYaw-dirGRD(1,:,1)));
        fExtMDint=squeeze(fEHMD(:,I(1,idx,1),:)).'; % maintains dimensional consistency
        fExtREint=squeeze(fEHRE(:,I(1,idx,1),:)).';
        fExtIMint=squeeze(fEHIM(:,I(1,idx,1),:)).';
        
        relYawLast=dirGRD(1,idx,1); % indices of dirGRD have already been resorted
        coeffsLastMD=fExtMDint;
        coeffsLastRE=fExtREint;
        coeffsLastIM=fExtIMint;
    end
    B1= sin(bsxfun(@plus,A1,phaseRandint));
    B11 = sin(bsxfun(@plus,w*time,phaseRandint));
    C0 = bsxfun(@times,A*WaveSpreadint,dw);
    C1 = sqrt(bsxfun(@times,A*WaveSpreadint,dw));
    D0 =bsxfun(@times,fExtMDint,C0);
    D1 =bsxfun(@times,fExtREint,C1);
    D11 = bsxfun(@times,fExtIMint,C1);
    E1 = D0+ bsxfun(@times,B1,D1);
    E11 = bsxfun(@times,B11,D11);
    Fext = Fext + sum(bsxfun(@minus,E1,E11));
end

end



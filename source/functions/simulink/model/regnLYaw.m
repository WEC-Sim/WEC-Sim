function [Fext,relYawLast,coeffsLastMD,coeffsLastRE,coeffsLastIM] = regnLYaw(A,w,dofGRD,dirGRD,fEHRE,fEHIM, fEHMD,time,direction,Disp, intThresh, phase, prevYaw, prevCoeffMD, prevCoeffRE, prevCoeffIM)
%#codegen
% Fext is the excitation force output, relYawLast is the angle of relative
% yaw at which that last interpolation was performed. If the current
% relative yaw angle - last interpolated > threshold, the interpolation is
% performed again. To interpolate every time step, let threshold=0. 

for ii=1:length(direction) % should be length=1 for regular waves
    relYaw=direction(ii)-(Disp(6).*180/pi); % relative yaw angle, convert to deg
   
     % compare relYaw to available direction data
        if relYaw>max(dirGRD(1,:)) % handle interpolation out of BEM range by wrapping other bound
            [~,idx]=min(dirGRD,[],2); % 
            dirGRD(:,idx)=dirGRD(:,idx)+360;
            [dirGRD,I]=sort(dirGRD,2); % grid must be in ascending order
            
        elseif relYaw<min(dirGRD(1,:))
            [~,idx]=max(dirGRD,[],2); % 
            dirGRD(:,idx)=dirGRD(:,idx)-360;
            [dirGRD,I]=sort(dirGRD,2); % grid must be in ascending order
        else
            I=1:length(dirGRD(1,:));
        end
        
    if abs(relYaw-prevYaw)>intThresh && min(abs(relYaw-dirGRD(1,:)))>intThresh% interpolate for nonlinear yaw 
       
        % performs 1D interpolation in wave direction
        fExtMDint=interpn(dofGRD,dirGRD,fEHMD(:,I(1,:)),dofGRD,relYaw*ones(size(dirGRD)));
        fExtREint=interpn(dofGRD,dirGRD,fEHRE(:,I(1,:)),dofGRD,relYaw*ones(size(dirGRD)));
        fExtIMint=interpn(dofGRD,dirGRD,fEHIM(:,I(1,:)),dofGRD,relYaw*ones(size(dirGRD)));
        
        fExtMDint=fExtMDint(:,1).';
        fExtREint=fExtREint(:,1).';
        fExtIMint=fExtIMint(:,1).';
                
        relYawLast=relYaw;
        coeffsLastMD=fExtMDint;
        coeffsLastRE=fExtREint;
        coeffsLastIM=fExtIMint;
  
   elseif min(abs(relYaw-dirGRD(1,:)))>intThresh % significant yaw is present, but close to previous value
        fExtMDint=prevCoeffMD;
        fExtREint=prevCoeffRE;
        fExtIMint=prevCoeffIM;
        
        relYawLast=prevYaw;
        coeffsLastMD=prevCoeffMD;
        coeffsLastRE=prevCoeffRE;
        coeffsLastIM=prevCoeffIM;
              
    else    % significant yaw may be is present, but nearby BEM calculated data
        [~,idx]=min(abs(relYaw-dirGRD(1,:)));
        fExtMDint=fEHMD(:,I(1,idx)).'; % maintains dimensional consistency
        fExtREint=fEHRE(:,I(1,idx)).';
        fExtIMint=fEHIM(:,I(1,idx)).';
     
        relYawLast=dirGRD(1,idx); % indices of dirGRD have already been resorted
        coeffsLastMD=fExtMDint;
        coeffsLastRE=fExtREint;
        coeffsLastIM=fExtIMint;
    end

    % regular wave excitation equation (with mean drift)
    Fext = fExtMDint*A^2 + A*fExtREint*cos(w*time + phase)- A*fExtIMint*sin(w*time + phase);
    

end



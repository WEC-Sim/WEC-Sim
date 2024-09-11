function [Fext, relYawLast, coeffsLastMD,coeffsLastRE,coeffsLastIM] = irregExcFullDirF(pYaw, nBins, A,w, nW, dofGRD,dirGRD,wGRD,qDofGRD,qWGRD,fEHRE,fEHIM, fEHMD, phaseRand,dw,time,spreadBins, dirBins, Disp, intThresh, prevYaw, prevCoeffMD, prevCoeffRE, prevCoeffIM)

%initialize outputs
% Fext = zeros(1,6);
% relYawLast=zeros(nW,nBins);
% coeffsLastMD=zeros(nBins,nW,6);
% coeffsLastRE=zeros(nBins,nW,6);
% coeffsLastIM=zeros(nBins,nW,6);

[M,N]=size(dirBins);
A1=bsxfun(@plus,w*time,pi/2);
A1=repmat(A1,1,nBins);
A = repmat(A,1,nBins);
%initialize outputs
Fext = zeros(1,6);
relYawLast=zeros(M,N);
coeffsLastMD=zeros(N,M,6); %  dirBins, freq, dof
coeffsLastRE=zeros(N,M,6);
coeffsLastIM=zeros(N,M,6);
%for ii=1:length(w) % frequency loop ?????????????????????????????????????

 relYaw = dirBins-(Disp(6)*180/pi); % relative yaw angle, size = dirBins = [length(w) nBins]

%phaseRandint = permute(phaseRandint,[2 3 1]);
%phaseRandint=phaseRand(:,:,ii); % freq, dirBin, wave train
%WaveSpreadBins=spreadBins(:,:ii); % freq, dirBin, wave train

%%% Need to fix dimensions to work over nBins).

% compare relYaw to available direction data Direction data must
% span 360 deg, inclusive (i.e [-180 180])
if max(relYaw,[],'all')>max(dirGRD,[],'all') % handle interpolation out of BEM range by wrapping other bound
    %idx = find(relYaw > max(dirGRD,[],'all')); % This is a fully representative sample of dirGRD
    relYaw=wrapTo180(relYaw);
    %[ia,ib]=ind2sub([M N],idx);
    %relYaw(idx)=relYaw(idx)-360;
    [relYaw,I]=sort(relYaw,2); % grid must be in ascending order
    % dofGRD(:,end+1,:) = dofGRD(:,1,:); % these columns are all the same, just to match size
    % wGRD (:,end+1,:) = wGRD(:,1,:); % these columns are all the same, just to match size
    % fEHMD()
%initialize outputs
elseif min(relYaw,[],'all')<min(dirGRD,[],'all')
   % idx = find(relYaw < min(dirGRD,[],'all'));
    %[ia,ib]=ind2sub([M N],idx);
   % relYaw(idx)=relYaw(idx)+360;
    relYaw=wrapTo180(relYaw);
    [relYaw,I]=sort(relYaw,2); % grid must be in ascending order
    % dofGRD(:,end+1,:) = dofGRD(:,1,:); % these columns are all the same, just to match size
    % wGRD (:,end+1,:) = wGRD(:,1,:);  % these columns are all the same, just to match size
    % this is a problem because fEHMD may change size w/ subsequent
    % executions and create problem during feedback of coefficient
    % sets

else
    I=1:length(relYaw(1,:));

end

 relYawGRD = zeros([6 size(relYaw.')]);
 for k=1:6
     relYawGRD(k,:,:) = relYaw.';
     %phaseRandint(k,:,:) = phaseRand.';
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
        %
        % else    % significant yaw may be is present, but nearby BEM calculated data: this should basically never run for real waves
        %     for k=1:length(yawError)
        %        [~,idx(k)] = min(abs(relYaw(k)-dirGRD(1,:,1)));
        %     end
        %     fExtMDint=squeeze(fEHMD(:,I(1,idx,1),:)).'; % maintains dimensional consistency
        %     fExtREint=squeeze(fEHRE(:,I(1,idx,1),:)).';
        %     fExtIMint=squeeze(fEHIM(:,I(1,idx,1),:)).';
        %
        %     relYawLast=dirGRD(1,idx,1); % indices of dirGRD have already been resorted
        %     coeffsLastMD=fExtMDint;
        %     coeffsLastRE=fExtREint;
        %     coeffsLastIM=fExtIMint;
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
C1 = sqrt(bsxfun(@times,A.*spreadBins.^2,dw));
for k=1:6
    D0 =bsxfun(@times,fExtMDint(:,:,k).',C0);
    D1 =bsxfun(@times,fExtREint(:,:,k).',C1);
    D11 = bsxfun(@times,fExtIMint(:,:,k).',C1);
    E1 = D0+ bsxfun(@times,B1,D1);
    E11 = bsxfun(@times,B11,D11);
    Fext(k) = Fext(k) + sum(sum(bsxfun(@minus,E1,E11)));
end

end

%[Fext,relYawLast,coeffsLastMD,coeffsLastRE,coeffsLastIM] = irregExcFullDirF(pYaw,nBins,A,w,nW,dofGRD,dirGRD,wGRD,qDofGRD,qWGRD,fEHRE,fEHIM, fEHMD, phaseRand,dw,time,direction,spreadBins, dirBins, Disp, intThresh, prevYaw, prevCoeffMD, prevCoeffRE, prevCoeffIM);

%end
function Fext = irregExcF(A,w,fExtRE,fExtIM,phaseRand,dw,time,direction,spread,fExtMD)
%#codegen
% pversistent A1 B1 B11 C1 D1 D11 E1 E11

A1=bsxfun(@plus,w*time,pi/2);
Fext = zeros(1,size(fExtRE,3));
for ii=1:length(direction)
    B1= sin(bsxfun(@plus,A1,phaseRand(:,ii)));
    B11 = sin(bsxfun(@plus,w*time,phaseRand(:,ii)));
    C0 = bsxfun(@times,A*spread(ii),dw);
    C1 = sqrt(bsxfun(@times,A*spread(ii),dw));
    D0 =bsxfun(@times,squeeze(fExtMD(ii,:,:)),C0);
    D1 =bsxfun(@times,squeeze(fExtRE(ii,:,:)),C1);
    D11 = bsxfun(@times,squeeze(fExtIM(ii,:,:)),C1);
    E1 = D0+ bsxfun(@times,B1,D1);
    E11 = bsxfun(@times,B11,D11);
    Fext = Fext + sum(bsxfun(@minus,E1,E11));
end

end
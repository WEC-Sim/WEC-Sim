function hydro = radiationIRFSS(hydro,Omax,R2t)
% Calculates the state space (SS) realization of the normalized radiation IRF.
% If this function is used, it must be implemented after the radiationIRF function.
% 
% Default parameters can be used by inputting [].
% See ``WEC-Sim\examples\BEMIO`` for examples of usage.
% 
% Parameters
% ----------
%     hydro : struct
%         Structure of hydro data
%     
%     Omax : integer 
%         Maximum order of the SS realization, the default is 10
% 
%     R2t : float
%         :math:`R^2` threshold (coefficient of determination) for the SS
%         realization, where :math:`R^2` may range from 0 to 1, and the
%         default is 0.95
%
% Returns
% -------
%     hydro : struct
%         Structure of hydro data with radiation IRF state space
%         coefficients
% 

p = waitbar(0,'Calculating state space radiation IRFs...');  % Progress bar

% Set defaults if empty
if isempty(Omax)==1;    Omax = 10;  end
if isempty(R2t)==1;     R2t = 0.95; end

t = hydro.ra_t;
dt = t(2)-t(1);
hydro.ss_A = zeros(sum(hydro.dof),sum(hydro.dof),Omax,Omax);
hydro.ss_B = zeros(sum(hydro.dof),sum(hydro.dof),Omax,1);
hydro.ss_C = zeros(sum(hydro.dof),sum(hydro.dof),1,Omax);
hydro.ss_D = zeros(sum(hydro.dof),sum(hydro.dof),1);
hydro.ss_K = zeros(sum(hydro.dof),sum(hydro.dof),length(t));
hydro.ss_conv = zeros(sum(hydro.dof),sum(hydro.dof));
hydro.ss_R2 = zeros(sum(hydro.dof),sum(hydro.dof));
hydro.ss_O = zeros(sum(hydro.dof),sum(hydro.dof));

for i=1:sum(hydro.dof)
    for j=1:sum(hydro.dof)
        
        K = squeeze(hydro.ra_K(i,j,:));
        R2i = norm(K-mean(K));  % Initial R2
        
        %Hankel Singular Value Decomposition
        O = 2;  % Initial state space order
        y = dt*K;
        h = hankel(y(2:end));
        [u,svh,v] = svd(h);
        svh=diag(svh);
        
        while R2i ~= 0.0
            u1 = u(1:length(K)-2,1:O);
            v1 = v(1:length(K)-2,1:O);
            u2 = u(2:length(K)-1,1:O);
            sqs = sqrt(svh(1:O));
            ubar = u1.'*u2;
            
            a = ubar.*((1./sqs)*sqs.');
            b = v1(1,:).'.*sqs;
            c = u1(1,:).*sqs.';
            d = y(1);
            
            iidd = inv(dt/2*(eye(O)+a));  % (T/2*I+T/2*A)^{-1} = 2/T(I+A)^{-1}
            ac = (a-eye(O))*iidd;         % (A-I)2/T(I+A)^{-1} = 2/T(A-I)(I+A)^{-1}
            bc = dt*(iidd*b);             % (T/2+T/2)*2/T(I+A)^{-1}B = 2(I+A)^{-1}B
            cc = c*iidd;                  % C*2/T(I+A)^{-1} = 2/T(I+A)^{-1}
            dc = d-dt/2*((c*iidd)*b);     % D-T/2C (2/T(I+A)^{-1})B = D-C(I+A)^{-1})B
            for k=1:length(t)
                ss_K(k) = ((cc*expm(ac*dt*(k-1)))*bc);  % Calc SS IRF approx
            end
            
            R2 = 1-(norm(K-ss_K.')/R2i)^2;  % Calc R2 for SS IRF approx
            if R2 >= R2t  status = 1;  break  % R2 threshold
            elseif O == Omax  status = 2;  break  % Max SS order threshold
            else  O = O+1;  end  % Increase state space order
        end
        if R2i ~= 0.0
            hydro.ss_A(i,j,1:O,1:O) = ac;
            hydro.ss_B(i,j,1:O,1) = bc;
            hydro.ss_C(i,j,1,1:O) = cc;
            hydro.ss_D(i,j) = dc;
            hydro.ss_K(i,j,:) = ss_K;
            hydro.ss_conv(i,j) = status;
            hydro.ss_R2(i,j) = R2;
            hydro.ss_O(i,j) = O;
        end
    end
    waitbar(i/(sum(hydro.dof)))
end
close(p)

end

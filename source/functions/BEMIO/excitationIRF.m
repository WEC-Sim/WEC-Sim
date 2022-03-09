function hydro = excitationIRF(hydro,tEnd,nDt,nDw,wMin,wMax)
% Calculates the normalized excitation impulse response function:
% 
% 	:math:`\overline{K}_{e,i,\theta}(t) = {\frac{1}{2\pi}}\intop_{-\infty}^{\infty}{\frac{X_i(\omega,\theta)e^{i{\omega}t}}{{\rho}g}}d\omega`
% 
% Default parameters can be used by inputting [].
% See ``WEC-Sim\examples\BEMIO`` for examples of usage.
% 
% Parameters
% ----------
%     hydro : struct
%         Structure of hydro data
%     
%     tEnd : float
%         Calculation range for the IRF, where the IRF is calculated from t
%         = 0 to tEnd, and the default is 100 s
%     
%     nDt : float
%         Number of time steps in the IRF, the default is 1001 
%     
%     nDw : float
%         Number of frequency steps used in the IRF calculation
%         (hydrodynamic coefficients are interpolated to correspond), the
%         default is 1001
% 
%     wMin : float
%         Minimum frequency to use in the IRF calculation, the default is
%         the minimum frequency from the BEM data
% 
%     wMax : float
%         Maximum frequency to use in the IRF calculation, the default is
%         the maximum frequency from the BEM data
%
% Returns
% -------
%     hydro : struct
%         Structure of hydro data with excitation IRF
% 

p = waitbar(0,'Calculating excitation IRFs...');  % Progress bar

% Set defaults if empty
if isempty(tEnd)==1;  tEnd = 100;           end
if isempty(nDt)==1;    nDt = 1001;            end
if isempty(nDw)==1;    nDw = 1001;            end
if isempty(wMin)==1;  wMin = min(hydro.w);  end
if isempty(wMax)==1;  wMax = max(hydro.w);  end

% Interpolate to the given t and w
t = linspace(-tEnd,tEnd,nDt);
w = linspace(wMin,wMax,nDw);  
N = sum(hydro.dof)*hydro.Nh;

% Calculate the impulse response function for excitation
n = 0;
for i = 1:sum(hydro.dof)
    for j = 1:hydro.Nh
        ex_re = interp1(hydro.w,squeeze(hydro.ex_re(i,j,:)),w);
        ex_im = interp1(hydro.w,squeeze(hydro.ex_im(i,j,:)),w);
        hydro.ex_K(i,j,:) = (1/pi)*trapz(w,ex_re.*cos(w.*t(:))-ex_im.*sin(w.*t(:)),2);
        n = n+1;
    end
    waitbar(n/N)
end

hydro.ex_t = t;
hydro.ex_w = w;
close(p);

end

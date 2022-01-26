function hydro = excitationIRF(hydro,tEnd,nDt,nDw,wMin,wMax)
% Calculates the normalized excitation impulse response function.
% 
% hydro = excitationIRF(hydro, tEnd, nDt, nDw, wMin, wMax)
%     hydro – data structure
%     tEnd – calculation range for the IRF, where the IRF is calculated from
%             t = -tEnd to tEnd, and the default is 100 s
%     nDt –   number of time steps in the IRF, the default is 1001
%     nDw –   number of frequency steps used in the IRF calculation (hydrodynamic
%             coefficients are interpolated to correspond), the default is 1001
%     wMin – minimum frequency to use in the IRF calculation, the default is
%             the minimum frequency from the BEM data
%     wMax – maximum frequency to use in the IRF calculation, the default is
%             the maximum frequency from the BEM data.
% 
% Default values are indicated by [].
% See ‘...WEC-Sim\examples\BEMIO...’ for examples of usage.

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
N = length(t)*sum(hydro.dof)*hydro.Nh;

% Calculate the impulse response function for excitation
n = 0;
for k = 1:length(t);
    for i = 1:sum(hydro.dof);
        for j = 1:hydro.Nh;
            ex_re = interp1(hydro.w,squeeze(hydro.ex_re(i,j,:)),w);
            ex_im = interp1(hydro.w,squeeze(hydro.ex_im(i,j,:)),w);
            hydro.ex_K(i,j,k) = (1/pi)*trapz(w,ex_re.*cos(w*t(k))-ex_im.*sin(w*t(k)));
            n = n+1;
        end
    end
    waitbar(n/N)
end

hydro.ex_t = t;
hydro.ex_w = w;
close(p);

end
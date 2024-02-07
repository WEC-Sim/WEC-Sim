function hydro = radiationIRF(hydro,tEnd,nDt,nDw,wMin,wMax)
% Calculates the normalized radiation impulse response function. This is
% equivalent to the radiation IRF in the theory section normalized by
% :math:`\rho`:
% 
%     :math:`\overline{K}_{r,i,j}(t) = {\frac{2}{\pi}}\intop_0^{\infty}{\frac{B_{i,j}(\omega)}{\rho}}\cos({\omega}t)d\omega`
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
%         Structure of hydro data with radiation IRF
% 

p = waitbar(0,'Calculating radiation IRFs...');  % Progress bar

% Set defaults if empty
if isempty(tEnd)==1;  tEnd = 100;           end
if isempty(nDt)==1;    nDt = 1001;            end
if isempty(nDw)==1;    nDw = 1001;            end
if isempty(wMin)==1;  wMin = min(hydro.w);  end
if isempty(wMax)==1;  wMax = max(hydro.w);  end

% Interpolate to the given t and w
t = linspace(0,tEnd,nDt);
w = linspace(wMin,wMax,nDw);
N = sum(hydro.dof) * sum(hydro.dof);

% Calculate the impulse response function for radiation
n = 0;
hydro.ra_K = nan(sum(hydro.dof), sum(hydro.dof), length(t));
for i = 1:sum(hydro.dof)
    for j = 1:sum(hydro.dof)
        ra_B = interp1(hydro.w,squeeze(hydro.B(i,j,:)),w);
        hydro.ra_K(i,j,:) = (2/pi)*trapz(w,ra_B.*(cos(w.*t(:)).*w), 2);
        n = n+1;
    end
    waitbar(n/N)
end

% Calculate the infinite frequency added mass
ra_Ainf_temp = zeros(length(hydro.w),1);                                    %Initialize the variable
[~,F] = size(hydro);                                                        %Last data set in
if isempty(hydro.Ainf) == 1 || isfield(hydro,'Ainf') == 0 || strcmp(hydro(F).code,'WAMIT')==0
    for i = 1:sum(hydro.dof)
        for j = 1:sum(hydro.dof)
            ra_A            = interp1(hydro.w,squeeze(hydro.A(i,j,:)),w);
            ra_K            = squeeze(hydro.ra_K(i,j,:));
            for k = 1:length(hydro.w)                                       %Calculate the infinite frequency added mass at each input frequency
                ra_Ainf_temp(k,1)  = ra_A(k) + (1./w(k))*trapz(t,ra_K.*sin(w(k).*t.'));
            end
            hydro.Ainf(i,j) = mean(ra_Ainf_temp);                           %Take the mean across the vector of infinite frequency added mass 
        end
    end
end

hydro.ra_t = t;
hydro.ra_w = w;
close(p)

end

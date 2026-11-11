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
%     nDw : float or nDOF x nDOF
%         Number of frequency steps used in the IRF calculation
%         (hydrodynamic coefficients are interpolated to correspond), the
%         default is 1001
% 
%     wMin : float or nDOF x nDOF
%         Minimum frequency to use in the IRF calculation, the default is
%         the minimum frequency from the BEM data
% 
%     wMax : float or nDOF x nDOF
%         Maximum frequency to use in the IRF calculation, the default is
%         the maximum frequency from the BEM data
%
% Returns
% -------
%     hydro : struct
%         Structure of hydro data with radiation IRF
% 

disp('Calculating radiation IRFs...');

% Set defaults if empty
if isempty(tEnd);  tEnd = 100;           end
if isempty(nDt);   nDt = 1001;           end
if isempty(nDw);   nDw = 1001;           end
if isempty(wMin);  wMin = min(hydro.w);  end
if isempty(wMax);  wMax = max(hydro.w);  end

nDOF = sum(hydro.dof);
nDw = expandSize(nDw, nDOF);
wMin = expandSize(wMin, nDOF);
wMax = expandSize(wMax, nDOF);

% Interpolate to the given t and w
t = linspace(0,tEnd,nDt);

% Calculate the impulse response function for radiation
hydro.ra_K = nan(sum(hydro.dof), sum(hydro.dof), length(t));
for i = 1:sum(hydro.dof)
    for j = 1:sum(hydro.dof)
        w = linspace(wMin(i,j), wMax(i,j), nDw(i,j));
        ra_B = interp1(hydro.w,squeeze(hydro.B(i,j,:)),w);
        hydro.ra_K(i,j,:) = (2/pi)*trapz(w,ra_B.*(cos(w.*t(:)).*w), 2);
        hydro.ra_w(i,j,:) = w;

        % Alternate calculation for the infinite-frequency added mass based on the
        % radiation IRF
        if isempty(hydro.Ainf) || ~isfield(hydro,'Ainf') || ~strcmp(hydro(F).code,'WAMIT')
            ra_Ainf_temp = zeros(length(w),1);
            ra_A = interp1(hydro.w,squeeze(hydro.A(i,j,:)),w);
            ra_K = squeeze(hydro.ra_K(i,j,:));
            for k = 1:length(w)                                             %Calculate the infinite frequency added mass at each input frequency
                ra_Ainf_temp(k,1)  = ra_A(k) + (1./w(k))*trapz(t,ra_K.*sin(w(k).*t.'));
            end
            hydro.Ainf(i,j) = mean(ra_Ainf_temp);                           %Take the mean across the vector of infinite frequency added mass 
        end
    end
end

hydro.ra_t = t;

end

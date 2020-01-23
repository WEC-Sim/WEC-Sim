function hydro = Radiation_IRF(hydro,t_end,n_t,n_w,w_min,w_max)

% Calculates the normalized radiation impulse response function.
% 
% hydro = Radiation_IRF(hydro, t_end, n_t, n_w, w_min, w_max)
%     hydro – data structure
%     t_end – calculation range for the IRF, where the IRF is calculated from
%             t = 0 to t_end, and the default is 100 s
%     n_t –   number of time steps in the IRF, the default is 1001
%     n_w –   number of frequency steps used in the IRF calculation (hydrodynamic
%             coefficients are interpolated to correspond), the default is 1001
%     w_min – minimum frequency to use in the IRF calculation, the default is
%             the minimum frequency from the BEM data
%     w_max – maximum frequency to use in the IRF calculation, the default is
%             the maximum frequency from the BEM data
% 
% Default values are indicated by [].
% See ‘…\WEC-Sim\tutorials\BEMIO\...’ for examples of usage.

p = waitbar(0,'Calculating radiation IRFs...');  % Progress bar

% Set defaults if empty
if isempty(t_end)==1;  t_end = 100;           end
if isempty(n_t)==1;    n_t = 1001;            end
if isempty(n_w)==1;    n_w = 1001;            end
if isempty(w_min)==1;  w_min = min(hydro.w);  end
if isempty(w_max)==1;  w_max = max(hydro.w);  end

% Interpolate to the given t and w
t = linspace(0,t_end,n_t);
w = linspace(w_min,w_max,n_w);
N = length(t)*sum(hydro.dof)*sum(hydro.dof);

% Calculate the impulse response function for radiation
n = 0;
for k = 1:length(t);
    for i = 1:sum(hydro.dof);
        for j = 1:sum(hydro.dof);
            ra_B = interp1(hydro.w,squeeze(hydro.B(i,j,:)),w);
            hydro.ra_K(i,j,k) = (2/pi)*trapz(w,ra_B.*(cos(w*t(k)).*w));
            % hydro.ra_L(i,j,k) = (2/pi)*trapz(w,ra_B.*(sin(w*t(k))));  %Not used
            n = n+1;
        end
    end
    waitbar(n/N)
end

hydro.ra_t = t;
hydro.ra_w = w;
close(p)

end
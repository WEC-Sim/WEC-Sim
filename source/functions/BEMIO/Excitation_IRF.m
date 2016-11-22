function hydro = Excitation_IRF(hydro,t_end,n_t,n_w,w_min,w_max)

% Calculates the normalized excitation impulse response function.
% 
% hydro = Excitation_IRF(hydro, t_end, n_t, n_w, w_min, w_max)
%     hydro – data structure
%     t_end – calculation range for the IRF, where the IRF is calculated from
%             t = -t_end to t_end, and the default is 100 s
%     n_t –   number of time steps in the IRF, the default is 1001
%     n_w –   number of frequency steps used in the IRF calculation (hydrodynamic
%             coefficients are interpolated to correspond), the default is 1001
%     w_min – minimum frequency to use in the IRF calculation, the default is
%             the minimum frequency from the BEM data
%     w_max – maximum frequency to use in the IRF calculation, the default is
%             the maximum frequency from the BEM data.
% 
% Default values are indicated by [].
% See ‘…\WEC-Sim\tutorials\BEMIO\...’ for examples of usage.

p = waitbar(0,'Calculating excitation IRFs...');  % Progress bar

% Set defaults if empty
if isempty(t_end)==1;  t_end = 100;           end
if isempty(n_t)==1;    n_t = 1001;            end
if isempty(n_w)==1;    n_w = 1001;            end
if isempty(w_min)==1;  w_min = min(hydro.w);  end
if isempty(w_max)==1;  w_max = max(hydro.w);  end

% Interpolate to the given t and w
t = linspace(-t_end,t_end,n_t);
w = linspace(w_min,w_max,n_w);  
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
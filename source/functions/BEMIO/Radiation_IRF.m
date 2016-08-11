function hydro = Radiation_IRF(hydro,t_end,n_t,n_w,w_min,w_max)

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
N = length(t)*6*hydro.Nb*6*hydro.Nb;

% Calculate the impulse response function for radiation
n = 0;
for k = 1:length(t);
    for i = 1:6*hydro.Nb;
        for j = 1:6*hydro.Nb;
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
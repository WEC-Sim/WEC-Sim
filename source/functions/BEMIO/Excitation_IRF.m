function hydro = Excitation_IRF(hydro,t_end,n_t,n_w,w_min,w_max)

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
N = length(t)*6*hydro.Nb*hydro.Nh;

% Calculate the impulse response function for excitation
n = 0;
for k = 1:length(t);
    for i = 1:6*hydro.Nb;
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
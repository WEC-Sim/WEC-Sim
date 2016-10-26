function hydro = Normalize(hydro)

% Normalize AQWA and NEMOH data in the same way that WAMIT data is normalized
% Cn = C/(rho*g);   Linear restoring stiffness
% An = A/rho;       Added mass
% Bn = B/(rho*w);   Radiation damping
% Xn = X/(rho*g);   Excitation force

[a,b] = size(hydro);  % Normalize last data set in
F = b;

hydro(F).C = hydro(F).C/(hydro(F).g*hydro(F).rho);
hydro(F).A = hydro(F).A/(hydro(F).rho);
hydro(F).Ainf = hydro(F).A(:,:,end);
for i=1:length(hydro(F).w)
    hydro(F).B(:,:,i) = hydro(F).B(:,:,i)/(hydro(F).rho*hydro(F).w(i));
end
hydro(F).ex_ma = hydro(F).ex_ma/(hydro(F).g*hydro(F).rho);
hydro(F).ex_re = hydro(F).ex_re/(hydro(F).g*hydro(F).rho);
hydro(F).ex_im = hydro(F).ex_im/(hydro(F).g*hydro(F).rho);

end


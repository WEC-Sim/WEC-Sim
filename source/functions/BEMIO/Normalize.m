function hydro = Normalize(hydro)

% Normalizes NEMOH and AQWA hydrodynamic coefficients in the same manner
% that WAMIT outputs are normalized. Specifically,the linear restoring
% stiffness is normalized as, C(i,j)/(rho*g); added mass is normalized as,
% A(i,j)/rho; radiation damping is normalized as, B(i,j)/(rho*w); and,
% exciting forces are normalized as, X(i)/(rho*g).
% 
% hydro = Normalize(hydro)
%     hydro – data structure
% 
% Typically, this function is not called directly by the user; it is
% automatically implemented within the Read_NEMOH and Read_AQWA functions.

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


function hydro = Normalize(hydro)

% Normalizes NEMOH and AQWA hydrodynamic coefficients in the same manner
% that WAMIT outputs are normalized. Specifically,the linear restoring
% stiffness is normalized as, C(i,j)/(rho*g); added mass is normalized as,
% A(i,j)/rho; radiation damping is normalized as, B(i,j)/(rho*w); and,
% exciting forces are normalized as, X(i)/(rho*g). And, if necessary, sort
% data according to ascending frequency.
%
% hydro = Normalize(hydro)
%     hydro – data structure
%
% This function is not called directly by the user; it is automatically
% implemented within the Read_WAMIT, Read_NEMOH, and Read_AQWA functions.

[a,b] = size(hydro);  % Last data set in
F = b;

if issorted(hydro(F).w)==0  % Sort, if necessary
    [w,I] = sort(hydro(F).w);
    hydro(F).w = hydro(F).w(I);
    hydro(F).T = hydro(F).T(I);
    hydro(F).A = hydro(F).A(:,:,I);
    hydro(F).B = hydro(F).B(:,:,I);
    hydro(F).ex_ma = hydro(F).ex_ma(:,:,I);
    hydro(F).ex_ph = hydro(F).ex_ph(:,:,I);
    hydro(F).ex_re = hydro(F).ex_re(:,:,I);
    hydro(F).ex_im = hydro(F).ex_im(:,:,I);
    hydro(F).sc_ma = hydro(F).sc_ma(:,:,I);
    if (exist('hydro(F).md_mc'))
        hydro(F).md_mc = hydro(F).md_mc(:,:,I);    
    end
    if (exist('hydro(F).md_cs'))    
        hydro(F).md_cs = hydro(F).md_cs(:,:,I);    
    end
    if (exist('hydro(F).md_pi'))    
        hydro(F).md_pi = hydro(F).md_pi(:,:,I);
    end
    
    hydro(F).sc_ph = hydro(F).sc_ph(:,:,I);
    hydro(F).sc_re = hydro(F).sc_re(:,:,I);
    hydro(F).sc_im = hydro(F).sc_im(:,:,I);
    hydro(F).fk_ma = hydro(F).fk_ma(:,:,I);
    hydro(F).fk_ph = hydro(F).fk_ph(:,:,I);
    hydro(F).fk_re = hydro(F).fk_re(:,:,I);
    hydro(F).fk_im = hydro(F).fk_im(:,:,I);
end

if strcmp(hydro(F).code,'WAMIT')==0  % Normalize
    hydro(F).C = hydro(F).C/(hydro(F).g*hydro(F).rho);
    hydro(F).A = hydro(F).A/(hydro(F).rho);
    hydro(F).Ainf = hydro(F).A(:,:,end);
    for i=1:length(hydro(F).w)
        hydro(F).B(:,:,i) = hydro(F).B(:,:,i)/(hydro(F).rho*hydro(F).w(i));
    end
    hydro(F).ex_ma = hydro(F).ex_ma/(hydro(F).g*hydro(F).rho);
    hydro(F).ex_re = hydro(F).ex_re/(hydro(F).g*hydro(F).rho);
    hydro(F).ex_im = hydro(F).ex_im/(hydro(F).g*hydro(F).rho);
    if (exist('hydro(F).md_mc')) 
        hydro(F).md_mc = hydro(F).md_mc/(hydro(F).g*hydro(F).rho);
    end
    if (exist('hydro(F).md_cs'))    
        hydro(F).md_cs = hydro(F).md_cs/(hydro(F).g*hydro(F).rho);    
    end
    if (exist('hydro(F).md_pi'))    
        hydro(F).md_pi = hydro(F).md_pi/(hydro(F).g*hydro(F).rho);
    end        
    hydro(F).sc_ma = hydro(F).sc_ma/(hydro(F).g*hydro(F).rho);
    hydro(F).sc_re = hydro(F).sc_re/(hydro(F).g*hydro(F).rho);
    hydro(F).sc_im = hydro(F).sc_im/(hydro(F).g*hydro(F).rho);
    hydro(F).fk_ma = hydro(F).fk_ma/(hydro(F).g*hydro(F).rho);
    hydro(F).fk_re = hydro(F).fk_re/(hydro(F).g*hydro(F).rho);
    hydro(F).fk_im = hydro(F).fk_im/(hydro(F).g*hydro(F).rho);
end

end


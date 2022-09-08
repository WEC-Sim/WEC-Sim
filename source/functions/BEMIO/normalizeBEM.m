function hydro = normalizeBEM(hydro)
% Normalizes BEM hydrodynamic coefficients in the same manner
% that WAMIT outputs are normalized. Specifically, the linear restoring
% stiffness is normalized as :math:`C_{i,j}/(\rho g)`; added mass is normalized as
% :math:`A_{i,j}/\rho`; radiation damping is normalized as :math:`B_{i,j}/(\rho \omega)`; and,
% exciting forces are normalized as :math:`X_i/(\rho g)`. And, if necessary, sort
% data according to ascending frequency.
%
% This function is not called directly by the user; it is automatically
% implemented within the readWAMIT, readCAPYTAINE, readNEMOH, and readAQWA
% functions.
%
% Parameters
% ----------
%     hydro : [1 x 1] struct
%         Structure of hydro data that will be  normalized and sorted
%         depending on the value of hydro.code
%
% Returns
% -------
%     hydro : [1 x 1] struct
%         Normalized hydro data
% 

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
    if isfield(hydro(F),'md_mc')
        hydro(F).md_mc = hydro(F).md_mc(:,:,I);
    end
    if isfield(hydro(F),'md_cs')    
        hydro(F).md_cs = hydro(F).md_cs(:,:,I);
    end
    if isfield(hydro(F),'md_pi')    
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

if strcmp(hydro(F).code,'WAMIT')==0  % normalize
    hydro(F).Khs = hydro(F).Khs/double(hydro(F).g*hydro(F).rho);
    hydro(F).A = hydro(F).A/double(hydro(F).rho);
    hydro(F).Ainf = hydro(F).A(:,:,end); % overwritten with more accurate method by radiationIRF.m 
    for i=1:length(hydro(F).w)
        hydro(F).B(:,:,i) = hydro(F).B(:,:,i)/double(hydro(F).rho*hydro(F).w(i));
    end
    hydro(F).ex_ma = hydro(F).ex_ma/double(hydro(F).g*hydro(F).rho);
    hydro(F).ex_re = hydro(F).ex_re/double(hydro(F).g*hydro(F).rho);
    hydro(F).ex_im = hydro(F).ex_im/double(hydro(F).g*hydro(F).rho);
    if isfield(hydro(F),'md_mc') 
        hydro(F).md_mc = hydro(F).md_mc/double(hydro(F).g*hydro(F).rho);
    end
    if isfield(hydro(F),'md_cs')    
        hydro(F).md_cs = hydro(F).md_cs/double(hydro(F).g*hydro(F).rho);    
    end
    if isfield(hydro(F),'md_pi')
        hydro(F).md_pi = hydro(F).md_pi/double(hydro(F).g*hydro(F).rho);
    end        
    hydro(F).sc_ma = hydro(F).sc_ma/double(hydro(F).g*hydro(F).rho);
    hydro(F).sc_re = hydro(F).sc_re/double(hydro(F).g*hydro(F).rho);
    hydro(F).sc_im = hydro(F).sc_im/double(hydro(F).g*hydro(F).rho);
    hydro(F).fk_ma = hydro(F).fk_ma/double(hydro(F).g*hydro(F).rho);
    hydro(F).fk_re = hydro(F).fk_re/double(hydro(F).g*hydro(F).rho);
    hydro(F).fk_im = hydro(F).fk_im/double(hydro(F).g*hydro(F).rho);
end

end

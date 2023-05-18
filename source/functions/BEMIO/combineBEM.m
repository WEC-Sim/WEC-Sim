function hydro = combineBEM(hydro)
% Combines multiple BEM outputs into one hydrodynamic ‘system.’ This function
% requires that all BEM outputs have the same water depth, wave frequencies,
% and wave headings. This function would be implemented following multiple
% readWAMIT, readNEMOH, readCAPYTAINE, or readAQWA and before radiationIRF,
% radiationIRFSS, excitationIRF, writeBEMIOH5, or plotBEMIO function calls.
%
% See ``WEC-Sim\examples\BEMIO\NEMOH`` for examples of usage.
% 
% Parameters
% ----------
%     hydro : [1 x n] struct
%         Structures of hydro data that will be combined into a single
%         structure
%
% Returns
% -------
%     hydro : [1 x 1] struct
%         Combined structure. 
%

p = waitbar(0,'Combining multiple BEM results...');  % Progress bar

[m,n] = size(hydro);
tol = 1e-2;
if n>1
    for i = 2:n
        if max(abs(hydro(i).h-hydro(i-1).h)) > tol
            error('Error: Inconsistent water depth');
        elseif (size(hydro(i).theta) ~= size(hydro(i-1).theta)) | ...
                (max(abs(sort(hydro(i).theta)-sort(hydro(i-1).theta))) > tol)
            error('Error: Inconsistent wave headings');
        elseif (size(hydro(i).T) ~= size(hydro(i-1).T)) | ...
                (max(abs(sort(hydro(i).T)-sort(hydro(i-1).T))) > tol)
            error('Error: Inconsistent wave frequencies');
        end
    end
    
    n = n+1;
    hydro(n).theta = hydro(1).theta;
    hydro(n).body = [];
    hydro(n).Khs = [];
    hydro(n).cb = [];
    hydro(n).cg = [];
    hydro(n).code = [];
    hydro(n).dof = [];
    hydro(n).ex_im = [];
    hydro(n).ex_ma = [];
    hydro(n).ex_ph = [];
    hydro(n).ex_re = [];
    hydro(n).fk_im = [];
    hydro(n).fk_ma = [];
    hydro(n).fk_ph = [];
    hydro(n).fk_re = [];
    hydro(n).sc_im = [];
    hydro(n).sc_ma = [];
    hydro(n).sc_ph = [];
    hydro(n).sc_re = [];
    hydro(n).file = [];
    hydro(n).g = 9.807;
    hydro(n).h = hydro(1).h;
    hydro(n).Nb = 0;
    hydro(n).Nf = hydro(1).Nf;
    hydro(n).Nh = hydro(1).Nh;
    hydro(n).rho = 1000;
    hydro(n).T = hydro(1).T;
    hydro(n).Vo = [];
    hydro(n).w = hydro(1).w;
    for i = 1:(n-1)
        hydro(n).body = [hydro(n).body, hydro(i).body];
        hydro(n).Khs = cat(3, hydro(n).Khs, hydro(i).Khs);
        hydro(n).cb = [hydro(n).cb, hydro(i).cb];
        hydro(n).cg = [hydro(n).cg, hydro(i).cg];
        hydro(n).code = [hydro(n).code, hydro(i).code];
        hydro(n).dof = [hydro(n).dof, hydro(i).dof];
        hydro(n).ex_im = cat(1, hydro(n).ex_im, hydro(i).ex_im);
        hydro(n).ex_ma = cat(1, hydro(n).ex_ma, hydro(i).ex_ma);
        hydro(n).ex_ph = cat(1, hydro(n).ex_ph, hydro(i).ex_ph);
        hydro(n).ex_re = cat(1, hydro(n).ex_re, hydro(i).ex_re);
        hydro(n).fk_im = cat(1, hydro(n).fk_im, hydro(i).fk_im);
        hydro(n).fk_ma = cat(1, hydro(n).fk_ma, hydro(i).fk_ma);
        hydro(n).fk_ph = cat(1, hydro(n).fk_ph, hydro(i).fk_ph);
        hydro(n).fk_re = cat(1, hydro(n).fk_re, hydro(i).fk_re);
        hydro(n).sc_im = cat(1, hydro(n).sc_im, hydro(i).sc_im);
        hydro(n).sc_ma = cat(1, hydro(n).sc_ma, hydro(i).sc_ma);
        hydro(n).sc_ph = cat(1, hydro(n).sc_ph, hydro(i).sc_ph);
        hydro(n).sc_re = cat(1, hydro(n).sc_re, hydro(i).sc_re);
        hydro(n).file = [hydro(n).file, hydro(i).file];
        hydro(n).Nb = hydro(n).Nb + hydro(i).Nb;
        hydro(n).Vo = [hydro(n).Vo, hydro(i).Vo];
    end
    hydro(n).Ainf = zeros(sum(hydro(n).dof),sum(hydro(n).dof));
    hydro(n).A = zeros(sum(hydro(n).dof),sum(hydro(n).dof),hydro(n).Nf);
    hydro(n).B = zeros(sum(hydro(n).dof),sum(hydro(n).dof),hydro(n).Nf);
    if isfield(hydro,'gbm')==1
        hydro(n).gbm = zeros(sum(hydro(n).dof),sum(hydro(n).dof),4);
    end
    k = 0;
    for i = 1:(n-1)
        j = sum(hydro(i).dof);
        hydro(n).Ainf((k+1):(k+j),(k+1):(k+j)) = hydro(i).Ainf;
        hydro(n).A((k+1):(k+j),(k+1):(k+j),:) = hydro(i).A;
        hydro(n).B((k+1):(k+j),(k+1):(k+j),:) = hydro(i).B;
        if isfield(hydro,'gbm')==1
            hydro(n).gbm((k+1):(k+j),(k+1):(k+j),:) = hydro(i).gbm;
        end
        k = k + j;
    end
    
    hydro(1) = hydro(n);
    hydro(2:n) = [];
    
end
hydro = addDefaultPlotVars(hydro);
close(p);
end

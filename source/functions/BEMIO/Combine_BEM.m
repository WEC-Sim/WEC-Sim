function hydro = Combine_BEM(hydro)

% Combines multiple BEM output files. However, the BEM files must have been
% run with the same water depth, wave frequencies, and wave headings.
% Density is assumed to be 1000 and gravity is assumed to be 9.807
% (AQWA & NEMOH data have already been normalized)

p = waitbar(0,'Combining multiple BEM results...');  % Progress bar

[m,n] = size(hydro);
tol = 1e-2;
if n>1
    for i = 2:n
        if max(abs(hydro(i).h-hydro(i-1).h)) > tol
            error('Error: Inconsistent water depth');
        elseif (size(hydro(i).beta) ~= size(hydro(i-1).beta)) | ...
                (max(abs(sort(hydro(i).beta)-sort(hydro(i-1).beta))) > tol)
            error('Error: Inconsistent water depth');
        elseif (size(hydro(i).T) ~= size(hydro(i-1).T)) | ...
                (max(abs(sort(hydro(i).T)-sort(hydro(i-1).T))) > tol)
            error('Error: Inconsistent wave frequencies');
        end
    end
    
    n = n+1;
    hydro(n).beta = hydro(1).beta;
    hydro(n).body = [];
    hydro(n).C = [];
    hydro(n).cb = [];
    hydro(n).cg = [];
    hydro(n).code = [];
    hydro(n).ex_im = [];
    hydro(n).ex_ma = [];
    hydro(n).ex_ph = [];
    hydro(n).ex_re = [];
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
        hydro(n).C = cat(3, hydro(n).C, hydro(i).C);
        hydro(n).cb = [hydro(n).cb, hydro(i).cb];
        hydro(n).cg = [hydro(n).cg, hydro(i).cg];
        hydro(n).code = [hydro(n).code, hydro(i).code];
        hydro(n).ex_im = cat(1, hydro(n).ex_im, hydro(i).ex_im);
        hydro(n).ex_ma = cat(1, hydro(n).ex_ma, hydro(i).ex_ma);
        hydro(n).ex_ph = cat(1, hydro(n).ex_ph, hydro(i).ex_ph);
        hydro(n).ex_re = cat(1, hydro(n).ex_re, hydro(i).ex_re);
        hydro(n).file = [hydro(n).file, hydro(i).file];
        hydro(n).Nb = hydro(n).Nb + hydro(i).Nb;
        hydro(n).Vo = [hydro(n).Vo, hydro(i).Vo];
    end
    hydro(n).Ainf = zeros(6*hydro(n).Nb,6*hydro(n).Nb);
    hydro(n).A = zeros(6*hydro(n).Nb,6*hydro(n).Nb,hydro(n).Nf);
    hydro(n).B = zeros(6*hydro(n).Nb,6*hydro(n).Nb,hydro(n).Nf);
    k = 0;
    for i = 1:(n-1)
        j = 6*hydro(i).Nb;
        hydro(n).Ainf((k+1):(k+j),(k+1):(k+j)) = hydro(i).Ainf;
        hydro(n).A((k+1):(k+j),(k+1):(k+j),:) = hydro(i).A;
        hydro(n).B((k+1):(k+j),(k+1):(k+j),:) = hydro(i).B;
        k = k + j;
    end
    
    hydro(1) = hydro(n);
    hydro(2:n) = [];
    
end
close(p);
end
function [F_mooring, HV_out] = nonLinearStaticMooring(disp, HV_in, data)
% The input variable `data` is shorthand for mooring.nonlinearStaticData
F_mooring = zeros(6, 1);
HV_out = zeros(data.nLines, 2);
rotMat = Rzyx(disp(6), disp(5), disp(4));

for m = 1:data.nLines
    FairleadNotrasl = rotMat*data.nodes(:, 2*m-1);
    DX = data.nodes(:,2*m)-...                  % Anchor
        (FairleadNotrasl+[disp(1);disp(2);disp(3)]); % Fairlead

    h = abs(DX(3));
    r = norm(DX(1:2));

    [HV_out(m,:)] = fminsearch(@(HV)calculateHV(HV,h,r,data), HV_in(m,:), data.fminsearch_options);

    alpha = atan(DX(2)/DX(1)) + pi*(DX(1)<0);
    F = [HV_out(m,1).*[cos(alpha); sin(alpha)]; -HV_out(m,2)];
    F_mooring = F_mooring + [F; cross(FairleadNotrasl, F)];
end

end

function err = calculateHV(HV, h, r, data)
    % Calculate the length of the bottom segment of the line
    LB = data.L - HV(2)/data.w;
    
    if LB > 0 % If the line touchs the seabed
        g = LB - HV(1)/data.CB/data.w;
        lambda = double(g>0)*g;
    
        x = LB+HV(1)/data.w*asinh(data.w*(data.L-LB)/HV(1))+HV(1)*data.L/data.EA+data.CB*data.w/2/data.EA*(g*lambda-LB^2);
        z = HV(1)/data.w*((sqrt(1+(data.w*(data.L-LB)/HV(1)).^2))-1)+data.w*(data.L-LB).^2/2/data.EA;
    
    else % If the line does not touch the seabed
        Va = HV(2) - data.w*data.L;
        x = HV(1)/data.w * (asinh((Va+data.w*data.L)/HV(1)) - asinh((Va)/HV(1) )) + HV(1)*data.L/data.EA;
        z = HV(1)/data.w * (sqrt(1+((Va+data.w*data.L)/HV(1)).^2) - sqrt(1+(Va/HV(1))^2)) + (Va*data.L+data.w*data.L.^2/2)/data.EA;
    end
    
    err = sqrt((x-r)^2+(z-h)^2);

end

function rotMat = Rzyx(rz,ry,rx)
    rotMat = [cos(ry)*cos(rz)  sin(rx)*sin(ry)*cos(rz)-cos(rx)*sin(rz)  cos(rx)*sin(ry)*cos(rz)+sin(rx)*sin(rz);
              cos(ry)*sin(rz)  sin(rx)*sin(ry)*sin(rz)+cos(rx)*cos(rz)  cos(rx)*sin(ry)*sin(rz)-sin(rx)*cos(rz);
              -sin(ry)         sin(rx)*cos(ry)                          cos(rx)*cos(ry)];
end

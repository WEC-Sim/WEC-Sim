function y = variableGenDamping(u)

if u<=31.5e-5 && u>=2.16e-5
bg = 6.19e4*u-1.1667;
else bg = 0.0713;
end

y = bg;
end


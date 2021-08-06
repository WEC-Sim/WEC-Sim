function y = variableMotorVolume(u)

if u<=15e6 && u>=4e6
    alphaD = 2.67e-11*u-8.52e-5;
else
    alphaD = 2e-5;
end
y = alphaD;
end


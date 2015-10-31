% function to return any items of interest to coupling from MoorDyn at
% every time step
function FLines = MoorDyn_caller(X,XD,Time,CoupTime)
    FLines_value = zeros(1,6);
    FLines = zeros(1,6);
    FLines_p = libpointer('doublePtr',FLines_value);
    calllib('Lines','LinesCalc',X,XD,FLines_p,Time,CoupTime);
    FLines = FLines_p.value;
end


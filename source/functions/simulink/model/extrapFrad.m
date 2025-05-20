function Frad =  extrapFrad(timeExtrap, FradExtrap, time)
%#codegen
% This function is to extrapolate the radiation damping loads when using CIC. 
% Since CIC uses persistent variables to track velocityHistory over time, 
% radiation damping loads cannot be updated at each sub-time step
%
% This function must be separated from Simulink calls to
% `convolutionIntegralInterp` and `convolutionIntegralSurface` so that its
% block's timestep can be inherited (-1) and be called at minor time steps.
% 
% Dimensions:
% nDOF = the body's number of degrees of freedom = body.dof
%
% Parameters:
<<<<<<< HEAD
%     timeExtrap : float [3 1]
=======
%     timeExtrap : float [1 3]
>>>>>>> 94a2132261c6ebf59b9e2856a84e0c611031a77c
%       Previous 3 main time steps used for extrapolation
% 
%     FradExtrap : float [3 nDOF]
%         Radiation force in each degree of freedom of the previous 3 main time steps, used for extrapolation
% 
%     time : float [1 1]
%         The current time step
%
% Returns:
%     Frad : float [nDOF 1]
%         The radiation force in each degree of freedom, extrapolated to the current time step
% 
<<<<<<< HEAD

Frad =  interp1(timeExtrap,FradExtrap,time,'pchip','extrap')';
=======
Frad                     =  zeros(length(FradExtrap(1,:)), 1);
timeLength               =  nnz(timeExtrap);

if timeLength           ==  0

    % Direct replication
    Frad                 =  FradExtrap(1,:)';

elseif timeLength       ==  1

    % Linear extrapolation
    timeDiff             =  timeExtrap - timeExtrap(1);
    timeOutput           =  time - timeExtrap(1);
    scaleFactor          =  timeOutput / timeDiff(2);
    
    for i                =  1:length(FradExtrap(1,:))
        b                = -(FradExtrap(1,i) - FradExtrap(2,i));
        Frad(i,1)        =  FradExtrap(1,i) + b*scaleFactor;
    end

else % timeLength       ==  2

    % Quadratic extrapolation
    timeDiff             =  timeExtrap - timeExtrap(1);
    timeOutput           =  time - timeExtrap(1);
    scaleFactor          =  timeOutput / (timeDiff(2) * timeDiff(3) * (timeDiff(2) - timeDiff(3)));

    for i                =  1:length(FradExtrap(1,:))
        b                =  (timeDiff(3)^2 * (FradExtrap(1,i) - FradExtrap(2,i)) + timeDiff(2)^2 * (-FradExtrap(1,i) + FradExtrap(3,i))) * scaleFactor;
        c                =  ((timeDiff(2) - timeDiff(3)) * FradExtrap(1,i) + timeDiff(3) * FradExtrap(2,i) - timeDiff(2) * FradExtrap(3,i)) * scaleFactor;
        Frad(i,1)        =  FradExtrap(1,i) + b + c * timeOutput;
    end
>>>>>>> 94a2132261c6ebf59b9e2856a84e0c611031a77c

end

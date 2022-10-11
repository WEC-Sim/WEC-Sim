function f = noWaveMorison(z,r,Vel,Accel,Disp,Area,Cd,Vol,Ca,Time,rho,rampTime,currentSpeed,currentDirection,currentDepth,currentOption,bodyMorison)
% This function calculates the Morison element force for the no wave case.
[rr,~]=size(r);
FMt = zeros(rr,6);
for ii = 1:rr
    % Calculate Rotation Matrix
    RotMax = [cos(Disp(5))*cos(Disp(6)) , cos(Disp(4))*sin(Disp(6)) + sin(Disp(4))*sin(Disp(5))*cos(Disp(6)) , sin(Disp(4))*sin(Disp(6)) - cos(Disp(4))*sin(Disp(5))*sin(Disp(6));...
              -cos(Disp(5))*sin(Disp(6)), cos(Disp(4))*cos(Disp(6)) -  sin(Disp(4))*sin(Disp(5))*sin(Disp(6)), sin(Disp(4))*cos(Disp(6)) + cos(Disp(4))*sin(Disp(5))*sin(Disp(6));...
              sin(Disp(5))              , -sin(Disp(4))*cos(Disp(5))                                         , cos(Disp(4))*cos(Disp(5))                                        ];
    % Rotate Cartesian
    rRot    = mtimes(RotMax,r(ii,:).')';
    Dispt   = [Disp(1),Disp(2),Disp(3)];
    ShiftCg = Dispt + rRot;
    zRot    = mtimes(RotMax,z(ii,:)')';
    % Update translational and rotational velocity
    % w refers to \omega = rotational velocity
    Velt    = [Vel(4),Vel(5),Vel(6)];
    wxr     = cross(Velt,r(ii,:));
    %
    switch currentOption
        case 0
            currentSpeedDepth = currentSpeed;
        case 1
            if ShiftCg(3) > -currentDepth
                currentSpeedDepth = currentSpeed*(1 + ShiftCg(3)/currentDepth)^(1/7);
            else
                currentSpeedDepth = 0;
            end
        case 2
            if ShiftCg(3) > -currentDepth
                currentSpeedDepth = currentSpeed*(1 + ShiftCg(3)/currentDepth);
            else
                currentSpeedDepth = 0;
            end
        otherwise
            currentSpeedDepth = 0;
    end
    % Ramp Time
    if Time < rampTime
        curramp        = currentSpeedDepth*(1 + cos(pi + pi/rampTime*Time))/2;
    else
        curramp        = currentSpeedDepth;
    end
    %Vel should be a column vector
    Vel2    = [Vel(1),Vel(2),Vel(3)] + wxr + [curramp*cosd(currentDirection),curramp*sind(currentDirection),0];
    % Update translational and rotational acceleration
    % dotw refers to \dot{\omega} = rotational acceleration
    Accelt  = [Accel(4),Accel(5),Accel(6)];
    dotwxr  = cross(Accelt,r(ii,:));
    wxwxr   = cross(Velt,wxr);
    Accel2  = [Accel(1),Accel(2),Accel(3)] + dotwxr + wxwxr;
    if bodyMorison == 2
        %% Decompose Body Velocity
        % Tangential Velocity
        Vel2T           = ((dot(zRot,Vel2))/(norm(zRot))^2)*zRot;
        % Normal Velocity
        Vel2N           = Vel2-Vel2T;
        %% Decompose Body Acceleration
        Accel2T         = ((dot(zRot,Accel2))/(norm(zRot)^2))*zRot;
        % Normal Acceleration
        Accel2N         = Accel2-Accel2T;
        %% Morison Equation
        % Forces from velocity drag
        FdN             = (1/2)*rho*Cd(ii,1)*Area(ii,1)*norm(Vel2N)*(-Vel2N);
        FdT             = (1/2)*rho*Cd(ii,2)*Area(ii,2)*norm(Vel2T)*(-Vel2T);
        Fd              = FdT + FdN;
        % Forces from body acceleration inertia
        FiN             = rho*Vol(ii,:)*Ca(ii,1)*(-Accel2N);
        FiT             = rho*Vol(ii,:)*Ca(ii,2)*(-Accel2T);
        Fbi             = FiN + FiT;
        F               = Fbi + Fd;
    else
        %% Added inertia and drag forces
        areaRot     = abs(mtimes(Area(ii,:),RotMax));
        CdRot       = mtimes(abs(Cd(ii,:)),RotMax);
        CaRot       = abs(mtimes(Ca(ii,:),RotMax));
        % Forces from body velocity drag
        FxuV        = (1/2)*abs(-1*Vel2(1))*-1*Vel2(1)*rho*CdRot(1)*areaRot(1);
        FxvV        = (1/2)*abs(-1*Vel2(2))*-1*Vel2(2)*rho*CdRot(2)*areaRot(2);
        FxwV        = (1/2)*abs(-1*Vel2(3))*-1*Vel2(3)*rho*CdRot(3)*areaRot(3);
        % Forces from body acceleration inertia
        FxuA        = rho*Vol(ii,:)*CaRot(1)*-1*Accel2(1);
        FxvA        = rho*Vol(ii,:)*CaRot(2)*-1*Accel2(2);
        FxwA        = rho*Vol(ii,:)*CaRot(3)*-1*Accel2(3);
        % Sum the force contributions
        F           = [FxuV + FxuA,FxvV + FxvA,FxwV + FxwA];
    end
    % Determine if the Morison Element point of application goes above the
    % mean water line and does not consider the local surface elevation.
    if ShiftCg(3) > 0
        F           = [0, 0, 0];
        M           = [0, 0, 0];
        % Calculate the moment about the center of gravity for each Morison Element
        FMt(ii,:)   = [F,M];
    else
        % Calculate the moment about the center of gravity for each Morison Element
        M           = cross(rRot,F);
        FMt(ii,:)   = [F,M];
    end
end
f      = 0.*Vel;
f(1:6) = [sum(FMt(:,1));sum(FMt(:,2));sum(FMt(:,3));sum(FMt(:,4));sum(FMt(:,5));sum(FMt(:,6))];
end
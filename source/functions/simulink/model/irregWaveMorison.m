function f = irregWaveMorison(z,r,Vel,Accel,Disp,Area,Cd,Vol,Ca,Time,rho,direction,waterDepth,k,w,A,rampTime,g,randPhase,dw,currentSpeed,currentDirection,currentDepth,currentOption,bodyMorison)
% This function calculates the Morison element force for the irregular wave
% case.
[rr,~]  = size(r); [ff]    = length(w);
FMt     = zeros(rr,6);
uVt     = zeros(ff,1); vVt = uVt; wVt = vVt; uAt = wVt; vAt = uAt; wAt = vAt;
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
    % Update Translational Acceleration
    Accel2  = [Accel(1),Accel(2),Accel(3)] + dotwxr + wxwxr;
    %% Calculate Orbital Velocity
    for jj = 1:ff
        waveDirRad      = direction*pi/180;
        phaseArg        = w(jj,1)*Time - k(jj,1)*(ShiftCg(1)*cos(waveDirRad) + ShiftCg(2)*sin(waveDirRad)) + randPhase(jj,1);
        % Vertical Variation
        kh              = k(jj,1)*waterDepth;
        kz              = k(jj,1)*ShiftCg(3);
        if kh > pi 
            % Deep Water Wave Assumption
            coeffHorz  = exp(kz);
            coeffVert  = coeffHorz;
        else
            % Shallow & Intermediate depth
            coeffHorz  = cosh(kz + kh)/cosh(kh);
            coeffVert  = sinh(kz + kh)/cosh(kh);
        end
        % Ramp Time
        if Time < rampTime
            ramp        = (sqrt(A(jj,1)*dw(jj,1))/2)*(1 + cos(pi + pi/rampTime*Time));
        else
            ramp        = sqrt(A(jj,1)*dw(jj,1));
        end
        % Orbital Velocity for each individual wave component
        uVt(jj,1)       =  ramp*coeffHorz*cos(phaseArg)*g*k(jj,1)*(1/w(jj,1))*cos(waveDirRad);
        vVt(jj,1)       =  ramp*coeffHorz*cos(phaseArg)*g*k(jj,1)*(1/w(jj,1))*sin(waveDirRad);
        wVt(jj,1)       = -ramp*coeffVert*sin(phaseArg)*g*k(jj,1)*(1/w(jj,1));
        % Orbital Acceleration for each individual wave component
        uAt(jj,1)       = -ramp*coeffHorz*sin(phaseArg)*g*k(jj,1)*cos(waveDirRad);
        vAt(jj,1)       = -ramp*coeffHorz*sin(phaseArg)*g*k(jj,1)*sin(waveDirRad);
        wAt(jj,1)       = -ramp*coeffVert*cos(phaseArg)*g*k(jj,1);
    end
    % Sum the wave components to obtain the x, y, z orbital velocities
    uV = sum(uVt); uA   = sum(uAt); vV = sum(vVt); vA = sum(vAt); wV = sum(wVt); wA = sum(wAt);
    fluidV              = [uV, vV, wV];
    fluidA              = [uA, vA, wA];
    if bodyMorison == 2
        %% Decompose Fluid Velocity
        % Tangential Velocity
        vT              = ((dot(zRot,fluidV))/(norm(zRot)^2))*zRot;        
        % Normal Velocity
        vN              = fluidV-vT;
        %% Decompose Fluid Acceleration
        AT              = ((dot(zRot,fluidA))/(norm(zRot)^2))*zRot;        
        % Normal Acceleration
        AN              = fluidA-AT;
        %% Decompose Body Velocity
        % Tangential Velocity
        Vel2T           = ((dot(zRot,Vel2))/(norm(zRot)^2))*zRot;       
        % Normal Velocity
        Vel2N           = Vel2-Vel2T;
        %% Decompose Body Acceleration
        Accel2T         = ((dot(zRot,Accel2))/(norm(zRot)^2))*zRot;   
        % Normal Acceleration
        Accel2N         = Accel2-Accel2T;
        %% Morison Equation
        % Forces from velocity drag
        FdN             = (1/2)*rho*Cd(ii,1)*Area(ii,1)*(vN-Vel2N)*norm(vN-Vel2N);                               
        FdT             = (1/2)*rho*Cd(ii,2)*Area(ii,2)*(vT-Vel2T)*norm(vT-Vel2T);                                          
        Fd              = FdT + FdN;
        % Forces from body acceleration inertia on the Morison Element
        FiN             = rho*Vol(ii,:)*Ca(ii,1)*(AN - Accel2N);            % AdiffN;
        FiT             = rho*Vol(ii,:)*Ca(ii,2)*(AT - Accel2T);            % AdiffT;
        Fbi             = FiN + FiT;
        % Forces from fluid acceleration inertia on the Morison Element
        Ffi             = rho*Vol(ii,:)*(fluidA);
        % Summation of inertial forces on the Morison Element
        Fi              = Ffi + Fbi;
        % Total Force from the Morison Element
        F               = Fi + Fd;
    else
        %% Added inertia and drag forces
        areaRot         = abs(mtimes(Area(ii,:),RotMax));
        CdRot           = mtimes(abs(Cd(ii,:)),RotMax);
        CaRot           = abs(mtimes(Ca(ii,:),RotMax));
        % Forces from velocity drag
        uVdiff          = uV - Vel2(1); FxuV = (1/2)*abs(uVdiff)*uVdiff*rho*CdRot(1)*areaRot(1);
        vVdiff          = vV - Vel2(2); FxvV = (1/2)*abs(vVdiff)*vVdiff*rho*CdRot(2)*areaRot(2);
        wVdiff          = wV - Vel2(3); FxwV = (1/2)*abs(wVdiff)*wVdiff*rho*CdRot(3)*areaRot(3);
        % Forces from body acceleration inertia
        uAdiff          = uA - Accel2(1); FxuA = uAdiff*rho*Vol(ii,:)*CaRot(1);
        vAdiff          = vA - Accel2(2); FxvA = vAdiff*rho*Vol(ii,:)*CaRot(2);
        wAdiff          = wA - Accel2(3); FxwA = wAdiff*rho*Vol(ii,:)*CaRot(3);
        % Forces from fluid acceleration inertia
        FxuAf           = uA*Vol(ii,:)*rho;
        FxvAf           = vA*Vol(ii,:)*rho;
        FxwAf           = wA*Vol(ii,:)*rho;
        % Total Force from the Morison Element
        F               = [FxuV + FxuA + FxuAf,...
                           FxvV + FxvA + FxvAf,...
                           FxwV + FxwA + FxwAf];
    end
    % Determine if the Morison Element point of application goes above the
    % mean water line and does not consider the local surface elevation.
    if ShiftCg(3) > 0
        F           = [0, 0, 0];
        M           = [0, 0, 0];
        FMt(ii,:)   = [F,M];
    else
        % Calculate the moment about the center of gravity for each Morison Element
        M           = cross(rRot,F);
        FMt(ii,:)   = [F,M];
    end
end
f      = 0.* Vel;
f(1:6) = [sum(FMt(:,1));sum(FMt(:,2));sum(FMt(:,3));sum(FMt(:,4));sum(FMt(:,5));sum(FMt(:,6))];
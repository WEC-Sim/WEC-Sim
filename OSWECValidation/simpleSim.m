% Dominic Forbush
% This is an attempt to prove the behavior 
% observed in WECSIM makes sense
% for the simple OSWEC example

m=2.7548e7+1850000; % flap added + static inertia in yaw
A=1.25; % wave amplitude in m. THIS IS 50% OF WAVE HEIGHT
D=1.7048e5+120000; % sum of PTO damping and rad coefficient
%G=1e6; % amplitude of forcing oscillation
G(:,1)=[-170:10:180].*(pi/180);
G(:,2)=body(1,1).hydroForce.fExt.fEHRE(6,:);
omega=2*pi/8; % wave radian frequency

dt=0.01;
T=[0:dt:400];

[t,x]=ode45(@(t,x) simpleOSWEC(t,x,A,D,G,omega,m)...
    , [0 400], [10*(pi/180) 0.0116]);

hold on;
plot(t-20,(180/pi).*x(:,1),'--r')
xlabel('Time(s)')
ylabel('OSWEC Yaw Position (deg)')
title('ODE45 Output')
legend('WEC-Sim','ODE45')

function dxdt=simpleOSWEC(t,x,A,D,G,omega,m)

dxdt(1,1)=x(2);
%dxdt(2,1)=(A*cos(omega.*t).*-G*sin(2*x(1))-D*x(2))/m;
dxdt(2,1)=(A*cos(omega.*t).*interp1(G(:,1),G(:,2),x(1))-D*x(2))/m;

end


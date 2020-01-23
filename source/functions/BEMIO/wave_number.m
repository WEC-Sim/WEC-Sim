function wk = wave_number(wa,h)
% Solves the wave dispersion relation sig^2 = g*k*tanh(k*h)
%
% Usage:
%  >> wk = wavenumber(g,wa,wd,h,u,v,tol)
%  >> [wk,err] = wavenumber(g,wa,wd,h,u,v)
%  >> wavenumber %demo
%
% Description:
%  Solves the wave dispersion relation 
%   sig^2 = g*wk*tanh(wk*h)
%  where 
%   g = gravity [L/T^2]
%   h = water depth [L]
%   sig = Relative angular frequency [rad/T]
%   sig = wa - wk*cos(wd)*u - wk*cos(wd)*v = wa - wk*uk [rad/T]
%   uk = cos(wd)*u + sin(wd)*v [L/T]
%   u = current velocity in x direction [L/T]
%   v = current velocity in y direction [L/T]
%
% The Newton-Raphson Method is given by
%   wk(n+1) = wk(n) - f(k(n))/fp(k(n))
% where
%   f = g*wk*tanh(wk*h) - sig^2
%   fp = g*(tanh(wk*h) - h*wk*(tanh(wk*h)^2-1)) + 2*uk*sig
%
% Makes initial guess using 
% Guo, J. (2002) Simple and explicit solution of wave 
%   dispersion, Coastal Engineering, 46(2), 71-74.
% A simple correction is applied to the initial guess to account for
% for currents.
%
% Input: 
%   wa = absolute angular frequency [rad/T]
%   wd = wave direction, going to [rad]
%   h = water depth [L]
%   u = current velocity in x direction [L/T]
%   v = current velocity in y direction [L/T]
%   tol = wave number error tolerance for Newton-Raphson method 
%         (default is 0.0001 rad/L)
%
% Output:
%   wk = wave number [rad/L]
%   err = final error defined as g*k*tanh(k*h) -sig^2 [rad^2/T^2]
%         (always smaller than tol)
%   iter = number of iterations 
%
% Author: Alex Sanchez, USACE-CHL
% Date: February 27, 2012
% Version 2.0

twopi = 2*pi; %Internal variable

%Demo mode
% if nargin==0
    g = 9.81; %gravity [m/s^2]
%     T = 5:10; %wave period [s]
%     freq = 1./T; %frequency [1/s]
%     wa = twopi*freq; %absolute angular frequency [rad/s]
    wd = 0*pi/180; %wave angle [rad]
%     h = 6; %water depth [m]
    u = 0;  %current velocity in x direction [m/s]
    v = 0;  %current velocity in y direction [m/s]
% end

%Make initial guess with Guo (2002)
xi = wa./sqrt(g./h); %note: =h*wa/sqrt(h*g/h)
yi = xi.*xi/(1.0-exp(-xi.^2.4908)).^0.4015;
wki = yi/h; %Initial guess without current-wave interaction

%Current velocity in wave direction
uk = cos(wd).*u + sin(wd).*v; 

%Simple correction for currents (tends to overcorrect, hense the relaxation)
wki = 0.3*wki + 0.7*(wa-wki.*uk).^2./(g*tanh(wki.*h));

%Save wavenumber for iteration
wk = wki; 

%Save for screen output
if nargin==0
    wleni = twopi./wki; %initial wave length [m]
end

%Set default tolerance
if nargin<7
    tol = 0.0001; %default tolerance for Newton-Raphson iteration loop
end

%Main loop for Newton-Raphson iteration
for iter=1:10
    sig = wa-wk.*uk; 
    tanhkh = tanh(wk.*h);
    f = g*wk.*tanhkh - sig.^2;
    fp = g*(tanhkh - h.*wk.*(tanhkh.^2-1)) + 2*uk.*sig;
    wk = wki - f./fp;
    iblk = (wk<0 | wk>1e6); %No solution, assume wave blocking
    wk(iblk) = NaN;
    wkchg = abs(wk-wki);
    if(all(iblk) || all(wkchg<tol)), break, end
    wki = wk;
end

%Compute final error in dispersion relation if needed
if nargout>=2 || nargin==0
    sig = wa-wk.*uk; 
    tanhkh = tanh(wk.*h);
    err = g*wk.*tanhkh - sig.^2; %same as f above but updated
    err(iblk) = NaN;
end

%Screen output for demo
if nargin==0
    wlen = twopi./wk;   %final wave length [m]
    disp('Initial Wave Length = ')
    disp(wleni)
    disp('Final Wave Length = ')
    disp(wlen)
    disp('Error =')
    disp(err)
    disp('Iterations = ')
    disp(iter)
end
return


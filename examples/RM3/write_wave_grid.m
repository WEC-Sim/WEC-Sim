

t = waves.waveAmpTime(:,1);
it = simu.dt;
x = linspace(-2, 2, 3);
y = linspace(-2, 2, 3);
[X,Y] = meshgrid(x,y);

for n=1:length(t)
Z = waveElevationGrid(waves, t(n), X, Y, t(n), it, simu.g)



end
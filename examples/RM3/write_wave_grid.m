clc
close all

t = waves.waveAmpTime(:,1);
it = simu.dt;
x = linspace(-100, 100, 100);
y = linspace(-100, 100, 100);
[X,Y] = meshgrid(x,y);

float = stlread('geometry\float.stl');
plate = stlread('geometry\plate.stl');

h = figure;
axis([-20 20 -20 20 -40 40])
axis tight manual % this ensures that getframe() returns a consistent size
filename = 'WaveSurf.gif';


for n=1:length(t)
    
    float_p = float.Points;
    float_c = float.ConnectivityList;
    float_p(:,3) = float.Points(:,3) + (output.bodies(1).position(n,3)-output.bodies(1).position(1,3));
    float_final = triangulation(float_c,float_p);

    plate_p = plate.Points;
    plate_c = plate.ConnectivityList;
    plate_p(:,3) = plate.Points(:,3) + (output.bodies(2).position(n,3)-output.bodies(2).position(1,3));
    plate_final = triangulation(plate_c,plate_p);

    trisurf(float_final,'FaceColor','y','EdgeColor','k')
    hold on
    trisurf(plate_final,'FaceColor','y','EdgeColor','k')
    hold on
    
    Z = waveElevationGrid(waves, t(n), X, Y, t(n), it, simu.g);
    
    surf(X,Y,Z, 'EdgeColor','none')
    caxis([-1.25 1.25])

    % Capture the plot as an image 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    if n == 1 
      imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else 
      imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.1); 
    end 
    
    hold off


end
 %}






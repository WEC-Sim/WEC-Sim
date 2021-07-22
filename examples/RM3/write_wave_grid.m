

t = waves.waveAmpTime(:,1);
it = simu.dt;
x = linspace(-100, 100, 100);
y = linspace(-100, 100, 100);
[X,Y] = meshgrid(x,y);

float = stlread('geometry\float.stl');
plate = stlread('geometry\plate.stl');
plate_p = plate.Points;
plate_c = plate.ConnectivityList;
plate_p(:,3) = plate.Points(:,3) - 10;
plate = triangulation(plate_c,plate_p);


 h = figure;
 axis([-20 20 -20 20 -2 2])
 axis tight manual % this ensures that getframe() returns a consistent size
 filename = 'WaveSurf.gif';


for n=1:length(t)
    
    trisurf(float,'FaceColor','y','EdgeColor','k')
    hold on
    trisurf(plate,'FaceColor','y','EdgeColor','k')
    hold on

    Z = waveElevationGrid(waves, t(n), X, Y, t(n), it, simu.g);
    
    surf(X,Y,Z, 'EdgeColor','none')

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





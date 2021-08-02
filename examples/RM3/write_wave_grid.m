clc
close all

t = waves.waveAmpTime(:,1);
it = simu.dt;
x = linspace(-100, 100, 100);
y = linspace(-100, 100, 100);
[X,Y] = meshgrid(x,y);

float = stlread('geometry\float.stl');
float_p = float.Points;
float_c = float.ConnectivityList;
plate = stlread('geometry\plate.stl');
plate_p = plate.Points;
plate_c = plate.ConnectivityList;

h = figure;

filename = 'WaveSurf.gif';


for i=1:length(t)
    
    for ii=1:length(float_p(:,1))
        
        
        
    end
    
    float_p(:,3) = float.Points(:,3) + (output.bodies(1).position(i,3)-output.bodies(1).position(1,3));
    float_final = triangulation(float_c,float_p);

    plate_p(:,3) = plate.Points(:,3) + (output.bodies(2).position(i,3)-output.bodies(2).position(1,3));
    plate_final = triangulation(plate_c,plate_p);

    trisurf(float_final,'FaceColor',[1 1 0],'EdgeColor','k','EdgeAlpha',.2)
    hold on
    trisurf(plate_final,'FaceColor',[1 1 0],'EdgeColor','k','EdgeAlpha',.2)
    hold on
    
    Z = waveElevationGrid(waves, t(i), X, Y, t(i), it, simu.g);
    
    surf(X,Y,Z, 'EdgeColor','none')
    caxis([-waves.A waves.A])
    hold on
    
    %{
    depth = -waves.waterDepth*ones(length(X));
    surf(X,Y,depth,'FaceColor',[.4 .4 0])
    hold on
    %}
    
    delete(findall(gcf,'type','annotation'));
    t_annot = ['time = ', num2str(t(i)), 's'];
    annotation('textbox',[.7 .4 .3 .3],'String',t_annot,'FitBoxToText','on');
    axis([-100 100 -100 100 -15 35])
    xlabel('x(m)')
    ylabel('y(m)')
    zlabel('z(m)')
    
    drawnow;
    

    % Capture the plot as an image 
    frame = getframe(h); 
    im = frame2im(frame); 
    [imind,cm] = rgb2ind(im,256); 
    % Write to the GIF File 
    if i == 1 
      imwrite(imind,cm,filename,'gif', 'Loopcount',inf); 
    else 
      imwrite(imind,cm,filename,'gif','WriteMode','append','DelayTime',.1); 
    end 
    %}
    
    hold off
    

end
 %}






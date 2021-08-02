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

float_x = output.bodies(1).position(:,1);
float_y = output.bodies(1).position(:,2);
float_z = output.bodies(1).position(:,3);
float_rx = output.bodies(1).position(:,4);
float_ry = output.bodies(1).position(:,5);
float_rz = output.bodies(1).position(:,6);

plate_x = output.bodies(2).position(:,1);
plate_y = output.bodies(2).position(:,2);
plate_z = output.bodies(2).position(:,3);
plate_rx = output.bodies(2).position(:,4);
plate_ry = output.bodies(2).position(:,5);
plate_rz = output.bodies(2).position(:,6);

h = figure;

filename = 'WaveSurf.gif';


for i=1:length(t)
    
    for ii=1:length(float_p(:,1))
        r_y = sqrt(float_x(ii)^2+float_z(ii)^2);
        theta_y = atan(float_z(ii)/float_x(ii));
        if float_x(ii)>0
            theta_y = theta_y+float_ry;
            float_x(ii) = r_y*
        end
        
        
    end
    
    float_p(:,3) = float.Points(:,3) + (float_z(i)-float_z(1));
    float_final = triangulation(float_c,float_p);

    plate_p(:,3) = plate.Points(:,3) + (plate_z(i)-plate_z(1));
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
    
%{
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






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

del_float_x = output.bodies(1).position(:,1)-output.bodies(1).position(1,1);
del_float_y = output.bodies(1).position(:,2)-output.bodies(1).position(1,2);
del_float_z = output.bodies(1).position(:,3)-output.bodies(1).position(1,3);
del_float_rx = output.bodies(1).position(:,4)-output.bodies(1).position(1,4);
del_float_ry = output.bodies(1).position(:,5)-output.bodies(1).position(1,5);
del_float_rz = output.bodies(1).position(:,6)-output.bodies(1).position(1,6);

del_plate_x = output.bodies(2).position(:,1)-output.bodies(2).position(1,1);
del_plate_y = output.bodies(2).position(:,2)-output.bodies(2).position(1,2);
del_plate_z = output.bodies(2).position(:,3)-output.bodies(2).position(1,3);
del_plate_rx = output.bodies(2).position(:,4)-output.bodies(2).position(1,4);
del_plate_ry = output.bodies(2).position(:,5)-output.bodies(2).position(1,5);
del_plate_rz = output.bodies(2).position(:,6)-output.bodies(2).position(1,6);

h = figure;

filename = 'WaveSurf.gif';

float_r_y = sqrt(float_p(:,1).^2+float_p(:,3).^2);
float_theta_y = zeros(length(float_p),1);
plate_r_y = sqrt(plate_p(:,1).^2+plate_p(:,3).^2);
plate_theta_y = zeros(length(plate_p),1);

for ii=1:length(float_p)
     if float_p(ii,1)>=0
         
         float_theta_y(ii) = atan(float_p(ii,3)/float_p(ii,1));

     else
         
         float_theta_y(ii) = atan(float_p(ii,3)/float_p(ii,1))+pi;
         
     end
end
   
for ii=1:length(plate_p)
     if plate_p(ii,1)>=0
        
         plate_theta_y(ii) = atan(plate_p(ii,3)/plate_p(ii,1));

     else
         
         plate_theta_y(ii) = atan(plate_p(ii,3)/plate_p(ii,1))+pi;
         
     end
end

for i=1:length(t)
    
            float_theta_y_new = float_theta_y+del_float_ry(i);

            float_p(:,1) = float_r_y.*cos(float_theta_y_new);
            float_p(:,3) = float_r_y.*sin(float_theta_y_new);
    

            
   
    
 
            plate_theta_y_new = plate_theta_y+del_plate_ry(i);

            plate_p(:,1) = plate_r_y.*cos(plate_theta_y_new);
            plate_p(:,3) = plate_r_y.*sin(plate_theta_y_new);
      
      
        
    
    
    float_p(:,3) = float.Points(:,3) + (del_float_z(i));
    float_final = triangulation(float_c,float_p);

    plate_p(:,3) = plate.Points(:,3) + (del_plate_z(i));
    plate_final = triangulation(plate_c,plate_p);

    trisurf(float_final,'FaceColor',[1 1 0],'EdgeColor','k','EdgeAlpha',.2)
    hold on
    trisurf(plate_final,'FaceColor',[1 1 0],'EdgeColor','k','EdgeAlpha',.2)
    hold on
    
    Z = waveElevationGrid(waves, t(i), X, Y, t(i), it, simu.g);
    
    %surf(X,Y,Z, 'EdgeColor','none')
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
    axis([-40 40 -40 40 -25 40])
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






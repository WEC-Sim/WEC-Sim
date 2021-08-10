function bod = plotWaves(obj,t,it,g,xlims,ylims,body,waves)
            
            %t = waves.waveAmpTime(:,1);
            %it = simu.dt;
            x = linspace(xlims(1),xlims(2),100);
            y = linspace(ylims(1),ylims(2),100);
            [X,Y] = meshgrid(x,y);

            for ibod=1:length(obj.bodies)
                
                % Read and assign geometry data
                read_bod = stlread(body(ibod).geometryFile);
                bod(ibod).Points = read_bod.Points;
                bod(ibod).Conns = read_bod.ConnectivityList;

                % Read changes and assign angles and position changes over time
                bod(ibod).del_pos = [obj.bodies(ibod).position(:,1)-obj.bodies(ibod).position(1,1),obj.bodies(ibod).position(:,2)-obj.bodies(ibod).position(1,2),obj.bodies(ibod).position(:,3)-obj.bodies(ibod).position(1,3)];
                bod(ibod).del_theta = [obj.bodies(ibod).position(:,4)-obj.bodies(ibod).position(1,4),obj.bodies(ibod).position(:,5)-obj.bodies(ibod).position(1,5),obj.bodies(ibod).position(:,6)-obj.bodies(ibod).position(1,6)];
            
                % Find distances and angles about each axis for the bodies
                % distances from each axis
                bod(ibod).dist = [sqrt(bod(ibod).Points(:,2).^2+bod(ibod).Points(:,3).^2),sqrt(bod(ibod).Points(:,1).^2+bod(ibod).Points(:,3).^2),sqrt(bod(ibod).Points(:,1).^2+bod(ibod).Points(:,2).^2)];
                bod(ibod).theta = zeros(length(bod(ibod).Points),3);
                
               

                % angles from each axis
                for ii=1:length(bod(ibod).Points)
                     if bod(ibod).Points(ii,2)>=0
                         bod(ibod).theta(ii,1) = atan(bod(ibod).Points(ii,3)/bod(ibod).Points(ii,2));
                     else
                         bod(ibod).theta(ii,1) = atan(bod(ibod).Points(ii,3)/bod(ibod).Points(ii,2))+pi;
                     end
                     if bod(ibod).Points(ii,1)>=0
                         bod(ibod).theta(ii,2) = atan(bod(ibod).Points(ii,3)/bod(ibod).Points(ii,1));
                         bod(ibod).theta(ii,3) = atan(bod(ibod).Points(ii,2)/bod(ibod).Points(ii,1));
                     else
                         bod(ibod).theta(ii,2) = atan(bod(ibod).Points(ii,3)/bod(ibod).Points(ii,1))+pi;
                         bod(ibod).theta(ii,3) = atan(bod(ibod).Points(ii,2)/bod(ibod).Points(ii,1))+pi;
                     end
                end

            end
            
            % Initialize figure
            h = figure;
            % Set filename for gif
            filename = 'WaveSurf.gif';

            for i=1:length(t)

                for ibod=1:length(obj.bodies)
                
                    
                    % Apply changes to each point based on angles
                    % x-axis
                    theta_new = bod(ibod).theta+bod(ibod).del_theta(i,:);

                    x_change = (bod(ibod).dist(:,2).*cos(theta_new(:,2))-bod(ibod).Points(:,1))+...
                        (bod(ibod).dist(:,3).*cos(theta_new(:,3))-bod(ibod).Points(:,1));
                    y_change = (bod(ibod).dist(:,1).*cos(theta_new(:,1))-bod(ibod).Points(:,2))+...
                        (bod(ibod).dist(:,3).*sin(theta_new(:,3))-bod(ibod).Points(:,2));
                    z_change = (bod(ibod).dist(:,1).*sin(theta_new(:,1))-bod(ibod).Points(:,3))+...
                        (bod(ibod).dist(:,2).*sin(theta_new(:,2))-bod(ibod).Points(:,3));

                    bod(ibod).pos_change = [x_change,y_change,z_change] + bod(ibod).del_pos(i,:);
                    % bod(ibod).Points = [bod(ibod).dist(:,2).*cos(theta_new(:,2))+bod(ibod).dist(:,3).*cos(theta_new(:,3)),bod(ibod).dist(:,1).*cos(theta_new(:,1))+bod(ibod).dist(:,3).*cos(theta_new(:,3)),bod(ibod).dist(:,1).*cos(theta_new(:,1))+bod(ibod).dist(:,2).*cos(theta_new(:,2))];

                    % Apply position changes to each point
                    bod(ibod).Points_new = bod(ibod).Points + bod(ibod).pos_change;
                    bod_final = triangulation(bod(ibod).Conns,bod(ibod).Points_new);
    
                    % Plot geometry
                    trisurf(bod_final,'FaceColor',[1 1 0],'EdgeColor','k','EdgeAlpha',.2)
                    hold on

                    
                    
                end
                
                % Create wave elevation grid
                Z = waveElevationGrid(waves, t(i), X, Y, t(i), it, g);
                surf(X,Y,Z, 'EdgeColor','none')
                caxis([-waves.A waves.A])
                colormap winter
                c = colorbar;
                ylabel(c, 'Wave Elevaion (m)')
                hold on

                %{
                depth = -waves.waterDepth*ones(length(X));
                surf(X,Y,depth,'FaceColor',[.4 .4 0])
                hold on
                %}

                % Time visual
                delete(findall(gcf,'type','annotation'));
                t_annot = ['time = ', num2str(t(i)), 's'];
                annotation('textbox',[.6 .625 .3 .3],'String',t_annot,'FitBoxToText','on');
                axis([-100 100 -100 100 -15 35])
                xlabel('x(m)')
                ylabel('y(m)')
                zlabel('z(m)')
                

                drawnow;
  %{
                video = VideoWriter('yourvideo.avi'); %create the video object
                open(video); %open the file for writing
                for ii=1:N %where N is the number of images
                I = imread('the ith image.jpg'); %read the next image
                writeVideo(video,I); %write the image to file
                end
                close(video); %close the file


          
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
%}
             %}
                hold off
                


            end
             
               %}
            
            %end
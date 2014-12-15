function plotResponse(output,bodyNum,comp)
%plots Response for each body.
%   'output' is a WEC-Sim output structure
%   bodyNum is the body number to plot
%   'comp' is the response direction to be plotted (1-6)
    t=output.bodies(bodyNum).time;
    pos=output.bodies(bodyNum).position(:,comp) - ...
        output.bodies(bodyNum).position(1,comp);
    vel=output.bodies(bodyNum).velocity(:,comp);
    acc=output.bodies(bodyNum).acceleration(:,comp);
    
    figure(bodyNum)
    plot(t,pos,'k-',...
        t,vel,'b-',...
        t,acc,'r-')
    legend('position','velocity','acceleration')
    xlabel('Time (s)')
    ylabel('Response')
    title([output.bodies(bodyNum).name ' Response'])
    
     clear t pos vel acc i
end

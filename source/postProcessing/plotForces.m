function plotForces(output,bodyNum,comp)
%plots force components for each body.
%   'output' is a WEC-Sim output structure
%   bodyNum is the body number to plot
%   'comp' is the force component to be plotted (1-6)

    t=output.bodies(bodyNum).time;
    FT=output.bodies(bodyNum).forceTotal(:,comp);
    FE=output.bodies(bodyNum).forceExcitation(:,comp);
    FRD=-1*output.bodies(bodyNum).forceRadiation(:,comp);
    FR=-1*output.bodies(bodyNum).forceRestoring(:,comp);
    FV=-1*output.bodies(bodyNum).forceViscous(:,comp);
    FM=-1*output.bodies(bodyNum).forceMooring(:,comp);

    figure('units','normalized','outerposition',[0 0 1 1]);
    plot(t,FT,'k-',...
        t,FE,'b-',...
        t,FRD,'r--',...
        t,FR,'g--',...
        t,FV,'m--',...
        t,FM,'c--')
    legend('forceTotal','forceExcitation','forceRadiation',...
        'forceRestoring','forceViscous','forceMooring')
    xlabel('Time (s)')
    ylabel('Forces (N)')
    title([output.bodies(bodyNum).name ' Forces'])

    clear t FT FE FRD FR FV FM i

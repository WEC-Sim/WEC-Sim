function FormatPlot(fig,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes)
% Creates a set of 1x3 subplots for the given input data. Adds formatting
% based on the given x and y axes labels, legend, title, subtitles and
% notes.
% 
% Parameters
% ----------
%     fig : [1 1] handle
%         Figure handle that the plots are created on
% 
%     titleString : [1 1] string
%         Overall title shown above all subplots
% 
%     subTitleStrings : [1 3] cell of strings
%         Subplot titles shown above each subplot
% 
%     xString : [1 3] cell of strings
%         X axis label shown on each subplot
% 
%     yString : [1 3] cell of strings
%         Y axis label shown on each subplot
% 
%     X : [1 1] struct
%         Struct of X data. Fields numbered sequentially. The number of
%         fields is the number of datasets being plotted. Each field must
%         correspond to one field of Y (e.g. X.X1 will be the x-axis for
%         all values in Y.Y1)
% 
%     Y : [1 1] struct
%         Struct of Y data. Fields numbered sequentially. The number of
%         fields is the number of datasets being plotted. Each field must
%         correspond to one field of Y and have a size of 3 in dimension 1
% 
%     legendStrings : [: :] cell of strings
%         Strings shown in the legend. The size of dimension 1 must be the
%         size of Y.Y1 dimension 2. The size of dimension 2 must be the
%         number of fields in Y
% 
%     notes : [1 :] cell of strings
%         Annotations shown below all subplots. Each column corresponds to
%         a new line of text

% Overall title for all subplots
sgtitle(titleString,'Interpreter','latex','FontWeight','bold','FontSize',12);

% Figures
[~,nBodies,~] = size(Y.Y1);
for iBody = 1:nBodies

    % Surge
    subplot('Position',[0.0731 0.3645 0.2521 0.4720])
    hold('on');
    box('on');
    numHydro = length(fieldnames(X));
    for ii = 1:numHydro           
        tmp1 = strcat('X',num2str(ii));
        tmp2 = strcat('Y',num2str(ii));
        plot(X.(tmp1),squeeze(Y.(tmp2)(1,iBody,:)),'LineWidth',1)  
    end
    if iBody == nBodies
        legend(reshape(legendStrings,[(numHydro)*nBodies,1]),'location','best','Box','off','Interpreter','none')
        title(subtitleStrings(1));
        xlabel(xString(1),'Interpreter','latex');
        ylabel(yString(1),'Interpreter','latex');    
    end
    
    % Heave
    subplot('Position',[0.3983 0.3645 0.2521 0.4720]);
    hold('on');
    box('on');
    numHydro = length(fieldnames(X));
    for ii = 1:numHydro           
        tmp1 = strcat('X',num2str(ii));
        tmp2 = strcat('Y',num2str(ii));
        plot(X.(tmp1),squeeze(Y.(tmp2)(2,iBody,:)),'LineWidth',1);  
    end
    if iBody == nBodies
        legend(reshape(legendStrings,[(numHydro)*nBodies,1]),'location','best','Box','off','Interpreter','none')
        title(subtitleStrings(2));
        xlabel(xString(2),'Interpreter','latex');
        ylabel(yString(2),'Interpreter','latex');
    end
    
    % pitch
    subplot('Position',[0.7235 0.3645 0.2521 0.4720]);
    hold('on');
    box('on');
    numHydro = length(fieldnames(X));
    for ii = 1:numHydro           
        tmp1 = strcat('X',num2str(ii));
        tmp2 = strcat('Y',num2str(ii));
        plot(X.(tmp1),squeeze(Y.(tmp2)(3,iBody,:)),'LineWidth',1);  
    end
    if iBody == nBodies
        legend(reshape(legendStrings,[(numHydro)*nBodies,1]),'location','best','Box','off','Interpreter','none')
        title(subtitleStrings(3));
        xlabel(xString(3),'Interpreter','latex');
        ylabel(yString(3),'Interpreter','latex');
    end
end

% Footer
annotation(fig,'textbox',[0.0 0.0 1.0 0.2628],...
    'String',notes,...
    'Interpreter','latex',...
    'FitBoxToText','off',...
    'EdgeColor','none');

end
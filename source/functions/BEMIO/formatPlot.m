function formatPlot(fig,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,options)
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

legendStrings1D = legendStrings(:);
legendStrings1D = legendStrings1D(~cellfun(@isempty, legendStrings1D));


% Figures
nHydro = length(fieldnames(X));
nBodiesTotal = 0;
for iHydro = 1:nHydro
    tmp1 = strcat('X',num2str(iHydro));
    tmp2 = strcat('Y',num2str(iHydro));
    [~,nBodies,~] = size(Y.(tmp2));
    nBodiesTotal = nBodiesTotal + nBodies;

    for iDofs = 1:length(options.dofs)
        
        % iterates through each degree of freedom
        subplot('Position',[.2/(length(options.dofs))+((.975/length(options.dofs))*(iDofs-1)) 0.3645 0.756/length(options.dofs) 0.4720])
        hold('on');
        box('on');
        for iBody = 1:nBodies
            plot(X.(tmp1),squeeze(Y.(tmp2)(iDofs,iBody,:)),'LineWidth',1)  
        end
        if iHydro == nHydro
            legend(legendStrings1D,'location','best','Box','off','Interpreter','none')
            title(subtitleStrings(options.dofs(iDofs)));
            xlabel(xString,'Interpreter','latex');
            ylabel(yString(iDofs),'Interpreter','latex');    
        end

    end
end

% Footer
annotation(fig,'textbox',[0.0 0.0 1.0 0.2628],...
    'String',notes,...
    'Interpreter','latex',...
    'FitBoxToText','off',...
    'EdgeColor','none');

end
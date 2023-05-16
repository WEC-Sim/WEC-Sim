function formatPlot(fig,titleString,subtitleStrings,xString,yString,X,Y,legendStrings,notes,plotDofs)
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
%     subTitleStrings : [1 ndof] cell of strings
%         Subplot titles shown above each subplot
% 
%     xString : [1 1] cell of strings
%         X axis label shown on each subplot
% 
%     yString : [1 ndof] cell of strings
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
legendStrings1D = strrep(legendStrings1D,'_','\_');

% Figures
nHydro = length(fieldnames(X));
nBodiesTotal = 0;
for iHydro = 1:nHydro
    tmp1 = strcat('X',num2str(iHydro));
    tmp2 = strcat('Y',num2str(iHydro));
    if isstruct(Y.(tmp2))
        [~,nBodies,~] = size(Y.(tmp2).d1);
        nDirections = length(fieldnames(Y.(tmp2)));
    else
        [~,nBodies,~] = size(Y.(tmp2));
        nDirections = 0;
    end
    nBodiesTotal = nBodiesTotal + nBodies;

    for iDofs = 1:size(plotDofs,1)
        
        % iterates through each degree of freedom
        subplot('Position',[.2/(size(plotDofs,1))+((.975/size(plotDofs,1))*(iDofs-1)) 0.3645 0.756/size(plotDofs,1) 0.4720])
        hold('on');
        box('on');
        for iBody = 1:nBodies
            if nDirections>0
                for iDir = 1:nDirections
                    tmp3 = strcat('d',num2str(iDir));
                    plot(X.(tmp1),squeeze(Y.(tmp2).(tmp3)(iDofs,iBody,:)),'LineWidth',1)  
                end
            else
                plot(X.(tmp1),squeeze(Y.(tmp2)(iDofs,iBody,:)),'LineWidth',1)
            end
        end
        hold off
        if iHydro == nHydro
            legend(legendStrings1D,'location','best','Box','off','Interpreter','tex');
            title(subtitleStrings(iDofs));
            xlabel(xString,'Interpreter','latex');
            ylabel(yString(iDofs),'Interpreter','latex');    
        end

    end

end

% Footer
annotation(fig,'textbox',[0.0 0.2 1.0 0.075],...
    'String',notes,...
    'Interpreter','latex',...
    'FitBoxToText','off',...
    'EdgeColor','none');

end
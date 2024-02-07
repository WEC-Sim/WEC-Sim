function dofNames = getDofNames(dofList)
% Outputs the dof names based on the list of dofs to be plotted. These
% names are used to define the BEM plot subtitles.
%
% This function is not called directly by the user; it is automatically
% implemented within the BEM plotting functions.
%
% Parameters
% ----------
%     doflist : [ndof 2] float matrix
%         List of dofs to be plotted
%
% Returns
% -------
%     dofNames : [ndof 1] cell of strings
%         List of dof names to be used as subtitles based on the list of
%         dofs to be plotted.
% 

dofNames = {}; % initialize empty cell.
dofDefault = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
for k=1:size(dofList,1)
    if dofList(k,1) == dofList(k,2) && dofList(k,1) < 7 % loop default names
        dofNames{k}= dofDefault{dofList(k,1)};
    elseif dofList(k,1) == dofList(k,2) % gbm diagonals
        dofNames{k} = ['gbm' num2str(dofList(k,1)-6)];
    else
        if dofList(k,1) > 6
            dofPre = ['gbm' num2str(dofList(k,1)-6)];
        else
            dofPre = dofDefault{dofList(k,1)};
        end

        if dofList(k,2) > 6
            dofSuff = ['gbm' num2str(dofList(k,2)-6)];
        else
            dofSuff = dofDefault{dofList(k,2)};
        end
        dofNames{k} = [dofPre '-' dofSuff];
    end
end

end

function dofNames = getDofNames(dofList)

dofNames = {}; % initialize empty cell.
dofDefault = {'Surge','Sway','Heave','Roll','Pitch','Yaw'};
for k=1:length(dofList);
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

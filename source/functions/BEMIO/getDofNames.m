function dofNames = getDofNames(dofList)

dofNames = {}; % initialize empty cell.
dofDefault = {'Surge','Sway','Heave','Roll','Pitch','Sway'}
for k=1:length(dofList);
    if dofList(k,1) == dofList(k,2) && dofList(k,1) < 7 % loop default names
        dofNames{k}= dofDefault{k};
    elseif dofList(k,1) == dofList(k,2) % gbm diagonals
        dofNames{k} = ['gbm' num2str(dofList(k,1)-6)];
    else
        if dofList(k,1) > 6
            dofPre = ['gbm' num2str(dofList(k,1)-6)];
        else
            dofPre = dofDefault{k};
        end

        if dofList(k,2) > 6
            dofSuff = ['gbm' num2str(dofList(k,2)-6)];
        else
            dofSuff = dofDefault{k};
        end
        dofNames{k} = [dofPre '-' dofSuff];
    end
end

end

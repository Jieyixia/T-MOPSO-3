function rep = SelectByGrid(rep)

    GridIndex = [rep.GridIndex];
    UniqueGridIndex = unique(GridIndex);
    UniqueGridIndexNum = numel(UniqueGridIndex);
    
    index = zeros(numel(UniqueGridIndex), 1);
    for i = 1 : UniqueGridIndexNum
            
        index(i) = randsample(find(GridIndex ==  UniqueGridIndex(i)), 1);
                
    end
    
    rep = rep(index);

end
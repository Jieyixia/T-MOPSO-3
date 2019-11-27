function d = GetChebychevDistance(cost, TargetRegion)

nObj = length(cost);

nTR = numel(TargetRegion);

d = zeros(nTR, 1);

for i = 1 : nTR
    
    is_within = 1;
    
    for j = 1 : nObj
        
        if cost(j) > TargetRegion(i).ub(j)
            is_within = 0;
            break
        end
        
        if cost(j) < TargetRegion(i).lb(j)
            is_within = 0;
            break
        end      
        
    end
    
    if is_within
        d(i) = 0;
    else
        d(i) = pdist2(cost', TargetRegion(i).lb, 'Chebychev');
    end
        
end

end
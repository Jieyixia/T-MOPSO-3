function TargetRegionFlag = GetTargetRegionFlag(cost, TargetRegion)

nObj = length(cost);

nTR = numel(TargetRegion);

TargetRegionFlag = ones(nTR, 1);

for i = 1 : nTR
    
    for j = 1 : nObj
        
        if cost(j) > TargetRegion(i).ub(j)
            
            TargetRegionFlag(i) = 0;
            
            break
            
        end
        
        if cost(j) < TargetRegion(i).lb(j)
            
            TargetRegionFlag(i) = 0;
            
            break
            
        end      
        
    end

end

end
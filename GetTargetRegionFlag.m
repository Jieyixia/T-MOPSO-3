function pop = GetTargetRegionFlag(pop, TargetRegion)

nPop = numel(pop);

nObj = length(pop(1).Cost);

nTR = numel(TargetRegion);

for i = 1 : nPop
    
    cost = pop(i).Cost;
    
    TargetRegionFlag = ones(nTR, 1);
    
    for j = 1 : nTR

        for k = 1 : nObj

            if cost(k) > TargetRegion(j).ub(k)

                TargetRegionFlag(j) = 0;

                break

            end

            if cost(k) < TargetRegion(j).lb(k)

                TargetRegionFlag(j) = 0;

                break

            end      

        end
    
    end
    
    pop(i).TargetRegionFlag = TargetRegionFlag;
    
end

end
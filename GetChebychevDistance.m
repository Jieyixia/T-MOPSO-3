function d = GetChebychevDistance(cost, TargetRegion)

nTR = numel(TargetRegion);

d = zeros(nTR, 1);

for i = 1 : nTR
    
        d(i) = pdist2(cost', TargetRegion(i).lb, 'Chebychev');
        
end

end
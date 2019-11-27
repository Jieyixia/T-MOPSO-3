function pop = DetermineChebychevRank(pop, epsilon)
    nPop = numel(pop);
    nTR = numel(pop(1).ChebychevDistance);
    MaxDch = floor(nPop/nTR);

    % Calculate Chebychev Rank
    CheDist = [pop.ChebychevDistance];
    
    CheRank = zeros(size(CheDist));
    
    for i = 1 : nTR
        CD = CheDist(i, :);
        [~, index] = sort(CD);
        
        cRank = -1;
        for j = 1 : nPop
            if CheRank(i, index(j)) >= MaxDch
                continue
            end

            if cRank == MaxDch
                CheRank(i, index(j)) = MaxDch + ceil(CD(index(j)));
                continue
            end
            
            cRank = cRank + 1;
            CheRank(i, index(j)) = cRank;
            
            
            MutualCD = pdist2(pop(index(j)).Cost', [pop.Cost]', 'Chebychev');
            MarkedIndex = find(MutualCD < epsilon);
            MarkedIndex(MarkedIndex == index(j)) = [];
            
            CheRank(i, MarkedIndex) = MaxDch + ceil(CD(MarkedIndex));

        end         
    end
    
%     CheRank = min(CheRank, [], 1);
    
    for i = 1: nPop
        pop(i).ChebychevRank = CheRank(:, i);
    end
end
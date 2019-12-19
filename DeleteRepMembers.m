function pop = DeleteRepMembers(pop, nRep)
    


    % Sort Based on Chebychev Rank
    [~, CRSO]=sort([pop.ChebychevRank]);
    pop=pop(CRSO);
    
    % Sort Based on Crowding Distance
    [~, CDSO]=sort([pop.CrowdingDistanceRank],'descend');
    pop=pop(CDSO);
    
    pop=pop(1:nRep);
    
end
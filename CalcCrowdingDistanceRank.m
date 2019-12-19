function pop = CalcCrowdingDistanceRank(pop, TargetRegion)
    
    % Calculate Crowding Distance
    pop = CalcCrowdingDistance(pop);
    
    % Assign Crowding Distance Rank
    pop = AssignCrowdingDistanceRank(pop, TargetRegion);
    
end

% function pop = AssignCrowdingDistanceRank(pop, TargetRegion)
% % Assign Crowding Distance Rank to Particles in the Repository
%         
%     nPop = numel(pop);
%     nTR = numel(TargetRegion);
%     TargetRegionFlag = [pop.TargetRegionFlag];
%     MaxDc = floor(nPop / nTR);
%     
%     for i = 1 : nTR
%         
%         tr_flag = TargetRegionFlag(i, :);
%         
%         CrowdingDistance = [pop(tr_flag == 1).CrowdingDistance];
%         
%         [~, index] = sort(CrowdingDistance, 'descend');
%         
%         for j = 1 : min(MaxDc, nPop)
%             
%             pop(index(j)).CrowdingDistanceRank = MaxDc - j + 1;
%            
%         end
%         
%         for j = min(MaxDc, nPop) + 1 : nPop
%             
%             pop(index(j)).CrowdingDistanceRank = pop(index(j)).CrowdingDistance / maxDc;
%             
%         end
%         
%     end
% 
% end


function pop = AssignCrowdingDistanceRank(pop, TargetRegion)
% Assign Crowding Distance Rank to Particles in the Repository
        

    nPop = numel(pop);
    
    nTR = numel(TargetRegion);
    
    MaxDc = floor(nPop / nTR);
    
    TargetRegionFlag = [pop.TargetRegionFlag];
    
    CrowdingDistance = [pop.CrowdingDistance];
    
    MaxCDx = max(CrowdingDistance);
        
    if MaxCDx == 0  % Crowding Distance for Every Particle Is 0

        for i = 1 : nPop
            
            pop(i).CrowdingDistanceRank = 0;
            
        end
        
        return

    end
    
    CrowdingDistanceRank = zeros(nPop, nTR);
    
    [~, index] = sort(CrowdingDistance, 'descend');
    
    for k = 1 : nTR
                
        tr_flag = TargetRegionFlag(k, :);
        
        tr_flag = tr_flag(index);
        
        count = 0;
        
        for i = 1 : nPop
            
            if count >= min(MaxDc, sum(tr_flag)) || tr_flag(i) == 0
                
                CrowdingDistanceRank(index(i), k) = 0;
            
            else
           
                CrowdingDistanceRank(index(i), k) = MaxDc - count;
                
                count = count + 1;
                
            end
           
        end
        
    end
    
%     CrowdingDistanceRank = max(CrowdingDistanceRank, [], 2);
    
    for i = 1 : nPop
        
        pop(i).CrowdingDistanceRank = CrowdingDistanceRank(i, :);
        
    end
    

end
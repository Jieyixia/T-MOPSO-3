%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA121
% Project Title: Multi-Objective Particle Swarm Optimization (MOPSO)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function leader=SelectLeader(rep, beta, pop)

    
    
    
%     % Method 2: shortest distance from one target region 
%     ChebychevDistance = [rep.ChebychevDistance];
%     [~, sci] = min(ChebychevDistance, [], 2);
%     k = ceil(rand * numel(sci));
%     leader = rep(sci(k));

    %% Method 3: use chebychev rank
    CheRank = [rep.ChebychevRank];
    
    t = min(CheRank, [], 1);
    
    index = find(t == min(t));
    
    if numel(index) <= numel(pop.ChebychevDistance)
        k = ceil(rand * numel(index));
        leader = rep(index(k));
        return
    end
    
%     [~, k] = min(pop.ChebychevDistance); % 找到粒子与哪个目标区域距离最近
%     
%     
%     % 找到对应目标区域中Chebychev Rank=0的粒子  
%     for i = 1 : numel(index)
%         if CheRank(k, index(i)) == 0
%             leader = rep(index(i));
%             return
%         end
%     end
%     
    
%     %% Method 4: shortest distance from nearest target region
%     ChebychevDistance = [rep.ChebychevDistance];
%     [~, sci] = min(ChebychevDistance, [], 2);
%     [~, k] = min(pop.ChebychevDistance);  % 这样对不同目标区域的强调程度是不一样的
%     leader = rep(sci(k));
    
%     %% Method 1: choose leader from adaptive grid
%     % Grid Index of All Repository Members
%     GI=[rep.GridIndex];
%     
%     % Occupied Cells
%     OC=unique(GI);
%     
%     % Number of Particles in Occupied Cells
%     N=zeros(size(OC));
%     for k=1:numel(OC)
%         N(k)=numel(find(GI==OC(k)));
%     end
%     
%     % Selection Probabilities
%     P=exp(-beta*N);
%     P=P/sum(P);
%     
%     % Selected Cell Index
%     sci=RouletteWheelSelection(P);
%     
%     % Selected Cell
%     sc=OC(sci);
%     
%     % Selected Cell Members
%     SCM=find(GI==sc);
%     
%     % Selected Member Index
%     smi=randi([1 numel(SCM)]);
%     
%     % Selected Member
%     sm=SCM(smi);
%     
%     % Leader
%     leader=rep(sm);

end



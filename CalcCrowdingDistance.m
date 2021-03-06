%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA120
% Project Title: Non-dominated Sorting Genetic Algorithm II (NSGA-II)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostapha Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function pop=CalcCrowdingDistance(pop)
% Calculate Crowding Distance for Particles in the Repository

    Costs=[pop.Cost];

    nObj=size(Costs,1);

    n=numel(pop);

    d=zeros(n,nObj);

    for j=1:nObj

        [cj, so]=sort(Costs(j,:));

        d(so(1),j)=inf;
        
        r=abs(cj(1)-cj(end));
        
        if r==0
            
            r=1;
            
        end

        for i=2:n-1

            d(so(i),j)=abs(cj(i+1)-cj(i-1))/r;

        end

        d(so(end),j)=inf;

    end


    for i=1:n
        
        if sum(pop(i).TargetRegionFlag) == 0  % Particles not in the Target Region
            
            pop(i).CrowdingDistance=0;
            
            continue
            
        end

        pop(i).CrowdingDistance=sum(d(i,:));

    end
    

end


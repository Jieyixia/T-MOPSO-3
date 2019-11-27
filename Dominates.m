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

function b=Dominates(x,y)
%     if x.TargetDist < y.TargetDist
%         b = 1;
%         return 
%     end
%     
%     if x.TargetDist > y.TargetDist
%         b = 0;
%         return 
%     end
    
%     if isstruct(x)
%         x=x.Cost;
%     end
%     
%     if isstruct(y)
%         y=y.Cost;
%     end

    b=all(x.Cost<=y.Cost) && any(x.Cost<y.Cost);
    
%     if b
%         return
%     end
%     
%     if x.TargetDist < y.TargetDist
%         b = 1;
%     end
    

end
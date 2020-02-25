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

function b=ConstraintDominates(x,y)

    cv1 = sum(x.CV);
    cv2 = sum(y.CV);
    
    b = false;
    
    if cv1 == cv2
        b=all(x.Cost<=y.Cost) && any(x.Cost<y.Cost);
        return
    end
    
    if cv1 < cv2
        b = true;
        return
    end
            
end
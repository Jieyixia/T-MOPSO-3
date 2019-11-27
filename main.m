
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

MaxIter = 1;

load seed.mat

func = {'sch', 'fon', 'zdt1', 'zdt2', 'zdt3', 'zdt6', 'zdt4'};  % zdt4无法收敛，kur还没找到真实pareto解

%% Set Target Region
empty_region.lb = [];
empty_region.ub = [];
empty_region.center = [];

TargetRegion = repmat(empty_region, 1, 1);

TargetRegion(1).lb = [0, 0.8];
TargetRegion(1).ub = [0.2, 1];

TargetRegion(2).lb = [0.4, 0.2];
TargetRegion(2).ub = [1, 0.6];

TargetRegion(3).lb = [0.8, 0];
TargetRegion(3).ub = [1, 0.2];

for i = 1 : numel(TargetRegion)
    TargetRegion(i).center = (TargetRegion(i).lb + TargetRegion(i).ub) / 2;
end

for func_no = 3
    for i = 1 : MaxIter
        tic
        tmopso(seed(i), func{func_no}, TargetRegion, 0.003);
        toc
    end
    
end
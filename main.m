
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

MaxIter = 100;

load seed.mat

func = {'sch', 'fon', 'zdt1', 'zdt2', 'zdt3', 'zdt6', 'zdt4',...
         'dtlz1', 'dtlz2', 'dtlz3', 'dtlz4', 'dtlz5', 'dtlz6', 'dtlz7'};

%% Set Target Region
empty_region.lb = [];
empty_region.ub = [];
empty_region.center = [];
empty_region.delta = [];
empty_region.attemp_obj = [];
empty_region.attemp_count = [];
empty_region.change_step = [];
empty_region.history.lb = [];
empty_region.history.ub = [];
empty_region.history.tr_sol_lb = [];
empty_region.history.tr_sol_ub = [];

TargetRegion = repmat(empty_region, 1, 1);

TargetRegion(1).lb = [2, 2, 2];
TargetRegion(1).ub = [2.4, 2.4, 2.4]; 
% 
% TargetRegion(2).lb = [0.6, 0.7, 0];
% TargetRegion(2).ub = [1, 1.1, 0.4];

% TargetRegion(3).lb = [0.8, 0.4];
% TargetRegion(3).ub = [1, 0.6];

for i = 1 : numel(TargetRegion)
    TargetRegion(i).center = (TargetRegion(i).lb + TargetRegion(i).ub) / 2;
    TargetRegion(i).delta = TargetRegion(i).ub - TargetRegion(i).lb;
    TargetRegion(i).attemp_obj = 0;
    TargetRegion(i).attemp_count = 0;
    TargetRegion(i).change_step = 0.1 * ones(size(TargetRegion(i).lb));
    TargetRegion(i).history.lb = TargetRegion(i).lb;
    TargetRegion(i).history.ub = TargetRegion(i).ub;
end

iter = zeros(MaxIter, numel(func));
for func_no = 8 : 11
    for i = 1 : MaxIter
        tic
        iter(i, func_no) = tmopso(seed(i), func{func_no}, TargetRegion, 0.005, i);
        toc
    end
    
end

path = 'data/';
if ~exist(path, 'dir')
    mkdir(path)
end

filename = [path, 'first_time_arrive_PF.mat'];
save(filename, 'iter');



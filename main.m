
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

load true_pf.mat true_pf

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
empty_region.history.tr_sol.lb = [];
empty_region.history.tr_sol.ub = [];
empty_region.MinObj = [];
empty_region.no_sol_count = [];

TargetRegion = repmat(empty_region, 1, 1);

% TargetRegion(1).lb = [0, 0, 0];
% TargetRegion(1).ub = [0.4, 0.4, 0.4];
% TargetRegion(1).lb = [2, 2, 2];
% TargetRegion(1).ub = [2.3, 2.3, 2.3]; 
% TargetRegion(1).lb = [1, 2,];
% TargetRegion(1).ub = [1.4, 2.4]; 

iter = zeros(MaxIter, numel(func));

MaxIt = 1000;
for func_no = 5 : 11
    if func_no < 8
        TargetRegion(1).lb = [1, 0.2,];
        TargetRegion(1).ub = [1.2, 0.4]; 
        TargetRegion(1).MinObj = [0, 0];
%         TargetRegion(2).lb = [0.2, 0.8,];
%         TargetRegion(2).ub = [0.4, 1]; 
%         TargetRegion(2).MinObj = [0, 0];
        
        
        if func_no == 5
            TargetRegion(1).MinObj = [0, -0.7];
%             TargetRegion(2).MinObj = [0, -0.7];
        end
        
%         TargetRegion(1).lb = [1, 2,];
%         TargetRegion(1).ub = [1.2, 2.2];
    else
        TargetRegion(1).lb = [2, 2, 2];
        TargetRegion(1).ub = [2.3, 2.3, 2.3]; 
        TargetRegion(1).MinObj = [0, 0, 0];
        
%         TargetRegion(1).lb = [2, 2, 2];
%         TargetRegion(1).ub = [2.2, 2.2, 2.2];
    end
    
     
    
    for i = 1 : numel(TargetRegion)
        TargetRegion(i).delta = TargetRegion(i).ub - TargetRegion(i).lb;
        TargetRegion(i).attemp_obj = 0;
        TargetRegion(i).attemp_count = 0;
        TargetRegion(i).change_step = 0.1 * ones(size(TargetRegion(i).lb));
        TargetRegion(i).history.lb = TargetRegion(i).lb;
        TargetRegion(i).history.ub = TargetRegion(i).ub;
    end
    
    % Ëã·¨¿ªÊ¼--------------------------------------------------------------------------
    for i = 1 : MaxIter
        tic
        [rep_t_mopso, TR] = tmopso(seed(i), func{func_no}, TargetRegion, 0.005, i, MaxIt);
        toc
%         tic
%         [rep_mopso, ~] = mopso(seed(i), func{func_no}, MaxIt, i);
%         toc
      
        % draw
        h = figure(1);
        PlotPareto(rep_t_mopso, func{func_no}, true_pf{func_no}, TR);
        hold on
        PlotPareto_mopso(rep_mopso, func{func_no}, true_pf{func_no});
        
        % save plot
        path = ['figure/', func{func_no}];
        if ~exist(path,'dir')
            mkdir(path);
        end
        
        filename = [path, '/', func{func_no}, '-', num2str(i)];
        saveas(h, filename, 'png');
    end
    
end

% path = 'data/';
% if ~exist(path, 'dir')
%     mkdir(path)
% end
% 
% filename = [path, 'first_time_arrive_PF.mat'];
% save(filename, 'iter');



%% Stureture Definition
% Target Region Structure
empty_region.lb = [];
empty_region.ub = [];
empty_region.delta = [];

empty_region.update_flag = [];
empty_region.attemp_obj = [];
empty_region.attemp_count = [];
empty_region.step_size = [];
empty_region.min_obj = [];
empty_region.no_sol_count = [];

empty_region.history.lb = [];
empty_region.history.ub = [];
empty_region.history.tr_sol.lb = [];
empty_region.history.tr_sol.ub = [];
empty_region.history.sol.center = [];

TargetRegion = repmat(empty_region, 1, 1);

tr_saved = repmat(empty_region, 100, 10);

% T-MOPSO Indicators Structure
empty_t_mopso.hv = [];
empty_t_mopso.iter = [];
empty_t_mopso.gd = [];
empty_t_mopso.sp = [];
empty_t_mopso.delta = [];
empty_t_mopso.rep = [];

t_mopso_indicators = repmat(empty_t_mopso, 100, 10);

% MOPSO Indicators Structure
empty_mopso.iter = [];
empty_mopso.hv = [];
empty_mopso.gd = [];
empty_mopso.sp = [];
empty_mopso.delta = [];
empty_mopso.rep = [];
empty_mopso.t_rep = [];
empty_mopso.t_hv = [];
empty_mopso.t_gd = [];

mopso_indicators = repmat(empty_mopso, 100, 10);

%% 
load seed.mat
func = {'zdt1', 'zdt2', 'zdt3', 'zdt4', 'zdt6',...
         'dtlz1', 'dtlz2', 'dtlz3', 'dtlz4', 'dtlz7',...
         'osy', 'ctp1', 'ctp2', 'ctp3', 'ctp4', 'ctp5',...
         'ctp6', 'ctp7'};
     
RepeatNum = 10;
MaxIter = [200 * ones(1, 3), 1000, 200, 1000 * ones(1, 5)];
% MaxIter = ones(1, 10);


for func_no = 11
    
    func_name = func{func_no}; 
%     true_pf = GetTruePF(func_name);
    TargetRegion = InitTargetRegion(TargetRegion, func_name);
   
%     MaxIt = MaxIter(func_no);
    MaxIt = 100;
    
    % Algorithm Begins
    for i = 1 : 1
        tic
        [t_mopso_indicators(i, func_no), TR] = tmopso(seed(i), func{func_no}, TargetRegion, 0.005, i, MaxIt);
        toc
        tr_saved(i, func_no) = TR;
%         TR = TargetRegion;
        tic
        mopso_indicators(i, func_no) = mopso(seed(i), func{func_no}, MaxIt, i, TR);
        toc
%       
%         % draw
%         h = figure(2);
%         PlotPareto(t_mopso_indicators(i, func_no).rep, func_name, true_pf, 't_mopso');
%         PlotPareto(mopso_indicators(i, func_no).rep, func_name, true_pf, 'mopso');
%         PlotTargetRegion(TR);
%         % save plot
%         path = ['figure_20200110/', func_name];
%         if ~exist(path,'dir')
%             mkdir(path);
%         end
%         
%         filename = [path, '/', func_name, '-', num2str(i)];
%         saveas(h, filename, 'png');
    end
    
end
save('tr.mat', 'tr')

% save('data/data_3.mat', 'mopso_indicators', 't_mopso_indicators')



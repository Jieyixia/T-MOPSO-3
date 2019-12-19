function TargetRegion=UpdateTargetRegion(pop, TargetRegion)
% update the belief space using particles in the repository

    nTR = numel(TargetRegion);
    nObj = numel(TargetRegion(1).lb);
    
    % Find Particles Within Each Target Region
    TargetRegionFlag = [pop.TargetRegionFlag];
    
    for j = 1 : nTR
        DominatingSet = IsDominated(pop, TargetRegion(j));
%         DominatingSet = IsEpsilonDominated(pop, TargetRegion(j), 0.05);
        
        if ~isempty(DominatingSet)  % the target region is dominated
            
            ds_lb = min(DominatingSet, [], 2)';
            ds_ub = max(DominatingSet, [], 2)';
            ds_delta = ds_ub - ds_lb;
            
            if sum(ds_delta > TargetRegion(j).delta) == nObj
                TargetRegion(j).ub = ds_ub;
                TargetRegion(j).lb = ds_ub - TargetRegion(j).delta;
            else
                TargetRegion(j).lb = min(DominatingSet, [],  2)';
                TargetRegion(j).ub = TargetRegion(j).lb + TargetRegion(j).delta;
            end
                
    
            TargetRegion(j).attemp_obj = 0;  % set zero
            TargetRegion(j).attemp_count = 0;
            TargetRegion(j).change_step = 0.1 * ones(size(TargetRegion(j).lb));
            
            % update history information
            TargetRegion(j).history.lb = TargetRegion(j).lb;
            TargetRegion(j).history.ub = TargetRegion(j).ub;
            
            continue
            
        end
        
        index = TargetRegionFlag(j, :) == 1;  % 处于目标区域中的解
        
        if sum(index) == 0  % no particle in the target region
            
            % 判断是否处于探索状态
            if TargetRegion(j).attemp_obj == 0
                
                continue           
                
            end
            
            % 避免出现原先目标区域中有解，移动完之后目标区域中无解但是又无法回退的情况
            
            TargetRegion(j).no_sol_count = TargetRegion(j).no_sol_count + 1;
            
            if TargetRegion(j).no_sol_count > 20
                
                % 回退50%
                TargetRegion(j).lb = TargetRegion(j).lb + 0.5 * TargetRegion(j).delta;
                TargetRegion(j).ub = TargetRegion(j).lb + TargetRegion(j).delta;
                
                % 重新开始目标区域更新的探索
                TargetRegion(j).attemp_obj = 0;
                TargetRegion(j).attemp_count = 0;
            end
            
            continue
        
        end
       
        % 找到此时目标区域中粒子在各个目标维度上的上下界
        lower = min([pop(index).Cost], [], 2);
        upper = max([pop(index).Cost], [], 2);
        
        if TargetRegion(j).attemp_obj == 0  % 目标区域的任何一维还没有被单独更改
            TargetRegion(j).attemp_obj = 1;
            
            % 新增------------------------------------------------
            % 记录历史信息
            TargetRegion(j).history.lb = TargetRegion(j).lb;
            TargetRegion(j).history.ub = TargetRegion(j).ub;
            % 新增------------------------------------------------
            
            % 尝试修改目标区域的第一个维度
            TargetRegion(j).lb(1) = TargetRegion(j).lb(1) - TargetRegion(j).change_step(1) * TargetRegion(j).delta(1);
            TargetRegion(j).lb(1) = max(TargetRegion(j).lb(1), TargetRegion(j).MinObj(1));  % lower bound of each dimension
            TargetRegion(j).ub(1) = TargetRegion(j).lb(1) + TargetRegion(j).delta(1);
            
            % 记录修改目标区域前，目标区域内粒子的上下界，作为历史信息
            TargetRegion(j).history.tr_sol.lb = lower;  
            TargetRegion(j).history.tr_sol.ub = upper;
            TargetRegion(j).history.tr_sol.delta = upper - lower;
            
            TargetRegion(j).no_sol_count = 0;
            
            continue
            
        end
        
        if IsImproved(lower, upper, TargetRegion(j)) % 如果得到的解有所改善
            
            % 更新历史信息
            TargetRegion(j).history.lb = TargetRegion(j).lb;
            TargetRegion(j).history.ub = TargetRegion(j).ub;
            
            % 增加变化的幅度
            n = TargetRegion(j).attemp_obj;
            TargetRegion(j).change_step(n) = min(TargetRegion(j).change_step(n) * 2, 0.1);

            % 看下一维
            TargetRegion(j).attemp_obj = n + 1;
            if TargetRegion(j).attemp_obj > nObj
                TargetRegion(j).attemp_obj = 1;
            end
            TargetRegion(j).attemp_count = 0;

            n = TargetRegion(j).attemp_obj;
            TargetRegion(j).lb(n) = TargetRegion(j).lb(n) - TargetRegion(j).change_step(n) * TargetRegion(j).delta(n);
            TargetRegion(j).lb(n) = max(TargetRegion(j).lb(n), TargetRegion(j).MinObj(n));  % lower bound of each dimension
            TargetRegion(j).ub(n) = TargetRegion(j).lb(n) + TargetRegion(j).delta(n); 
            
            % 新增------------------------------------------------
            % 记录改变目标区域前的 目标区域中非支配解的 上下界
            TargetRegion(j).history.tr_sol.lb = lower;                                                                
            TargetRegion(j).history.tr_sol.ub = upper;
            TargetRegion(j).history.tr_sol.delta = upper - lower;
            TargetRegion(j).no_sol_count = 0;
            % 新增------------------------------------------------
 
        else  % 如果没有
            
            TargetRegion(j).attemp_count =  TargetRegion(j).attemp_count + 1;

            if TargetRegion(j).attemp_count > 10  
                
                % 利用历史信息回退
                TargetRegion(j).lb = TargetRegion(j).history.lb;
                TargetRegion(j).ub = TargetRegion(j).history.ub;
                
                % 新增---------------------------------------------
                % 减小这一维变化的幅度
                n = TargetRegion(j).attemp_obj;
                TargetRegion(j).change_step(n) = max(TargetRegion(j).change_step(n) / 2, 0.0125);
                % 新增---------------------------------------------
                
                % 看下一维
                TargetRegion(j).attemp_obj = TargetRegion(j).attemp_obj + 1;
                if TargetRegion(j).attemp_obj > nObj
                    TargetRegion(j).attemp_obj = 1;
                end
                TargetRegion(j).attemp_count = 0;
                
                n = TargetRegion(j).attemp_obj;
                
%                 % 以下代表停止对这一维的探索
%                 if TargetRegion(j).change_step(n) < 1e-3
%                     continue
%                 end
                
                % 始终要进行探索
                TargetRegion(j).lb(n) = TargetRegion(j).lb(n) - TargetRegion(j).change_step(n) * TargetRegion(j).delta(n);
                TargetRegion(j).lb(n) = max(TargetRegion(j).lb(n), TargetRegion(j).MinObj(n));  % lower bound of each dimension
                TargetRegion(j).ub(n) = TargetRegion(j).lb(n) + TargetRegion(j).delta(n);
                
                TargetRegion(j).change_step(n) = TargetRegion(j).change_step(n) / 2;
                
                % 新增------------------------------------------------
                % 记录改变目标区域前的 目标区域中非支配解的 上下界
                TargetRegion(j).history.tr_sol.lb = lower;                                                                
                TargetRegion(j).history.tr_sol.ub = upper;
                TargetRegion(j).history.tr_sol.delta = upper - lower;
                TargetRegion(j).no_sol_count = 0;
                % 新增------------------------------------------------
            end
        end   
        
%         % 不管目标区域中的解是否有改善，都记录目标区域中解的上下界
%         TargetRegion(j).history.tr_sol_lb = lower;                                                                
%         TargetRegion(j).history.tr_sol_ub = upper;
        
    end
 
end


function DominatingSet = IsDominated(pop, TargetRegion)
    
    nPop = numel(pop);
    DominatingSet = [];
    for i = 1 : nPop
        lower = TargetRegion.lb';
        if all(pop(i).Cost<=lower) && any(pop(i).Cost<lower)
            DominatingSet = [DominatingSet pop(i).Cost]; %#ok<AGROW>
        end
    end

end
% 
% function DominatingSet = IsEpsilonDominated(pop, TargetRegion, epsilon)
%     nPop = numel(pop);
%     DominatingSet = [];
%     for i = 1 : nPop
%         lower = TargetRegion.lb';
%         epsilon_cost = pop(i).Cost - epsilon * TargetRegion.delta'; 
%         if all(epsilon_cost <= lower) && any(epsilon_cost < lower)
%             DominatingSet = [DominatingSet epsilon_cost]; %#ok<AGROW>         
%         end
%     end
% end

function flag = IsImproved(lower, upper, TargetRegion)
% lower, upper为当前目标区域内粒子范围的上下界
    
%     flag = 0;
% 
%     % 如果在所有目标维度上的解都有改善
%     if all(lower < TargetRegion.history.tr_sol.lb)
%         flag = 1;
%     else
%         % 或者所有目标维度上解的范围没有减小超过10%
%         delta = upper - lower;
%         if delta > 0.9 * TargetRegion.history.tr_sol.delta
%             flag = 1;
%         end
%     end
    
   
    
    % 之前的 效果提升的判断标准
    n = TargetRegion.attemp_obj;
    if lower(n) < TargetRegion.history.tr_sol.lb(n)
        flag = 1;
    else
        flag = 0;
    end
end
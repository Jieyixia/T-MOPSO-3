function TargetRegion=UpdateTargetRegion_new(pop, TargetRegion, func_name)
% update the belief space using particles in the repository

    nTR = numel(TargetRegion);
    nObj = numel(TargetRegion(1).lb);
    
    % Particles Within Each Target Region
    TargetRegionFlag = [pop.TargetRegionFlag];
%     ChebychevRank = [pop.ChebychevRank];
    if contains(func_name, 'zdt')
        if isequal(func_name, 'zdt4')
            MaxCount = 50;         
        else
            MaxCount = 10;

        end
    else
        MaxCount = 50;
    end
    
    for j = 1 : nTR
        
%         disp(['update_flag = ', num2str(TargetRegion.update_flag)])
        
        % Domination Relationship in Priority
        DominatingSet = IsDominated(pop, TargetRegion(j));
        
        if ~isempty(DominatingSet) 
            
            % update history information
            TargetRegion(j).history.lb = TargetRegion(j).lb;
            TargetRegion(j).history.ub = TargetRegion(j).ub;
            
            % ���¹�����Ҫ��һ���޸�-------------------------------
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
            % ���¹�����Ҫ��һ���޸�------------------------------- 
            
            TargetRegion(j).update_flag = 0;
            
            % Set Zero
            TargetRegion(j).attemp_obj = 0;
            TargetRegion(j).attemp_count = 0;
            TargetRegion(j).no_sol_count = 0;
            
            continue
            
        end   
        
        index = TargetRegionFlag(j, :) == 1;  % Particles in j-th Target Region        
        
        if TargetRegion(j).update_flag == -1  % Do Nothing
            continue
%             if sum(index) == 0
%                 continue            
%             end
%             
%             TargetRegion(j).update_flag = 3;
        end
        
        
        
        if TargetRegion(j).update_flag == 0            
            if sum(index) == 0                             
                continue                
            end            
        end
        
        if TargetRegion(j).update_flag < 2 
            
             if sum(index) > 0  % Exist Paticles
                 
                 TargetRegion(j) = UpdateAllDimensions(TargetRegion(j));    
                 TargetRegion(j).update_flag = 1;
                 
             else  % No Particles
                 
                 count = TargetRegion(j).no_sol_count;
                 
                 if count == 0                     
                     TargetRegion(j).history.sol.center = mean([pop.Cost], 2)';                
                     TargetRegion(j).no_sol_count = 1;
                     TargetRegion(j).update_flag = 1;
                 else                     
                     [TargetRegion(j), flag] = PopImproved(TargetRegion(j), pop);                    
                     
                     if ~flag                         
                         count = count + 1;                      
                         if count <= MaxCount                          
                             TargetRegion(j).no_sol_count = count;                             
                         else                             
                             TargetRegion(j) = RollBack(TargetRegion(j));                             
                             TargetRegion(j).update_flag = 2;                             
                         end                                            
                     end                                       
                 end
                 % ������Ŀ��������û�����ӵ�����£�ÿ�ζ����¸���ʷ��Ϣ
%                  TargetRegion(j).history.sol.center = mean([pop.Cost], 2)';
             end
             
             continue
            
        end
        
        % Temination Criterion
        if sum(TargetRegion(j).step_size > 0.02) == 0 && TargetRegion(j).update_flag == 3 
                % ��Ҫ���ݾ���������ж��Ƿ���Ҫ����
                
                % Roll Back 50%
                TargetRegion(j).lb = TargetRegion(j).lb + 0.5 * TargetRegion(j).delta;
                TargetRegion(j).ub = TargetRegion(j).lb + TargetRegion(j).delta;
                
                % Stop Updating
                TargetRegion(j).update_flag = -1;

                continue
                
        end
            
        % update_flag >=2�����
        if sum(index) > 0

            if TargetRegion(j).attemp_obj == 0 || TargetRegion(j).update_flag == 3
                
                % Store History Information
                TargetRegion(j).history.lb = TargetRegion(j).lb;
                TargetRegion(j).history.ub = TargetRegion(j).ub;

                % Update Current Dimension
                TargetRegion(j).attemp_obj = 1;
                TargetRegion(j) = UpdateCurrentDimension(TargetRegion(j), pop(index));
                              
            else
                if IsImproved(TargetRegion(j), pop(index))
                    
                    % Store History Information
                    TargetRegion(j).history.lb = TargetRegion(j).lb;
                    TargetRegion(j).history.ub = TargetRegion(j).ub;
                    
                    % Increase Step Size
                    n = TargetRegion(j).attemp_obj;
                    TargetRegion(j) = IncreaseStepSize(TargetRegion(j), n); 
                    
                    % Update Next Dimension
                    n = n + 1;
                    if n > nObj
                        n = 1;
                    end
                    TargetRegion(j).attemp_obj = n;
                    TargetRegion(j) = UpdateCurrentDimension(TargetRegion(j), pop(index));
                    
                else
                    count = TargetRegion(j).attemp_count;
                    count = count + 1;
                    if count <= MaxCount
                        TargetRegion(j).attemp_count = count;
                    else
                        
                        % Roll Back
                        TargetRegion(j) = RollBack(TargetRegion(j));
                        
                        % Decrease Step Size
                        n = TargetRegion(j).attemp_obj;
                        TargetRegion(j) = DecreaseStepSize(TargetRegion(j), n);
                        
                        % Update Next Dimension
                        n = n + 1;
                        if n > nObj
                            n = 1;
                        end
                        TargetRegion(j).attemp_obj = n;
                        TargetRegion(j) = UpdateCurrentDimension(TargetRegion(j), pop(index));
                        
                    end                                 
                end                
            end
            
            TargetRegion(j).update_flag = 2;
            
        else
            
            if TargetRegion(j).attemp_obj == 0 || TargetRegion(j).update_flag == 2
                TargetRegion(j).history.sol.center = mean([pop.Cost], 2)';
                TargetRegion(j).attemp_obj = 1;
                TargetRegion(j) = UpdateCurrentDimension(TargetRegion(j), []);
                
            else
                [TargetRegion(j), flag] = PopImproved(TargetRegion(j), pop);
                if ~flag
                    count = TargetRegion(j).attemp_count;
                    count = count + 1;                      
                    if count <= MaxCount                            
                        TargetRegion(j).attemp_count = count;                             
                    else 
                        
                        % Decrease Step Size
                        n = TargetRegion(j).attemp_obj;
                        TargetRegion(j) = DecreaseStepSize(TargetRegion(j), n);
                        
                        % Roll Back
                        TargetRegion(j) = RollBack(TargetRegion(j));
                        
                        % Update Next Dimension
                        n = n + 1;
                        if n > nObj
                            n = 1;
                        end
                        TargetRegion(j).attemp_obj = n;
                        TargetRegion(j) = UpdateCurrentDimension(TargetRegion(j), pop(index));                                                       
                    end  
                end
            end  
            
%             TargetRegion(j).history.sol.center = mean([pop.Cost], 2)';
     
            TargetRegion(j).update_flag = 3;
        end
                 
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


function flag = IsImproved(TargetRegion, pop)

    flag = 1;
    
    return
       
%     n = TargetRegion.attemp_obj;
%     
%     lower = min([pop.Cost], [], 2);
%     
%     if lower(n) < TargetRegion.history.tr_sol.lb(n)
%         
%         flag = 1;
%         
%         disp('IsImproved')
%         
%     else
%         
%         flag = 0;
%         
%     end
    
end

function [TargetRegion, flag] = PopImproved(TargetRegion, pop)

    new_center = mean([pop.Cost], 2)';    
    old_center = TargetRegion.history.sol.center;
    
    t1 = (old_center - new_center) ./ old_center;
    
    if sum(t1) <= 0
        
        flag = 0;
        
        return
        
    end
            
    tr_ub = new_center;
    tr_lb = tr_ub - TargetRegion.delta;
    tr_lb = max(tr_lb, TargetRegion.min_obj);
    
%     t2 = (TargetRegion.lb - tr_lb) ./ TargetRegion.lb;
    t2 = TargetRegion.lb - tr_lb;
    
%     disp(['t1=[', num2str(t1(1)), ', ', num2str(t1(2)), '], ', 't2=[', num2str(t2(1)), ', ', num2str(t2(2)),']'])
    
    if sum(t2) <= 0
        
        flag = 0;
        
        return
        
    end
    
    flag = 1;

    TargetRegion.step_size(tr_lb == TargetRegion.min_obj) = 0.0125;
    TargetRegion.step_size(tr_lb > TargetRegion.min_obj) = 0.1;                         

    % Store History Information
    TargetRegion.history.sol.center = new_center;

    % Update Target Region
    TargetRegion.lb = tr_lb;
    TargetRegion.ub = tr_lb + TargetRegion.delta;
    TargetRegion.no_sol_count = 0;
     
%     disp(['PopImproved��sum(t1)=', num2str(sum(t1)), ' sum(t2)=', num2str(sum(t2))])
end

function TargetRegion = RollBack(TargetRegion)

    TargetRegion.lb = TargetRegion.history.lb;
    TargetRegion.ub = TargetRegion.history.ub;
    
    TargetRegion.attemp_count = 0;
    TargetRegion.no_sol_count = 0;
    
%     disp('RollBack')
    
end

function TargetRegion = UpdateAllDimensions(TargetRegion)

    % Store history information 
    TargetRegion.history.lb = TargetRegion.lb;
    TargetRegion.history.ub = TargetRegion.ub;

    % Update Target Region
    TargetRegion.lb = TargetRegion.lb - TargetRegion.step_size.* TargetRegion.delta;
    TargetRegion.lb = max(TargetRegion.lb, TargetRegion.min_obj);
    TargetRegion.ub = TargetRegion.lb + TargetRegion.delta;
    
    % Update Step Size
    index = TargetRegion.lb == TargetRegion.min_obj;
    TargetRegion.step_size(index) = 0.0125; 
    
    % Set Zero
    TargetRegion.attemp_obj = 0;
    TargetRegion.attemp_count = 0;
    TargetRegion.no_sol_count = 0;
    
%     disp('Update All Dimensions')
    
end

function TargetRegion = UpdateCurrentDimension(TargetRegion, pop)

    % Store history information 
    TargetRegion.history.lb = TargetRegion.lb;
    TargetRegion.history.ub = TargetRegion.ub;
    
    % Get Which Dimension
    n = TargetRegion.attemp_obj;
    
    % Set Zero
    TargetRegion.attemp_count = 0;
    TargetRegion.no_sol_count = 0;
    
    % Update n-th Dimension
    TargetRegion.lb(n) = TargetRegion.lb(n) - TargetRegion.step_size(n) * TargetRegion.delta(n);
    TargetRegion.lb(n) = max(TargetRegion.lb(n), TargetRegion.min_obj(n));  
    TargetRegion.ub(n) = TargetRegion.lb(n) + TargetRegion.delta(n);
    
    % Update Step Size
    if TargetRegion.lb(n) == TargetRegion.min_obj(n)
        TargetRegion.step_size(n) = 0.0125;
    end

    if isempty(pop)
        return
    end
    
    % Store History Infomation
    lower = min([pop.Cost], [], 2);
    upper = max([pop.Cost], [], 2);
    TargetRegion.history.tr_sol.lb = lower;                                                                
    TargetRegion.history.tr_sol.ub = upper;
    TargetRegion.history.tr_sol.delta = upper - lower;
    TargetRegion.no_sol_count = 0;
    
%     disp('Update Current Dimension')
    
end

function TargetRegion = DecreaseStepSize(TargetRegion, n)

    TargetRegion.step_size(n) = max(TargetRegion.step_size(n) / 2, 0.0125);
    
end

function TargetRegion = IncreaseStepSize(TargetRegion, n)

    TargetRegion.step_size(n) = min(TargetRegion.step_size(n) * 2, 0.1);
    
end
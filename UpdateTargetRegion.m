function TargetRegion=UpdateTargetRegion(pop, TargetRegion)
% update the belief space using particles in the repository

    nTR = numel(TargetRegion);
    nObj = numel(TargetRegion(1).lb);
    
    % Find Particles Within Each Target Region
    TargetRegionFlag = [pop.TargetRegionFlag];
    
    for j = 1 : nTR
        DominatingSet = IsDominated(pop, TargetRegion(j));
        
        if ~isempty(DominatingSet)  % the target region is dominated
            TargetRegion(j).lb = min(DominatingSet, [],  2)';
            TargetRegion(j).ub = TargetRegion(j).lb + TargetRegion(j).delta;
            TargetRegion(j).attemp_obj = 0;  % set zero
            TargetRegion(j).attemp_count = 0;
            TargetRegion(j).change_step = 0.1 * ones(size(TargetRegion(j).lb));
            
            % update history information
            TargetRegion(j).history.lb = TargetRegion(j).lb;
            TargetRegion(j).history.ub = TargetRegion(j).ub;
            
            continue
            
        end
        
        index = TargetRegionFlag(j, :) == 1;  % ����Ŀ�������еĽ�
        
        if sum(index) == 0  % no particle in the target region
            
            continue           
        
        end
       
        lower = min([pop(index).Cost], [], 2);
        upper = max([pop(index).Cost], [], 2);
        
        if TargetRegion(j).attemp_obj == 0  % no obj has been changed
            TargetRegion(j).attemp_obj = 1;
            TargetRegion(j).lb(1) = TargetRegion(j).lb(1) - TargetRegion(j).change_step(1) * TargetRegion(j).delta(1);
            TargetRegion(j).lb(1) = max(TargetRegion(j).lb(1), 0);  % lower bound of each dimension
            TargetRegion(j).ub(1) = TargetRegion(j).lb(1) + TargetRegion(j).delta(1);
            
            % ��¼���ε���Ϣ
            TargetRegion(j).history.tr_sol_lb = lower;  % Ӧ�������������һ��Ϣ��
            TargetRegion(j).history.tr_sol_ub = upper;
            
            continue
            
        end
        
        if IsImproved(lower, TargetRegion(j)) % ����õ��Ľ���������
            
            % ������ʷ��Ϣ
            TargetRegion(j).history.lb = TargetRegion(j).lb;
            TargetRegion(j).history.ub = TargetRegion(j).ub;
            
            % ���ӱ仯�ķ���
            n = TargetRegion(j).attemp_obj;
            TargetRegion(j).change_step(n) = min(TargetRegion(j).change_step(n) * 2, 0.1);

            % ����һά
            TargetRegion(j).attemp_obj = n + 1;
            if TargetRegion(j).attemp_obj > nObj
                TargetRegion(j).attemp_obj = 1;
            end
            TargetRegion(j).attemp_count = 0;

            n = TargetRegion(j).attemp_obj;
            TargetRegion(j).lb(n) = TargetRegion(j).lb(n) - TargetRegion(j).change_step(n) * TargetRegion(j).delta(n);
            TargetRegion(j).lb(n) = max(TargetRegion(j).lb(n), 0);  % lower bound of each dimension
            TargetRegion(j).ub(n) = TargetRegion(j).lb(n) + TargetRegion(j).delta(n);           
 
        else  % ���û��
            
            TargetRegion(j).attemp_count =  TargetRegion(j).attemp_count + 1;

            if TargetRegion(j).attemp_count > 10  
                
                % ������ʷ��Ϣ����
                TargetRegion(j).lb = TargetRegion(j).history.lb;
                TargetRegion(j).ub = TargetRegion(j).history.ub;
                
                % ����һά
                TargetRegion(j).attemp_obj = TargetRegion(j).attemp_obj + 1;
                if TargetRegion(j).attemp_obj > nObj
                    TargetRegion(j).attemp_obj = 1;
                end
                TargetRegion(j).attemp_count = 0;
                
                n = TargetRegion(j).attemp_obj;
                
                if TargetRegion(j).change_step(n) < 1e-3
                    continue
                end
                TargetRegion(j).lb(n) = TargetRegion(j).lb(n) - TargetRegion(j).change_step(n) * TargetRegion(j).delta(n);
                TargetRegion(j).lb(n) = max(TargetRegion(j).lb(n), 0);  % lower bound of each dimension
                TargetRegion(j).ub(n) = TargetRegion(j).lb(n) + TargetRegion(j).delta(n);
                
                TargetRegion(j).change_step(n) = TargetRegion(j).change_step(n) / 2;
            end
        end   
        
        % ����Ŀ�������еĽ��Ƿ��и��ƣ�����¼Ŀ�������н�����½�
        TargetRegion(j).history.tr_sol_lb = lower;                                                                
        TargetRegion(j).history.tr_sol_ub = upper;
        
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

function flag = IsImproved(lower, TargetRegion)
    n = TargetRegion.attemp_obj;
    if lower(n) < TargetRegion.history.tr_sol_lb(n)
        flag = 1;
    else
        flag = 0;
    end
end
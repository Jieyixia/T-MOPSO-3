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
        
        index = TargetRegionFlag(j, :) == 1;  % ����Ŀ�������еĽ�
        
        if sum(index) == 0  % no particle in the target region
            
            % �ж��Ƿ���̽��״̬
            if TargetRegion(j).attemp_obj == 0
                
                continue           
                
            end
            
            % �������ԭ��Ŀ���������н⣬�ƶ���֮��Ŀ���������޽⵫�����޷����˵����
            
            TargetRegion(j).no_sol_count = TargetRegion(j).no_sol_count + 1;
            
            if TargetRegion(j).no_sol_count > 20
                
                % ����50%
                TargetRegion(j).lb = TargetRegion(j).lb + 0.5 * TargetRegion(j).delta;
                TargetRegion(j).ub = TargetRegion(j).lb + TargetRegion(j).delta;
                
                % ���¿�ʼĿ��������µ�̽��
                TargetRegion(j).attemp_obj = 0;
                TargetRegion(j).attemp_count = 0;
            end
            
            continue
        
        end
       
        % �ҵ���ʱĿ�������������ڸ���Ŀ��ά���ϵ����½�
        lower = min([pop(index).Cost], [], 2);
        upper = max([pop(index).Cost], [], 2);
        
        if TargetRegion(j).attemp_obj == 0  % Ŀ��������κ�һά��û�б���������
            TargetRegion(j).attemp_obj = 1;
            
            % ����------------------------------------------------
            % ��¼��ʷ��Ϣ
            TargetRegion(j).history.lb = TargetRegion(j).lb;
            TargetRegion(j).history.ub = TargetRegion(j).ub;
            % ����------------------------------------------------
            
            % �����޸�Ŀ������ĵ�һ��ά��
            TargetRegion(j).lb(1) = TargetRegion(j).lb(1) - TargetRegion(j).change_step(1) * TargetRegion(j).delta(1);
            TargetRegion(j).lb(1) = max(TargetRegion(j).lb(1), TargetRegion(j).MinObj(1));  % lower bound of each dimension
            TargetRegion(j).ub(1) = TargetRegion(j).lb(1) + TargetRegion(j).delta(1);
            
            % ��¼�޸�Ŀ������ǰ��Ŀ�����������ӵ����½磬��Ϊ��ʷ��Ϣ
            TargetRegion(j).history.tr_sol.lb = lower;  
            TargetRegion(j).history.tr_sol.ub = upper;
            TargetRegion(j).history.tr_sol.delta = upper - lower;
            
            TargetRegion(j).no_sol_count = 0;
            
            continue
            
        end
        
        if IsImproved(lower, upper, TargetRegion(j)) % ����õ��Ľ���������
            
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
            TargetRegion(j).lb(n) = max(TargetRegion(j).lb(n), TargetRegion(j).MinObj(n));  % lower bound of each dimension
            TargetRegion(j).ub(n) = TargetRegion(j).lb(n) + TargetRegion(j).delta(n); 
            
            % ����------------------------------------------------
            % ��¼�ı�Ŀ������ǰ�� Ŀ�������з�֧���� ���½�
            TargetRegion(j).history.tr_sol.lb = lower;                                                                
            TargetRegion(j).history.tr_sol.ub = upper;
            TargetRegion(j).history.tr_sol.delta = upper - lower;
            TargetRegion(j).no_sol_count = 0;
            % ����------------------------------------------------
 
        else  % ���û��
            
            TargetRegion(j).attemp_count =  TargetRegion(j).attemp_count + 1;

            if TargetRegion(j).attemp_count > 10  
                
                % ������ʷ��Ϣ����
                TargetRegion(j).lb = TargetRegion(j).history.lb;
                TargetRegion(j).ub = TargetRegion(j).history.ub;
                
                % ����---------------------------------------------
                % ��С��һά�仯�ķ���
                n = TargetRegion(j).attemp_obj;
                TargetRegion(j).change_step(n) = max(TargetRegion(j).change_step(n) / 2, 0.0125);
                % ����---------------------------------------------
                
                % ����һά
                TargetRegion(j).attemp_obj = TargetRegion(j).attemp_obj + 1;
                if TargetRegion(j).attemp_obj > nObj
                    TargetRegion(j).attemp_obj = 1;
                end
                TargetRegion(j).attemp_count = 0;
                
                n = TargetRegion(j).attemp_obj;
                
%                 % ���´���ֹͣ����һά��̽��
%                 if TargetRegion(j).change_step(n) < 1e-3
%                     continue
%                 end
                
                % ʼ��Ҫ����̽��
                TargetRegion(j).lb(n) = TargetRegion(j).lb(n) - TargetRegion(j).change_step(n) * TargetRegion(j).delta(n);
                TargetRegion(j).lb(n) = max(TargetRegion(j).lb(n), TargetRegion(j).MinObj(n));  % lower bound of each dimension
                TargetRegion(j).ub(n) = TargetRegion(j).lb(n) + TargetRegion(j).delta(n);
                
                TargetRegion(j).change_step(n) = TargetRegion(j).change_step(n) / 2;
                
                % ����------------------------------------------------
                % ��¼�ı�Ŀ������ǰ�� Ŀ�������з�֧���� ���½�
                TargetRegion(j).history.tr_sol.lb = lower;                                                                
                TargetRegion(j).history.tr_sol.ub = upper;
                TargetRegion(j).history.tr_sol.delta = upper - lower;
                TargetRegion(j).no_sol_count = 0;
                % ����------------------------------------------------
            end
        end   
        
%         % ����Ŀ�������еĽ��Ƿ��и��ƣ�����¼Ŀ�������н�����½�
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
% lower, upperΪ��ǰĿ�����������ӷ�Χ�����½�
    
%     flag = 0;
% 
%     % ���������Ŀ��ά���ϵĽⶼ�и���
%     if all(lower < TargetRegion.history.tr_sol.lb)
%         flag = 1;
%     else
%         % ��������Ŀ��ά���Ͻ�ķ�Χû�м�С����10%
%         delta = upper - lower;
%         if delta > 0.9 * TargetRegion.history.tr_sol.delta
%             flag = 1;
%         end
%     end
    
   
    
    % ֮ǰ�� Ч���������жϱ�׼
    n = TargetRegion.attemp_obj;
    if lower(n) < TargetRegion.history.tr_sol.lb(n)
        flag = 1;
    else
        flag = 0;
    end
end
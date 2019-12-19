function PlotPareto(rep, func_name, true_pf, target_region)

    Cost = [rep.Cost];
    
    if size(Cost, 1) == 2
    
    plot(Cost(1, :), Cost(2, :), 'r*', 'MarkerSize', 8);
    
    hold on
    
    if strcmp(func_name, 'zdt3')
        
        if length(true_pf) == 100
            
            sec = [19 24 20 19 18];
            
        else
            
            sec = [96 121 102 93 88];
            
        end
        
        cur = 0;
        
        for i = 1 : 5
            
            plot(true_pf(1, cur + 1 : cur + sec(i)), true_pf(2, cur + 1 : cur + sec(i)), 'c')
            
            hold on
            
            cur = cur + sec(i);
            
        end
        
    else
        
        plot(true_pf(1, :), true_pf(2, :), 'c')
        
    end
    
    
    xlabel('1^{st} Objective');
    ylabel('2^{nd} Objective');
    
    else
        
        angle = [180 0 0] * pi / 180;
        
        quaternion = angle2quat(angle(1),angle(2),angle(3));
        
        rotated_pf = quatrotate(quaternion, true_pf);
        
        scatter3(rotated_pf(:, 1), rotated_pf(:, 2), rotated_pf(:, 3), 10, 'co', 'filled')
        
        hold on;
        
        rotated_cost = quatrotate(quaternion, Cost');
        
        scatter3(rotated_cost(:, 1), rotated_cost(:, 2), rotated_cost(:, 3), 'r*')
        
    end

    grid on;
    
    if size(Cost, 1) == 2
        for i = 1 : numel(target_region)
            lb = target_region(i).lb;
            ub = target_region(i).ub;
            plot([lb(1) ub(1) ub(1) lb(1) lb(1)], [lb(2) lb(2) ub(2) ub(2) lb(2)])
            hold on
        end
    else
        for i = 1 : numel(target_region)
            lb = target_region(i).lb;
            ub = target_region(i).ub;

            A = [lb(1), lb(2), lb(3)];
            B = [ub(1), lb(2), lb(3)];
            C = [ub(1), ub(2), lb(3)];
            D = [lb(1), ub(2), lb(3)];

            E = [lb(1), lb(2), ub(3)];
            F = [ub(1), lb(2), ub(3)];
            G = [ub(1), ub(2), ub(3)];
            H = [lb(1), ub(2), ub(3)];

            edges_bottom = [A; B; C; D; A];
            edges_top = [E; F; G; H; E];
            
            edges_bottom = quatrotate(quaternion, edges_bottom);
            edges_top = quatrotate(quaternion, edges_top);

            plot3(edges_bottom(:, 1), edges_bottom(:, 2), edges_bottom(:, 3), 'r'); 
            hold on

            plot3(edges_top(:, 1), edges_top(:, 2), edges_top(:, 3), 'r');  
            hold on

            AE = [A; E];      
            BF = [B; F];       
            CG = [C; G];        
            DH = [D; H];
            
            AE = quatrotate(quaternion, AE);
            BF = quatrotate(quaternion, BF);
            CG = quatrotate(quaternion, CG);
            DH = quatrotate(quaternion, DH);

            plot3(AE(:, 1), AE(:, 2), AE(:, 3), 'r')  
            hold on

            plot3(BF(:, 1), BF(:, 2), BF(:, 3), 'r') 
            hold on

            plot3(CG(:, 1), CG(:, 2), CG(:, 3), 'r')
            hold on

            plot3(DH(:, 1), DH(:, 2), DH(:, 3), 'r')

        end
    end
    hold off;
    
end
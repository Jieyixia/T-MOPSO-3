function PlotPareto(rep, func_name, true_pf)

    Cost = [rep.Cost];
    
    if size(Cost, 1) == 2
    
    plot(Cost(1, :), Cost(2, :), 'bo');
    
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
    
    end
    
    if size(Cost, 1) == 3
        
        angle = [180 0 0] * pi / 180;
        
        quaternion = angle2quat(angle(1),angle(2),angle(3));
        
        rotated_pf = quatrotate(quaternion, true_pf);
        
        scatter3(rotated_pf(:, 1), rotated_pf(:, 2), rotated_pf(:, 3) , 10, 'co', 'filled')
        
        hold on
        
        rotated_cost = quatrotate(quaternion, Cost');
        
        scatter3(rotated_cost(:, 1), rotated_cost(:, 2), rotated_cost(:, 3), 'bo')
        
    end

    grid on;
    
    hold off;
    
end
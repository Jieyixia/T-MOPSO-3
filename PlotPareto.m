function PlotPareto(rep, func_name, true_pf, a_option)

    Cost = [rep.Cost];  
    
    if isequal(a_option, 't_mopso')
        marker = 'bo';
    else
        marker = 'rp';     
    end
    
    if contains(func_name, 'zdt')
        marker_size = 6;
    else
        marker_size = 10;
    end
    
    if size(Cost, 1) == 2
    
    plot(Cost(1, :), Cost(2, :), marker, 'MarkerSize', marker_size)
    hold on
    
    if strcmp(func_name, 'zdt3')
        
        sec = [316, 594, 781, 898, 1000];
                       
        cur = 0;
        
        for i = 1 : 5
            
            plot(true_pf(cur + 1 : sec(i), 1), true_pf(cur + 1 : sec(i), 2), 'k')
            
            hold on
            
            cur = sec(i);
            
        end
        
    else
        
        plot(true_pf(:, 1), true_pf(:, 2), 'k')
        
    end
    
    
    xlabel('1^{st} Objective');
    ylabel('2^{nd} Objective');
    
    else
        
        angle = [180 0 0] * pi / 180;
        
        quaternion = angle2quat(angle(1),angle(2),angle(3));
        
        rotated_pf = quatrotate(quaternion, true_pf);
        
        color = 0.75 * ones(1, 3);
                
        scatter3(rotated_pf(:, 1), rotated_pf(:, 2), rotated_pf(:, 3), 3,...
            color, 'o', 'filled')
        
        hold on;
        
        rotated_cost = quatrotate(quaternion, Cost');
        
        scatter3(rotated_cost(:, 1), rotated_cost(:, 2), rotated_cost(:, 3), marker_size, marker)
        
    end

%     grid on;
    
end
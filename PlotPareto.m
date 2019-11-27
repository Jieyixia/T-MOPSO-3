function PlotPareto(rep, func_name, true_pf, target_region)

    Cost = [rep.Cost];
    
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
            
            plot(true_pf(1, cur + 1 : cur + sec(i)), true_pf(2, cur + 1 : cur + sec(i)))
            
            hold on
            
            cur = cur + sec(i);
            
        end
        
    else
        
        plot(true_pf(1, :), true_pf(2, :))
        
    end
    
    
    xlabel('1^{st} Objective');
    ylabel('2^{nd} Objective');

    grid on;
    
    for i = 1 : numel(target_region)
        lb = target_region(i).lb;
        ub = target_region(i).ub;
        plot([lb(1) ub(1) ub(1) lb(1) lb(1)], [lb(2) lb(2) ub(2) ub(2) lb(2)])
        hold on
    end
    hold off;
    
end
%
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

function PlotCosts(pop,rep, target_region)

    pop_costs=[pop.Cost];
    rep_costs=[rep.Cost];
    
    if size(pop_costs, 1) == 2
        plot(pop_costs(1,:), pop_costs(2,:), 'ko');
        hold on;
        plot(rep_costs(1,:), rep_costs(2,:), 'r*');
        
        for i = 1 : numel(target_region)
            lb = target_region(i).lb;
            ub = target_region(i).ub;
            plot([lb(1) ub(1) ub(1) lb(1) lb(1)], [lb(2) lb(2) ub(2) ub(2) lb(2)])
            hold on
        end
    
        xlabel('1^{st} Objective');
        ylabel('2^{nd} Objective');

        
    else
        angle = [180 0 0] * pi / 180;
        
        quaternion = angle2quat(angle(1),angle(2),angle(3));
        
        rotated_pop_cost = quatrotate(quaternion, pop_costs');
        
        scatter3(rotated_pop_cost(:, 1), rotated_pop_cost(:, 2), rotated_pop_cost(:, 3), 10, 'co', 'filled')
        
        hold on;
        
        rotated_rep_costs = quatrotate(quaternion, rep_costs');
        
        scatter3(rotated_rep_costs(:, 1), rotated_rep_costs(:, 2), rotated_rep_costs(:, 3), 'r*')
        
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
    
    grid on;
    hold off;

end
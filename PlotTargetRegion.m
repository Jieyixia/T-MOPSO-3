function PlotTargetRegion(TargetRegion)

    nObj = numel(TargetRegion.lb);
    
    if nObj == 2
        for i = 1 : numel(TargetRegion)
            lb = TargetRegion(i).lb;
            ub = TargetRegion(i).ub;
            plot([lb(1) ub(1) ub(1) lb(1) lb(1)], [lb(2) lb(2) ub(2) ub(2) lb(2)], 'm')
            hold on
        end
    else
        angle = [180 0 0] * pi / 180; 
        quaternion = angle2quat(angle(1),angle(2),angle(3));
        
        for i = 1 : numel(TargetRegion)
            lb = TargetRegion(i).lb;
            ub = TargetRegion(i).ub;

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

            plot3(edges_bottom(:, 1), edges_bottom(:, 2), edges_bottom(:, 3), 'm'); 
            hold on

            plot3(edges_top(:, 1), edges_top(:, 2), edges_top(:, 3), 'm');  
            hold on

            AE = [A; E];      
            BF = [B; F];       
            CG = [C; G];        
            DH = [D; H];
            
            AE = quatrotate(quaternion, AE);
            BF = quatrotate(quaternion, BF);
            CG = quatrotate(quaternion, CG);
            DH = quatrotate(quaternion, DH);

            plot3(AE(:, 1), AE(:, 2), AE(:, 3), 'm')  
            hold on

            plot3(BF(:, 1), BF(:, 2), BF(:, 3), 'm') 
            hold on

            plot3(CG(:, 1), CG(:, 2), CG(:, 3), 'm')
            hold on

            plot3(DH(:, 1), DH(:, 2), DH(:, 3), 'm')

        end
    end
    hold off;
end
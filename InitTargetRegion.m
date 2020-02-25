function TargetRegion = InitTargetRegion(TargetRegion, func_name)

    index = str2double(func_name(end));
    
    if contains(func_name, 'zdt')
        
        TargetRegion(1).lb = [0.5, 0.5];
        TargetRegion(1).ub = [0.7, 0.7];
        TargetRegion(1).min_obj = [0, 0];
             
        if index == 3
            TargetRegion(1).min_obj = [0, -0.7];
        end
        
        return
    else
    
        if contains(func_name, 'dtlz')

            TargetRegion(1).lb = [2, 2, 2];
            TargetRegion(1).ub = [2.2, 2.2, 2.2];

            if index == 1
                TargetRegion(1).lb = [2, 2, 2];
                TargetRegion(1).ub = [2.1, 2.1, 2.1];
            end

            if index == 7

                TargetRegion(1).lb = [2, 2, 15];
                TargetRegion(1).ub = [2.2, 2.2, 15.2];
            end

            TargetRegion(1).min_obj = [0, 0, 0];

        else
            TargetRegion(1).lb = [0.1, 5];
            TargetRegion(1).ub = [0.3, 5.2];
            TargetRegion(1).min_obj = [0, 0];
        end

    
    for i = 1 : numel(TargetRegion)
        TargetRegion(i).delta = TargetRegion(i).ub - TargetRegion(i).lb;
        
        TargetRegion(i).update_flag = 0;
        TargetRegion(i).attemp_obj = 0;
        TargetRegion(i).attemp_count = 0;
        TargetRegion(i).step_size = 0.1 * ones(size(TargetRegion(i).lb));
        
    end
end
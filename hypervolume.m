function hv = HyperVolume(pop, func_name)
    
    if isempty(pop)
        
        hv = 0;
        
        return
        
    end

    func_name = lower(func_name);
    
    if contains(func_name, 'dtlz')
        
        if contains(func_name, 'dtlz7')
            
            r = [2; 2; 7];
            
        else
            
            r = [2; 2; 2];
            
        end
        
    else
        
        r = [3; 3];
        
    end

    Cost = [pop.Cost]; 
    
    n = numel(pop);
    
    nObj = numel(pop(1).Cost);
    
    diff = r - Cost;
    
    hv = 1;
    
    for i = 1 : nObj
        
        hv = hv .* diff(i, :);
        
    end
    
    hv = sum(hv) / n;
    
end
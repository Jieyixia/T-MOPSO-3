function sp = spacing(pop)
    
    n = numel(pop);    
    pf = [pop.Cost];
    
    if n < 2
        sp = NaN;
        return
    end
    
    d = zeros(1, n);
    for i = 1 : n
        cur = pf(:, i);   
        temp = cur - pf;
        temp(:, i) = [];
        s = 0;
        for obj = 1 : numel(cur)
            s = s + abs(temp(obj, :));
        end
        d(i) = min(s);  
    end
    
    sp = std(d);
    
end
function sp = spacing(pf)

    [nObj, n] = size(pf);
    
    if n < 2
        sp = NaN;
        return
    end
    d = zeros(1, n);
    for i = 1 : n
        temp = pf(:, i) - pf;
        temp(:, i) = [];
        s = 0;
        for obj = 1 : nObj
            s = s + abs(temp(obj, :));
        end
        d(i) = min(s);
        
    end
    
    sp = std(d);
    
end
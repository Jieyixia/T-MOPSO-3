function hv = hypervolume(pf)
    r = [10; 10];
    [nObj, n] = size(pf);
%     r = max(pf, [], 2) + 1; 
    
    diff = r - pf;
    hv = 1;
    for i = 1 : nObj
        hv = hv .* diff(i, :);
    end
    hv = sum(hv) / n;
    
end
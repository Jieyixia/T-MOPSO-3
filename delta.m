function dm = delta(pop, true_pf)

    n = numel(pop);
    
    current_pf = [pop.Cost]';
    current_pf = sortrows(current_pf, 1);
    
    true_pf = sortrows(true_pf, 1);
    
    max_pf = [current_pf; true_pf(end, :)];
    min_pf = [true_pf(1, :); current_pf];
    
    diff = max_pf - min_pf;
    
    d = 0;

    for i = 1 : numel(pop(1).Cost)

        d = d +  diff(:, i).^2;

    end
    
    d = sqrt(d);
    df = d(1);
    dl = d(end);
    d = d(2 : end - 1);
    
    if isempty(d)
        dm = 1;
        return
    end
    d_bar = mean(d);
    
    dm = df + dl + sum(abs(d - d_bar));
    dm = dm / (df + dl + (n - 1) * d_bar);
    

end
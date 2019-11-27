function z = KUR(x)
    
    n = numel(x);
    
    z1 = 0;
    
    for i = 1 : n - 1
        
        z1 = z1 - 10 * exp(-0.2 * sqrt(x(i)^2 + x(i + 1)^2));
        
    end
    
    z2 = sum(abs(x) .^ 0.8 + 5 * sin(x .^ 3));
    
    z = [z1 z2]';
    
end
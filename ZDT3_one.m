function z = ZDT3_one(x)

    n = numel(x);
    
    g = 1 + 9 * sum(x(2 : end)) / (n - 1);
    
    z2 = g * (1 - sqrt(x(1) / g) - x(1) / g * sin(10 * pi * x(1)));
    
    z = -z2;
    
end
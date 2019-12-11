function flag = HasArrivedPF(repo, true_pf)
% To judge if any solution in the repo has arrived the PF

n = numel(repo);

flag = 0;

for i = 1 : n
    
    d = vecnorm(repo(i).Cost - true_pf);
    
    if min(d) < 1e-3
        
        flag = 1;
        
        break
        
    end
    
end

end
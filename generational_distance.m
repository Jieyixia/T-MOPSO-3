function gd = generational_distance(repo, true_pf) 

n = numel(repo);

d = zeros(1, n);

for i = 1 : n
    
    d(i) = min_d(repo(i).Cost, true_pf);

end

gd = sqrt(sum(d)) / n;

end

function dmin = min_d(p, true_pf)

diff = true_pf - p;

dmin = min(diff(1, :).^2 + diff(2, :).^2);

end
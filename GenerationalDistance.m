function gd = GenerationalDistance(repo, true_pf) 

n = numel(repo);

d = zeros(1, n);

true_pf = true_pf';


for i = 1 : n
    
    d(i) = min_d(repo(i).Cost, true_pf);

end

gd = sqrt(sum(d)) / n;

end

function dmin = min_d(p, true_pf)

diff = true_pf - p;

nObj = numel(p);

dmin = 0;

for i = 1 : nObj
    
    dmin = dmin + diff(i, :).^2;

end

dmin = min(dmin);

end
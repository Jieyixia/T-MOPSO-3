function inverted_gd = IGD(repo, true_pf)

n = length(true_pf);

d = zeros(1, n);

for i = 1 : n
    
    d(i) = min_d([repo.Cost], true_pf(:, i));

end

inverted_gd = sqrt(sum(d)) / n;

end


function dmin = min_d(p, true_pf)

diff = true_pf - p;

d = 0;

for i = 1 : numel(diff(:, 1))
    
    d = d +  diff(i, :).^2;
    
end

dmin = min(d);

end
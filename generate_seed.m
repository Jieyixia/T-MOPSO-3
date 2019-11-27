load seed.mat seed
test1 = zeros(100, 1);
for i = 1 : 100
    rng(seed(i))
    test1(i) = rand;
end
load('mopso_nGrid=50.mat')
result_nGrid50 = [mean(gd); mean(hv); mean(iter); mean(repo_size)];
load('mopso_nGrid=7.mat')
result_nGrid7 = [mean(gd); mean(hv); mean(iter); mean(repo_size)];


load('mopso_nGrid=50_bug.mat')
result_nGrid50_bug = [mean(gd); mean(hv); mean(iter); mean(repo_size)];
load('mopso_nGrid=7_bug.mat')
result_nGrid7_bug = [mean(gd); mean(hv); mean(iter); mean(repo_size)];

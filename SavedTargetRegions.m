
%% SCH
% Intersect with PF
TargetRegion(1).lb = [0, 2];
TargetRegion(1).ub = [1, 3];

TargetRegion(2).lb = [1, 0];
TargetRegion(2).ub = [2, 1];

TargetRegion(3).lb = [3, 0];
TargetRegion(3).ub = [4, 1];


%% FON



%% ZDT1
% 后两个目标区域其中一条边部分重叠
TargetRegion(1).lb = [0, 0.8];
TargetRegion(1).ub = [0.2, 1];

TargetRegion(2).lb = [0.4, 0.2];
TargetRegion(2).ub = [1, 0.6];

TargetRegion(3).lb = [0.8, 0];
TargetRegion(3).ub = [1, 0.2];
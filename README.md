# T-MOPSO-3
T-MOPSO for multiple target regions
现在的问题是，迭代几十次之后算法失去探索能力，解趋向于相同。
推测有可能是因为每次选择的leader是相同的。


20191211
1.修改了选择leader的方式，随机从某个chebychev rank=1的粒子中选一个，延迟了这一现象出现的时间
2.加入了自适应修改目标区域的机制

figure_MaxIter=1000/figure/
参数：c1=1;c2-2;mu=0.4;pop_size=50;repo_size=50;MaxIter=1000
终止条件：对于sch,fon,zdt1,2,3,6，终止条件是有一个粒子与真实帕雷托前沿上最近解的距离小于1e-3;对于zdt4,dtlz1,2,3,4，终止条件是有一个粒子与真实帕雷托前沿上最近解的距离小于1e-2。


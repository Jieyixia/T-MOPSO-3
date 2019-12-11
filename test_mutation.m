mu = 0.4;
MaxIt = 100;
it = 1 : MaxIt;
pm = (1 - (it - 1) / (MaxIt - 1)).^(1 / mu);
plot(it, pm)

hold on 
MaxIt = 500;
it = 1 : MaxIt;
pm = (1 - (it - 1) / (MaxIt - 1)).^(1 / mu);
plot(it, pm)

hold on
MaxIt = 1000;
it = 1 : MaxIt;
pm = (1 - (it - 1) / (MaxIt - 1)).^(1 / mu);
plot(it, pm)
legend('MaxIt=100 mu=0.4', 'MaxIt=500 mu=0.4', 'MaxIt=1000, mu=0.4')

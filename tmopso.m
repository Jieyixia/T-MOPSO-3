%
% Copyright (c) 2015, Yarpiz (www.yarpiz.com)
% All rights reserved. Please read the "license.txt" for license terms.
%
% Project Code: YPEA121
% Project Title: Multi-Objective Particle Swarm Optimization (MOPSO)
% Publisher: Yarpiz (www.yarpiz.com)
% 
% Developer: S. Mostaph6a Kalami Heris (Member of Yarpiz Team)
% 
% Contact Info: sm.kalami@gmail.com, info@yarpiz.com
%

function tmopso(seed, func_name, TargetRegion, epsilon)
%% Load True Pareto Front
load true_pf.mat true_pf

%% Problem Definition
switch func_name
    case 'sch'
        CostFunction = @(x)SCH(x);
        nVar = 1; 
        VarMax = 1000;
        VarMin = -1000;      
        true_pf = true_pf{1};
        
    case 'fon'
        CostFunction = @(x)FON(x);
        nVar = 3; 
        VarMax = ones(1,  nVar) * 4;
        VarMin = ones(1,  nVar) * (-4);
        true_pf = true_pf{2};
        
    case 'kur'
        CostFunction = @(x)KUR(x);
        nVar = 3;
        VarMax = ones(1,  nVar) * 5;
        VarMin = ones(1,  nVar) * (-5);
        
    case 'zdt1'
        CostFunction = @(x)ZDT1(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);      
        true_pf = true_pf{3};
        
    case 'zdt2'
        CostFunction = @(x)ZDT2(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);    
        true_pf = true_pf{4};
        
    case 'zdt3'
        CostFunction = @(x)ZDT3(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);     
        true_pf = true_pf{5};
        
    case 'zdt4'
        CostFunction = @(x)ZDT4(x);
        nVar = 10; 
        VarMax = [1 ones(1,  nVar - 1) * 5];
        VarMin = [0 ones(1,  nVar - 1) * (-5)];  
        true_pf = true_pf{7};
        
    case 'zdt6'
        CostFunction = @(x)ZDT6(x);
        nVar = 10; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);    
        true_pf = true_pf{6};
end

VarSize=[1 nVar];   % Size of Decision Variables Matrix


%% MOPSO Parameters
if isequal(func_name, 'zdt4')
    MaxIt = 1000;           % Maximum Number of Iterations
else
    MaxIt = 100;
end

% MaxIt=1000;           % Maximum Number of Iterations
nPop=50;            % Population Size
nRep=50;            % Repository Size

w=0.5;              % Inertia Weight
wdamp=0.99;         % Intertia Weight Damping Rate
c1=1;               % Personal Learning Coefficient
c2=2;               % Global Learning Coefficient

nGrid=50;            % Number of Grids per Dimension

alpha=0.1;          % Inflation Rate

beta=2;             % Leader Selection Pressure
gamma=2;            % Deletion Selection Pressure

mu=0.4;             % Mutation Rate

%% random seed
rng(seed, 'twister')

%% Initialization

empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.ChebychevDistance=[];
empty_particle.IsDominated=[];
empty_particle.GridIndex=[];
empty_particle.GridSubIndex=[];
empty_particle.ChebychevDistance=[];
empty_particle.ChebychevRank = [];

pop=repmat(empty_particle,nPop,1);
 

for i=1:nPop
    
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);  
    pop(i).Velocity=zeros(VarSize);   
    pop(i).Cost=CostFunction(pop(i).Position);
    pop(i).ChebychevDistance=GetChebychevDistance(pop(i).Cost, TargetRegion);
    
    % Update Personal Best
    
    pop(i).Best.Position=pop(i).Position;
    pop(i).Best.Cost=pop(i).Cost;
    pop(i).Best.ChebychevDistance=pop(i).ChebychevDistance;
    
    
end

% Determine Domination
pop=DetermineDomination(pop);

% Update Repository
rep=pop(~[pop.IsDominated]);

% Determine Chebychev Rank
rep=DetermineChebychevRank(rep, epsilon);

% Grid=CreateGrid(rep,nGrid,alpha);
% 
% for i=1:numel(rep)
%     rep(i)=FindGridIndex(rep(i),Grid);
% end


%% MOPSO Main Loop

tr_num = zeros(MaxIt, 1);
for it=1:MaxIt
    disp(['It-' num2str(it)])
    for i=1:nPop

        leader=SelectLeader(rep, beta, pop(i));
        
%         figure(3)
%         plot(leader.Cost(1), leader.Cost(2), 'o')
%         grid on;
%         for r = 1 : numel(TargetRegion)
%         lb = TargetRegion(r).lb;
%         ub = TargetRegion(r).ub;
%         plot([lb(1) ub(1) ub(1) lb(1) lb(1)], [lb(2) lb(2) ub(2) ub(2) lb(2)], 'b')
%         hold on
%         end
%         axis([0, 1, 0, 1])
        pop(i).Velocity = w*pop(i).Velocity ...
            +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
            +c2*rand(VarSize).*(leader.Position-pop(i).Position);
        
        pop(i).Position = pop(i).Position + pop(i).Velocity;
        
        % make the solution feasible
        pop(i).Position = max(pop(i).Position, VarMin);
        pop(i).Position = min(pop(i).Position, VarMax);
        
        pop(i).Cost = CostFunction(pop(i).Position);
        pop(i).ChebychevDistance = GetChebychevDistance(pop(i).Cost, TargetRegion);
        
        % Apply Mutation
        pm=(1-(it-1)/(MaxIt-1))^(1/mu);
        if rand<pm
            NewSol.Position=Mutate(pop(i).Position,pm,VarMin,VarMax);
            
            % make the solution feasible -----------------------
            NewSol.Position = max(NewSol.Position, VarMin);
            NewSol.Position = min(NewSol.Position, VarMax);
            % make the solution feasible -----------------------
            
            NewSol.Cost=CostFunction(NewSol.Position);
            NewSol.ChebychevDistance = GetChebychevDistance(NewSol.Cost, TargetRegion);
            if Dominates(NewSol,pop(i))
                pop(i).Position=NewSol.Position;
                pop(i).Cost=NewSol.Cost;
                pop(i).ChebychevDistance = NewSol.ChebychevDistance;

            elseif Dominates(pop(i),NewSol)
                % Do Nothing

            else
%                 if  pop(i).ChebychevDistance > NewSol.ChebychevDistance
%                     pop(i).Position=NewSol.Position;
%                     pop(i).Cost=NewSol.Cost;
%                     pop(i).ChebychevDistance = NewSol.ChebychevDistance;
%                 end
                if rand<0.5
                    pop(i).Position=NewSol.Position;
                    pop(i).Cost=NewSol.Cost;
                    pop(i).ChebychevDistance=NewSol.ChebychevDistance;
        
                end
            end
        end
        
        if Dominates(pop(i),pop(i).Best)
            pop(i).Best.Position=pop(i).Position;
            pop(i).Best.Cost=pop(i).Cost;
            pop(i).Best.ChebychevDistance = pop(i).ChebychevDistance;
            
        elseif Dominates(pop(i).Best,pop(i))
            % Do Nothing
            
        else
%             if  pop(i).Best.ChebychevDistance > pop(i).ChebychevDistance
%                 pop(i).Best.Position=pop(i).Position;
%                 pop(i).Best.Cost=pop(i).Cost;
%                 pop(i).Best.ChebychevDistance = pop(i).ChebychevDistance;
%             end
            if rand<0.5
                pop(i).Best.Position=pop(i).Position;
                pop(i).Best.Cost=pop(i).Cost;
                pop(i).Best.ChebychevDistance=pop(i).ChebychevDistance;
            end
        end
        
    end
    
    pop=DetermineDomination(pop); % 源代码中少了这一行，导致算法结果不对
    
    % Add Non-Dominated Particles to Repository
    rep=[rep
         pop(~[pop.IsDominated])]; %#ok
    
    % Determine Domination of New Resository Members
    rep=DetermineDomination(rep);
    
    % Keep only Non-Dminated Memebrs in the Repository
    rep=rep(~[rep.IsDominated]);
    
    % Determine Chebychev Rank
    rep=DetermineChebychevRank(rep, epsilon);
    
    
    
%     % Update Grid
%     Grid=CreateGrid(rep,nGrid,alpha);

%     % Update Grid Indices
%     for i=1:numel(rep)
%         rep(i)=FindGridIndex(rep(i),Grid);
%     end
    
    % Check if Repository is Full
    if numel(rep)>nRep
        
        Extra=numel(rep)-nRep;
        for e=1:Extra
            rep=DeleteOneRepMember(rep,gamma);
        end
        
    end
%     tr_num(it) = sum([rep.ChebychevDistance] == 0);
    
%     disp(['It-' num2str(it, '%04d') ' Num of Particles:' num2str(tr_num(it), '%04d') ' Proportion:' num2str(tr_num(it)/nPop, '%.4f')])
    % Plot Costs
    figure(1)
    PlotCosts(pop,rep, TargetRegion);
    
    figure(2)
    PlotPareto(rep, func_name, true_pf, TargetRegion);
    pause(0.001);
    
    % Damping Inertia Weight
    w=w*wdamp;
    

end
% figure;
% plot(1:MaxIt, tr_num/nRep)
% disp(['目标区域内最大粒子数: ' num2str(max(tr_num))])
end


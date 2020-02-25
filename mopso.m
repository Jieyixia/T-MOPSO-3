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

function mopso_indicators = mopso(seed, func_name, MaxIt, It_no, TargetRegion)
disp(['MOPSO:', func_name, '-', num2str(It_no)])

%% Load True Pareto Front
load('TruePF.mat', 'ZDT_PF', 'DTLZ_PF')
load('true_pf.mat', 'true_pf')

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
        
    case 'zdt1'
        CostFunction = @(x)ZDT1(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);      
        true_pf = ZDT_PF{1};
        
    case 'zdt2'
        CostFunction = @(x)ZDT2(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);    
        true_pf = ZDT_PF{2};
        
    case 'zdt3'
        CostFunction = @(x)ZDT3(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);     
        true_pf = ZDT_PF{3};
        
    case 'zdt4'
        CostFunction = @(x)ZDT4(x);
        nVar = 10; 
        VarMax = [1 ones(1,  nVar - 1) * 5];
        VarMin = [0 ones(1,  nVar - 1) * (-5)];  
        true_pf = ZDT_PF{4};
        
    case 'zdt6'
        CostFunction = @(x)ZDT6(x);
        nVar = 10; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);    
        true_pf = ZDT_PF{6};
        
    case 'dtlz1'
        CostFunction = @(x)dtlz1(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
        true_pf = DTLZ_PF{1};
        
    case 'dtlz2'
        CostFunction = @(x)dtlz2(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
        true_pf = DTLZ_PF{2};
        
    case 'dtlz3'
        CostFunction = @(x)dtlz3(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
        true_pf = DTLZ_PF{3};
        
    case 'dtlz4'
        CostFunction = @(x)dtlz4(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
        true_pf = DTLZ_PF{4};

    case 'dtlz5'
        CostFunction = @(x)dtlz5(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
        true_pf = DTLZ_PF{5};
        
    case 'dtlz6'
        CostFunction = @(x)dtlz6(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
        true_pf = DTLZ_PF{6};

    case 'dtlz7'
        CostFunction = @(x)dtlz7(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
        true_pf = DTLZ_PF{7};
        
    case 'osy'
        CostFunction = @(x)OSY(x);
        nVar = 6; 
        VarMax = [10, 10, 5, 6, 5, 10];
        VarMin = [0, 0, 1, 0, 1, 0];      
%         true_pf = true_pf{1};
        
    case 'ctp1'
        CostFunction = @(x)CTP1(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);
%         true_pf = true_pf{2};
        
    case 'ctp2'
        CostFunction = @(x)CTP2(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);
%         true_pf = true_pf{2};

    case 'ctp3'
        CostFunction = @(x)CTP3(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);
%         true_pf = true_pf{2};
    case 'ctp4'
        CostFunction = @(x)CTP4(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);
%         true_pf = true_pf{2};

    case 'ctp5'
        CostFunction = @(x)CTP5(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);
%         true_pf = true_pf{2};
        
    case 'ctp6'
        CostFunction = @(x)CTP6(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);
%         true_pf = true_pf{2};

    case 'ctp7'
        CostFunction = @(x)CTP7(x);
        nVar = 30; 
        VarMax = ones(1,  nVar);
        VarMin = zeros(1,  nVar);
%         true_pf = true_pf{2};
        
end

VarSize=[1 nVar];   % Size of Decision Variables Matrix


%% MOPSO Parameters

% MaxIt=1000;           % Maximum Number of Iterations
if contains(func_name, 'zdt')
    nPop=50;            % Population Size
    nRep=50;            % Repository Size
else
    nPop=100;
    nRep=100;
end

w=0.5;              % Inertia Weight
wdamp=0.99;         % Intertia Weight Damping Rate
c1=1;               % Personal Learning Coefficient
c2=2;               % Global Learning Coefficient

nGrid=50;            % Number of Grids per Dimension

alpha=0.1;          % Inflation Rate

beta=2;             % Leader Selection Pressure
gamma=2;            % Deletion Selection Pressure

mu=0.4;             % Mutation Rate

% random seed
rng(seed, 'twister')
%% Initialization

empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.CV=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.IsDominated=[];
empty_particle.GridIndex=[];
empty_particle.GridSubIndex=[];
empty_particle.TargetRegionFlag=[];

pop=repmat(empty_particle,nPop,1);

for i=1:nPop
    
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    pop(i).Velocity=zeros(VarSize);
    
    [pop(i).Cost, pop(i).CV]=CostFunction(pop(i).Position);
        
    % Update Personal Best
    pop(i).Best.Position=pop(i).Position;
    pop(i).Best.Cost=pop(i).Cost;
    pop(i).Best.CV=pop(i).CV;
    
end

% Determine Domination
pop=DetermineDomination(pop);

rep=pop(~[pop.IsDominated]);

Grid=CreateGrid(rep,nGrid,alpha);

for i=1:numel(rep)
    rep(i)=FindGridIndex(rep(i),Grid);
end


%% MOPSO Main Loop
for it=1:MaxIt
    disp(['It-', num2str(it)])
    for i=1:nPop

        leader=SelectLeader_mopso(rep,beta);
        
        pop(i).Velocity = w*pop(i).Velocity ...
            +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
            +c2*rand(VarSize).*(leader.Position-pop(i).Position);
        
        pop(i).Position = pop(i).Position + pop(i).Velocity;
        
        % make solution feasible
        pop(i).Position = max(pop(i).Position, VarMin);
        pop(i).Position = min(pop(i).Position, VarMax);
                
        [pop(i).Cost, pop(i).CV] = CostFunction(pop(i).Position);
        
        % Apply Mutation
        pm=(1-(it-1)/(MaxIt-1))^(1/mu);
        if rand<pm
            NewSol.Position=Mutate(pop(i).Position,pm,VarMin,VarMax);
            
            % make solution feasible
            NewSol.Position = max(NewSol.Position, VarMin);
            NewSol.Position = min(NewSol.Position, VarMax);
            
            [NewSol.Cost, NewSol.CV]=CostFunction(NewSol.Position);
            
            if ConstraintDominates(NewSol,pop(i))
                pop(i).Position=NewSol.Position;
                pop(i).Cost=NewSol.Cost;
                pop(i).CV=NewSol.CV;

            elseif ConstraintDominates(pop(i),NewSol)
                % Do Nothing

            else
                if rand<0.5
                    pop(i).Position=NewSol.Position;
                    pop(i).Cost=NewSol.Cost;
                    pop(i).CV=NewSol.CV;
                end
            end
        end
        
        if ConstraintDominates(pop(i),pop(i).Best)
            pop(i).Best.Position=pop(i).Position;
            pop(i).Best.Cost=pop(i).Cost;
            pop(i).Best.CV=pop(i).CV;
            
        elseif ConstraintDominates(pop(i).Best,pop(i))
            % Do Nothing
            
        else
            if rand<0.5
                pop(i).Best.Position=pop(i).Position;
                pop(i).Best.Cost=pop(i).Cost;
                pop(i).Best.CV=pop(i).CV;
            end
        end
        
    end
    
%     % 每隔20代进行一次反向学习
%     if mod(it, 5) == 0
%         
%         for i = 1 : nPop
%             OblSol.Position = obl(pop(i).Position, VarMin, VarMax);
%             OblSol.Cost = CostFunction(OblSol.Position);
%             if Dominates(OblSol,pop(i))
%                 pop(i).Position=OblSol.Position;
%                 pop(i).Cost=OblSol.Cost;
%             end
%             if Dominates(pop(i),pop(i).Best)
%                 pop(i).Best.Position=pop(i).Position;
%                 pop(i).Best.Cost=pop(i).Cost;
%             end
%         end
%     end
    
    % update pop---------------------------------------------
    pop=DetermineDomination(pop); % 这是自己加的，这一行原代码中没有
    % update pop---------------------------------------------
    
    % Add Non-Dominated Particles to REPOSITORY
    rep=[rep
         pop(~[pop.IsDominated])]; %#ok
    
    % Determine Domination of New Resository Members
    rep=DetermineDomination(rep);
    
    % Keep only Non-Dminated Memebrs in the Repository
    rep=rep(~[rep.IsDominated]);
    
    % Update Grid
    Grid=CreateGrid(rep,nGrid,alpha);

    % Update Grid Indices
    for i=1:numel(rep)
        rep(i)=FindGridIndex(rep(i),Grid);
    end
    
    % Check if Repository is Full
    if numel(rep)>nRep
        
        Extra=numel(rep)-nRep;
        for e=1:Extra
            rep=DeleteOneRepMemebr(rep,gamma);
        end
        
    end
   
    % plot
    figure(1)
    PlotConstraints(rep);
    pause(0.1)
%     % Plot Costs
%     figure(1);
%     PlotCosts_mopso(pop,rep);
%     PlotPareto_mopso(rep, func_name, true_pf);

%     figure(1)
%     PlotPareto(rep, func_name, true_pf, 'mopso');
%     PlotTargetRegion(TargetRegion);
    
    % Damping Inertia Weight
    w=w*wdamp;
    
end

% Calculate Indicators
hv = HyperVolume(rep, func_name);
gd = GenerationalDistance(rep, true_pf);
sp = spacing(rep);
d = delta(rep, true_pf);
rep = GetTargetRegionFlag(rep, TargetRegion);
t_rep = rep([rep.TargetRegionFlag] == 1);
t_hv = HyperVolume(t_rep, func_name);
t_gd = GenerationalDistance(t_rep, true_pf);

% Output
mopso_indicators.iter = it;
mopso_indicators.hv = hv;
mopso_indicators.gd = gd;
mopso_indicators.sp = sp;
mopso_indicators.delta = d;
mopso_indicators.rep = rep;
mopso_indicators.t_rep = t_rep;
mopso_indicators.t_hv = t_hv;
mopso_indicators.t_gd = t_gd;

% Display
disp(['it=', num2str(it), ' hv=', num2str(hv, '%.4f'),...
    ' gd=', num2str(gd, '%.4f'), ' sp=', num2str(sp, '%.4f'),...
    ' delta=', num2str(d, '%.4f'),...
    ])
disp(['t_hv=', num2str(t_hv, '%.4f'), ' t_gd=', num2str(t_gd, '%.4f'),...
    ' num=', num2str(numel(t_rep))])
end


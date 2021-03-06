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

function [t_mopso_indicators, TargetRegion] = tmopso(seed, func_name, TargetRegion, epsilon, It_no, MaxIt)
disp(['T-MOPSO:', func_name, '-', num2str(It_no)])
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
        VarMin = [10, 10, 1, 0, 1, 0];      
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
nTR=numel(TargetRegion);
terminate_flag=zeros(nTR, 1);

w=0.5;              % Inertia Weight
wdamp=0.99;         % Intertia Weight Damping Rate
c1=1;               % Personal Learning Coefficient
c2=2;               % Global Learning Coefficient

nGrid=20;            % Number of Grids per Dimension

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
empty_particle.CV=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.IsDominated=[];
empty_particle.GridIndex=[];
empty_particle.GridSubIndex=[];
empty_particle.ChebychevDistance=[];
empty_particle.ChebychevRank=[];
empty_particle.CrowdingDistance=[];
empty_particle.CrowdingDistanceRank=[];
empty_particle.TargetRegionFlag = [];  % show whch target region the particle is in

pop=repmat(empty_particle,nPop,1);
 

for i=1:nPop
    
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);  
    pop(i).Velocity=zeros(VarSize);   
    [pop(i).Cost,pop(i).CV]=CostFunction(pop(i).Position);
    
    % Update Personal Best   
    pop(i).Best.Position=pop(i).Position;
    pop(i).Best.Cost=pop(i).Cost;
    pop(i).Best.CV=pop(i).CV;
    
end

% relax constraints and make all solutions feasible
Epsilon = max([pop.CV], [], 2);

% Determine Domination
pop=DetermineDomination(pop);

% Update Repository
rep=pop(~[pop.IsDominated]);

% Get Target Region Flag of Particles in Repository
rep=GetTargetRegionFlag(rep, TargetRegion);

% Determine Chebychev Rank
rep=DetermineChebychevRank(rep, TargetRegion, epsilon);

% Calculalte Crowding Distance Rank
rep=CalcCrowdingDistanceRank(rep, TargetRegion);

% Grid=CreateGrid(rep,nGrid,alpha);
% 
% for i=1:numel(rep)
%     rep(i)=FindGridIndex(rep(i),Grid);
% end


%% MOPSO Main Loop
final_repo = [];
for it=1:MaxIt
    
%     disp(['It-' num2str(it)])
    
    for i=1:nPop

        leader=SelectLeader(rep, beta);  
       
        pop(i).Velocity = w*pop(i).Velocity ...
            +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
            +c2*rand(VarSize).*(leader.Position-pop(i).Position);
        
        pop(i).Position = pop(i).Position + pop(i).Velocity;
        
        % make the solution feasible
        pop(i).Position = max(pop(i).Position, VarMin);
        pop(i).Position = min(pop(i).Position, VarMax);
        
        [pop(i).Cost,pop(i).CV] = CostFunction(pop(i).Position);
        
        % Apply Mutation
        pm=(1-(it-1)/(MaxIt-1))^(1/mu);
        if rand<pm
            NewSol.Position=Mutate(pop(i).Position,pm,VarMin,VarMax);
            
            % make the solution feasible
            NewSol.Position = max(NewSol.Position, VarMin);
            NewSol.Position = min(NewSol.Position, VarMax);
                        
            [NewSol.Cost,NewSol.CV]=CostFunction(NewSol.Position);
            
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
        
        % compare with personal best
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
    
    pop=DetermineDomination(pop); % 源代码中少了这一行，导致算法结果不对
    
    % Add Non-Dominated Particles to Repository
    rep=[rep
         pop(~[pop.IsDominated])]; %#ok
    
    % Determine Domination of New Repository Members
    rep=DetermineDomination(rep);
    
    % Keep only Non-Dminated Members in the Repository
    rep=rep(~[rep.IsDominated]);
    
%     figure(1)
%     PlotPareto(rep, func_name, true_pf, 't_mopso');
%     PlotTargetRegion(TargetRegion);
    
    % Update Target Region Flag of Particles in the Repository
    rep=GetTargetRegionFlag(rep, TargetRegion);
    
    % Determine Chebychev Rank
    rep=DetermineChebychevRank(rep, TargetRegion, epsilon);
    
    % Calculalte Crowding Distance Rank
    rep=CalcCrowdingDistanceRank(rep, TargetRegion);
    
    % Update Target Region
    TargetRegion=UpdateTargetRegion_new(rep, TargetRegion, func_name);
    
%     % Maintain Diversity
%     for nt = 1 : nTR
%         
%         if TargetRegion(nt).update_flag == -1
%             terminate_flag(nt) = terminate_flag(nt) + 1;
%             final_repo = [final_repo; rep]; %#ok<*AGROW>
%             
%         else
%             terminate_flag(nt) = 0;
%         end
%               
%     end
%     
%     if all(terminate_flag == 30)
%         
%         % Update Grid
%         Grid=CreateGrid(final_repo,nGrid,alpha);
% 
%         % Update Grid Indices
%         for i=1:numel(final_repo)
%             final_repo(i)=FindGridIndex(final_repo(i),Grid);
%         end
%         
%         % 根据格子进行筛选
%         rep=SelectByGrid(final_repo);
%         
%         break
%         
%     end
    
    % Check if Repository is Full
    if numel(rep)>nRep % 根据更新后的target region筛选粒子？                
        rep = DeleteRepMembers(rep, nRep);     
    end
    
    % Damping Inertia Weight
    w=w*wdamp;
      
    for nt = 1 : nTR
        
        if TargetRegion(nt).update_flag == -1
            terminate_flag(nt) = terminate_flag(nt) + 1;
        else
            terminate_flag(nt) = 0;
        end
              
    end
    
%     if all(terminate_flag == 50)
%         
%         break
%         
%     end
    

    figure(1)
    PlotConstraints(rep);
    PlotTargetRegion(TargetRegion);
    pause(0.1)
end
hv = HyperVolume(rep, func_name);
gd = GenerationalDistance(rep, true_pf);
sp = spacing(rep);
d = delta(rep, true_pf);

% Output
t_mopso_indicators.iter = it;
t_mopso_indicators.hv = hv;
t_mopso_indicators.gd = gd;
t_mopso_indicators.rep = rep;
t_mopso_indicators.sp = sp;
t_mopso_indicators.delta = d;

disp(['it=', num2str(it), ' hv=', num2str(hv, '%.4f'),...
    ' gd=', num2str(gd, '%.4f'), ' sp=', num2str(sp, '%.4f'), ...
    ' delta=', num2str(d, '%.4f')])
% pf_t_mopso = [rep.Cost];
% hold on
end


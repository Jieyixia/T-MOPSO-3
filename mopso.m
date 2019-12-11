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

function [gd_save, inverted_gd_save, hv_save, sp_save, delta_save, repository] = mopso(seed, func_name)
%% Problem Definition
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
    MaxIt = 100;           % Maximum Number of Iterations
else
    MaxIt = 30;
end

% MaxIt=1000;           % Maximum Number of Iterations
nPop=40;            % Population Size
nRep=40;            % Repository Size

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
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.Best.TargetDist=[];
empty_particle.IsDominated=[];
empty_particle.GridIndex=[];
empty_particle.GridSubIndex=[];
empty_particle.TargetDist=[];

pop=repmat(empty_particle,nPop,1);

target_region.lb = [0.3 0.5];
target_region.ub = [0.6 1];

for i=1:nPop
    
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);  
    pop(i).Velocity=zeros(VarSize);   
    pop(i).Cost=CostFunction(pop(i).Position);
    pop(i).TargetDist = GetTargetDist(pop(i).Cost, target_region);
    
    % Update Personal Best
    
    pop(i).Best.Position=pop(i).Position;
    pop(i).Best.Cost=pop(i).Cost;
    pop(i).Best.TargetDist=pop(i).TargetDist;
    
    
end

% Determine Domination
pop=DetermineDomination(pop);

rep=pop(~[pop.IsDominated]);

Grid=CreateGrid(rep,nGrid,alpha);

for i=1:numel(rep)
    rep(i)=FindGridIndex(rep(i),Grid);
end


%% MOPSO Main Loop
gd_save = zeros(MaxIt, 1);
inverted_gd_save = zeros(MaxIt, 1);
hv_save = zeros(MaxIt, 1);
sp_save = zeros(MaxIt, 1);
delta_save = zeros(MaxIt, 1);

repository = cell(MaxIt, 1);

tr_num = zeros(MaxIt, 1);
for it=1:MaxIt

    for i=1:nPop

        leader=SelectLeader(rep, beta);
        
        pop(i).Velocity = w*pop(i).Velocity ...
            +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
            +c2*rand(VarSize).*(leader.Position-pop(i).Position);
        
        pop(i).Position = pop(i).Position + pop(i).Velocity;
        
        % test------------------------------------------------
        pop(i).Position = max(pop(i).Position, VarMin);
        pop(i).Position = min(pop(i).Position, VarMax);
        % test------------------------------------------------
        
        pop(i).Cost = CostFunction(pop(i).Position);
        pop(i).TargetDist = GetTargetDist(pop(i).Cost, target_region);
        % Apply Mutation
        pm=(1-(it-1)/(MaxIt-1))^(1/mu);
        if rand<pm
            NewSol.Position=Mutate(pop(i).Position,pm,VarMin,VarMax);
            % test---------------------------------------------
            NewSol.Position = max(NewSol.Position, VarMin);
            NewSol.Position = min(NewSol.Position, VarMax);
            % test---------------------------------------------
            NewSol.Cost=CostFunction(NewSol.Position);
            NewSol.TargetDist = GetTargetDist(NewSol.Cost, target_region);
            if Dominates(NewSol,pop(i))
                pop(i).Position=NewSol.Position;
                pop(i).Cost=NewSol.Cost;
                pop(i).TargetDist = NewSol.TargetDist;

            elseif Dominates(pop(i),NewSol)
                % Do Nothing

            else
                if  pop(i).TargetDist > NewSol.TargetDist
                    pop(i).Position=NewSol.Position;
                    pop(i).Cost=NewSol.Cost;
                    pop(i).TargetDist = NewSol.TargetDist;
                end
%                 if rand<0.5
%                     pop(i).Position=NewSol.Position;
%                     pop(i).Cost=NewSol.Cost;
%                 end
            end
        end
        
        if Dominates(pop(i),pop(i).Best)
            pop(i).Best.Position=pop(i).Position;
            pop(i).Best.Cost=pop(i).Cost;
            pop(i).Best.TargetDist = pop(i).TargetDist;
        elseif Dominates(pop(i).Best,pop(i))
            % Do Nothing
            
        else
            if  pop(i).Best.TargetDist > pop(i).TargetDist
                pop(i).Best.Position=pop(i).Position;
                pop(i).Best.Cost=pop(i).Cost;
                pop(i).Best.TargetDist = pop(i).TargetDist;
            end
%             if rand<0.5
%                 pop(i).Best.Position=pop(i).Position;
%                 pop(i).Best.Cost=pop(i).Cost;
%             end
        end
        
    end
    
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
    
%     % Update Grid
%     Grid=CreateGrid(rep,nGrid,alpha);
% 
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
    tr_num(it) = sum([rep.TargetDist] == 0);
%     % Plot Costs
    figure(1);
%     PlotCosts(pop,rep, target_region);
    PlotPareto(rep, func_name, true_pf, target_region);
    pause(0.001);
    
%     % Damping Inertia Weight
    w=w*wdamp;
    
    % Show Iteration Information
    hv = hypervolume([rep.Cost]);
    gd = generational_distance(rep, true_pf);
    inverted_gd = IGD(rep, true_pf);
    sp = spacing([rep.Cost]);
    d = delta(rep, true_pf);
    
    gd_save(it) = gd;
    inverted_gd_save(it) = inverted_gd;
    hv_save(it) = hv;
    sp_save(it) = sp;
    delta_save(it) = d;
    repository{it} = [rep.Cost];
    
    disp([func_name ' ' num2str(it) ': Rep Size=' num2str(numel(rep)) ', HV=' num2str(hv, '%.4f') ', GD=' num2str(gd, '%.4f'), ', SP=' num2str(sp, '%.4f')]);

    disp(['delta = ' num2str(d, '%.4f')])
%     if numel(gd_repo) < 10
%         gd_repo = [gd_repo gd];
%         continue
%     end
% 
%     if mean(gd_repo) < 1e-3 && std(gd_repo) < mean(gd_repo) * 0.05
%         break
%     end
%     
%     gd_repo(1) = [];
%     gd_repo = [gd_repo gd];
    
end
% figure
% PlotPareto(rep, func_name, true_pf);
end


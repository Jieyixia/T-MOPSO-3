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

function [rep, it] = mopso(seed, func_name, MaxIt, It_no)
disp(['MOPSO:It-' num2str(It_no)])
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
        
    case 'dtlz1'
        CostFunction = @(x)dtlz1(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
        true_pf = true_pf{8};
        
    case 'dtlz2'
        CostFunction = @(x)dtlz2(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
        true_pf = true_pf{9};
        
    case 'dtlz3'
        CostFunction = @(x)dtlz3(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
        true_pf = true_pf{10};
        
    case 'dtlz4'
        CostFunction = @(x)dtlz4(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
        true_pf = true_pf{11};

    case 'dtlz5'
        CostFunction = @(x)dtlz5(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
%         true_pf = true_pf{12};
        
    case 'dtlz6'
        CostFunction = @(x)dtlz6(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
%         true_pf = true_pf{13};

    case 'dtlz7'
        CostFunction = @(x)dtlz7(x, 3);
        nVar = 10;
        VarMax = ones(1, nVar);
        VarMin = zeros(1, nVar);
%         true_pf = true_pf{14};
        
end

VarSize=[1 nVar];   % Size of Decision Variables Matrix


%% MOPSO Parameters

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

% random seed
rng(seed, 'twister')
%% Initialization

empty_particle.Position=[];
empty_particle.Velocity=[];
empty_particle.Cost=[];
empty_particle.Best.Position=[];
empty_particle.Best.Cost=[];
empty_particle.IsDominated=[];
empty_particle.GridIndex=[];
empty_particle.GridSubIndex=[];

pop=repmat(empty_particle,nPop,1);

for i=1:nPop
    
    pop(i).Position=unifrnd(VarMin,VarMax,VarSize);
    
    pop(i).Velocity=zeros(VarSize);
    
    pop(i).Cost=CostFunction(pop(i).Position);
    
    
    % Update Personal Best
    pop(i).Best.Position=pop(i).Position;
    pop(i).Best.Cost=pop(i).Cost;
    
end

% Determine Domination
pop=DetermineDomination(pop);

rep=pop(~[pop.IsDominated]);

Grid=CreateGrid(rep,nGrid,alpha);

for i=1:numel(rep)
    rep(i)=FindGridIndex(rep(i),Grid);
end


%% MOPSO Main Loop
% gd_save = zeros(MaxIt, 1);
% inverted_gd_save = zeros(MaxIt, 1);
% hv_save = zeros(MaxIt, 1);
% sp_save = zeros(MaxIt, 1);
% delta_save = zeros(MaxIt, 1);
% 
% repository = cell(MaxIt, 1);
for it=1:MaxIt
%     disp(['It-', num2str(it)])
    for i=1:nPop

        leader=SelectLeader_mopso(rep,beta);
        
        pop(i).Velocity = w*pop(i).Velocity ...
            +c1*rand(VarSize).*(pop(i).Best.Position-pop(i).Position) ...
            +c2*rand(VarSize).*(leader.Position-pop(i).Position);
        
        pop(i).Position = pop(i).Position + pop(i).Velocity;
        
        % test------------------------------------------------
        pop(i).Position = max(pop(i).Position, VarMin);
        pop(i).Position = min(pop(i).Position, VarMax);
        % test------------------------------------------------
        
        pop(i).Cost = CostFunction(pop(i).Position);
        
        % Apply Mutation
        pm=(1-(it-1)/(MaxIt-1))^(1/mu);
        if rand<pm
            NewSol.Position=Mutate(pop(i).Position,pm,VarMin,VarMax);
            % test---------------------------------------------
            NewSol.Position = max(NewSol.Position, VarMin);
            NewSol.Position = min(NewSol.Position, VarMax);
            % test---------------------------------------------
            NewSol.Cost=CostFunction(NewSol.Position);
            if Dominates(NewSol,pop(i))
                pop(i).Position=NewSol.Position;
                pop(i).Cost=NewSol.Cost;

            elseif Dominates(pop(i),NewSol)
                % Do Nothing

            else
                if rand<0.5
                    pop(i).Position=NewSol.Position;
                    pop(i).Cost=NewSol.Cost;
                end
            end
        end
        
        if Dominates(pop(i),pop(i).Best)
            pop(i).Best.Position=pop(i).Position;
            pop(i).Best.Cost=pop(i).Cost;
            
        elseif Dominates(pop(i).Best,pop(i))
            % Do Nothing
            
        else
            if rand<0.5
                pop(i).Best.Position=pop(i).Position;
                pop(i).Best.Cost=pop(i).Cost;
            end
        end
        
    end
    
%     % ÿ��20������һ�η���ѧϰ
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
    pop=DetermineDomination(pop); % �����Լ��ӵģ���һ��ԭ������û��
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
    
    
    % If Exists Particles that Reach the PF
%     flag = HasArrivedPF(rep, true_pf);
%     
%     if flag     
%         % draw
%         h = figure(1);
%         PlotPareto_mopso(rep, func_name, true_pf);
% %         set(h,'visible','off');
%         
%         % save plot
%         path = ['figure/', func_name];
%         if ~exist(path,'dir')
%             mkdir(path);
%         end
%         
%         filename = [path, '/', func_name, '-', num2str(It_no)];
%         saveas(h, filename, 'png');
%         break
%     end
   
%     % Plot Costs
    figure(1);
    PlotCosts_mopso(pop,rep);
%     PlotPareto_mopso(rep, func_name, true_pf);
%     pause(0.001);
    
    % Damping Inertia Weight
    w=w*wdamp;
    

    
end
% gd = generational_distance(rep, true_pf);
pf_mopso = [rep.Cost];
end


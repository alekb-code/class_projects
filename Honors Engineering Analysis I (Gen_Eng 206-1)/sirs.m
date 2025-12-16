function [X,S,I,R,D] = sirs(G,x,dfinal,beta,gamma,delta,xi)
% SIRS - Simulate SIRS epidemic model of a contact network graph
% 
% function [X,S,I,R,D] = sirs(G,x,dfinal,beta,gamma,delta,xi)
%
% Inputs: 
%   G - graph of the contact network
%   x - column vector of initial states for each node
%   dfinal - number of days in the simulation
%   beta - infection rate
%   gamma - recovery rate - probability of going from infected to recovered
%   delta - death rate - probability of going from infected to deceased
%   xi - susceptibility rate - probability of going from recovered to susceptible
%
% Outputs:
%   X - N x dfinal matrix of state history (each person's state for every day)
%   S - vector of susceptible counts each day
%   I - vector of infected counts each day
%   R - vector of recovered counts each day
%   D - vector of deceased counts each day
%
% State values: 0=susceptible, 1=infected, 2=recovered, 3=deceased
% 
% Honors EA1
% Homework Program 6
%
% Name: Branovacki, Alek
% Date: 10/30/2025
% Large number of the comments are mostly for me to structure my code! 

arguments % arguments block
    G graph
    x (:,1) {mustBeInteger, mustBeInRange(x,0,3)} % size specification from assignment document
    dfinal (1,1) {mustBePositive, mustBeInteger} 
    beta (1,1) {mustBeNonnegative}
    gamma (1,1) {mustBeInRange(gamma,0,1)}
    delta (1,1) {mustBeInRange(delta,0,1)} % cannot use 1-gamma as stated in assignment document
    xi (1,1) {mustBeInRange(xi,0,1)}
end

N = numnodes(G); % get number of nodes
if length(x) ~= N % verify x has correct length
    error('Length of x must equal number of nodes in G');
end
X = zeros(N, dfinal, 'uint8'); % initialize the output matrix X, use uint8 for memory efficiency
X(:,1) = x; % copy x (initial states) into first column
A = adjacency(G); % use adjacency matrix for efficiency

figure; % plotting graph before simulation, from assignment document
p = plot(G,'Layout','force','NodeLabel',[], ...
    'MarkerSize',5,'NodeCData',x);
title(sprintf('Day %3u',1));

colormap([0 0 1; 1 0 0; 0 1 0; 0 0 0]); % color mapping - blue(susceptible), red(infected), green(recovered), black(deceased)
clim([0 3]);
clim('manual');

for d = 2:dfinal % simulation loop from day 2 until dfinal
    current = X(:,d-1); % get current state
    next = current; % initialize next state to be current state
    
    is_infected = (current == 1); % find infected nodes
    num_infected_neighbors = full(sum(A(:,is_infected), 2)); % count the number of infected neighbors for each node
    
    % going from susceptible to infected
    is_susceptible = (current == 0); % find susceptible nodes
    if any(is_susceptible) 
        n_i = num_infected_neighbors(is_susceptible); % count the number of infected neighbors for each susceptible node
        infection_prob = (beta * n_i) ./ (1 + abs(beta * n_i)); % calculate probability of infection using the sigmoid function defined in the assignment document
        
        becomes_infected = rand(sum(is_susceptible),1) < infection_prob; % randomly infect susceptible nodes
        susceptible_indices = find(is_susceptible); % find actual indices of each susceptible node
        next(susceptible_indices(becomes_infected)) = 1; % update state of nodes that went from susceptible to infected
    end
    
    % going from infected to recovered or deceased
    is_infected = (current == 1); % find infected nodes (not including ones that just got infected from the code above)
    if any(is_infected)
        rand_vals = rand(sum(is_infected),1); % generate a random number per infected node
        infected_indices = find(is_infected); % find actual indices of each infected person
        
        becomes_dead = rand_vals < delta; % use delta to determine which infected nodes die
        next(infected_indices(becomes_dead)) = 3; % update their state
        
        becomes_recovered = (~becomes_dead) & (rand_vals < gamma + delta); % use delta and gamma to determine which infected nodes recover
        next(infected_indices(becomes_recovered)) = 2; % update their state
    end
    
    % going from recovered to susceptible
    is_recovered = (current == 2); % find recovered nodes (not including those that just recovered from the code above)
    if any(is_recovered)
        becomes_susceptible = rand(sum(is_recovered),1) < xi; % randomly make recovered nodes susceptible again
        recovered_indices = find(is_recovered); % find actual indices of each recovered person
        next(recovered_indices(becomes_susceptible)) = 0; % update their state
    end
    
    X(:,d) = next; % record this day in the history matrix
    
    % if no one is infected
    if sum(next == 1) == 0
        alive = find(next ~= 3); % find all nodes that are alive
        if ~isempty(alive) % if there are living people 
            reinfect_idx = alive(randi(length(alive))); % randomly reinfect one person
            X(reinfect_idx, d) = 1; % update their state
        end
    end
    
    p.NodeCData = X(:,d); % update with new colors, from assignment document
    title(sprintf('Day %3u',d));
    drawnow;
end

% aggregate vector outputs
S = sum(X == 0, 1)'; 
I = sum(X == 1, 1)';
R = sum(X == 2, 1)';
D = sum(X == 3, 1)';

% plot vs. time
figure;
hold on;
plot(1:dfinal, S, 'b-', 'LineWidth', 2, 'DisplayName', 'susceptible');
plot(1:dfinal, I, 'r-', 'LineWidth', 2, 'DisplayName', 'infected');
plot(1:dfinal, R, 'g-', 'LineWidth', 2, 'DisplayName', 'recovered');
plot(1:dfinal, D, 'k-', 'LineWidth', 2, 'DisplayName', 'deceased');
hold off;

xlabel('day');
ylabel('number of nodes');
title('Aggregate states versus time for the SIRS model');
legend('Location', 'best');
grid on;

end

% Question 1: the geometric graph produces the smallest maximum daily infection
% rates.

% Question 2: the geometric graph and Watts-Strogatz graph produce larger
% long-term average daily susceptibility rates.
% Honors EA1
% Homework Program 1
%
% Name: Branovacki, Alek
% Date: 9/25/2025

% Step 1: User Inputs for number of nodes and damping factor
nodes_prompt = "Enter the desired number of nodes: ";
N = input(nodes_prompt);
damping_prompt = "Enter the desired damping factor: ";
d = input(damping_prompt);

% Step 2: N x N Matrix of 0 and 1s
A = randi([0, 1], N, N);

% Step 3: Create Digraph without selfloops
G = digraph(A, 'omitselfloops');
plot(G);

% Step 4: Calculate Edge Weights
sources = G.Edges.EndNodes(:,1); % gets the source nodes for each edge
w = 1 ./ outdegree(G,sources); % 1 over how many outgoing edges each source node has
G.Edges.Weight = w; % assigns the weights to each edge

% Step 5: Calculate the Hyperlink Matrix and r
H = adjacency(G, "weighted").'; % transposes the weighted adjacency matrix to get hyperlink matrix
I = eye(size(H));
one = ones(N,1);
r = (I-d*H)\((1-d)*one); % solves for the vector of ranks

% Step 6: 3D visualization 
plot(G,'NodeColor','r','MarkerSize',10*r, ...
'LineWidth',10*w,'Layout','force3');

% Step 7: Table
T = table((1:N)', r, indegree(G), outdegree(G), 'VariableNames', {'Node','Rank', 'In-degree', 'Out-degree'});
sorted_T = sortrows(T, 'Rank', 'descend'); % sorts the table by rank, from highest to lowest rank
disp(' ');
disp(sorted_T);

% Example Program Output:

 % Enter the desired number of nodes: 16
 % Enter the desired damping factor: .8

 % Node     Rank      In-degree    Out-degree
 %    ____    _______    _________    __________
 % 
 %     16      1.3237        9             9    
 %     12      1.2998       10            10    
 %     10      1.2753       10             8    
 %      6      1.2687       10             8    
 %      4      1.1736        9             5    
 %      8      1.1652       10             8    
 %     13      1.0515        9             5    
 %      5        1.04        7             4    
 %      7     0.98933        7             8    
 %      3     0.95883        7             9    
 %     14     0.88418        6             4    
 %      2     0.86585        7             8    
 %     15     0.73154        5             9    
 %      1     0.70422        4             9    
 %     11     0.70079        5             9    
 %      9     0.56741        3             5
% Honors EA1
% Homework Program 2
%
% Name: Branovacki, Alek
% Date: 10/2/2025

% Step 1: User inputs for number of nodes and expected degree
nodes_prompt = "Enter the desired number of nodes: ";
N = input(nodes_prompt);
if N < 2 % need at least 2 nodes
    error('InputError:InvalidValue', 'The desired number of nodes must be at least 2. Current number: %d', N);
end
degree_prompt = "Enter the expected degree: ";
mu = input(degree_prompt);
if (mu < 1) || (mu > (N/2)) % need mu to be between these bounds
    error('InputError:InvalidValue', 'The expected degree must be between 1 and half the number of nodes. Current number of nodes: %d. Current expected degree: %d', N, mu);
end

% Step 2: Random graph using Erdos-Renyi method and its degree vector
p = mu/(N-1); % probability parameter calculation using formula 3
A = rand(N) <= p; % square matrix size N with entries either 1 with probability p or 0 with probability 1-p.
A = triu(A,1); % only take upper triangle of A, exluding the main diagonal. This sets the main diagonal entries to 0 and solves the selfloops issue.
A = A + A'; % take A's transpose and add it to itself, creating a symmetrical adjacency matrix
G1 = graph(A);
deg1 = degree(G1);

% Step 3: Geometric random graph and its vector degree
% https://mathworld.wolfram.com/DiskLinePicking.html
fa = @(s)((4/pi)*s.*acos(s/2)-(2/pi)*(s.^2).*sqrt(1-(s/2).^2));
fb = @(r)((N-1)*integral(fa,0,r)-mu);
R = fzero(fb,[0 2]);
r = sqrt(rand(1,N)); % code for randomizing r and theta is from section 3 of the homework document
theta = 2*pi*rand(1,N);
D = r.^2 + r.^2' - 2 * (r .* r') .* cos(theta - theta'); % calculation of D from formula 6
A = D <= R^2; % symmetric adjacency matrix
G2 = graph(A, 'omitselfloops');
deg2 = degree(G2);

% Step 4: Random graph using Barabási-Albert method and its degree vector
m = (.5)*(N-sqrt((N^2)-2*mu*N)); % calculation of m from formula 8
m = round(m); % rounding m to nearest integer
G3 = graph(1:m,2:m+1);
% plot(G3);
for node = m+2:N % from assignment document
    d = degree(G3);
    targets = datasample(1:numnodes(G3), m, 'Replace', false, 'Weights', d); % using the datasample function to select m targets
    G3 = addedge(G3,node,targets);
end 
deg3 = degree(G3);

% Step 5: Expected degree distributions P(k) for all three methods. copied from homework document
kmax = max([deg1;deg2;deg3]);
% curve for method 1
k1 = 0:kmax;
P1 = binopdf(k1,N-1,p);
% curve for method 2
k2 = 0:kmax;
g2 = @(r)(poisspdf(k2,kbar_geo(r,R,N))*2*r);
P2 = integral(g2,0,1,'ArrayValued',true);
% curve for method 3
k3 = m:kmax;
P3 = 2*m*(m+1)./(k3.*(k3+1).*(k3+2)); % from formula 9

% Step 6
sgtitle(sprintf('Random Graph Degree Distributions (N = %d, μ = %d)', N, mu));
subplot(3,1,1); % using subplots to keep all plots on the same screen
histogram(deg1, 'Normalization', 'pdf'); % from document
hold on; % using hold to graph both P and k
plot(k1, P1, 'r-', 'LineWidth', 2);
hold off;
xlabel('degree'); % x and y labels, titles, and legends are designed around the example in the homework document
ylabel('probability');
title(sprintf('Degree distribution, Erdős-Rényi (N = %d, μ = %d)', N, mu));
legend('freq(k)', 'P(k)', 'Location', 'northeast');

subplot(3,1,2);
histogram(deg2, 'Normalization', 'pdf');
hold on;
plot(k2, P2, 'r-', 'LineWidth', 2);
hold off;
xlabel('degree');
ylabel('probability');
title(sprintf('Degree distribution, geometric (N = %d,  μ = %d)', N, mu));
legend('freq(k)', 'P(k)', 'Location', 'northeast');

subplot(3,1,3);
histogram(deg3, 'Normalization', 'pdf');
hold on;
plot(k3, P3, 'r-', 'LineWidth', 2);
hold off;
xlabel('degree');
ylabel('probability');
title(sprintf('Degree distribution, Barabási-Albert (N = %d,  μ = %d)', N, mu));
legend('freq(k)', 'P(k)', 'Location', 'northeast');

% Question 1:
% After testing different values of N and mu, the expected degree distributions P(k) 
% generally do predict the shape of the actual degree distributions freq(k), but 
% the accuracy depends on the graph size and expected degree values.
%
% For small graphs (N < 100): The histograms look choppy and don't match the smooth
% theoretical curves as well. However, the general shape is still captured 
% by the expected degree distributions. There's more randomness as well. I believe
% this is because with smaller sample sizes, there is more variance.
%
% For large graphs (N > 2000): The histograms match the theoretical curves much
% better. I think this is because of the law of large numbers. With more 
% nodes, the data averages out and the actual results get 
% closer to the predictions.
%
% For different mu values: When mu is small (~.01N), all three methods 
% show good matching between histograms and curves. When mu gets larger (up to .5N), 
% the predictions still work but the distributions get more concentrated 
% around the average degree.

% Question 2:
hubs1 = (max(deg1)/(mean(deg1))); % calculation of max/mean ratio
hubs2 = (max(deg2)/(mean(deg2)));
hubs3 = (max(deg3)/(mean(deg3)));
fprintf('Max/Mean Erdős-Rényi: %.2f\n', hubs1);
fprintf('Max/Mean Geometric: %.2f\n', hubs2);
fprintf('Max/Mean Barabási-Albert: %.2f\n', hubs3);

% code used to create the plots for visualization of hubs
% plot(G1,'NodeColor','red','MarkerSize',50*max(1,deg1)/N, ...
% 'NodeLabel',{},'Layout','force3');

% plot(G2,'NodeColor','red','MarkerSize',50*max(1,deg2)/N, ...
% 'NodeLabel',{},'Layout','force3');

% plot(G3,'NodeColor','red','MarkerSize',50*max(1,deg3)/N, ...
% 'NodeLabel',{},'Layout','force3');

% After testing some scenarios where mu <= .1N, the Barabási-Albert method
% results in graphs with hubs. When looking at some plots with smaller Ns (<= 100),
% there are, very visibly, a few nodes that are exceptionally large compared to the others
% in the Barabási-Albert plot. This is confirmed through the ratios between
% each methods' max/mean. This ratio becomes larger the smaller mu is compared to N. Below are some sample outputs:

% Scenario 1:
% Enter the desired number of nodes: 20
% Enter the expected degree: 2
% Max/Mean Erdős-Rényi: 2.61
% Max/Mean Geometric: 2.00
% Max/Mean Barabási-Albert: 3.68

% Scenario 2:
% Enter the desired number of nodes: 100
% Enter the expected degree: 5
% Max/Mean Erdős-Rényi: 2.09
% Max/Mean Geometric: 1.97
% Max/Mean Barabási-Albert: 5.15

% Scenario 3:
% Enter the desired number of nodes: 1000
% Enter the expected degree: 10
% Max/Mean Erdős-Rényi: 2.15
% Max/Mean Geometric: 1.91
% Max/Mean Barabási-Albert: 10.65

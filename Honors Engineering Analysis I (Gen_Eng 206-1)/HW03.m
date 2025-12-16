% Honors EA1
% Homework Program 3
%
% Name: Branovacki, Alek
% Date: 10/9/2025

% User Inputs
while true % loop until input is valid
    d = input("Enter the damping factor: ");
    if d > 0 && d < 1 % validating damping factor to be between 0 and 1
        break;
    end
    fprintf('Damping factor must be between 0 and 1.\n');
end
while true
    iterations = input("Enter the number of iterations: ");
    if iterations > 0 && mod(iterations, 1) == 0  % validating iterations to be a positive integer
        break;
    end
    fprintf('Number of iterations must be a positive integer.\n');
end
while true
    omegas = input("Enter a vector of values for ω: ");
    if all(omegas > 0 & omegas < 2) % validating relxation parameters list to all be between 0 and 2
        break;
    end
    fprintf('The relation parameters must be a vector with each entry between 0 and 2.\n');
end

load("H.mat"); % load hyperlink matrix
N = size(H, 1); % find total number of entries in H, assuming H is a square matrix
r0 = ones(N, 1); % Initial guess of all ones
errors_jacobi = zeros(iterations, 1); % initializing vector for jacobi errors
errors_gs = zeros(iterations, length(omegas)); % initializing error matrix for Gauss-Seidel

% Jacobi's Method
fprintf('Calculating PageRank using Jacobi''s method ...\n');
fprintf('Iteration: \n');
r = r0; % set initial guess
tic;
for k = 1:iterations
    fprintf('%d ', k); % iteration loading bar
    if mod(k, 10) == 0 % new line every 10 iterations
        fprintf('\n');
    end

    r_new = d * H * r + (1 - d) * ones(N, 1); % calculate next iteration of r using variation of equation 1 discussed in the assignment document
    errors_jacobi(k) = norm(r_new - r, inf); % keeping a list of the errors for plotting
    r = r_new;
end
time_jacobi = toc; % calculate the total time the calculation took
fprintf('The error is %.3e after %d iterations and %.2f seconds.\n', ...
    errors_jacobi(iterations), iterations, time_jacobi); 


% Gauss-Seidel Method
fprintf('\nCalculating PageRank using the Gauss-Seidel method ...\n');

A = speye(N) - d * H; % A = I-dH, in sparse form
b = (1 - d) * ones(N, 1); % from Ax=b
D = spdiags(diag(A), 0, N, N); % diagonal of A in sparse form
L = tril(A, -1); % lower triangle of A without diagonal 

for idx = 1:length(omegas) % do the calculation for every item in omegas
    omega = omegas(idx); % get the specific omega from the vector
    fprintf('ω=%.2f: \n', omega);
    fprintf('Iteration: \n');
    r = r0; % set initial guess
    tic;
    
    M = (1/omega) * D + L; % from assignment document, lower triangular so that MATLAB uses forward substitution automatically
    M_minus_A = M - A; % for efficiency, outlined in the assignment document
    
    for k = 1:iterations
        fprintf('%d ', k);
        if mod(k, 10) == 0
            fprintf('\n');
        end
        
        r_new = M \ (M_minus_A * r + b); % using forward substitution
        errors_gs(k, idx) = norm(r_new - r, inf); % record errors
        r = r_new;
    end
    
    time_gs = toc; % time calculation
    fprintf('The error is %.3e after %d iterations and %.2f seconds.\n\n', ...
        errors_gs(iterations, idx), iterations, time_gs);
end

% Plot
figure;
semilogy(1:iterations, errors_jacobi, '-o', 'LineWidth', 1.5, 'DisplayName', 'Jacobi');
hold on;
for idx = 1:length(omegas) % display each row of the matrix seperately, since each row corresponds to a specific omega
    semilogy(1:iterations, errors_gs(:, idx), '-o', 'LineWidth', 1.5, ...
        'DisplayName', sprintf('Gauss-Seidel (ω=%.2f)', omegas(idx)));
end
hold off;
xlabel('iteration');
ylabel('error');
title(sprintf('Convergence for N=%d and d=%.2f', N, d));
legend('Location', 'best');
grid on;

% Question 1:
% Enter the damping factor: .85
% Enter the number of iterations: 40
% Enter a vector of values for ω: 0.8:0.1:1.5
% After analyzing the graph with the above values, the Gauss-Seidel method
% with ω = 1.00 has the lowest error between 5 and 10 iterations. So, if I
% only had the time and resources to run 5-10 iterations, I would choose
% this method.

% Question 2:
% Using the same inputs as question 1, the method I would choose if I
% wanted to achieve an erorr of less than 1e-10 would be the Gauss-Seidel
% method with ω = 1.20, becuase it is the method which reaches an error of
% less than 1e-10 in the least amount of iterations (~36 iterations in this
% case. No other methods even reach an error of 1e-10 in 40 iterations)

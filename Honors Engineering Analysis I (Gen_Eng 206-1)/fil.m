function y = fil(u, A, B)
% FIL Digital filter implementation for linear difference equations
%   y = fil(u, A, B) filters the input signal or signals in the matrix u through a digital
%   filter defined by polynomials Pa(q) and Pb(q) wose coefficients are
%   stored in the column vectors A and B, respectively. The filter implements 
%   the difference equation from equation 1 in the assignment document: Pa(q)*y = Pb(q)*u
%
%   Inputs:
%       u - matrix of input signals where each row is a separate signal
%       A - column vector of coefficients [a0; a1; ...; an] for Pa(q)
%       B - column vector of coefficients [b0; b1; ...; bn] for Pb(q)
%
%   Output:
%       y - output signal matrix that is the same size as u
% 
%   Example:
%       A=[1; 0]; B=[0.5; 0.5]; u=[1:6; 2:2:12]; y=fil(u,A,B)

% Honors EA1
% Homework Program 8
%
% Name: Alek Branovacki
% Date: 11/20/2025

% Step 1: arguments
arguments
    u (:,:) double {mustBeReal, mustBeFinite}
    A (:,1) double {mustBeReal, mustBeFinite}
    B (:,1) double {mustBeReal, mustBeFinite}
end

% Step 2: calculating the filter order
n = length(A) - 1; % order of the polynomial is the number of coefficients - 1 (since there will be a coefficient for the 0th order)

% Step 3: handling the 0 order case
if n == 0
    y = u * B / A;
    return;
end

% Step 4: get N and L and initialize y
N = size(u, 1);  % number of rows (aka number of signals)
L = size(u, 2);  % number of columns (aka number of samples)
y = zeros(N, L); % zero matrix of same size as u (NxL)

% Step 5: initialize the auxiliary signal W
W = zeros(N, n); % size Nxn

% Step 6: loop
for k = 1:L
    % calculating wk from current input and previous w values
    wk = u(:, k); % getting uk
    if n >= 1 % not needed for 0th order signals
        wk = wk - W * A(2:end); % from the assignment document, wk = (1/a0) * [uk - a1*w(k-1) - a2*w(k-2) - ... - an*w(k-n)]
    end
    wk = wk / A(1); % b0*wk part of the equation
    
    % calculating yk from current and previous w values
    y(:, k) = B(1) * wk; % b0*wk part of the equation
    if n >= 1 % not needed for 0th order signals
        y(:, k) = y(:, k) + W * B(2:end); % from the assignment document, % yk = b0*wk + b1*w(k-1) + b2*w(k-2) + ... + bn*w(k-n)
    end
    
    % update W
    if n > 1
        W = [wk, W(:, 1:end-1)]; % throws out rightmost column, shifts wk into the first column
    else
        W = wk; % if 1st order, jsut replace with wk
    end
end

end

% Testing the function
% 
%  A=[1; 0]; B=[0.5; 0.5]; u=[1:6; 2:2:12]; y=fil(u,A,B)
% 
% y =
% 
%     0.5000    1.5000    2.5000    3.5000    4.5000    5.5000
%     1.0000    3.0000    5.0000    7.0000    9.0000   11.0000

% Plotting Gain vs. Frequency
% 
% fs = 8000; % sample rate
% t = 0:(1/fs):2; % signals should be 2 seconds long
% f = logspace(log10(50),log10(4000),100);
% u = cos(2*pi*f'*t);
% A = [1.0000; -3.0308; 4.2593; -3.3038; 1.3981; -0.2567];
% B = [0.0021; 0.0103; 0.0207; 0.0207; 0.0103; 0.0021];
% y = fil(u,A,B);
% G = max(abs(y(:,80:length(t))),[],2); % find gain across each row
% semilogx(f,G);
% axis([50 4000 0 1.1]);
% grid;
% xlabel('Frequency f (Hz)');
% ylabel('Gain G');

% Question 1: need to solve homogeneous system Pa(q) * yh = 0. So (1 - q)(1
% - 3q) * yh = 0. (1 - q) * yh = 0, which gives yh_k = c1 * 1^k = c1 or (1
% - 3q)*yh = 0, which gives yh_k = c2 * 3^k. So a basis for Ker(Pa) is:
% {1^k, 3^k} which has a dimension of 2.
%
% Question 2: filter equation is Pa(q)*y = Pb(q)*u. From the assignment
% document, Pa(q)*w = u and y = Pb(q)*w. So, Pa(q)*y = Pa(q)*Pb(q)*w. We
% can then say that Pa(q)*y = Pb(q)*Pa(q)*w, since polynomial
% transformations commute. Since Pa(q)*w = u, the equation reduces to Pa(q)*y = Pb(q)*u
% 
% Question 3: This is a "low pass" filter because it passes low frequency
% (low and high meaning below and above a certain threshold. In this
% example code, the threshold appears to be 1000 Hz) 
% signals with little reduction in amplitude/gain, but it reduces the
% amplitude of high frequency signals.
% 
% Question 4: 
% 1. The highpass.mat, which is a "high pass" filter, does the oppposite of
% the "low pass" filter. It does not reduce the amplitude/gain of high
% frequency signals, but it reduces the amplitude of low frequency signals.
% 2. The bandpass.mat, which is a "band pass" filter, appears to combine a
% "high pass" and "low pass" filter. Frequencies below a threshold and
% above a different threshold (this second threshold is greater than the
% first one or else no signals would pass through) are reduced, but the
% signals in between the thresholds are passed through. 
% 3. The bandstop.mat, which is a "band stop" filter, appears to be the
% inverse of a "band pass" filter. Between two thresholds, it reduces those
% frequencies, but every other frequency passes through. 

% Audio sample
% 
% clear all
% load handel
% u = y';  % Transpose! u must be a row vector
% clear y
% 
% Unfiltered sound
% sound(u, Fs)
%
% Low pass filter
% 
% A = [1.0000; -3.0308; 4.2593; -3.3038; 1.3981; -0.2567];
% B = [0.0021; 0.0103; 0.0207; 0.0207; 0.0103; 0.0021];
% y = fil(u, A, B);
% sound(y, Fs)
%
% High pass filter
%
% load highpass.mat
% y = fil(u, A, B);
% sound(y, Fs)
% 
% Band pass filter
% 
% load bandpass.mat
% y = fil(u, A, B);
% sound(y, Fs)
%
% Band stop filter
%
% load bandstop.mat
% y = fil(u, A, B);
% sound(y, Fs)
%
% These definitely match the frequency vs. gain graphs of each filter. I
% heard mostly the frequencies that had high gain in each respective
% plot/filter
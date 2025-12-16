function [US, V] = compress(X, ratio)
% COMPRESS Compress a color image using truncated SVD
%   [US, V] = compress(X, ratio) compresses the RGB image array (X) to a 
%   specified ratio (ratio) using the truncated singular value 
%   decomposition (SVD)
%
%   Inputs:
%       X - 3D array of size m x n x 3 representing an RGB image. Values in 
%       the interval [0, 1]
%       ratio - compression ratio between 0 and 1
%
%   Outputs:
%       US - 3D array of Uk*Sk for each of the three color channels
%       V  - 3D array of Vk for each of the three color channels

% Honors EA1
% Homework Program 9
%
% Name: Branovacki, Alek
% Date: 12/04/2025

% Step 1: argument block and input validation
arguments
    X (:,:,3) {mustBeInRange(X, 0, 1)}
    ratio (1,1) {mustBeInRange(ratio, 0, 1)}
end

% Step 2: calculating k
m = size(X, 1); % get first two dimensions of the image
n = size(X, 2);
k = round(ratio / (1/m + 1/n)); % calculating k using compression ratio from assignment document

% Step 3: computing US and V using svds
US = zeros(m, k, 3); % initialize output arrays
V = zeros(n, k, 3); 

for channel = 1:3 % loop through each channel: red, green, and blue
    plane = X(:,:,channel); % get the current channel plane
    [Uk, Sk, Vk] = svds(plane, k); % truncated SVD for current plane
    US(:,:,channel) = Uk * Sk; % storing UkSk and Vk
    V(:,:,channel) = Vk;
end

% Step 4: reconstruct and display the compressed image
Z = zeros(m, n, 3); % initialize the image array
for channel = 1:3 % fill in Z for each RGB plane
    Z(:,:,channel) = US(:,:,channel) * V(:,:,channel)';
end
Z(Z < 0) = 0; % replace negative entries with 0
Z(Z > 1) = 1; % replace entries larger than 1 with 1
figure; % displaying image
image(Z); 
axis equal; % correct aspect ratio
axis off; % remove tick marks
end

% Compression ratios for Boats, Flower, and Parrot
% Boats:
% smallest ratio to identify object: .05
% smallest ratio for good quality: .3
% Flower:
% smallest ratio to identify object: .02
% smallest ratio for good quality: .4
% Parrot:
% smallest ratio to identify object: .03
% smallest ratio for good quality: .2
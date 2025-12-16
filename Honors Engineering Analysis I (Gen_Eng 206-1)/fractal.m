function [EscTime, EscVal, Image] = fractal(kind, kw) % Step 1: declare function along with documentation
% FRACTAL Calculates and displays either the Mandelbrot set or burning ship fractal
%   [EscTime, EscVal, Image] = fractal(kind) calculates the fractal
%   specified by kind ('Mandelbrot' or 'burning ship') and returns
%   escape times, escape values, and the image array.
%
%   Optional named arguments:
%       limits - [XMIN XMAX YMIN YMAX] rectangular region (default depends on kind: [-2.0 0.5 -1.2 1.2] for the Mandelbrot set and [-2.2 1.2 -2 0.6] for the “burning ship” fractal.)
%       nx - number of pixels in x-direction (default: 1024)
%       ny - number of pixels in y-direction (default: 1024)
%       maxEscTime - maximum iterations (default: 1000)
%       colors - colormap function handle (default: @turbo)
%
%   Examples:
%       [EscTime,EscVal,Image]=fractal(nx=500, ny=500, colors=@hsv);
%       [EscTime,EscVal,Image]=fractal('b', limits=[-1.8 -1.7 -0.09 0.01]);

% Honors EA1
% Homework Program 4
%
% Name: Branovacki, Alek
% Date: 10/15/2025

% Step 2: arguments block for the 6 inputs
arguments
    kind {mustBeTextScalar} = 'm' % default value of m (Mandelbrot), must be a single piece of text
    kw.limits (1,4) {mustBeNumeric} = get_default_limits(kind) % use local function to choose default value of limits, must be a row vector with four entries, and all entries must be numeric
    kw.nx (1,1) {mustBeInteger, mustBePositive} = 1024 % default values of 1024 for x and y pixel count. Must be positive integer scalars.
    kw.ny (1,1) {mustBeInteger, mustBePositive} = 1024
    kw.maxEscTime (1,1) {mustBeInteger, mustBePositive} = 1000 % default value of 1000 (max number of iterations). Must be a positive integer scalar.
    kw.colors = @turbo % color mapping
end

% Step 3: indicating whether Mandelbrot or burning ship is being used
ship = strncmpi(kind, 'b', 1); % logic only checks first letter of user input (case insensitive)
if ship
    fprintf('Calculating a burning ship fractal\n'); % messages letting the user know which type of fractal is being calculated
else
    fprintf('Calculating a Mandelbrot set\n');
end

% Step 4: create ny by nx matrix C
x = linspace(kw.limits(1), kw.limits(2), kw.nx); % evenly spaced row vectors for x and y axes. goes from lower limits to upper limits in nx or ny steps
y = linspace(kw.limits(3), kw.limits(4), kw.ny);
[X, Y] = meshgrid(x, y(end:-1:1)); % use meshgrid function to form the array C
C = X + 1i*Y;

% Step 5: process C
EscTime = inf(kw.ny, kw.nx); % initialize escape times to be infinity
EscVal = nan(kw.ny, kw.nx); % initialize escape values to be undefined
Z = zeros(kw.ny, kw.nx); % initialize values for all pixels (0)
done = false(kw.ny, kw.nx); % track which pixels have escaped

for k = 1:kw.maxEscTime % iterate up to max escape time
    if ship
        Z = (abs(real(Z)) + 1i*abs(imag(Z))).^2 + C; % update Z using the burning ship formula 
    else
        Z = Z.^2 + C; % updating Z using the Mandelbrot formula
    end
    mask = (abs(Z) > 2) & ~done; % create mask for pixels that just escaped in the last iteration, but havent escaped before
    EscTime(mask) = k; % record escape time and value for pixels that just escaped in the last iteration
    EscVal(mask) = abs(Z(mask)); 
    done(mask) = true; % mark these pixels as done
    if all(done, 'all') % if all pixels have been marked as done (ie have escaped), exit the loop early
        break;
    end
end

% Step 6: Create and display the image
Image = showFractal(EscTime, EscVal, kw.limits, kw.colors);
if ship
    set(gca, 'YDir', 'reverse');
end

end % end of fractal function

% Part of Step 2, local function that determines the default limits based
% on the kind of fractal being used
function limits = get_default_limits(kind)
    if strncmpi(kind, 'b', 1) % logic only checks first letter of user input (case insensitive)
        limits = [-2.2 1.2 -2 0.6]; % burning ship default limits
    else 
        limits = [-2.0 0.5 -1.2 1.2]; % Mandelbrot default limits
    end
end
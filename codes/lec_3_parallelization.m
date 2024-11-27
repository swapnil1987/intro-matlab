%==========================================================================
%                   MATLAB Parallel Computing Tutorial
%
% This program demonstrates the power of parallel computing in MATLAB using
% various computationally intensive examples
%
%@Objective             Demonstrate parallel computing benefits and techniques
%@Author                Swapnil Singh
%==========================================================================

clc
clear all

% Check if parallel pool is available and create if needed
if isempty(gcp('nocreate'))
    parpool('local'); % Create parallel pool
end

%% Example 1: Monte Carlo Pi Estimation
% Demonstrate parallel computing with Monte Carlo simulation

n_points = 10^7; % Number of points for Monte Carlo
n_experiments = 20; % Number of experiments

% Serial computation
tic
pi_estimates_serial = zeros(n_experiments, 1);
for i = 1:n_experiments
    % Generate random points
    x = rand(n_points, 1);
    y = rand(n_points, 1);
    % Count points inside circle
    inside_circle = sum((x.^2 + y.^2) <= 1);
    % Estimate pi
    pi_estimates_serial(i) = 4 * inside_circle / n_points;
end
time_serial = toc;

% Parallel computation
tic
pi_estimates_parallel = zeros(n_experiments, 1);
parfor i = 1:n_experiments
    % Generate random points
    x = rand(n_points, 1);
    y = rand(n_points, 1);
    % Count points inside circle
    inside_circle = sum((x.^2 + y.^2) <= 1);
    % Estimate pi
    pi_estimates_parallel(i) = 4 * inside_circle / n_points;
end
time_parallel = toc;

fprintf('Example 1: Monte Carlo Pi Estimation\n');
fprintf('Serial time: %.3f seconds\n', time_serial);
fprintf('Parallel time: %.3f seconds\n', time_parallel);
fprintf('Speedup factor: %.2fx\n\n', time_serial/time_parallel);

%% Example 2: Image Processing
% Demonstrate parallel computing with image processing

% Create multiple random images
n_images = 100;
image_size = 1000;
images = rand(image_size, image_size, n_images);

% Define Gaussian filter
sigma = 2;
filter_size = 11;
[x, y] = meshgrid(-filter_size:filter_size, -filter_size:filter_size);
gaussian_filter = exp(-(x.^2 + y.^2)/(2*sigma^2));
gaussian_filter = gaussian_filter/sum(gaussian_filter(:));

% Serial computation
tic
filtered_images_serial = zeros(size(images));
for i = 1:n_images
    filtered_images_serial(:,:,i) = conv2(images(:,:,i), gaussian_filter, 'same');
end
time_serial_img = toc;

% Parallel computation
tic
filtered_images_parallel = zeros(size(images));
parfor i = 1:n_images
    filtered_images_parallel(:,:,i) = conv2(images(:,:,i), gaussian_filter, 'same');
end
time_parallel_img = toc;

fprintf('Example 2: Image Processing\n');
fprintf('Serial time: %.3f seconds\n', time_serial_img);
fprintf('Parallel time: %.3f seconds\n', time_parallel_img);
fprintf('Speedup factor: %.2fx\n\n', time_serial_img/time_parallel_img);

%% Example 3: Matrix Operations
% Demonstrate parallel computing with large matrix operations

% Generate large matrices
n_matrices = 50;
matrix_size = 500;
matrices_A = zeros(matrix_size, matrix_size, n_matrices);
matrices_B = zeros(matrix_size, matrix_size, n_matrices);

for i = 1:n_matrices
    matrices_A(:,:,i) = rand(matrix_size);
    matrices_B(:,:,i) = rand(matrix_size);
end

% Serial computation
tic
result_serial = zeros(matrix_size, matrix_size, n_matrices);
for i = 1:n_matrices
    result_serial(:,:,i) = matrices_A(:,:,i) * matrices_B(:,:,i);
end
time_serial_mat = toc;

% Parallel computation
tic
result_parallel = zeros(matrix_size, matrix_size, n_matrices);
parfor i = 1:n_matrices
    result_parallel(:,:,i) = matrices_A(:,:,i) * matrices_B(:,:,i);
end
time_parallel_mat = toc;

fprintf('Example 3: Matrix Operations\n');
fprintf('Serial time: %.3f seconds\n', time_serial_mat);
fprintf('Parallel time: %.3f seconds\n', time_parallel_mat);
fprintf('Speedup factor: %.2fx\n\n', time_serial_mat/time_parallel_mat);

%% Example 4: Numerical Integration
% Demonstrate parallel computing with numerical integration

% Define function to integrate
f = @(x) sin(x).^2 .* exp(-x./2);

% Parameters
n_intervals = 10^7;
n_integrals = 100;
x_ranges = [0 10; 1 12; 2 15; 0 8; 5 15];
x_ranges = repmat(x_ranges, ceil(n_integrals/5), 1);
x_ranges = x_ranges(1:n_integrals,:);

% Serial computation
tic
integrals_serial = zeros(n_integrals, 1);
for i = 1:n_integrals
    x = linspace(x_ranges(i,1), x_ranges(i,2), n_intervals);
    dx = (x_ranges(i,2) - x_ranges(i,1))/(n_intervals-1);
    integrals_serial(i) = sum(f(x))*dx;
end
time_serial_int = toc;

% Parallel computation
tic
integrals_parallel = zeros(n_integrals, 1);
parfor i = 1:n_integrals
    x = linspace(x_ranges(i,1), x_ranges(i,2), n_intervals);
    dx = (x_ranges(i,2) - x_ranges(i,1))/(n_intervals-1);
    integrals_parallel(i) = sum(f(x))*dx;
end
time_parallel_int = toc;

fprintf('Example 4: Numerical Integration\n');
fprintf('Serial time: %.3f seconds\n', time_serial_int);
fprintf('Parallel time: %.3f seconds\n', time_parallel_int);
fprintf('Speedup factor: %.2fx\n\n', time_parallel_int/time_parallel_int);

%% Visualization of Results
figure('Position', [100 100 1200 600]);

% Collect all timing data
serial_times = [time_serial, time_serial_img, time_serial_mat, time_serial_int];
parallel_times = [time_parallel, time_parallel_img, time_parallel_mat, time_parallel_int];

% Subplot 1: Bar plot of execution times
subplot(1,2,1)
bar([serial_times; parallel_times]');
legend('Serial', 'Parallel');
title('Performance Comparison: Serial vs. Parallel');
xlabel('Example Number');
ylabel('Execution Time (seconds)');
set(gca, 'XTickLabel', {'Monte Carlo', 'Image Proc', 'Matrix Ops', 'Integration'});
grid on;

% Add speedup text annotations
for i = 1:4
    text(i, mean([serial_times(i), parallel_times(i)]), ...
         sprintf('%.1fx', serial_times(i)/parallel_times(i)), ...
         'HorizontalAlignment', 'center');
end

% Subplot 2: Speedup factors
subplot(1,2,2)
speedups = serial_times./parallel_times;
bar(speedups);
title('Speedup Factors');
xlabel('Example Number');
ylabel('Speedup (x times)');
set(gca, 'XTickLabel', {'Monte Carlo', 'Image Proc', 'Matrix Ops', 'Integration'});
grid on;

%% Display Parallel Computing Tips
fprintf('Key Tips for Parallel Computing in MATLAB:\n\n');
fprintf('1. Use parfor for independent iterations\n');
fprintf('2. Avoid communication between workers\n');
fprintf('3. Preallocate arrays for better performance\n');
fprintf('4. Consider overhead when deciding to parallelize\n');
fprintf('5. Use parallel pools efficiently\n');
fprintf('6. Be aware of variable classification (broadcast, sliced, etc.)\n');
fprintf('7. Profile code to identify parallelization opportunities\n\n');

% Clean up parallel pool
delete(gcp('nocreate'));
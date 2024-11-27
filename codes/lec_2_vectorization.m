%==========================================================================
%                   MATLAB Vectorization Tutorial
%
% This program demonstrates the power of vectorization in MATLAB through
% various examples and performance comparisons
%
%@Objective             Demonstrate vectorization benefits and techniques
%@Author                Swapnil Singh
%==========================================================================

clc
clear all

%% Example 1: Basic Array Operations
% Demonstrate vectorization with simple calculations

% Create large arrays for testing
n = 1000000;  % Size of arrays
x = rand(1,n);
y = rand(1,n);

% Example operation: z = x^2 + y^2 + 2xy

% Method 1: Using loops (slow)
tic  % Start timing
z_loop = zeros(1,n);
for i = 1:n
    z_loop(i) = x(i)^2 + y(i)^2 + 2*x(i)*y(i);
end
time_loop = toc;  % End timing

% Method 2: Using vectorization (fast)
tic
z_vec = x.^2 + y.^2 + 2.*x.*y;
time_vec = toc;

% Display results
fprintf('Example 1: Basic Array Operations\n');
fprintf('Loop time: %.6f seconds\n', time_loop);
fprintf('Vectorized time: %.6f seconds\n', time_vec);
fprintf('Speedup factor: %.2fx\n\n', time_loop/time_vec);

%% Example 2: Matrix Operations
% Demonstrate vectorization in matrix calculations

% Create matrices
A = rand(1000, 1000);
B = rand(1000, 1000);

% Calculate Frobenius norm of A*B + A^2

% Method 1: Using loops (slow)
tic
sum_loop = 0;
for i = 1:1000
    for j = 1:1000
        temp = 0;
        % Calculate (A*B)_{ij}
        for k = 1:1000
            temp = temp + A(i,k)*B(k,j);
        end
        % Calculate (A^2)_{ij}
        temp2 = 0;
        for k = 1:1000
            temp2 = temp2 + A(i,k)*A(k,j);
        end
        sum_loop = sum_loop + (temp + temp2)^2;
    end
end
norm_loop = sqrt(sum_loop);
time_loop_matrix = toc;

% Method 2: Using vectorization (fast)
tic
norm_vec = norm(A*B + A^2, 'fro');
time_vec_matrix = toc;

fprintf('Example 2: Matrix Operations\n');
fprintf('Loop time: %.6f seconds\n', time_loop_matrix);
fprintf('Vectorized time: %.6f seconds\n', time_vec_matrix);
fprintf('Speedup factor: %.2fx\n\n', time_loop_matrix/time_vec_matrix);

%% Example 3: Logical Operations and Filtering
% Demonstrate vectorization with conditional operations

% Create test data
data = randn(1, 1000000);  % Random normal distribution

% Find all values > 0, square them, and sum

% Method 1: Using loops (slow)
tic
sum_positive_loop = 0;
for i = 1:length(data)
    if data(i) > 0
        sum_positive_loop = sum_positive_loop + data(i)^2;
    end
end
time_loop_logical = toc;

% Method 2: Using vectorization (fast)
tic
sum_positive_vec = sum(data(data > 0).^2);
time_vec_logical = toc;

fprintf('Example 3: Logical Operations\n');
fprintf('Loop time: %.6f seconds\n', time_loop_logical);
fprintf('Vectorized time: %.6f seconds\n', time_vec_logical);
fprintf('Speedup factor: %.2fx\n\n', time_loop_logical/time_vec_logical);

%% Example 4: Image Processing
% Demonstrate vectorization in image processing context

% Create a sample image (random noise)
img = rand(1000, 1000);

% Apply Gaussian smoothing using 3x3 kernel
kernel = [1 2 1; 2 4 2; 1 2 1] / 16;

% Method 1: Using loops (slow)
tic
img_smooth_loop = zeros(size(img));
for i = 2:size(img,1)-1
    for j = 2:size(img,2)-1
        % Apply convolution manually
        window = img(i-1:i+1, j-1:j+1);
        img_smooth_loop(i,j) = sum(sum(window .* kernel));
    end
end
time_loop_image = toc;

% Method 2: Using built-in convolution (vectorized)
tic
img_smooth_vec = conv2(img, kernel, 'same');
time_vec_image = toc;

fprintf('Example 4: Image Processing\n');
fprintf('Loop time: %.6f seconds\n', time_loop_image);
fprintf('Vectorized time: %.6f seconds\n', time_vec_image);
fprintf('Speedup factor: %.2fx\n\n', time_loop_image/time_vec_image);

%% Example 5: Distance Matrix Calculation
% Calculate pairwise distances between points

% Generate random points
n_points = 1000;
points = rand(n_points, 2);  % 2D points

% Method 1: Using loops (slow)
tic
dist_matrix_loop = zeros(n_points);
for i = 1:n_points
    for j = 1:n_points
        dist_matrix_loop(i,j) = sqrt((points(i,1)-points(j,1))^2 + ...
                                   (points(i,2)-points(j,2))^2);
    end
end
time_loop_dist = toc;

% Method 2: Using vectorization (fast)
tic
% Use built-in pdist2 function
dist_matrix_vec = pdist2(points, points);
time_vec_dist = toc;

fprintf('Example 5: Distance Matrix Calculation\n');
fprintf('Loop time: %.6f seconds\n', time_loop_dist);
fprintf('Vectorized time: %.6f seconds\n', time_vec_dist);
fprintf('Speedup factor: %.2fx\n\n', time_loop_dist/time_vec_dist);

%% Visualization of Performance Comparison
figure('Position', [100 100 800 600]);

% Collect all timing data
loop_times = [time_loop, time_loop_matrix, time_loop_logical, ...
              time_loop_image, time_loop_dist];
vec_times = [time_vec, time_vec_matrix, time_vec_logical, ...
             time_vec_image, time_vec_dist];

% Create bar plot
bar([loop_times; vec_times]');
legend('Loop-based', 'Vectorized');
title('Performance Comparison: Loop vs. Vectorized Operations');
xlabel('Example Number');
ylabel('Execution Time (seconds)');
set(gca, 'XTickLabel', {'Array Ops', 'Matrix Ops', 'Logical Ops', ...
                        'Image Proc', 'Distance Mat'});
grid on;

% Add speedup text annotations
for i = 1:5
    text(i, mean([loop_times(i), vec_times(i)]), ...
         sprintf('%.1fx', loop_times(i)/vec_times(i)), ...
         'HorizontalAlignment', 'center');
end

%% Key Lessons in Vectorization
% Display important vectorization tips
fprintf('Key Lessons in Vectorization:\n\n');
fprintf('1. Element-wise operations: Use .* ./ .^ instead of loops\n');
fprintf('2. Logical indexing: data(data > 0) instead of if statements\n');
fprintf('3. Built-in functions: Use MATLAB''s optimized functions\n');
fprintf('4. Matrix operations: Leverage MATLAB''s matrix operation capabilities\n');
fprintf('5. Preallocate arrays: Always preallocate for better performance\n');
fprintf('6. Avoid loops when possible: Especially nested loops\n');
fprintf('7. Use vector and matrix operations: They are highly optimized\n\n');
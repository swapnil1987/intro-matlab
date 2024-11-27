%==========================================================================
%                   Newton-Raphson Optimization
%
% This program implements the Newton-Raphson method for optimization with
% visualization of the optimization process
%
%@Objective             Demonstrate Newton-Raphson optimization
%@Author                Swapnil Singh
%==========================================================================

clc
clear all
close all

%% Define Test Function and Derivatives
% We'll use the Rosenbrock function as an example
% f(x,y) = (1-x)^2 + 100(y-x^2)^2

% Function definition
f = @(x) (1-x(1))^2 + 100*(x(2)-x(1)^2)^2;

% Gradient
grad = @(x) [-2*(1-x(1)) - 400*x(1)*(x(2)-x(1)^2);
             200*(x(2)-x(1)^2)];

% Hessian
hess = @(x) [2 - 400*x(2) + 1200*x(1)^2, -400*x(1);
             -400*x(1), 200];

%% Newton-Raphson Implementation with Path Storage
function [x_opt, f_opt, path, f_path] = newton_raphson(f, grad, hess, x0, max_iter, tol)
    % Initialize
    x = x0;
    path = x0;
    f_path = f(x0);  % Store function values
    
    for i = 1:max_iter
        % Compute gradient and Hessian
        g = grad(x);
        H = hess(x);
        
        % Check convergence
        if norm(g) < tol
            break;
        end
        
        % Compute Newton step
        % Use try-catch to handle singular Hessian
        try
            d = -H\g;
        catch
            % If Hessian is singular, use small regularization
            d = -(H + 1e-6*eye(length(x)))\g;
        end
        
        % Line search (simple backtracking)
        alpha = 1;
        while f(x + alpha*d) > f(x) + 0.1*alpha*g'*d
            alpha = 0.5*alpha;
            if alpha < 1e-10
                break;
            end
        end
        
        % Update position
        x = x + alpha*d;
        
        % Store path and function values
        path = [path, x];
        f_path = [f_path, f(x)];
    end
    
    x_opt = x;
    f_opt = f(x);
end

%% Test the Implementation
% Set parameters
x0 = [-1; -2];              % Initial point
max_iter = 50;             % Maximum iterations
tol = 1e-6;               % Tolerance for gradient norm

% Run optimization
[x_opt, f_opt, path, f_path] = newton_raphson(f, grad, hess, x0, max_iter, tol);

%% Visualization
% Create meshgrid for contour plot
[X, Y] = meshgrid(linspace(-2, 2, 100), linspace(-1, 3, 100));
Z = zeros(size(X));
for i = 1:size(X,1)
    for j = 1:size(X,2)
        Z(i,j) = f([X(i,j); Y(i,j)]);
    end
end

% Create figure with three subplots
figure('Position', [100 100 1200 400]);

% Subplot 1: Contour plot with optimization path
subplot(1,3,1)
contour(X, Y, Z, 50);
hold on
plot(path(1,:), path(2,:), 'r.-', 'MarkerSize', 15);
plot(x_opt(1), x_opt(2), 'r*', 'MarkerSize', 10);
title('Optimization Path');
xlabel('x');
ylabel('y');
colorbar;
grid on;

% Subplot 2: 3D surface plot
subplot(1,3,2)
surf(X, Y, Z, 'EdgeColor', 'none');
hold on
plot3(path(1,:), path(2,:), f_path, 'r.-', 'MarkerSize', 15);
plot3(x_opt(1), x_opt(2), f_opt, 'r*', 'MarkerSize', 10);
title('3D Surface View');
xlabel('x');
ylabel('y');
zlabel('f(x,y)');
colorbar;

% Subplot 3: Convergence plot
subplot(1,3,3)
semilogy(0:length(f_path)-1, abs(f_path-f_opt), 'b.-', 'MarkerSize', 15);
title('Convergence Plot');
xlabel('Iteration');
ylabel('Error (log scale)');
grid on;

% Add overall title
sgtitle('Newton-Raphson Optimization of Rosenbrock Function', 'FontSize', 14);

% Display results
fprintf('Optimization Results:\n');
fprintf('Optimal point: [%.6f, %.6f]\n', x_opt(1), x_opt(2));
fprintf('Optimal value: %.6f\n', f_opt);
fprintf('Number of iterations: %d\n', size(path,2)-1);

%% Animation of Optimization Process
figure('Position', [100 100 600 500]);
contour(X, Y, Z, 50);
hold on;
colorbar;
title('Newton-Raphson Optimization Process');
xlabel('x');
ylabel('y');
grid on;

h = plot(path(1,1), path(2,1), 'r.', 'MarkerSize', 20);
for i = 2:size(path,2)
    pause(0.5);  % Pause to show animation
    set(h, 'XData', path(1,1:i), 'YData', path(2,1:i));
    drawnow;
end
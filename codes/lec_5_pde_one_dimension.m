% Solve 1D Heat Equation: du/dt = alpha * d^2u/dx^2
% Using explicit finite difference method

% Parameters
L = 1;          % Length of domain
Nx = 50;        % Number of spatial points
dx = L/Nx;      % Spatial step size
x = 0:dx:L;     % Spatial grid

T = 10;        % Total simulation time
alpha = 0.5;   % Thermal diffusivity
dt = 0.3*dx^2/alpha;  % Time step (chosen for stability)
Nt = ceil(T/dt);     % Number of time steps
t = 0:dt:T;     % Time grid

% Initialize temperature field (initial condition: Gaussian pulse)
u = zeros(Nx+1, Nt+1);
u(:,1) = exp(-(x-L/2).^2/0.1);  % Initial condition

% Boundary conditions (fixed temperature at ends)
u(1,:) = 0;     % Left boundary
u(end,:) = 0;   % Right boundary

% Main time-stepping loop
figure('Position', [100 100 800 400]);
for n = 1:Nt
    % Compute spatial second derivative
    for i = 2:Nx
        % Explicit scheme
        u(i,n+1) = u(i,n) + alpha*dt/dx^2 * ...
                   (u(i+1,n) - 2*u(i,n) + u(i-1,n));
    end
    
    % Plot every 10 time steps
    if mod(n,10) == 0
        % Create subplot for temperature profile
        subplot(1,2,1)
        plot(x, u(:,n), 'b-', 'LineWidth', 2)
        hold on
        plot(x, u(:,1), 'r--', 'LineWidth', 1)
        hold off
        xlabel('Position (x)')
        ylabel('Temperature (u)')
        title(sprintf('Time: %.3f s', t(n)))
        legend('Current', 'Initial')
        axis([0 L 0 1.2])
        grid on
        
        % Create subplot for temperature evolution (heat map)
        subplot(1,2,2)
        imagesc(t(1:n), x, u(:,1:n))
        xlabel('Time (s)')
        ylabel('Position (x)')
        title('Temperature Evolution')
        colorbar
        
        drawnow
    end
end

% Display final time
disp(['Simulation completed. Final time: ' num2str(T) ' seconds'])
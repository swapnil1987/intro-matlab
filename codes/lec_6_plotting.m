function createPublicationPlot(data)
    % Sample data structure assumption
    % data should be a table/struct with fields:
    % - predicted_popdens
    % - female_rural
    % - asia (0 or 1)
    % - iso3 (country codes)

    % Set figure size and properties
    fig = figure('Position', [100 100 800 600]);
    hold on;
    
    % Separate data by region
    asia_idx = data.asia == 1;
    africa_idx = data.asia == 0;
    
    % Plot scatter points
    scatter(data.predicted_popdens(africa_idx), data.female_rural(africa_idx), 100, 'r', ...
        'filled', 'Marker', 'o', 'DisplayName', 'Sub-Saharan Africa');
    scatter(data.predicted_popdens(asia_idx), data.female_rural(asia_idx), 100, 'k', ...
        'filled', 'Marker', 's', 'DisplayName', 'South and South East Asia');
    
    % Fit and plot trend lines
    % For Africa
    p_africa = polyfit(data.predicted_popdens(africa_idx), data.female_rural(africa_idx), 1);
    x_africa = linspace(min(data.predicted_popdens(africa_idx)), max(data.predicted_popdens(africa_idx)), 100);
    y_africa = polyval(p_africa, x_africa);
    plot(x_africa, y_africa, 'r-', 'LineWidth', 2, 'HandleVisibility', 'off');
    
    % For Asia
    p_asia = polyfit(data.predicted_popdens(asia_idx), data.female_rural(asia_idx), 1);
    x_asia = linspace(min(data.predicted_popdens(asia_idx)), max(data.predicted_popdens(asia_idx)), 100);
    y_asia = polyval(p_asia, x_asia);
    plot(x_asia, y_asia, 'k--', 'LineWidth', 2, 'HandleVisibility', 'off');
    
    % Highlight India
    india_idx = strcmp(data.iso3, 'IND');
    if any(india_idx)
        scatter(data.predicted_popdens(india_idx), data.female_rural(india_idx), 100, 'b', ...
            'filled', 'Marker', 's', 'DisplayName', 'India');
        text(data.predicted_popdens(india_idx), data.female_rural(india_idx), ' India', ...
            'FontSize', 12, 'VerticalAlignment', 'bottom');
    end
    
    % Customize the plot
    box off;
    ax = gca;
    ax.LineWidth = 1;
    ax.FontSize = 12;
    ax.TickDir = 'out';
    
    % Add labels and title
    xlabel('log population density', 'FontSize', 12);
    ylabel('rural female labor force non-participation', 'FontSize', 12);
    
    % Customize legend
    legend('Location', 'northwest', 'Box', 'off', 'FontSize', 12);
    
    % Remove top and right borders
    ax.Box = 'off';
    ax.XAxis.LineWidth = 1;
    ax.YAxis.LineWidth = 1;
    
    % Remove minor grid lines
    ax.MinorGridLineStyle = 'none';
    
    % Adjust plot margins
    ax.TightInset;
    set(gca, 'Position', [0.13 0.11 0.85 0.815]);
    
    % Set background color to white
    set(gcf, 'Color', 'w');
    
    %Save the figure in high resolution
    print(fig, 'publication_plot', '-dpng', '-r300');
end

% Example usage:

function demo()
    % Create sample data
    rng(1); % For reproducibility
    n_points = 30;
    
    % Sample data structure
    data = struct();
    data.predicted_popdens = randn(n_points, 1);
    data.female_rural = 0.3 * data.predicted_popdens + 0.5 + 0.1 * randn(n_points, 1);
    data.asia = [zeros(n_points/2, 1); ones(n_points/2, 1)];
    data.iso3 = cell(n_points, 1);
    data.iso3(:) = {'OTH'};
    data.iso3{15} = 'IND';
    
    % Create the plot
    createPublicationPlot(data);
end

% Run the demo
demo();
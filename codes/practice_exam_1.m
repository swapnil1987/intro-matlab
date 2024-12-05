%% Practice Exam: Market Equilibrium Analysis
% Problem: Find the market equilibrium price and quantity where supply equals demand
% using Newton-Raphson method, then analyze price elasticity of demand at different points

function marketAnalysis()
    % Initialize structure to store market data
    market = struct();
    market.initial_price = 10;
    market.prices = 1:50;  % Range of prices to analyze
    
    % Market parameters stored in structure
    market.params = struct();
    market.params.demand = struct('a', 100, 'b', 1.5);  % Q_d = a - b*P
    market.params.supply = struct('c', 2, 'd', 2);      % Q_s = c + d*P
    
    % Part 1: Find Market Equilibrium (25 points)
    % Using Newton-Raphson to find equilibrium price
    [equil_price, iterations, conv_history] = findEquilibrium(market);
    
    % Part 2: Calculate Quantities (15 points)
    equil_demand = demandFunction(equil_price, market.params.demand);
    equil_supply = supplyFunction(equil_price, market.params.supply);
    
    % Part 3: Generate and Store Price-Quantity Data (20 points)
    market.results = calculateMarketData(market);
    
    % Part 4: Calculate Price Elasticity (20 points)
    elasticities = calculateElasticities(market.results);
    
    % Part 5: Visualization (20 points)
    plotResults(market, equil_price, equil_demand, conv_history, elasticities);
end

function [equil_price, iterations, conv_history] = findEquilibrium(market)
    % Newton-Raphson implementation to find equilibrium price
    max_iter = 100;
    tolerance = 1e-6;
    price = market.initial_price;
    conv_history = zeros(max_iter, 1);
    
    for i = 1:max_iter
        % Excess demand function and its derivative
        excess = excessDemand(price, market.params);
        excess_prime = excessDemandDerivative(market.params);
        
        % Store current price in history
        conv_history(i) = price;
        
        % Newton-Raphson step
        new_price = price - excess/excess_prime;
        
        % Check convergence
        if abs(new_price - price) < tolerance
            equil_price = new_price;
            iterations = i;
            conv_history = conv_history(1:i);
            return
        end
        
        price = new_price;
    end
    
    error('Failed to converge within maximum iterations');
end

function excess = excessDemand(price, params)
    % Calculate excess demand at given price
    demand = demandFunction(price, params.demand);
    supply = supplyFunction(price, params.supply);
    excess = demand - supply;
end

function derivative = excessDemandDerivative(params)
    % Derivative of excess demand function
    derivative = -params.demand.b - params.supply.d;
end

function demand = demandFunction(price, params)
    % Linear demand function
    demand = params.a - params.b * price;
end

function supply = supplyFunction(price, params)
    % Linear supply function
    supply = params.c + params.d * price;
end

function results = calculateMarketData(market)
    % Calculate and store supply and demand for different prices
    results = struct();
    results.prices = market.prices;
    results.demand = zeros(size(market.prices));
    results.supply = zeros(size(market.prices));
    
    for i = 1:length(market.prices)
        results.demand(i) = demandFunction(market.prices(i), market.params.demand);
        results.supply(i) = supplyFunction(market.prices(i), market.params.supply);
    end
end

function elasticities = calculateElasticities(results)
    % Calculate price elasticity of demand at each point
    elasticities = zeros(length(results.prices)-1, 1);
    
    for i = 1:length(results.prices)-1
        % Arc elasticity formula
        p1 = results.prices(i);
        p2 = results.prices(i+1);
        q1 = results.demand(i);
        q2 = results.demand(i+1);
        
        % Calculate arc elasticity
        elasticities(i) = ((q2-q1)/(q2+q1)) / ((p2-p1)/(p2+p1));
    end
end

function plotResults(market, equil_price, equil_quantity, conv_history, elasticities)
    figure('Position', [100, 100, 1200, 800]);
    
    % Plot 1: Supply and Demand Curves
    plot(market.results.demand, market.prices, 'b-', 'LineWidth', 2)
    hold on
    plot(market.results.supply, market.prices, 'r-', 'LineWidth', 2)
    plot(equil_quantity, equil_price, 'ko', 'MarkerSize', 10)
    xlabel('Quantity')
    ylabel('Price')
    title('Supply and Demand Curves')
    legend('Demand', 'Supply', 'Equilibrium')
    grid on
    
   
end
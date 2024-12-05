%% Examples of Recursion in MATLAB

% Example 1: Factorial calculation
function fact = factorial_recursive(n)
    if n == 0 || n == 1
        fact = 1;
    else
        fact = n * factorial_recursive(n-1);
    end
end

% Example 2: Fibonacci sequence
function fib = fibonacci_recursive(n)
    if n <= 2
        fib = 1;
    else
        fib = fibonacci_recursive(n-1) + fibonacci_recursive(n-2);
    end
end

% Example 3: Binary Search
function index = binary_search_recursive(arr, target, left, right)
    if left > right
        index = -1;
        return;
    end
    
    mid = floor((left + right)/2);
    
    if arr(mid) == target
        index = mid;
    elseif arr(mid) > target
        index = binary_search_recursive(arr, target, left, mid-1);
    else
        index = binary_search_recursive(arr, target, mid+1, right);
    end
end

% Example 4: Tower of Hanoi
function tower_of_hanoi(n, source, auxiliary, target)
    if n == 1
        fprintf('Move disk 1 from %s to %s\n', source, target);
        return;
    end
    
    tower_of_hanoi(n-1, source, target, auxiliary);
    fprintf('Move disk %d from %s to %s\n', n, source, target);
    tower_of_hanoi(n-1, auxiliary, source, target);
end

% Example 5: Sum of Array Elements
function sum = array_sum_recursive(arr, n)
    if n <= 0
        sum = 0;
    else
        sum = array_sum_recursive(arr, n-1) + arr(n);
    end
end

% Example usage and visualization
function demonstrate_recursion()
    % Factorial demonstration
    n = 5;
    fprintf('Factorial of %d is %d\n', n, factorial_recursive(n));
    
    % Fibonacci demonstration
    fib_nums = zeros(1, 10);
    for i = 1:10
        fib_nums(i) = fibonacci_recursive(i);
    end
    figure('Name', 'Fibonacci Sequence');
    plot(1:10, fib_nums, 'bo-', 'LineWidth', 2);
    title('First 10 Fibonacci Numbers');
    grid on;
    
    % Binary Search demonstration
    arr = sort(randi([1 100], 1, 20));
    target = arr(randi([1 20]));
    result = binary_search_recursive(arr, target, 1, length(arr));
    fprintf('Found %d at index %d\n', target, result);
    
    % Tower of Hanoi demonstration
    fprintf('\nTower of Hanoi with 3 disks:\n');
    tower_of_hanoi(3, 'A', 'B', 'C');
    
    % Array sum demonstration
    test_arr = 1:5;
    sum = array_sum_recursive(test_arr, length(test_arr));
    fprintf('\nSum of array elements: %d\n', sum);
end


demonstrate_recursion()
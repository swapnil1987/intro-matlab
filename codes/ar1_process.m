
%function for the AR(1) process
function Y = ar1_process(parameter)
    Y = zeros(parameter.N,1) * NaN;
    Y(1) = parameter.initial_Y;
    for i = 2:parameter.N
        epsilon = parameter.sigma*randn(1);
        Y(i) = parameter.rho * Y(i-1) + epsilon;
    end %end for i

    disp(parameter.print_statement)
end %end function ar1_process

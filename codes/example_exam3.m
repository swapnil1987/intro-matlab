%y_t = \rho * y_{t-1} + \epsilon_t
clc
clear all
close all


%size of the vector
N = 100;

%storage of the vector
Y = zeros(N,1);
Y(1) = 3;
%standard deviation of the error term
sigma = 3;
rho = 1;



%inline function
y_present = @(y_past, rho, sigma) rho * y_past + sigma * randn(1);


%for i = 2:N
%    Y(i) = y_present(Y(i-1), rho, sigma);
%end %end for

i = 2;
while true

    Y(i) = y_present(Y(i-1), rho, sigma);

    i = i + 1;

    if i > N
        break;
    end

end %end while




plot((1:N), Y)




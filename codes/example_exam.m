%  plot a AR(1) process


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

%for loop for populating the AR(1) process
for i = 2:N
    epsilon = sigma*randn(1);

    Y(i) = rho * Y(i-1) + epsilon;
end %end of for loop 

plot((1:N), Y)







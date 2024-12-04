%generate AR(1) process through a function

clc;
clear all;
close all;


p.rho = 0.9;
p.sigma = 0.1;
p.initial_Y = 2;
p.N = 100;
p.print_statement = 'everyone finds this tough';

Y = ar1_process(p);


plot((1:p.N), Y)


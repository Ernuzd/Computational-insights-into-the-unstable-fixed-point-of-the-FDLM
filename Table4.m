clear all; close all; clc;

%set N=1,2,...,9
for N = 1:9
    disp(N);
    %Initialize all variables
    a=[]; 
    x_star =[];
    x_step_temp = [];
    x_step_temp_1 = [];
    x_step=[];

    %Generate all possible floating-point representations of a $\in$ (3,4]
    a = (3+10^(-N+1)):10^(-N+1):4; 

    %Compute the corresponding value of $\widetilde{x}_*$
    x_star = round(1-round(1./a,N,"significant"),N,"significant");

    %Set initial condition $x_0 =\widetilde{x}_*$ and compute $\widetilde{x}_1$ 
    %by executing a single iteration of the logistic map in the floating-point 
    %arithmetic at given $N$.
    x_step_temp = round(1-x_star,N,"significant");
    x_step_temp_1 = round(a.*x_star,N,"significant");
    x_step = round(x_step_temp_1.*x_step_temp,N,"significant");

    %Compare $\widetilde{x}_1$ and $\widetilde{x}_*$ and compute the ratio
    %$\rho(N)$
    frac(N) = sum(x_star==x_step)/length(a)*100; 
end
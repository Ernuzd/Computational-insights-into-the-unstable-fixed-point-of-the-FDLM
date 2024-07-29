clear all; close all; clc;

%set N=2,...,9
for N = 2:9
    disp(N);
    clearvars -except N frac_1
    
    %Generate all possible floating-point representations of a
    a = round((1+sqrt(6)),N,"significant"):10^(-N+1):4;
    
    %Compute the corresponding value of $\widetilde{x}_{*U}$
    x_star_temp_1 = round(a/2,N,"significant");
    x_star_temp_2 = round(a.^2,N,"significant");
    x_star_temp_3 = round(2*a,N,"significant");
    x_star_temp_4a = round(x_star_temp_2 - x_star_temp_3,N,"significant");
    x_star_temp_4 = round(x_star_temp_4a - 3,N,"significant");
    x_star_temp_5 = round(sqrt(x_star_temp_4),N,"significant");
    x_star_temp_6 = round(x_star_temp_5/2,N,"significant");
    x_star_temp_7a = round(x_star_temp_1 + 0.5,N,"significant");
    x_star_temp_7 = round(x_star_temp_7a + x_star_temp_6,N,"significant");
    x_star = round(x_star_temp_7./a,N,"significant");
    
    %Set initial condition $x_{0U} =\widetilde{x}_{*U}$ and compute $\widetilde{x}_{2U}$ 
    %by executing two iterations of the logistic map in the floating-point 
    %arithmetic at given $N$ starting from initial condition $x_{0U}$.
    x_step_1_temp = round(1-x_star,N,"significant");
    x_step_1_temp_1 = round(a.*x_star,N,"significant");
    x_step_1 = round(x_step_1_temp_1.*x_step_1_temp,N,"significant");

    x_step_2_temp = round(1-x_step_1,N,"significant");
    x_step_2_temp_1 = round(a.*x_step_1,N,"significant");
    x_step_2 = round(x_step_2_temp_1.*x_step_2_temp,N,"significant");
   
    %Compare $\widetilde{x}_{2U}$ and $x_{0U}$ and compute the ratio
    %$\rho_U(N)$
    frac_1(N) = sum(x_star==x_step_2)/length(a)*100; 
end

%Repeat the same steps for the lower branch of the period-2 orbit
clearvars -except frac_1
for N = 2:9
    disp(N);
    clearvars -except N frac_2  frac_1

    a = round((1+sqrt(6)),N,"significant"):10^(-N+1):4;

    x_star_temp_1 = round(a/2,N,"significant");
    x_star_temp_2 = round(a.^2,N,"significant");
    x_star_temp_3 = round(2*a,N,"significant");
    x_star_temp_4a = round(x_star_temp_2 - x_star_temp_3,N,"significant");
    x_star_temp_4 = round(x_star_temp_4a - 3,N,"significant");
    x_star_temp_5 = round(sqrt(x_star_temp_4),N,"significant");
    x_star_temp_6 = round(x_star_temp_5/2,N,"significant");
    x_star_temp_7a = round(x_star_temp_1 + 0.5,N,"significant");
    x_star_temp_7 = round(x_star_temp_7a - x_star_temp_6,N,"significant");
    x_star = round(x_star_temp_7./a,N,"significant");
    
    x_step_1_temp = round(1-x_star,N,"significant");
    x_step_1_temp_1 = round(a.*x_star,N,"significant");
    x_step_1 = round(x_step_1_temp_1.*x_step_1_temp,N,"significant");

    x_step_2_temp = round(1-x_step_1,N,"significant");
    x_step_2_temp_1 = round(a.*x_step_1,N,"significant");
    x_step_2 = round(x_step_2_temp_1.*x_step_2_temp,N,"significant");
   
    frac_2(N) = sum(x_star==x_step_2)/length(a)*100; 
end
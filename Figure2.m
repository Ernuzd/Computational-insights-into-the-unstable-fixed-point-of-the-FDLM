clear all; close all; clc;

%--------------------------------------------------------------------------
% This script changes all interpreters from text to latex. 
list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end
%--------------------------------------------------------------------------
%set the number of Monte Carlo trials to 10^7
trials = 10^7;

%set N=15
N=15;

for i = 1:trials
    if(mod(i,10^6) == 0)
        disp(i);
    end
    %Generate random a $\in$ (3,4] with N significant digits
    a(i) = rand() + 3;
    a(i) = round(a(i),N,"significant");

    %Compute the corresponding value of $\widetilde{x}_*$
    x_star(i) = round(1-1/a(i),N,"significant");

    %Set initial condition $x_0 =\widetilde{x}_*$ and compute $\widetilde{x}_1$ 
    %by executing a single iteration of the logistic map in the floating-point 
    %arithmetic at given $N$.
    x_step_temp(i) = round(1-x_star(i),N,"significant");
    x_step_temp_1(i) = round(a(i).*x_star(i),N,"significant");
    x_step(i) = round(x_step_temp_1(i).*x_step_temp(i),N,"significant");
end
%Divide the interval $(3,4]$ into 100 equal sub-intervals and compute the 
%ratio $\rho_k(15)$ for each subinterval. 
%Plot the distribution of $\rho_k(15)$ in $(3,4]$.
bool_a = x_star==x_step;
a_0 = a(bool_a==0);
a_1 = a(bool_a==1);
x_star_0 = x_star(bool_a==0);
x_star_1 = x_star(bool_a==1);
frac = sum(bool_a)/length(a)*100; 

[counts1,centers1] = hist(a_1,100);
[counts0,centers0] = hist(a_0,100);
frac_hist = (counts1./(counts1+counts0))*100;
figure();
hold on
plot([3,4],[frac,frac],'r:','LineWidth',2);
for i = 1:length(counts1)
    plot([centers1(i)-0.004,centers1(i)+0.004],[frac_hist(i),frac_hist(i)],'k-','LineWidth',2);
end

xlabel('$a$');
ylabel('$\rho_k(15)$');
set(findall(gcf,'-property','FontSize'),'FontSize',30);
axis tight
ylim([0,40]);
xlim([3,4]);

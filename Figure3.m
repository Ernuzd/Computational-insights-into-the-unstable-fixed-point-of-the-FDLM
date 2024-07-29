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
figure();
%set the number of Monte Carlo trials to 10^7
trials = 10^7;
%set N=15
N=15;

%Generate random a $\in (1+\sqrt{6},4]$ with N significant digits
a = (1+sqrt(6)) + (4-(1+sqrt(6))).*rand(trials,1);
a = round(a,N,"significant");

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

%Divide the interval $(1+\sqrt{6},4]$ into 100 equal sub-intervals and compute the 
%ratio $\rho_{kU}(15)$ for each subinterval. 
%Plot the distribution of $\rho_{kU}(15)$ in $(1+\sqrt{6},4]$.
bool_a = x_star==x_step_2;
a_0 = a(bool_a==0);
a_1 = a(bool_a==1);
x_star_rounded_0 = x_star(bool_a==0);
x_star_rounded_1 = x_star(bool_a==1);
frac = sum(bool_a)/length(a)*100;

subplot(1,2,1); hold on;
[counts1,centers1] = hist(a_1,100);
[counts0,centers0] = hist(a_0,100);

frac_hist = (counts1./(counts1+counts0))*100;
hold on
plot([3,4],[frac,frac],'r:','LineWidth',2);
for i = 1:length(counts1)
    plot([centers1(i)-0.004,centers1(i)+0.004],[frac_hist(i),frac_hist(i)],'k-','LineWidth',2);
end
xlabel({'$a$';'(a)'});
ylabel('$\rho_{kU}(15)$');
set(findall(gcf,'-property','FontSize'),'FontSize',30);
axis tight
ylim([0,15]);
xlim([1+sqrt(6),4]);

%Repeat the same steps for the lower branch of the period-2 orbit
clear all;

trials = 10^7;
N=15;

a = (1+sqrt(6)) + (4-(1+sqrt(6))).*rand(trials,1);
a = round(a,N,"significant");

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

bool_a = x_star==x_step_2;
a_0 = a(bool_a==0);
a_1 = a(bool_a==1);
x_star_rounded_0 = x_star(bool_a==0);
x_star_rounded_1 = x_star(bool_a==1);
frac = sum(bool_a)/length(a)*100;

subplot(1,2,2); hold on;
[counts1,centers1] = hist(a_1,100);
[counts0,centers0] = hist(a_0,100);

frac_hist = (counts1./(counts1+counts0))*100;
hold on
plot([3,4],[frac,frac],'r:','LineWidth',2);
for i = 1:length(counts1)
    plot([centers1(i)-0.004,centers1(i)+0.004],[frac_hist(i),frac_hist(i)],'k-','LineWidth',2);
end
xlabel({'$a$';'(b)'});
ylabel('$\rho_{kL}(15)$');
set(findall(gcf,'-property','FontSize'),'FontSize',30);
axis tight
ylim([0,15]);
xlim([1+sqrt(6),4]);

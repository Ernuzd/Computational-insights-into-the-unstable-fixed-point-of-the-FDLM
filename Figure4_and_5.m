clear; close all; clc;
%--------------------------------------------------------------------------
% This script changes all interpreters from text to latex. 
list_factory = fieldnames(get(groot,'factory'));
index_interpreter = find(contains(list_factory,'Interpreter'));
for i = 1:length(index_interpreter)
    default_name = strrep(list_factory{index_interpreter(i)},'factory','default');
    set(groot, default_name,'latex');
end
%--------------------------------------------------------------------------

rng('default'); %Setting the default RNG seed;
a_numpoints = 10000; %Number of a values used;
a_bounds = exp([0, 3.7]); %Parameter a lowest and highest values;
a_step = (a_bounds(2)-a_bounds(1))/a_numpoints; %Step size for parameter a values;
a_set =  a_bounds(1):a_step:a_bounds(2); %Parameter a value vector with a_numpoints points
scale = 1000; %Rounding parameter;
maxpoints = 100; %Number of points plotted;
n = 500; %Number of points in the calculated trajectory of the fractional difference logistic map;
nu = 0.8; %Fractionality parameter nu (often denoted as alpha);
%% Plotting Figure 4

figure(); hold on;

for j = 1:length(a_set)
    disp(j);
    r = a_set(j);
    x0 = 0.91882401326391849317; %Initial condition x_0;
    x = Fractional_logistic_seq(x0, log(r), nu, n-1);
    x = [x0 x];
    out{j} = unique(round(scale*x(end - maxpoints:end)))/scale; %Bifurcation graph values with rounding (so similar values are shown as the same value)
    plot(r*ones(size(out{j})),out{j},'k.','Color',[0.5 0.5 0.5]); %Plotting the bifurcation points;
end

xticks([exp(0),exp(1),exp(2),exp(3),exp(3.7)]);
xticklabels([0,1,2,3,3.7]);
yticks([0 0.5 1]);
yticklabels({'0' '0.5' '1'});
ylim([0 1]);
xlim([exp(0),exp(3.7)]);
xlabel('$a$', 'Interpreter','latex');
ylabel('$x_{k}$', 'Interpreter','latex');
%Type-1 and Type-2

N = 600;
n = 15;

for i = 1:N
    a(i) = rand() + 2.75; %A value calculations with random values;
    a(i) = round(a(i),n,"significant"); %Rounding the value a to the significant part of the number;
    x_star(i) = round(1-1/a(i),n,"significant");
    x_step_temp(i) = round(1-x_star(i),n,"significant");
    x_step_temp_1(i) = round(a(i).*x_star(i),n,"significant");
    x_step(i) = round(x_step_temp_1(i).*x_step_temp(i),n,"significant"); %Steps done to calculate the next value rounded to the 15 significant digits;
end

bool_a = x_star==x_step; %Conditional vector to find values that stay within the fixed point;
a_0 = a(bool_a==0);
a_1 = a(bool_a==1);
x_star_0 = x_star(bool_a==0);
x_star_1 = x_star(bool_a==1); %Separating the values that remain in the fixed point (1) from ones that do not (0);
frac = sum(bool_a)/length(a)*100; %Calculating the percentage of how many values remain in the fixed point

plot(exp(a_1), x_star_1,'r.'); %Plotting the values that remain in the period-1 fixed point with red dots;

set(findall(gcf,'-property','FontSize'),'FontSize',28);
set(gcf, 'WindowState', 'maximized');

%% 2nd visualization for showcasing 2 similar initial conditions that theoretically both should stay at one value but do not due to rounding.
%Plotting Figure 5
order = [1:N; a; bool_a];
order = sortrows(order', 2, "ascend");
order_unrounded = order;

n_len = 500; %Length of the calculated trajectory;
good = 329; %Index of the initial condition x_0 whose trajectory stays in the fixed point;
bad = 21; %Index of the initial condition x_0 whose trajectory does not stay in the fixed point;
a_good = a(good); %Value of the initial condition whose trajectory does not stay in the fixed point;
a_bad = a(bad); %Index of the initial condition whose trajectory does not stay in the fixed point;
a_good = 0.340685989097371e1; %0.337797335919011e1; 
a_bad = 0.3405740699156590e1; %0.337789637961417e1;


%[val, ind] = min(abs(exp(a) - 29.3113)); %Minimum absolute differences

x_good = [x_star(good), Fractional_logistic_seq(x_star(good), a_good, nu, n_len)]; %Calculating the trajectory that stays in the fixed point using initial condition a value a_good;
x_bad =  [x_star(bad), Fractional_logistic_seq(x_star(bad), a_bad, nu, n_len)]; %Calculating the trajectory that does not stay in the fixed point using initial condition a value a_bad;
x_star_good = 0.706474574240800e+00;
x_star_bad =  0.706378116147350e+00;

figure() %Plotting these trajectories in 2 separate subplots;

subplot(2, 1, 1)
plot(x_good, 'LineStyle','-', 'Color',[0 0 0], 'Marker','o', 'MarkerFaceColor',[0 0 0], 'LineWidth',2);
xlabel({'$k$', '$a)$'}, 'Interpreter','latex');
ylabel('$x_{k}$', 'Interpreter','latex');
% yticks([0 0.5 1]);
xlim([0 501]);
ylim([0 1]);

subplot(2, 1, 2)
plot(x_bad, 'LineStyle','-', 'Color',[0 0 0], 'Marker','o', 'MarkerFaceColor',[0 0 0], 'LineWidth',2);
xlabel({'$k$', '$b)$'}, 'Interpreter','latex');
ylabel('$x_{k}$', 'Interpreter','latex');
yticks([0 0.2 0.4 0.6 0.8 1]);
xlim([0 501])
ylim([0 1])

set(findall(gcf,'-property','FontSize'),'FontSize',34);

a_unrounded = a;
a_0_unrounded = a_0;
a_1_unrounded = a_1;

set(gcf, 'WindowState', 'maximized');

%% -----Functions-----

function [x] = Fractional_logistic_seq(x0,a,nu,n)
%Fractional difference logistic map trajectory calculations
%x0 - initial condition x0
%a - parameter a value
%nu - parameter nu (fractional model order) value
%n - iteration step count

    g = G_coeffs(nu,n);
    g0 = 1;
    
    x(1) = x0 + a * x0*(1-x0) - x0 ;
    
    for k = 2:n
        
        gx = g0 * (a * x(k-1)*(1-x(k-1)) - x(k-1));
        for j = 2:k-1
            gx = gx + g(j-1) * (a*x(k-j)*(1-x(k-j)) - x(k-j));
        end
        gx = gx + g(k-1) * (a*x0*(1-x0) - x0);
        
        x(k)= x0 + gx;
        
    end
end

function g = G_coeffs(nu,n)
%Coefficient G1, G2, G3,..., Gn calculation
%nu - parameter nu (fractional model order) value
%n - iteration step count

    g = zeros(n,1);
    g(1) = nu;
    
    for j=2:n
        g(j) = (1-(1-nu)/j)*g(j-1);
    end
end



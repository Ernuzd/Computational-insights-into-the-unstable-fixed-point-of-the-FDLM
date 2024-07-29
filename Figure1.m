clear; close all; clc;

%Parameter initialization;
nu = 0.8; %Fractionality parameter;
a_numpoints = 10000; %Number of points for the parameter a range;
a_bounds = exp([0, 4]); %Parameter a min and max values;
scale = 1000; %Rounding parameter;
maxpoints = 200; %Maximum number of points shown in plot;
n = 500; %Length of the classical logistic map's trajectory;
x0 = 0.91882401326391849317; %Initial condition x_0;
tx = exp([0 1 3 3.4495 4]); %Vector for different a value tick labels;
[a_step, a_set, data] = classic_bifurcation_calc(a_numpoints, a_bounds, scale, maxpoints, n, x0); %Calculating the classical logistic map's values and parameter a step size;
%% Classic logistic map's bifurcation graph
col = [0.5 0.5 0.5];
hold on
fract_bifurcation_graph_only(a_step, a_set, data, scale, tx, col);%Plotting the classic logistic map's bifurcation diagram;
%%
a_start = exp(0);
a_end = exp(4);
a_step = (a_end - a_start)/a_numpoints;
[x_upper, x_lower] = bifurcation_branch_calc_period2(a_start, a_step, a_end); %Calculating the values of the unstable period-2 orbit;
x_middle = bifurcation_branch_calc_period1(exp(0), a_step,exp(4)); %Calculating the values of the unstable period-1 orbit;
%%
%Plotting the 3 unstable period orbits on top of the bifurcation diagram;
hold on

a_exp_set = a_start:a_step:a_end;
[minval3, minind3] = min(abs(exp(3) - a_exp_set));
[minvalsqrt6, minindsqrt6] = min(abs(exp(1+sqrt(6)) - a_exp_set));


plot(a_set(minindsqrt6:length(x_upper)), x_upper(minindsqrt6:length(x_upper)), 'r-', 'LineWidth',4);
plot(a_set(minindsqrt6:length(x_lower)), x_lower(minindsqrt6:length(x_lower)), 'r-', 'LineWidth',4);
plot(a_set(minind3:length(x_middle)), x_middle(minind3:length(x_middle)), 'b-', 'LineWidth',4);
hold off
%% --------Functions-------
function [x] = Classic_logistic_seq(x0,a,n)
    %Classic (non-fractional) logistic map calculation
    %x0 - initial condition
    %a - parameter a value
    %n - iteration step count
    
    x(1) = x0;
    
    for i = 1:n
        x(i+1) = a*x(i)*(1-x(i));
    end

end


function [a_step, a_set, data] = classic_bifurcation_calc(a_numpoints, a_bounds, scale, maxpoints, n, x0)
%Calculating the classic logistic map's bifurcation diagram
    a_step = (a_bounds(2)-a_bounds(1))/a_numpoints;
    a_set =  a_bounds(1):a_step:a_bounds(2);
    
    for j = 1:length(a_set)
        disp(j);
        r=a_set(j);
        x = Classic_logistic_seq(x0, log(r), n-1);
    %     x = Fractional_logistic_seq(x0, log(r), nu, n-1);
        x = [x0 x];
        out{j} = unique(round(scale*x(end-maxpoints:end)));
    end
    
    data = [];
    for k = 1:length(a_set)
        nn = length(out{k});
        data = [data;  k*ones(nn,1), out{k}'];
    end
end

function fract_bifurcation_graph_only(a_step, a_set, data, scale, tx, col)
%Calculating selected map's bifurcation diagram.
    h=scatter(a_set(data(:,1)),data(:,2)/scale,1,'Marker','.','MarkerFaceColor', col, 'MarkerEdgeColor',col);
    set(gca, 'TickLabelInterpreter', 'latex');
    axis tight
    %txi = round((tx-tx(1))/a_step)+1;
    xticks(tx);
    xticklabels({'$0$','$1$','$2$','$3$','$4$'});
    xlabel('$a$', 'Interpreter','latex');
    yticks([0 0.5 1]);
    ylim([0 1]);
    yticklabels({'0', '0.5','1'});
    ylabel('$x_k$', 'Interpreter','latex');
    set(gca,'fontsize',24);
end

function [x_upper, x_lower] = bifurcation_branch_calc_period2(a_start, a_step, a_end)
%Calculating unstable period-2 values
    a = a_start:a_step:a_end;
    x_upper = zeros(1,length(a));
    x_lower = zeros(1,length(a));
    for j = 1:length(a)
        x_upper(j) = (log(a(j))+1+sqrt(log(a(j))*log(a(j))-2*log(a(j))-3))/(2*log(a(j)));
        x_lower(j) = (log(a(j))+1-sqrt(log(a(j))*log(a(j))-2*log(a(j))-3))/(2*log(a(j)));
    end
end

function x_middle = bifurcation_branch_calc_period1(a_start, a_step, a_end)
%Calculating unstable period-1 values
    a = a_start:a_step:a_end;
    x_middle = zeros(1,length(a));
    for j = 1:length(a)
        x_middle(j) = 1-1/log(a(j));
    end
end
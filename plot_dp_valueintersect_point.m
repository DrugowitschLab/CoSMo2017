function plot_dp_valueintersect_point(mu0, c)
%% plots example value functions and where Vd and Ve intersect
%
% The function computes the value function for point hypotheses and plot
% the value function for accumulating more evidence and for deciding
% immediately, showing their intersection points.
%
% mu0 and c are the momentary evidence drift and evidence accumulation
% cost, respectively. If not given, they are set to mu0 = 1 and c = 0.2.

%% settings
% momentary evidence drift
if nargin < 1, mu0 = 1; end
% evidence accumulation cost
if nargin < 2, c = 0.2; end
% discretisation of belief (coarse, as only for illustraction purposes)
ng = 100;
% time-step for belief transition (large for illustration purposes)
dt = 0.2;


%% compute values and point where they intersect
gs = dp_discretized_g(ng);
[Vd, Ve] = dp_value_iteration_point_hyp(gs, dt, mu0, c);
g = dp_valueintersect(gs, Vd, Ve);


%% plot results
figure('Color', 'white');  hold on;
xlim([0 1]);  ylim([0 1]);
% plot values
plot(gs, Vd, 'LineWidth', 3, 'Color', [0.8 0 0]);
plot(gs, Ve, 'LineWidth', 3, 'Color', [0 0 0.8]);
% plot intersection
plot([1 1] * g, ylim, 'LineWidth', 1, 'Color', [1 1 1] * 0.5);
plot([1 1] * (1-g), ylim, 'LineWidth', 1, 'Color', [1 1 1] * 0.5);
legend('max(g, 1-g)', '<V> - c dt', 'Location', 'SouthEast');
xlabel('belief g');
ylabel('value');
set(gca,'Layer','top','Box','off','PlotBoxAspectRatio',[1,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02);

function plot_dp_valueintersect_gauss(sigmu2, c, t)
%% plots an example of a value function and the associated bound
%
% sigmu2 is the overall task difficulty (variance of prior on mu), c is the
% evidence accumulation cost, and t is the time until which the values are
% to be computed. The function computes until 5*t that time, but only
% displays the value function / bounds until t.
%
% If not given, the arguments default to sig2 = 1, c = 0.1, and t = 3.
%
% Jan Drugowitsch, July 2017


%% settings
if nargin < 1, sigmu2 = 1; end;      % task difficulty
if nargin < 2, c = 0.1; end;         % cost for accumulating evidence
if nargin < 3, t = 3; end            % time-frame of interest
ng = 100;                            % belief discretization (coarse)
dt = 0.01;                           % time discretization
t = ceil(t / dt) * dt;               % round up t to fit the discretisation
T = 5 * t;                           % compute value until time T
% plot colors
Ve_col = [0 0 0.8];
Vd_col = [0.8 0 0];


%% compute the value function
gs = dp_discretized_g(ng);
[Vd, Ve] = dp_getvalues_gauss_hyp(gs, dt, T, sigmu2, c);
% the actual value function is the maximum of Vd and Ve for each time-step
%V = bsxfun(@max, Vd, Ve); %- not required for plotting


%% compute the resulting bounds in belief
g_bound = NaN(1, size(Ve, 1));
for i = 1:length(g_bound)
    g_bound(i) = dp_valueintersect(gs, Vd, Ve(i,:));
end


%% plot value function
figure('Color', 'white');  hold on;
nt = ceil(t / dt);  ts = dt * (0:(nt-1));
% Value functions for accumulating more reward and for immediate decisions
surf(gs, ts, Ve(1:nt,:), ones(nt,ng), ...
    'EdgeColor','none','FaceColor','flat','FaceAlpha',0.5,'CDataMapping','direct');
colormap([Ve_col; Vd_col]);
surf(gs, ts, repmat(Vd, nt, 1), 2*ones(nt,ng), ...
    'EdgeColor','none','FaceColor','flat','FaceAlpha',0.5,'CDataMapping','direct');
% resulting decision boundaries
plot3(g_bound(1:nt), ts, g_bound(1:nt), '-', 'Color', [1 1 1]*0.5, 'LineWidth',2);
plot3(1-g_bound(1:nt), ts, g_bound(1:nt), '-', 'Color', [1 1 1] * 0.5, 'LineWidth',2);
plot3(g_bound(1:nt), ts, zeros(1,nt), 'k-','LineWidth',2);
plot3(1-g_bound(1:nt), ts, zeros(1,nt), 'k-','LineWidth',2);
plot3(g_bound(1) * [1 1], [1 1] * ts(1), [0 g_bound(1)], 'k--');
plot3((1-g_bound(1)) * [1 1], [1 1] * ts(1), [0 g_bound(1)], 'k--');
plot3(g_bound(nt) * [1 1], [1 1] * ts(end), [0 g_bound(nt)], 'k--');
plot3((1-g_bound(nt)) * [1 1], [1 1] * ts(end), [0 g_bound(nt)], 'k--');
view(135,45);
ylabel('time');  xlabel('g');  zlabel('value');
title(sprintf('\\sigma_\\mu^2 = %.1f, c = %.2f', sigmu2, c));


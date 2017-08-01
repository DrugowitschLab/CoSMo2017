function plot_dp_diffusion_gauss(sigmu2, c, t)
%% plots an example trial diffusion in g and x
%
% sigmu2 is the overall task difficulty (variance of prior on mu), c is the
% evidence accumulation cost, and t is the maximum time until which the
% diffusion is being simulated. The value function and associated decision
% boundaries are copmuted until 5*t, but the decision boundaries are only
% displayed until t.
%
% If not given, the arguments default to sig2 = 1, c = 0.1, and t = 3.
%
% Jan Drugowitsch, July 2017


%% settings
if nargin < 1, sigmu2 = 0.8^2; end;      % task difficulty
if nargin < 2, c = 0.1; end;         % cost for accumulating evidence
if nargin < 3, t = 3; end            % time-frame of interest
ng = 100;                            % belief discretization (coarse)
dt = 0.01;                           % time discretization
t = ceil(t / dt) * dt;               % round up t to fit the discretisation
T = 5 * t;                           % compute value until time T
% belief values to plot and their color
plot_gs = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
g_cols = [0 0 0.8; 0.125 0.125 0.725; 0.25 0.25 0.65; 0.375 0.375 0.575; ...
          0.5 0.5 0.5; ...
          0.6 0.49 0.375; 0.7 0.48 0.25; 0.8 0.47 0.125; 0.9 0.45 0];
rng(7);


%% compute the value function and resulting decision boundaries
gs = dp_discretized_g(ng);
[Vd, Ve] = dp_getvalues_gauss_hyp(gs, dt, T, sigmu2, c);
% decision boundaries from value-function interaction
g_bound = NaN(1, size(Ve, 1));
theta = NaN(1, size(Ve, 1));
for i = 1:length(g_bound)
    g_bound(i) = dp_valueintersect(gs, Vd, Ve(i,:));
    % map bound in belief into bound in x,
    % x(t) = Phi^-1(g(t)) sqrt(sig_mu^-2 + t)
    theta(i) = norminv(g_bound(i)) * sqrt(1/sigmu2 + (i-1)*dt);
end


%% perform diffusion model simulation
nt = ceil(t / dt);  ts = dt * (0:(nt-1));
xs = NaN(1, nt);
xs(1) = 0;
dmu = dt * sqrt(sigmu2) * randn();   % draw drift according to prior
sqrtdt = sqrt(dt);                   % diffusion SD per step
for i = 2:nt
    % single dift/diffusion step
    xs(i) = xs(i-1) + dmu + sqrtdt * randn();
    % stop diffusion at bound
    if abs(xs(i)) > theta(i)
        xs(i) = sign(xs(i)) * theta(i);
        break
    end
end
% map diffusion path into belief
gxs = normcdf(xs ./ sqrt(1/sigmu2 + ts));


%% plot diffusion and bounds
figure('Color', 'white');  hold on;
plot(ts, xs, '-', 'Color', [1 1 1]*0.5, 'LineWidth', 1);
xlim([0 ts(end)]);
plot(ts, theta(1:nt), 'k-', 'LineWidth', 2);
plot(ts, -theta(1:nt), 'k-', 'LineWidth', 2);
ylims = ylim;  ylim(ylims);  % fix y-axis to current limits
for ig = 1:length(plot_gs)
    % map belief into x-space, using g = 1 / (1 + exp(-2 mu0 x))
    plot(ts, norminv(plot_gs(ig)) * sqrt(1/sigmu2 + ts), ...
         'Color', g_cols(ig,:));
end
xlabel('t');
ylabel('x(t)');

figure('Color', 'white');  hold on;
plot(ts, gxs, '-', 'Color', [1 1 1]*0.5, 'LineWidth', 1);
xlim([0 ts(end)]);  ylim([0 1]);
plot(ts, g_bound(1:nt), 'k-', 'LineWidth', 2);
plot(ts, 1-g_bound(1:nt), 'k-', 'LineWidth', 2);
for ig = 1:length(plot_gs)
    plot(xlim, plot_gs(ig)*[1 1], 'Color', g_cols(ig,:));
end
xlabel('t');
ylabel('g(t)');


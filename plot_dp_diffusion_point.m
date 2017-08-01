function plot_dp_diffusion_point(mu0, c)
%% plots an example trial diffusion in g and x
%
% The given parameters, mu0 and c, are the momentary evidence mean and
% accumulation cost. The optimal boundary is computed using these
% parameters.
%
% The function simulates a single diffusion model run for the given
% parameters and plots the simulation in x and g.
%
% Jan Drugowitsch, July 2017

%% settings
if nargin < 1, mu0 = 1; end
if nargin < 2, c = 0.1; end
ng = 500;   % discretisation of belief
dt = 0.005;  % time-step for belief transition and diff model simulation


%% find optimal bound in g (and mapped to x) by value iteration
gs = dp_discretized_g(ng);
[Vd, Ve] = dp_value_iteration_point_hyp(gs, dt, mu0, c);
theta_g = dp_valueintersect(gs, Vd, Ve);
theta_x = log(theta_g / (1 - theta_g)) / (2 * mu0);


%% simulate diffusion model in x up to bound
sqrtdt = sqrt(dt);
dmu0 = mu0 * dt;
x = 0;  % will be concatenated to contain particle trajectory
while abs(x) < theta_x
    x = cat(2, x, x(end) + dmu0 + sqrtdt * randn());
end
x(end) = sign(x(end)) * theta_x;  % don't pass bound


%% plot diffusion in x and g
tmax = ceil(dt*length(x)*10)/10;  % round to next 0.1
ts = (1:length(x))*dt - dt;
figure('Color', 'white');  hold on;
plot(ts, x, '-', 'Color', [1 1 1]*0.5);
plot([0 tmax], [1 1]*theta_x, 'k-', 'LineWidth', 2);
plot([0 tmax], -[1 1]*theta_x, 'k-', 'LineWidth', 2);
plot([0 tmax], [0 0], 'k--');
xlim([0 tmax]);
xlabel('t');
ylabel('x(t)');

figure('Color', 'white');  hold on;
plot(ts, 1 ./ (1 + exp(-2 * mu0 * x)), '-', 'Color', [1 1 1]*0.5);
plot([0 tmax], [1 1]*theta_g, 'k-', 'LineWidth', 2);
plot([0 tmax], [1 1]*(1-theta_g), 'k-', 'LineWidth', 2);
plot([0 tmax], [0.5 0.5], 'k--');
xlim([0 tmax]);  ylim([0 1]);
xlabel('t');
ylabel('g(t)');
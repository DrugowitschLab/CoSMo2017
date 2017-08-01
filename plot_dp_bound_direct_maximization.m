function plot_dp_bound_direct_maximization
%% plots a comparison between DP bounds and those found by ER maximization
%
% For a set of costs and momentary evidence drifts, this function computes
% the bounds in two ways: either by dynamic programming (using value
% iteration), or by direct maximization of the expected reward rate. It
% then plots these two bounds against each other.
%
% Jan Drugowitsch, July 2017

%% settings
c = 0.1;      % base values
mu0 = 1;
cs = linspace(0.1,1.1,10);     % values to iterate over
mu0s = linspace(0.2,2,10);
ng = 1000;    % belief space discretisation
dt = 0.0005;   % time-step for belief transition, required for DP


%% compute the optimal diffusion model bounds for different c / mu0
fprintf('Compute bounds for c =');
c_bounds = NaN(2, length(cs));
for ic = 1:length(cs)
    fprintf(' %4.2f', cs(ic));
    c_bounds(1, ic) = dp_bound(mu0, cs(ic), ng, dt);
    c_bounds(2, ic) = direct_bound(mu0, cs(ic));
end
fprintf('\n');

fprintf('Compute bounds for mu0 =');
mu0_bounds = NaN(2, length(mu0));
for imu0 = 1:length(mu0s)
    fprintf(' %4.2f', mu0s(imu0));
    mu0_bounds(1, imu0) = dp_bound(mu0s(imu0), c, ng, dt);
    mu0_bounds(2, imu0) = direct_bound(mu0s(imu0), c);
end
fprintf('\n');


%% plot results
figure('Color', 'white');  hold on;
plot(cs, c_bounds(1,:), 'r-', 'LineWidth', 2);
plot(cs, c_bounds(2,:), 'k--', 'LineWidth', 2);
xlim([0 1.2]);  ylims = ylim;  ylim([0 ylims(2)]);
legend('DP', 'direct');
xlabel('cost c');
ylabel('bound');

figure('Color', 'white');  hold on;
plot(cs, mu0_bounds(1,:), 'r-', 'LineWidth', 2);
plot(cs, mu0_bounds(2,:), 'k--', 'LineWidth', 2);
xlim([0 1.2]);  ylims = ylim;  ylim([0 ylims(2)]);
legend('DP', 'direct');
xlabel('drift mu0');
ylabel('bound');


function theta = dp_bound(mu0, c, ng, dt)
%% returns optimal bound in x using dynamic programming
gs = dp_discretized_g(ng);
[Vd, Ve] = dp_value_iteration_point_hyp(gs, dt, mu0, c);
g = dp_valueintersect(gs, Vd, Ve);
theta = log(g / (1-g)) / (2*mu0);


function theta = direct_bound(mu0, c)
%% return optimal bound in x by direct maximization
%
% We can find the optimal bound in two ways:
%
% 1) maximize PC - c <t>, which is given by
%
%    1 / (1 + exp(-2 * mu0 * theta) - c * theta * tanh(mu0 * theta) / mu0
%
%    For this you can use fminsearch or fminbnd. Be careful to use the
%    negative of the above, as they both find the minimum rather than the
%    maximum.
%
% 2) find the point where the derivative of PC - c <t> wrt. theta is zero.
%    This derivative is given by
%
%    (mu0 - 2 * c * theta) * sech(theta * mu0)^2 / 2 - c * tanh(theta * mu0) / mu0
%
%    You can find this zero-crossing by fzero.

% define function you want to minimize / find the root
% f = @(theta) ...

% perform root finding, starting at theta = 1
%theta = fzero(f, 1);
% or find minimum, guessing that it won't be larger than theta > 10
%theta = fminbnd(f, 1e-6, 100);

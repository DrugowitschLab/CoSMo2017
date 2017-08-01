% example for continuous evidence accumulation with Gaussian prior
%
% Jan Drugowitsch, July 2017

%% simulation settings
sig_mu = 1;   % standard deviation of prior over mu
mu = 0.5;     % 'chosen' mu for given choice (usually mu ~ N(0, sig_mu^2))
T = 10;       % maximum simulation time
dt = 0.05;    % simulation time-step
% belief values to plot and their color
plot_gs = [0.1 0.2 0.3 0.4 0.5 0.6 0.7 0.8 0.9];
g_cols = [0 0 0.8; 0.125 0.125 0.725; 0.25 0.25 0.65; 0.375 0.375 0.575; ...
          0.5 0.5 0.5; ...
          0.6 0.49 0.375; 0.7 0.48 0.25; 0.8 0.47 0.125; 0.9 0.45 0];
rng(2);

ts = 0:dt:T;
N = length(ts) - 1;

%% generate samples
dxs = mu0 * dt + sqrt(dt) * randn(1, N);
accum_x = [0 cumsum(dxs)];


%% plot samples
figure('Color', 'white');  hold on;
plot(ts, accum_x, 'k-', 'LineWidth', 2);
for ig = 1:length(plot_gs)
    % map belief into x-space, using g = Phi(x / sqrt(t + sig_mu^-2))
    plot(ts, norminv(plot_gs(ig))*sqrt(ts + sig_mu^(-2)), 'Color', g_cols(ig,:));
end
xlabel('t');

figure('Color', 'white');  hold on;
plot(ts, normcdf(accum_x ./ sqrt(ts + sig_mu^(-2))), 'k-', 'LineWidth', 2);
for ig = 1:length(plot_gs)
    plot(xlim, plot_gs(ig)*[1 1], 'Color', g_cols(ig,:));
end
ylim([0 1]);
xlabel('t');

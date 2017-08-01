% example for discrete evidence accumulation
%
% Jan Drugowitsch, July 2017

%% simulation settings
mu0 = 0.3;
N = 10;
rng(0);


%% generate samples
xs = mu0 + randn(1, N);
accum_x = [0 cumsum(xs)];


%% plot samples
figure('Color', 'white');  hold on;
plot(1:N, xs, 'ko', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
plot(0:N, accum_x, 'k-', 'LineWidth', 2);
plot(xlim, [0 0], 'k--');
legend('xn', 'sum xn');
xlabel('n');

figure('Color', 'white');  hold on;
plot(0:N, 1 ./ (1 + exp(-2 * mu0 * accum_x)), 'ko-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
plot(xlim, [0.5 0.5], 'k--');
ylim([0 1]);
xlabel('n');

%% plots expected reward for accumulating evidence
%
% Jan Drugowitsch, July 2017


%% simulation settings
mu0 = 1;
dt = 0.05;
T = 10;
trials = 10000;
cs = [0 0.1 0.2 0.3];
c_cols = [0 0 0; 0.3 0 0; 0.6 0 0; 0.9 0 0];
tis = [0 1.5 3];
ti_cols = [0 0 0; 0 0 0.4; 0 0 0.8];
ti_c = 0.05;
ts = 0:dt:T;
N = length(ts) - 1;


%% accumulate evidence
xs = mu0 * dt + sqrt(dt) * randn(trials, N);
xs = [zeros(trials,1) cumsum(xs,2)];
exp_rew = 1 ./ (1 + exp(-2 * xs));
exp_rew_mu = mean(exp_rew, 1);
exp_rew_sd = sqrt(var(exp_rew, [], 1));


%% plot expected reward / reward rate
% no cost
figure('Color', 'white');  hold on;
fill([ts fliplr(ts)],[(exp_rew_mu+exp_rew_sd) fliplr(exp_rew_mu-exp_rew_sd)], ...
    [0.5 0.5 0.5],'EdgeColor','none');
plot(ts, exp_rew_mu, 'k-', 'LineWidth', 2);
ylim([0 1]);
plot(xlim, [0.5  0.5], 'k--');
xlabel('t');
ylabel('expected reward');

% different costs
figure('Color', 'white');  hold on;
for i = 1:length(cs)
    plot(ts, exp_rew_mu - ts .* cs(i), '-', 'LineWidth', 2, 'Color', c_cols(i,:));
end
plot(xlim, [0.5 0.5]);
ylim([0 1]);
legend(arrayfun(@(c) sprintf('cost %.1f', c), cs, 'UniformOutput', false));
xlabel('t');
ylabel('expected reward');

% different inter-choice intervals
figure('Color', 'white');  hold on;
for i = 1:length(tis)
    plot(ts, (exp_rew_mu - ts * ti_c) ./ (ts + tis(i)) , '-', 'LineWidth', 2, 'Color', ti_cols(i,:));
end
plot(xlim, [0.5 0.5]);
ylim([0 1]);
legend(arrayfun(@(ti) sprintf('ti %.1f', ti), tis, 'UniformOutput', false));
xlabel('t');
ylabel('expected reward');


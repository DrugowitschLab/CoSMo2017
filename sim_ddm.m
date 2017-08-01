%% Simulates the diffusion model and illustrates the effect of varying drift
%
% Jan Drugowitsch, July 2017

% diffusion model parameters
sim_mus = [0.0 2.0]; % drift rates to simulate
theta = 0.5;         % boundary height
nmus = length(sim_mus);

% simulation settings
trials = 50;        % number of trials per drift rate
dt = 0.005;          % size of each simulation time step
tmax = 1;            % maximum simulation time

% time steps
ts = 0:dt:tmax;
nts = length(ts);
sqrtdt = sqrt(dt);

% psychometric / chronometric plot settings
plot_mus = linspace(-4, 4, 100);


%% simulate diffusion for different drift rates
x = NaN(trials, nts, nmus);
rt = NaN(trials, nmus);
rt_mus = NaN(2, nmus);
choice = NaN(trials, nmus);
pr_mus = NaN(2, nmus);
for imu = 1:nmus
    dmu = sim_mus(imu) * dt;
    for trial = 1:trials
        % simulate diffusion, starting at x(0) = 0
        x(trial, 1, imu) = 0;
        for i = 2:nts
            % add N(mu dt, sig^2 dt) to x((i-1) dt)
            x(trial, i, imu) = x(trial, i-1, imu) + dmu + sqrtdt * randn();
            % check for boundary crossing, and record choice / RT
            if abs(x(trial, i, imu)) >= theta
                x(trial, i, imu) = theta * sign(x(trial, i, imu));
                rt(trial, imu) = ts(i);
                choice(trial, imu) = 0.5 * (sign(x(trial, i, imu)) + 1);
                break
            end
        end
    end
    % perform rt median split, and compute mean rt / p(right)
    rtimu = rt(:, imu);
    choiceimu = choice(:, imu);
    [rtimu, rt_order] = sort(rtimu);
    choiceimu = choiceimu(rt_order);
    n2 = floor(trials / 2);
    rt_mus(:, imu) = [nanmean(rtimu(1:n2)) nanmean(rtimu((n2+1):end))];
    pr_mus(:, imu) = [nanmean(choiceimu(1:n2)) nanmean(choiceimu((n2+1):end))];
end


%% plot simulation results
for imu = 1:nmus
    figure('Color', 'white');  hold on;
    for trial = 1:trials
        plot(ts, x(trial, :, imu), '-', 'Color', [1 1 1]*0.5, 'LineWidth', 0.2);
    end
    xlim([0 max(ts)]);  ylim((theta * 1.1) * [-1 1]);
    plot(xlim, theta*[1 1], 'k-', 'LineWidth', 2);
    plot(xlim, -theta*[1 1], 'k-', 'LineWidth', 2);
    plot(xlim, [0 0], 'k--', 'LineWidth', 0.5);
    xlabel('time [s]');
    ylabel('particle location x(t)');
    title(sprintf('drift mu=%4.2f', sim_mus(imu)));
end


%% plot psychometric / chronometric curves
figure('Color', 'white');
% use analytical diffusion model expressions for p(right) / <RT>
pr_pred = 1 ./ (1 + exp(-2 * plot_mus * theta));
rt_pred = theta ./ plot_mus .* tanh(theta * plot_mus);
rt_pred(plot_mus == 0) = theta^2;
% plot chronometric/psychometric curves & add simulation results
subplot(2,1,1);  hold on;
plot(plot_mus, rt_pred, 'k-', 'LineWidth', 2);
errorbar(sim_mus, nanmean(rt, 1), sqrt(nanvar(rt, [], 1) / trials), 'ko', ...
         'LineWidth', 2, 'MarkerFace', [1 1 1]);
plot(sim_mus, rt_mus(1,:), 'go', 'MarkerFace', 'g');
plot(sim_mus, rt_mus(2,:), 'ro', 'MarkerFace', 'r');
ylims = ylim;  ylim([0 ylims(2)]);  % make sure DTs start at 0
ylabel('decision time [s]');
subplot(2,1,2);  hold on;
plot(plot_mus, pr_pred, 'k-', 'LineWidth', 2);
errorbar(sim_mus, nanmean(choice, 1), sqrt(nanvar(choice, [], 1) / trials), 'ko', ...
         'LineWidth', 2, 'MarkerFace', [1 1 1]);
plot(sim_mus, pr_mus(1,:), 'go', 'MarkerFace', 'g');
plot(sim_mus, pr_mus(2,:), 'ro', 'MarkerFace', 'r');
plot(xlim, [0.5 0.5], 'k--');
ylabel('fraction right');
xlabel('drift mu');
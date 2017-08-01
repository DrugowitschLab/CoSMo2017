function sim_accum
%% Simulates standard accumulator model
%
% The script performs the following:
% - it simulates a single trial and plots the accumulator states over time,
%   until they reach the boundary;
% - and it simulates a set of trials with different 'coherences' and plots
%   psychometric and chronometric curves and reaction time distributions.
%
% Jan Drugowitsch, July 2017


%% settings
sim_dt = 0.01;         % simulation step size
sim_cohs = [0 0.032 0.064 0.128 0.256 0.5120];  % coherences
sim_coh = sim_cohs(3); % example coherence
k = 10;                % scaling factor coherence -> mu
theta = 2;             % bound height
sim_trials = 50000;    % number of trials per coherence
plot_cols = [0.8 0.4 0; 0 0 0.8];
rng(1);

ncohs = length(sim_cohs);


%% perform single simulation, tracking trajectories
x1 = 0;  x2 = 0;
dmu = sim_coh * k * sim_dt;
sqrtdt = sqrt(sim_dt);
while x1(end) < theta && x2(end) < theta
    % generate momentary evidence / input
    dx = dmu + sqrtdt * randn();
    % add to x1 or x2, depending on sign
    if dx > 0
        x1 = cat(2, x1, x1(end) + dx);
        x2 = cat(2, x2, x2(end));
    else
        x1 = cat(2, x1, x1(end));
        x2 = cat(2, x2, x2(end) - dx);
    end
end
% make sure that trajectory does not cross bound
if x1(end) > theta, x1(end) = theta; end
if x2(end) > theta, x2(end) = theta; end
% plot trajectories
nt = max(length(x1), length(x2));
ts = (0:(nt-1)) * sim_dt;
figure('Color', 'white');  hold on;
plot(ts(1:length(x1)), x1, '-', 'Color', plot_cols(1,:), 'LineWidth', 2);
plot(ts(1:length(x2)), x2, '-', 'Color', plot_cols(2,:), 'LineWidth', 2);
plot(xlim, theta * [1 1], 'k-', 'LineWidth', 3);
xlabel('t');
ylabel('x1(t), x2(t)');


%% simulate 'trials' trials per coherence
cohs = NaN(1, sim_trials * ncohs);
rt = NaN(1, sim_trials * ncohs);
choice = NaN(1, sim_trials * ncohs);
for icoh = 1:ncohs
    i = (icoh-1)*sim_trials + 1;
    j = i + sim_trials - 1;
    cohs(i:j) = sim_cohs(icoh);
    [rt(i:j), choice(i:j)] = sim_choices(sim_cohs(icoh) * k, theta, ...
                                         sim_trials, sim_dt);
end


%% plot statistics
plot_psych_chron(cohs, choice, rt);
plot_rt_dist(cohs, choice, rt);


function [rt, choice] = sim_choices(mu, theta, trials, dt)
%% simulates a set of trials performed by the standard accumulator model
%
% mu is the 'drift' rate (0 = equal evidence for both options) and theta is
% the bound height.

% constant for simulation
dmu = mu * dt;
sqrtdt = sqrt(dt);

% simulate individual trials
rt = NaN(1, trials);
choice = NaN(1, trials);
for trial = 1:trials
    x1 = 0;  x2 = 0;  t = 0;
    while x1 < theta && x2 < theta
        % momentary evidence / input
        dx = dmu + sqrtdt * randn();
        % add to x1 or x2, depending on sign
        if dx > 0
            x1 = x1 + dx;
        else
            x2 = x2 - dx;
        end
        t = t + dt;
    end
    choice(trial) = x1 >= theta;
    rt(trial) = t;
end

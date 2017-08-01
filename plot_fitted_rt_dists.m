function plot_fitted_rt_dists(cohs, choice, rt)
% compare RT distributions between data and diffusion model fits
%
% Function needs to be called with vector of (signed) coherences,
% choices, and reaction times, as loaded from the phs_*.mat/rt_*.mat files.
%
% Jan Drugowitsch, July 2017

%% some settings
% diffusion model simulations
sim_dt = 0.005;    
sim_trials = 10000;


%% data pre-processing
% we only care about absolute coherence
abscohs = abs(cohs);
coherences = unique(abscohs);
ncoherences = length(coherences);


%% find diffusion model parameters
fprintf('Finding diffusion model parameters by maximum likelihood\n');
[k, theta, tnd] = fit_psych_chron(cohs, choice, rt, false);


%% simulate diffusion model
fprintf('Simulating diffusion model\n');
mcohs = NaN(1, sim_trials * ncoherences);
mchoice = NaN(1, length(mcohs));
mrt = NaN(1, length(mcohs));
for icoh = 1:ncoherences
    i = (icoh-1)*sim_trials + 1;
    j = i + sim_trials - 1;
    mcohs(i:j) = coherences(icoh);
    [mrt(i:j), mchoice(i:j)] = ddm_sim(k * coherences(icoh), ...
                                       theta, tnd, sim_trials, sim_dt);
end


%% plot reaction time distributions
plot_rt_dist(cohs, choice, rt, mcohs, mchoice, mrt);


function [rt, choice] = ddm_sim(mu, theta, tnd, trials, dt)
%% simulate diffusion model with given parameters
%
% The function returns 'trials' reaction times, and corresponding choices.

% pre-compute constants
sqrtdt = sqrt(dt);
dmu = mu * dt;
tnd_sd = 0.1 * tnd;

% pre-allocate space and run simulations
rt = NaN(1, trials);
choice = NaN(1, trials);
for trial = 1:trials
    x = 0;
    t = 0;
    % simulate diffusion to boundary crossing
    while abs(x) < theta
        x = x + dmu + sqrtdt * randn();
        t = t + dt;
    end
    % add non-decision time and store
    rt(trial) = t + tnd + tnd_sd * randn();
    choice(trial) = x > 0;
end

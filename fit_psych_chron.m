function [k, theta, tnd] = fit_psych_chron(cohs, choice, rt, verbose)
% Fitting psych/chronometric curves of PHS/RS dataset with simple DDM
%
% Function needs to be called with vector of (signed) coherences,
% choices, and reaction times, as loaded from the phs_*.mat files.
%
% The 'verbose' argument is optional and set to 'true' by default.
%
% Jan Drugowitsch, July 2017

if nargin < 4, verbose = true; end

%% data pre-processing
% we only care about absolute coherence
corr_choice = 0.5 * (sign(cohs + 1e-6) + 1) == choice;
abscohs = abs(cohs);
coherences = unique(abscohs);
[pr_mu, pr_sem, ns] = grpstats(corr_choice, abscohs, {'mean', 'sem', 'numel'});
[rt_mu, rt_sem] = grpstats(rt, abscohs, {'mean', 'sem'});


%% find parameters that maximize the likelihood
% requires Bayesian Adaptive Direct Search toolbox, https://github.com/lacerbi/bads

% function to minimize is negative log-likelihood, parameters [k theta tnd]
opt_fun = @(x) -loglh(x(1) * coherences, x(2), x(3), rt_mu, pr_mu, ns);
% arguments are function, x_ini, lower bound, upper bound, probable lower
% bound, probable upper bound
if verbose
    opt = optimset('Display', 'iter');
else
    opt = optimset('Display', 'none');
end
x_opt = fmincon(opt_fun,[10 1 0.3],[],[],[],[],[0 0 0],[1000 100 10],[],opt);
% output results and compute model predictions
k = x_opt(1);
theta = x_opt(2);
tnd = x_opt(3);
if verbose
    fprintf('Maximum likelihood parameters:\n');
    fprintf('k     = %6.2f\n', k);
    fprintf('theta = %6.2f\n', theta);
    fprintf('tnd   = %6.2f\n', tnd);
end


%% plot model fits
if verbose
    figure('Color', 'white');
    plot_cohs = linspace(0, max(coherences)*1.1, 100);
    [rt_pred, ~, pr_pred] = ddm_predictions(plot_cohs * k, theta, tnd);
    subplot(2,1,1);  hold on;
    plot(plot_cohs, rt_pred, 'k-', 'LineWidth', 2);
    errorbar(coherences, rt_mu, rt_sem, 'ko', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
    xlim([-0.01 max(coherences)*1.1+0.01]);
    ylims = ylim;  ylim([0 ylims(2)]);  % make sure RTs start at 0
    ylabel('reaction time [s]');
    subplot(2,1,2);  hold on;
    plot(plot_cohs, pr_pred, 'k-', 'LineWidth', 2);
    errorbar(coherences, pr_mu, pr_sem, 'ko', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
    plot(xlim, [0.5 0.5], 'k--');
    xlim([-0.01 max(coherences)*1.1+0.01]);
    ylim([0.4 1]);
    xlabel('coherence');
    ylabel('fraction right');
end


function [rt_mean, rt_var, pr] = ddm_predictions(mus, theta, tnd)
%% returns the diffusion model predictions for each drift in mus
%
% theta and tnd are assumes scalar. The returned vectors have the same
% size as mus.
%
% The used expressions are from Palmer, Huk & Shadlen (2005). The
% predictions assume a non-decision time with a standard deviation that is
% 10% of its mean.

zero_mus = mus == 0;
theta_mus = theta * mus;
rt_mean = theta ./ mus .* tanh(theta_mus);
rt_mean(zero_mus) = theta^2;
rt_mean = rt_mean + tnd;
rt_var = theta * (tanh(theta_mus) - theta_mus .* sech(theta_mus).^2) .^ mus;
rt_var(zero_mus) = 2/3 * theta^4;
rt_var = rt_var + (0.1 * tnd)^2;
pr = 1 ./ (1 + exp(-2 * theta_mus));


function l = loglh(mus, theta, tnd, rts, prs, ns)
%% returns the log-likelihood of rt/pr data for given parameters
%
% The function N different conditions in the data
% - rts: N reaction times
% - prs: N p(correct)
% - ns: N number of trials per condition
%
% The model parameters are:
% - mus: N drift rates, one per condition
% - theta: scalar bound height
% - tnd: scalar non-decision time
%
% The function ignores all parameter-independent components of the
% likelihood.

% turn everything into column vectors
mus = mus(:); rts = rts(:); prs = prs(:); ns = ns(:);

% get number of conditions, and check consistency
N = length(mus);
assert(N == length(rts));
assert(N == length(prs));
assert(N == length(ns));

% log-likelihoods, avoiding log underflow
[rt_mean_pred, rt_var_pred, pr_pred] = ddm_predictions(mus, theta, tnd);
log_p_rt = sum(-0.5 * log(rt_var_pred) - (rts - rt_mean_pred).^2 ./ (2 * rt_var_pred ./ ns));
log_p_pr = sum(ns .* prs .* log(max(1e-60, pr_pred)) + ns.* (1 - prs) .* log(max(1e-60, 1 - pr_pred)));
l = log_p_rt + log_p_pr;

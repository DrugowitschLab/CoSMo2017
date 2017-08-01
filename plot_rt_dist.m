function plot_rt_dist(cohs, choice, rt, mcohs, mchoice, mrt)
%% plots the reaction time distribution per abs(coherence)
%
% cohs, choice & rt are vectors indicating pre-trial coherence, choice and
% reaction time, as provided in phs_*.mat and rs_*.mat.
%
% The optional arguments, mcohs, mchoice & mrt are model simulations of the
% same format, and are plotted in comparison, if provided.
%
% Jan Drugowitsch, July 2017

% use empty model, if not given
if nargin < 6, mcohs = []; mchoice = []; mrt = []; end


%% settings
trials_per_bin = 10;          % (min) average number of trials per bin
col_corr = [0 0.8 0];         % plot color for correct choices
col_incorr = [0.8 0 0];       % plot color for incorrect choices


%% data properties
abscohs = abs(cohs);
coherences = unique(abscohs);
ncoherences = length(coherences);
corr_choice = 0.5 * (sign(cohs + 1e-6) + 1) == choice;
mcorr_choice = 0.5 * (sign(mcohs + 1e-6) + 1) == mchoice;
% make sure that model has same coherences
if ~isempty(mcohs)
    cohsdiff = setdiff(unique(abs(mcohs)), abscohs);
    if ~isempty(cohsdiff)
        error('mcohs contains additional values not in cohs, %s', ...
              mat2str(cohsdiff));
    end
end


%% plot binned RT data per (absolute) coherence
figure('Color', 'white');
plot_max_y = ceil(max(rt) * 11) / 10;  % plot 10% above largest rt
for icoh = 1:ncoherences
    subplot(ceil(ncoherences/2),2,icoh);  hold on;
    xlim([0 plot_max_y]);
    % collect RT statistics for given coherence
    coh_trials = abscohs == coherences(icoh);
    corr_rts = rt(coh_trials & corr_choice);
    incorr_rts = rt(coh_trials & ~corr_choice);
    % correct choices
    if length(corr_rts) >= trials_per_bin
        [rt_means, p_rt] = bin_rts(corr_rts, trials_per_bin);
        plot(rt_means, p_rt, '-', 'Color', col_corr, 'LineWidth', 2);
    end
    % incorrect choices
    if length(incorr_rts) >= trials_per_bin
        [rt_means, p_rt] = bin_rts(incorr_rts, trials_per_bin);
        plot(rt_means, -p_rt, '-', ...
             'Color', col_incorr, 'LineWidth', 2, 'MarkerFace', [1 1 1]);
    end
    % same for m* data
    coh_trials = abs(mcohs) == coherences(icoh);
    corr_rts = mrt(coh_trials & mcorr_choice);
    incorr_rts = mrt(coh_trials & ~mcorr_choice);
    % correct choices
    if length(corr_rts) >= trials_per_bin
        [rt_means, p_rt] = bin_rts(corr_rts, trials_per_bin);
        plot(rt_means, p_rt, '--', ...
             'Color', col_corr, 'LineWidth', 2, 'MarkerFace', [1 1 1]);
    end
    % incorrect choices
    if length(incorr_rts) >= trials_per_bin
        [rt_means, p_rt] = bin_rts(incorr_rts, trials_per_bin);
        plot(rt_means, -p_rt, '--', ...
             'Color', col_incorr, 'LineWidth', 2, 'MarkerFace', [1 1 1]);
    end
    % plot line at y = 0
    plot(xlim, [0 0], 'k--');
    xlabel('RT');  ylabel(sprintf('p(RT | coh = %.3f)', coherences(icoh)));
end


function [rt_means, p_rt] = bin_rts(rts, trials_per_bin)
%% returns bin mean and fraction for binned reaction times
%
% The function uses bins that contain on average trials_per_bin trials, and
% returns the means of each bin, and the fraction of trials in each bin,
% both as a vector.

% bound number of bins
min_bins = 2;
max_bins = 50;

% find bin boundaries
nbins = min(max_bins, max(min_bins, floor(length(rts) / trials_per_bin)));
binranges = linspace(min(rts), max(rts)+1e-6, nbins+1);
binw = binranges(2) - binranges(1);
binranges(end) = binranges(end)*1.01;   % extend beyond max(rt)
[~,binid] = histc(rts, binranges);
% bin reaction times
rt_means = NaN(1, nbins);
p_rt = NaN(1, nbins);
for ibin = 1:nbins
    rt_means(ibin) = mean(rts(binid == ibin));
    if isnan(rt_means(ibin))
        rt_means(ibin) = binranges(1) + binw * (ibin - 0.5);
    end
    p_rt(ibin) = mean(binid == ibin);
end
% add p=0 bins at beginning and end
drt = mean(diff(rt_means));
rt_means = [(rt_means(1)-drt) rt_means (rt_means(end)+drt)];
p_rt(isinf(p_rt)) = 0;
p_rt = [0 p_rt 0];
% turn fraction into densities
drt = diff(rt_means);
binw = [drt(1) 0.5*(drt(1:(end-1))+drt(2:end)) drt(end)];
p_rt = p_rt ./ binw;
function plot_pcorrect_over_time
%% plots p(correct) over time for PHS/RS data
%
% The function discards early/late outliers and then bins trials by
% reaction time, to have roughly the same number of trials per bin. For
% each bin it plots p(correct) over reaction time.
%
% Jan Drugowitsch, July 2017

%% settings
phs_ids = {'ah', 'eh', 'jd', 'jp', 'mk', 'mm'};
rs_ids = {'b', 'n'};


%% process and plot data
figure('Color', 'white');  hold on;
for iphs = 1:length(phs_ids)
    d = load(['phs_' phs_ids{iphs} '.mat']);
    corr_choice = 0.5 * (sign(d.cohs + 1e-6) + 1) == d.choice;
    [rt_mean, pcorr_mean, pcorr_sem] = pcorr_per_rt_bin(d.rt, corr_choice);
    errorbar(rt_mean, pcorr_mean, pcorr_sem, 'ko-', 'LineWidth', 1, 'MarkerFace', [1 1 1]);
end
plot(xlim, [0.5 0.5], 'k--');
ylim([0.4 1]);
xlabel('reaction time');
ylabel('fraction correct');

figure('Color', 'white');  hold on;
for irs = 1:length(rs_ids)
    d = load(['rs_' rs_ids{irs} '.mat']);
    corr_choice = 0.5 * (sign(d.cohs + 1e-6) + 1) == d.choice;
    [rt_mean, pcorr_mean, pcorr_sem] = pcorr_per_rt_bin(d.rt, corr_choice);
    errorbar(rt_mean, pcorr_mean, pcorr_sem, 'ko-', 'LineWidth', 1, 'MarkerFace', [1 1 1]);
end
plot(xlim, [0.5 0.5], 'k--');
ylim([0.4 1]);
xlabel('reaction time');
ylabel('fraction correct');



function [rt_mean, pcorr_mean, pcorr_sem] = pcorr_per_rt_bin(rt, corrc)
%% returns bin statistics for p(correct) binned by RT
%
% rt and corrc are two vectors, indicating reaction time and if choice was
% correct. The function discards rt's outside include_rt_range (see
% settings), and then creates N bins containing at least trials_per_bin
% trials each (see settings), using percentile splits. For each of these
% bins, it computes the mean reaction time, mean p(correct), and its
% standard error, all of which are returned.

%% settigs
trials_per_bin = 50;   % determines number of bins in time
include_rt_range = [2.5 97.5];  % percentile RT range to include


%% turn into colum vectors, and only include include_rt_range trials
[rt, rt_order] = sort(rt(:));
corrc = corrc(rt_order);
cuttrials = length(rt) * include_rt_range / 100;
rt = rt(floor(cuttrials(1)):ceil(cuttrials(2)));
corrc = corrc(floor(cuttrials(1)):ceil(cuttrials(2)));


%% determine number of bins and bin boundaries
nbins = floor(length(rt) / trials_per_bin);
binranges = prctile(rt, linspace(0,100,nbins+1));
binranges(end) = binranges(end)*1.01;   % extend last bin beyond max(rt)
[~,binid] = histc(rt, binranges);


%% collect statistics per bin
rt_mean = NaN(1, nbins);
pcorr_mean = NaN(1, nbins);
pcorr_sem = NaN(1, nbins);
for ibin = 1:nbins
    bintrials = binid == ibin;
    rt_mean(ibin) = mean(rt(bintrials));
    bin_corrc = corrc(bintrials);
    pcorr_mean(ibin) = mean(bin_corrc);
    pcorr_sem(ibin) = sqrt(var(bin_corrc) / length(bin_corrc));
end

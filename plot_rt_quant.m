function plot_rt_quant(cohs, choice, rt);
%% plots RT quantile plots
% 
% cohs, choice & rt are vectors indicating pre-trial coherence, choice and
% reaction time, as provided in phs_*.mat and rs_*.mat.
%
% Jan Drugowitsch, July 2017

%% settings
plot_prctiles = [10 30 50 70 90];       % prctiles for quantile plot
jitter_sd = 0.01;
% plot colors
col_corr = [0 0.8 0];
col_incorr = [0.8 0 0];

nprctiles = length(plot_prctiles);

%% process behavioral data
abscohs = abs(cohs);
coherences = unique(abscohs);
ncoherences = length(coherences);
corr_choice = 0.5 * (sign(cohs + 1e-6) + 1) == choice;


%% compute quantiles
qcorr = NaN(ncoherences, nprctiles);
qincorr = NaN(ncoherences, nprctiles);
pcorr = NaN(1, ncoherences);
for icoh = 1:ncoherences
    coh_trials = abscohs == coherences(icoh);
    corr_rts = rt(coh_trials & corr_choice);
    incorr_rts = rt(coh_trials & ~corr_choice);
    if length(corr_rts) >= length(plot_prctiles)
        qcorr(icoh, :) = prctile(corr_rts, plot_prctiles);
    end
    if length(incorr_rts) >= nprctiles
        qincorr(icoh, :) = prctile(incorr_rts, plot_prctiles);
    end
    pcorr(icoh) = mean(corr_choice(coh_trials));
end


%% generate quantile plots
figure('Color', 'white');  hold on;
% grey lines correcting percentiles across p(correct)
for iprctile = 1:nprctiles
    plot([(1-pcorr) pcorr], [qincorr(:,iprctile)' qcorr(:,iprctile)'], ...
         '-', 'Color', [1 1 1]*0.5, 'LineWidth', 1);
end
for icoh = 1:ncoherences
    % plot correct / incorrect
    plot(pcorr(icoh) * ones(nprctiles,1), qcorr(icoh, :), ...
        'x', 'LineWidth', 2, 'Color', col_corr, 'MarkerSize', 10);
    plot((1-pcorr(icoh)) * ones(nprctiles,1), qincorr(icoh, :), ...
         'x', 'LineWidth', 2, 'Color', col_incorr, 'MarkerSize', 10);
    ylims = ylim;
    % add jittered data
    coh_trials = abscohs == coherences(icoh);
    corr_rts = rt(coh_trials & corr_choice);
    incorr_rts = rt(coh_trials & ~corr_choice);    
    plot(pcorr(icoh) * ones(1, length(corr_rts)) + jitter_sd * randn(1, length(corr_rts)), ...
         corr_rts, '.', 'Color', col_corr);
    plot((1-pcorr(icoh)) * ones(1, length(incorr_rts)) + jitter_sd * randn(1, length(incorr_rts)), ...
         incorr_rts, '.', 'Color', col_incorr);     
     xlim([0 1]);  ylim([0 ceil(ylims(2) * 4) / 4]);
     xlabel('fraction correct');
     ylabel('RT quantiles');
end

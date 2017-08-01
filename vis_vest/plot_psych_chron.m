function plot_psych_chron(oris, mods, cohs, choice, rt)
%% plots psychometric/chronometric curves for vis/vest datasets
%
% The given vectors describe the trial-by-trial conditions and subject
% responses, as described in vis_vest_README.txt. The function plots
% the chronometric and psychometric curves over heading direction,
% with one figure per coherence.
%
% Jan Drugowitsch, July 2017


%% plot settings
ori_bounds = [-20 20];


%% check the data
% here we require trials of all coherences and modalities to be present.
% This is a pre-requisit for the below statistics computations to work.
unique_mods = unique(mods);
if length(unique_mods) ~= 3 || any(unique_mods ~= [1 2 3])
    error('Vector mods of modalities incomplete, or contains unknown ids');
end
unique_cohs = unique(cohs);
if length(unique_cohs) ~= 4 || any(unique_cohs ~= [0.0 0.25 0.37 0.7])
    error('Vector of coherences incomplete, or contains unallowed values');
end
unique_oris = unique(oris);
noris = length(unique_oris);


%% compute statistics
% map coherences to ids
cohs(cohs == 0.25) = 1;
cohs(cohs == 0.37) = 2;
cohs(cohs == 0.7) = 3;
% compute statistics separately per coherence
rt_mu = NaN(4, noris, 3);   % coh x ori x mod
rt_sem = NaN(4, noris, 3);
pr_mu = NaN(4, noris, 3);
pr_sem = NaN(4, noris, 3);
for icoh = 1:3
    % here we include trials with coherence > 0 for visual and combined
    % conditions, and trials with coherence = 0 for vestibular-only trials.
    % This means the same vestibular-only trials are included in the
    % statsitics for all different coherences
    coh_trials = cohs == icoh | cohs == 0;
    % compute statistics separately for the different modalities
    for imod = 1:3
        mod_trials = mods == imod;
        [rt_mu(icoh,:,imod), rt_sem(icoh,:,imod)] = grpstats(...
            rt(coh_trials & mod_trials), oris(coh_trials & mod_trials), {'mean', 'sem'});
        [pr_mu(icoh,:,imod), pr_sem(icoh,:,imod)] = grpstats(...
            choice(coh_trials & mod_trials), oris(coh_trials & mod_trials), {'mean', 'sem'});
    end
end


%% plot results
for icoh = 1:3
    coh = unique_cohs(icoh + 1);  % 0 is coherence unique_cohs(1)
    figure('Color', 'white');
    % chronometric curves, vis/vest/comb order
    subplot(2,1,1);  hold on;
    for imod = 1:3
        errorbar(unique_oris, rt_mu(icoh,:,imod), rt_sem(icoh,:,imod), 'o-', ...
                 'LineWidth', 2, 'Color', cond_color(imod, coh), 'MarkerFace', [1 1 1]);
    end
    xlim(ori_bounds);  ylims = ylim;  ylim([0 ylims(2)]);
    plot([0 0], ylim, '-', 'Color', [1 1 1]*0.5);
    ylabel('reaction time [s]');
    title(sprintf('%d%% visual coherence', unique_cohs(icoh+1)*100));
    % psychometric curves, vis/vest/comb order
    subplot(2,1,2);  hold on;
    for imod = 1:3
        errorbar(unique_oris, pr_mu(icoh,:,imod), pr_sem(icoh,:,imod), 'o-', ...
                 'LineWidth', 2, 'Color', cond_color(imod, coh), 'MarkerFace', [1 1 1]);
    end
    xlim(ori_bounds);  ylim([0 1]);
    plot([0 0], ylim, '-', 'Color', [1 1 1]*0.5);
    plot(xlim, [0.5 0.5], '-', 'Color', [1 1 1]*0.5);
    xlabel('heading direction [deg]');  ylabel('p(right)');    
end

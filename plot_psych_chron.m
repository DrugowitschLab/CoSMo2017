function plot_psych_chron(cohs, choice, rt)
%% Plotting psychometric and chronometric curves for given choice data
%
% cohs, choice & rt are vectors indicating pre-trial coherence, choice and
% reaction time, as provided in phs_*.mat and rs_*.mat.
%
% Jan Drugowitsch,  July 2017

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Mofidy the below line to compute for each trial if the choice was
% correct (1 = correct, 0 = incorrect).
% Recall that 'choice' is a vector of 0s (left) or 1s (right), and that the
% sign of the elements of 'cohs' tell us if the motion direction was
% rightwards (positive) or leftwards (negative). Use sign(cohs + 1e-6) to
% extract this sign while avoiding sign(0) = 0 for 0-coherence trials.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% corr_choice = % TO BE COMPLETED, should be 0 for incorrect, 1 for correct

% group by absolute coherence
abscohs = abs(cohs);
coherences = unique(abscohs);
% grpstats computes statistics across values of the first vector grouped by
% values of the second vector. Below we use it to group trials by
% coherences.
[corr_mu, corr_se] = grpstats(corr_choice, abscohs, {'mean', 'sem'});
[rt_mu, rt_se] = grpstats(rt, abscohs, {'mean', 'sem'});
%[rtcorr_mu, rtcorr_se] = grpstats(rt(corr_choice), abscohs(corr_choice), {'mean', 'sem'});
%[rtincorr_mu, rtincorr_se] = grpstats(rt(~corr_choice), abscohs(~corr_choice), {'mean', 'sem'});

% plot results
figure('Color', 'white');
subplot(2, 1, 1);  hold on;
errorbar(coherences, rt_mu, rt_se, 'ko-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
%errorbar(unique(abscohs(corr_choice)), rtcorr_mu, rtcorr_se, 'go-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
%errorbar(unique(abscohs(~corr_choice)), rtincorr_mu, rtincorr_se, 'ro-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
xlim([-0.01, 0.55]);  ylim([0 1.2]);
ylabel('Reaction time [s]');
subplot(2, 1, 2);
errorbar(coherences, corr_mu, corr_se, 'ko-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
xlim([-0.01, 0.55]);  ylim([0.4 1]);
hold on; plot(xlim, [0.5 0.5], 'k--');
ylabel('fraction correct');
xlabel('coherence');

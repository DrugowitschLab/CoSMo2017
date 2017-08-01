function test_standard_cue_comb(oris, mods, cohs, choice)
%% tests if data satisfies standard cue combination criteria
%
% This script needs to be completed to test if the provded data satisfies
% standard Bayesian cue combination criteria. oris, mods, cohs, and choice
% arevectors specifying per-trial conditions and responses, as specified in
% vis_vest_README.txt.
%
% The aim is to group conditions by visual coherence, and to check for each
% coherence if the heading discrimination threshold in the combined
% condition corresponds to that predicted from the visual and vestibular
% condition assuming Bayes-optimal cue combination.
%
% To do so, fit a cumulative Gaussian to each condition separately, using
% fit_cumul_gauss(.) (see test_fit_cumul_gauss(.) for an example). The
% fitted sig is monotonically related to the orientation discrimination
% threshold. Specifically, if the 75% correct discrimination threshhold is
% given by theta, then we need normcdf(theta / (sig * sqrt(2))) = 0.75, or
% theta = sig * sqrt(2) * norminv(0.75) to hold. Therefore, a larger sig
% implies a larger orinetation discrimination threshold, or worse
% orientation discrimination performance.
%
% Then, for each visual coherence, use the fitted standard deviation, sig,
% from the unimodal conditions, to predict that in the combined condition,
% using the Bayes-optimal relation,
%
%     1 / sig_comb,pred(coh)^2 = 1 / sig_vis(coh)^2 + 1 / sig_vest^2 .
%
% At last, plot predicted vs. observed discrimination thresholds
% against each other, to check for their correspondance.
%
% Jan Drugowitsch, July 2017.

%% settings
coh_range = [0 1];    % plot range for coherences


%% find unique coherences
% here, we are ignoring the 0-entries from vestibular-only trials
unique_cohs = unique(cohs);
unique_cohs(unique_cohs == 0) = [];
ncohs = length(unique_cohs);


%% find discrimination threshold per coherence
vis_sigs = NaN(1, ncohs);
comb_sigs = NaN(1, ncohs);
for icoh = 1:ncohs
    coh = unique_cohs(icoh);
    % here, use extract_cond(.) to extract trials corresponding to the
    % visual modality, and coherence coh. Use fit_cumul_gauss(.) to find
    % the slope sig of the psychometric curve, and assign it to
    % vis_sigs(icoh). See test_fit_cumul_gauss(.) for an example of how to
    % perform this fit.
    
    vis_sigs(icoh) = % TODO

    % Do the same for the combined modality, and assign the slope to
    % comb_sigs(icoh).
    
    comb_sigs(icoh) = % TODO
end
% At last, do the same for the vestibular modality, and assign the slope to
% vest_sig.

vest_sig = % TODO


%% predict discrimination threshold in combined condition
% Following Bayes-optimal cue combination, the discrimination threshold in
% the combined condition can be predicted from that extracted in the two
% unimodal conditions. Use the equation in the script main comment to
% complete the below computation.
pred_sigs = % TODO


%% plot resulting discrimination threshold
figure('Color', 'white');  hold on;
sig2thresh = @(sig) sig * sqrt(2) * norminv(0.75);
plot(unique_cohs, sig2thresh(vis_sigs), 'o-', ...
     'Color', cond_color(1, 0.25), 'LineWidth', 2, 'MarkerFace', [1 1 1]);  % visual
plot(unique_cohs, sig2thresh(vest_sig * [1 1 1]), 'o-', ...
     'Color', cond_color(2), 'LineWidth', 2, 'MarkerFace', [1 1 1]);  % vestibular
plot(unique_cohs, sig2thresh(comb_sigs), 'o-', ...
     'Color', cond_color(3, 0.25), 'LineWidth', 2, 'MarkerFace', [1 1 1]); % combined
plot(unique_cohs, sig2thresh(pred_sigs), 'o--', 'Color', cond_color(3, 0.25), ...
     'LineWidth', 2, 'MarkerFace', [1 1 1]);
xlim(coh_range);  ylims = ylim;  ylim([0 ylims(2)]);
xlabel('visual coherence');
ylabel('discr. threshold [1 / deg]');
legend('vis', 'vest', 'comb', 'pred');

% Plotting speed/accuracy trade-off for PHS/RS dataset
%
% IMPORTANT: don't forget to load one of the phs_*.mat/rs_*.mat datasets
% before calling this script.
%
% Jan Drugowitsch, 07/2017

% group by absolute coherence and compute statistics
abscohs = abs(cohs);
coherences = unique(abscohs);
ncoherences = length(coherences);
corr_choice = 0.5 * (sign(cohs + 1e-6) + 1) == choice;
sem = @(x) sqrt(var(x) / length(x));  % computes SEM
% pre-allocate space
corr_mu = NaN(3, ncoherences);
corr_sem = NaN(3, ncoherences);
rt_mu = NaN(3, ncoherences);
rt_sem = NaN(3, ncoherences);
% compute statistics for each coherence separately
for i = 1:ncoherences
    coh_trials = abscohs == coherences(i);
    % RT / correctness ordered by RT for coherence i
    rti = rt(coh_trials);
    corri = corr_choice(coh_trials);
    [rti, rt_order] = sort(rti);
    corri = corri(rt_order);
    n2 = floor(length(rti) / 2);
    % collect statistics
    corr_mu(:, i) = [mean(corri) mean(corri(1:n2)) mean(corri((n2+1):end))];
    corr_sem(:, i) = [sem(corri) sem(corri(1:n2)) sem(corri((n2+1):end))];
    rt_mu(:, i) = [mean(rti) mean(rti(1:n2)) mean(rti((n2+1):end))];
    rt_sem(:, i) = [sem(rti) sem(rti(1:n2)) sem(rti((n2+1):end))];
end

% plot results
figure('Color', 'white');
subplot(2, 1, 1);  hold on;
errorbar(coherences, rt_mu(1,:), rt_sem(1,:), 'ko-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
errorbar(coherences, rt_mu(2,:), rt_sem(2,:), 'go-', 'LineWidth', 1, 'MarkerFace', [1 1 1]);
errorbar(coherences, rt_mu(3,:), rt_sem(3,:), 'ro-', 'LineWidth', 1, 'MarkerFace', [1 1 1]);
xlim([-0.01, 0.55]);  ylim([0 1.2]);
ylabel('Reaction time [s]');  legend('avg', 'fast', 'slow');
subplot(2, 1, 2);  hold on;
errorbar(coherences, corr_mu(1,:), corr_sem(1,:), 'ko-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
errorbar(coherences, corr_mu(2,:), corr_sem(2,:), 'go-', 'LineWidth', 1, 'MarkerFace', [1 1 1]);
errorbar(coherences, corr_mu(3,:), corr_sem(3,:), 'ro-', 'LineWidth', 1, 'MarkerFace', [1 1 1]);
xlim([-0.01, 0.55]);  ylim([0.4 1]);
hold on; plot(xlim, [0.5 0.5], 'k--');
ylabel('fraction correct');
xlabel('coherence');
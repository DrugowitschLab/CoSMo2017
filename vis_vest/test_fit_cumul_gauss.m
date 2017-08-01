function test_fit_cumul_gauss(oris, mods, cohs, choice, fit_mod, fit_coh)
%% tests fit_cumul_gauss on psychometric curve for given condition
%
% oris, mods, cohs, and choice are vectors specifying per-trial conditions
% and responses, as specified in vis_vest_README.txt. fit_mod and fit_coh
% specify the condition, as for extract_cond(.).
%
% The function fits the psychometric curve corresponding to the specified
% condition, and plots both data and fit.


%% plot settings
ori_range = [-20 20];
psych_oris = linspace(ori_range(1), ori_range(2), 100);

%% extract condition trials
% to extract condition-specific trials, we simply make up reaction time, as
% we don't use them later.
[oris, choice, ~] = extract_cond(oris, mods, cohs, choice, NaN(size(choice)), ...
                                 fit_mod, fit_coh);


%% fit psychometric curve
% performing fits here. Omit 'true' (or provide 'false') to suppress output
[sig, bias, a, b] = fit_cumul_gauss(oris, choice, true);
psych_pred = (1-a) * normcdf((psych_oris - bias) / sig) + a * b;


%% collect statistics
unique_oris = unique(oris);
[pr_mu, pr_sem] = grpstats(choice, oris, {'mean', 'sem'});
fprintf('Found the following parameters\n');
fprintf('  sig = %f\n', sig);
fprintf(' bias = %f\n', bias);
fprintf('    a = %f\n', a);
fprintf('    b = %f\n', b);


%% plot data and fits
figure('Color', 'white');  hold on;
plot(psych_oris, psych_pred, '-', ...
     'Color', cond_color(fit_mod, fit_coh), 'LineWidth', 2);
errorbar(unique_oris, pr_mu, pr_sem, 'o', 'Color', cond_color(fit_mod, fit_coh), ...
         'LineWidth', 2, 'MarkerFace', [1 1 1]);
xlim(ori_range);  ylim([0 1]);
xlabel('heading direction [deg]');
ylabel('p(right)');
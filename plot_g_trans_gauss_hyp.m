function plot_g_trans_gauss_hyp
%% Generates some example plots for the belief transition for Gaussian
% hypothesis
%
% The transision matrices are for different dt's as well as different
% mu0's.
%
% Jan Drugowitsch, July 2017

%% settings
ng = 100;        % belief discretisation
dt = 0.01;       % time step-size
t = 0.5;         % base parameters
sigmu2 = 1;
ts = [0 0.5 4];  % parameter variations
sigmu2s = [0.5^2 1^2 5^2];
nt = length(ts);
nsigmu2 = length(sigmu2s);


%% discretised belief
gs = dp_discretized_g(ng);
invgs = norminv(gs);


%% plot belief transition examples
figure('Color', 'white');
% varying time step size
for it = 1:nt
    subplot(2, 3, it);
    gg = dp_g_trans_gauss_hyp(invgs, dt / (ts(it) + 1/sigmu2));
    gg = addconfregsion(gg);
    imagesc(gs, gs, 1-sqrt(gg));  colormap('bone');
    % labels
    set(gca,'Layer','top','PlotBoxAspectRatio',[1,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:0.5:1,'YTick',0:0.5:1);
    title(sprintf('t = %4.2f, \\sigma_\\mu^2 = %4.2f', ts(it), sigmu2));
    if it == 1, ylabel('g'); end
end
% varying task difficulty
for sig2_idx = 1:nsigmu2
    subplot(2, 3, sig2_idx + 3);
    gg = dp_g_trans_gauss_hyp(invgs, dt / (t + 1/sigmu2s(sig2_idx)));
    gg = addconfregsion(gg);
    imagesc(gs, gs, 1-sqrt(gg));  colormap('bone');
    % labels
    set(gca,'Layer','top','PlotBoxAspectRatio',[1,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:0.5:1,'YTick',0:0.5:1);
    title(sprintf('t = %4.2f, \\sigma_\\mu^2 = %4.2f', t, sigmu2s(sig2_idx)));
    if sig2_idx == 1, ylabel('g'); end
    xlabel('g''');
end



function gg = addconfregsion(gg)
%% adds the 95% confidence region to the probability distributions

for k = 1:size(gg, 1)
    gcum = cumsum(gg(k,:));
    % find 2.5 and 97.5 percentiles of the cumulative
    li = find(gcum >= 0.025, 1, 'first');
    ui = find(gcum < 0.975, 1, 'last');
    if isempty(ui), ui = 1;
    else ui = ui + 1; end
    % mark them in the distribution
    gg(k, li) = 1;
    gg(k, ui) = 1;
end
function plot_g_trans_point_hyp
%% Generates some example plots for the belief transition for point-wise
% hypothesis
%
% The transision matrices are for different dt's as well as different
% mu0's.
%
% Jan Drugowitsch, July 2017

%% settings
% belief discretisation
ng = 100;
% base parameters
dt = 0.01;
mu0 = 1;
% parameter variations
dts = [0.1 0.01 0.001];
mu0s = [2 1 0.2];
ndt = length(dts);
nmu0 = length(mu0s);


%% discretised belief
gs = dp_discretized_g(ng);


%% plot belief transition examples
figure('Color', 'white');
% varying time step size
for idt = 1:ndt
    subplot(2, 3, idt);
    gg = dp_g_trans_point_hyp(gs, dts(idt), mu0);
    gg = addconfregsion(gg);
    imagesc(gs, gs, 1-sqrt(gg));  colormap('bone');
    % labels
    set(gca,'Layer','top','PlotBoxAspectRatio',[1,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:0.5:1,'YTick',0:0.5:1);
    title(sprintf('dt = %5.3f, mu0 = %5.3f', dts(idt), mu0));
    if idt == 1, ylabel('g'); end
end
% varying task difficulty
for imu0 = 1:nmu0
    subplot(2, 3, imu0 + 3);
    gg = dp_g_trans_point_hyp(gs, dt, mu0s(imu0));
    gg = addconfregsion(gg);
    imagesc(gs, gs, 1-sqrt(gg));  colormap('bone');
    % labels
    set(gca,'Layer','top','PlotBoxAspectRatio',[1,1,1],...
        'FontName','Arial','FontSize',12,...
        'TickDir','out','TickLength',[1 1]*0.02,'XTick',0:0.5:1,'YTick',0:0.5:1);
    title(sprintf('dt = %5.3f, mu0 = %5.3f', dt, mu0s(imu0)));
    if imu0 == 1, ylabel('g'); end
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
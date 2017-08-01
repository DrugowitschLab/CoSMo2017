%% plots the bound in belief for constant-bounded diffusion models
%
% The function illustrates that, even for diffusion models with constant
% boundaries, the bound in belief is time-dependent.
%
% Jan Drugowitsch, July 2017

%% simulation settings
dt = 0.01;            % step-size in time (for plotting)
t = 3;                % maximum time to plot
sigmu2 = 2^2;         % variance of prior over mu
thetas = [0.25 0.5 1 1.5 2];   % bound heights
theta_cols = [0.8 0 0; 0 0 0.8];   % extremes of color gradient
nthetas = length(thetas);
theta_col = @(i) (i-1)/(nthetas-1) * theta_cols(1,:) + ...
                 (nthetas-i)/(nthetas-1) * theta_cols(2,:);


%% plot bounds
% ...in particle space
figure('Color', 'white');  hold on;
for itheta = 1:nthetas
    plot([0 t], [1 1]*thetas(itheta), 'Color', theta_col(itheta), 'LineWidth', 2);
    plot([0 t], -[1 1]*thetas(itheta), 'Color', theta_col(itheta), 'LineWidth', 2);
end
xlim([0 t]);
xlabel('t');
ylabel('x(t)');

% .. in belief space
ts = 0:dt:t;
figure('Color', 'white');  hold on;
for itheta = 1:nthetas
    g_bound = normcdf(thetas(itheta) ./ sqrt(1/sigmu2 + ts));
    plot(ts, g_bound, 'Color', theta_col(itheta), 'LineWidth', 2);
    plot(ts, 1-g_bound, 'Color', theta_col(itheta), 'LineWidth', 2);
end
xlabel('t');
ylabel('g(t)');


%% generates plots for RT distributions for constant vs. collapsing bounds
%
% This script uses the dm package. Make sure that it is included in the search
% paths before calling this script.
%
% Jan Drugowitsch, July 2017

%% settings
mus = [0 1 2 3];    % drift rates
dt = 0.01;          % time step-size
t = 3;              % maximum time to compute
theta_const = 1;    % counstant boundary
theta_vary_fn = @(t) theta_const ./ sqrt(1 + 2 * t);   % time-varying boundary
% plotting colors
nmu = length(mus);
corr_cols = @(i) (i-1)/(nmu-1) * [0.5 0.5 0.5] + (nmu-i)/(nmu-1) * [0 0.8 0];
incorr_cols = @(i) (i-1)/(nmu-1) * [0.5 0.5 0.5] + (nmu-i)/(nmu-1) * [0.8 0 0];

nt = ceil(t / dt);
ts = (0:(nt-1)) * dt;
theta_vary = theta_vary_fn(ts);

%% find first-passage time densities and associated moments
pfpt_const = NaN(2, nt, nmu);
pfpt_vary = NaN(2, nt, nmu);
fptmoments_const = NaN(5, nmu);
fptmoments_vary = NaN(5, nmu);
for imu = 1:nmu
    [pfpt_const(1,:,imu), pfpt_const(2,:,imu)] = ddm_fpt(mus(imu), theta_const, dt, t);
    [pfpt_vary(1,:,imu), pfpt_vary(2,:,imu)] = ddm_fpt(mus(imu), theta_vary, dt, t);
    [fptmoments_const(1, imu), fptmoments_const(2, imu), fptmoments_const(3, imu), ...
     fptmoments_const(4, imu), fptmoments_const(5, imu)] = ...
        fpt_moments(pfpt_const(1,:,imu), pfpt_const(2,:,imu), dt);
    [fptmoments_vary(1, imu), fptmoments_vary(2, imu), fptmoments_vary(3, imu), ...
     fptmoments_vary(4, imu), fptmoments_vary(5, imu)] = ...
        fpt_moments(pfpt_vary(1,:,imu), pfpt_vary(2,:,imu), dt);    
end

%% plot first-passage time densities
% constant boundary
figure('Color','white'); hold on
plot([0 t], [1 1]*theta_const, 'k-', 'LineWidth', 2);
plot([0 t], -[1 1]*theta_const, 'k-', 'LineWidth', 2);
for imu = 1:nmu
    plot(ts, theta_const+pfpt_const(1,:,imu), '-', 'Color', corr_cols(imu), 'LineWidth', 1);
    plot(ts, -theta_const-pfpt_const(2,:,imu), '-', 'Color', incorr_cols(imu), 'LineWidth', 1);
end
xlim([0 t]);  ylim([-2 5]);

% time-varying boundary
figure('Color','white'); hold on
plot([0 t], [1 1]*theta_vary(1), 'k--');
plot([0 t], -[1 1]*theta_vary(1), 'k--');
plot(ts, theta_vary, 'k-', 'LineWidth', 2);
plot(ts, -theta_vary, 'k-', 'LineWidth', 2);
for imu = 1:nmu
    plot(ts, theta_vary(1)+pfpt_vary(1,:,imu), '-', 'Color', corr_cols(imu), 'LineWidth', 1);
    plot(ts, -theta_vary(1)-pfpt_vary(2,:,imu), '-', 'Color', incorr_cols(imu), 'LineWidth', 1);
end
xlim([0 t]);  ylim([-2 5]);

% psychometric/chronometric curves
figure('Color', 'white');
subplot(2,1,1);  hold on;
plot(mus, fptmoments_const(1,:), 'go-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
plot(mus, fptmoments_const(2,:), 'ro--', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
xlim([0 max(mus)]);  ylim([0 1]);
ylabel('decision time');  legend('corr', 'incorr');
subplot(2,1,2);  hold on;
plot(mus, fptmoments_const(5,:), 'ko-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
plot([0 max(mus)], [0.5 0.5], 'k--');
xlim([0 max(mus)]);  ylim([0.4 1]);
xlabel('\mu');  ylabel('fraction correct');

figure('Color', 'white');
subplot(2,1,1);  hold on;
plot(mus, fptmoments_vary(1,:), 'go-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
plot(mus, fptmoments_vary(2,:), 'ro-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
xlim([0 max(mus)]);  ylim([0 1]);
ylabel('decision time');  legend('corr', 'incorr');
subplot(2,1,2);  hold on;
plot(mus, fptmoments_vary(5,:), 'ko-', 'LineWidth', 2, 'MarkerFace', [1 1 1]);
xlim([0 max(mus)]);  ylim([0.4 1]);
plot([0 max(mus)], [0.5 0.5], 'k--');
xlabel('\mu');  ylabel('fraction correct');

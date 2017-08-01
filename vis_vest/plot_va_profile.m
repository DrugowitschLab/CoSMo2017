function plot_va_profile
%% example plot of velocity and acceleration profile
%
% Plots the velocity and acceleration profile, using va_profile(.)
%
% Jan Drugowitsch, July 2017

%% settings
dt = 0.01;
v_col = cond_color(1, 0.25);    % visual modality for velocity color
a_col = cond_color(2);          % vestibular modality for acc. color


%% get profiles and plot them
[vn, an, ts] = va_profile(dt);
figure('Color', 'white');  hold on;
plot(ts, vn, '-', 'Color', v_col, 'LineWidth', 2);
plot(ts, an, '-', 'Color', a_col, 'LineWidth', 2);
plot([0 ts(end)], [0 0], 'k-', 'LineWidth', 1);
xlabel('time [s]');
ylabel('v(t) / a(t)');
legend('vel', 'acc');
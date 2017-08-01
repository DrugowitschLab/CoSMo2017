function sim_weighted_diffusion()
%% simulates a DDM optimally accumulating evidence of varying reliability
%
% The script, once modified, simulated a set of trials that optimally
% accumulates evidence of time-varying reliability. By default, it does not
% perform any reliability-weighting.
%
% You should modify the script first in the 'simulate diffusion model'
% section at the indicated line to perform reliability-weighted evidence
% accumulation, following the derivation of the Bayes-optimal strategy for
% doing so.
%
% Second, you should go through the derivation of how to combine evidence
% from multiple sources, and modify the 'reliability time-course' to
% generate diffusion model simulations that accumulate evidence from both
% the visual modality (reliability kvis, time-course vn) and vestibular
% modality (reliability kvest, time-course an). This will yield new
% expressions for k and dn.
%
% Jan Drugowitsch, July 2017

%% settings
dt = 0.01;      % simulation time-steps
h = 3 * pi/180; % heading direction in rad
kvis = 30;      % reliability of visual modality
kvest = 25;     % reliability of vestibular modality
theta = 0.5;    % diffusion model bound
trials = 50;    % number of trials to simulate

zh = sin(h);  % informativeness of heading direction


%% get velocity and acceleration time-course
% vn and an will be velocity and acceleration in steps of dt
[vn, an, ts] = va_profile(dt);
nt = length(ts);
tmax = ts(end);


%% reliability time-course
% YOU SHOULD MODIFY THE BELOW LINES TO ACCUMULATE EVIDENCE FROM MULTIPLE
% SOURCES (step 2)
k = kvis;     % reliability
dn = vn;      % relibaility time-course


%% simulate diffusion model
xs = NaN(trials, nt);   % xs stores trajectoris, trial x time
sqrtdt = sqrt(dt);      % sqrtdt * randn() will be ~N(0, dt)
for trial = 1:trials
    % starting point of diffusing particle
    xs(trial, 1) = 0.0;
    for i = 2:nt
        % sample momentary evidence, dxi ~ N(zh dn k dt, dt)
        dxi = zh * dn(i) * k * dt + sqrtdt * randn();
        
        % YOU SHOULD MODIFY THE BELOW LINE TO INTRODUCE WEIGHTING BY
        % EVIDENC RELIABILITY (step 1)
        % add this momentary evidence to current particle location
        xs(trial, i) = xs(trial, i-1) + dn(i) * dxi;
        
        % stop accumulation when bound crossed
        if abs(xs(trial,i)) > theta
            % make sure to not exceed bound
            xs(trial,i) = theta * sign(xs(trial,i));
            % break out of inner loop over i, go to next trial
            break
        end
    end
end


%% plot simulated trajectories
figure('Color', 'white'); hold on;
% trajectories
for trial = 1:trials
    plot(ts, xs(trial,:), '-', 'Color', [1 1 1] * 0.5);
end
% diffusion bounds and center
plot([0 tmax], theta*[1 1], 'k-', 'LineWidth', 2);
plot([0 tmax], -theta*[1 1], 'k-', 'LineWidth', 2);
plot([0 tmax], [0 0], 'k--');
xlabel('time');
ylabel('particle location');


%% plot variance of increment vs. reliability time-course
figure('Color', 'white');
subplot(2,1,1);  hold on;
% compute variance in change in xs over time.
% using nanvar here, as trials might be of different lengths
xsdiffvar = nanvar(diff(xs,[],2)/dt,[],1);
plot(ts(2:end), xsdiffvar, 'k-', 'LineWidth', 2);
xlim([0 tmax]);
ylabel('dx/dt variance across trials');
% reliability time-course over time
subplot(2,1,2);  hold on;
plot(ts, dn.^2, 'b-', 'LineWidth', 2);
xlim([0 tmax]);
xlabel('time');  ylabel('reliability^2');
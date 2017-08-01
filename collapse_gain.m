function collapse_gain
%% Identifying the task-dependent gain for collapsing boundaries
%
% If the choice difficulty across conditions varies, the optimal decision
% boundaries in belief are known to collapse over time. This tutorial
% addresses the question of how much one gains from having these boundaries
% collapse when compared to a non-collapsing strategy.
%
% The task assumes a Gaussian prior over mu ~ N(0, sigmu2), where sigmu2
% controls the overall task difficulty (larger sigmu2 -> easier task). In
% addition, there is a cost c per second for accumulating evidence. The
% quality of a decision strategy is measured by its overall expected
% reward ER,
%                    ER = <PC> - c <T>
% where <PC> is the probability of performing correct choices, averaged
% over all values of mu, and <T> is the average decision time (i.e.,
% evidence accumulation duration), again averaged over all values of mu.
%
% The tutorial's aim is to compare the expected reward associated with the
% optimal strategy to that associated with using a diffusion model with a
% constant boundary for different values of sigmu2 and c. This identifies
% under which circumstances it makes sense to implement a collapsing
% boundary rather than a simpler, constant boundary.
%
% Implementation:
% The script iterates over different values for sigmu2 for a fixed c, and
% over different values for c for a fixed sigmu2. For each sigmu2 / c
% combination, it needs to compute two things: (i) the expected reward
% resulting from the optimal strategy, and (ii) the expected reward
% resulting from a diffusion model with a constant boundary.
%
% To find the expected reward resulting from the optimal strategy, recall
% that the value function V(g,t) returns the expected reward when holding
% belief g at time t and behaving optimally thereafter. Therefore, the
% overall expected reward corresponds to the value function at belief g=1/2
% and time t=0, which is the decision-maker's state at trial onset. Thus,
% to find this expected reward, we only need to find the value function
% corresponding to the optimal policy, but not the associated boundaries.
%
% To find the expected reward resulting from a constant diffusion model
% boundary, we can use the expressions
%   <PC|mu> = 1 / (1 + exp(-2 theta |mu|)),
%    <T|mu> = theta / mu tanh(theta mu)   if mu > 0,
%             theta^2                     if mu == 0,
% where theta > 0 is the bound height. These expressions corresponds to a
% known drift rate. However, the expected reward is defined as an average
% over all drift rates. To compute this average, we can discretize the
% prior mu into steps of equal probability mass, and then compute <PC> and
% <T> as an average over these steps.
%
% As a final, plot the expected rewards emerging from the two different
% strategies against each other for varying c and sigmu2.
%
% Note:
% The expected reward from dynamic programming might be below that arising
% from a diffusion model with constant boundaries. This is theoretically
% impossible, but might arise due to numerical approximations. In this
% case, try to lower dp_dt, increase dp_ng, and increase dp_tmax, all of
% which improve the quality of the dynamic programming solution.
%
% Bonus questions:
% - How do the optimal policy bounds compare to the constant diffusion
%   model bounds? For this, find the bounds as in
%   plot_dp_valueintersect_gauss(.), and map them into the particle space
%   by x(t) = norminv(g(t)) * sqrt(t + 1/sigmu2).
% - How much better would we do with a linearly collapsing bound compared
%   to a constant bound? Addressing this becomes harder, as we have no
%   expressions for <PC|mu> and <T|mu>. Instead, they need to be computed
%   by using ddm_fpt(..), followed by fpt_moments(..).
%
% Jan Drugowitsch, July 2017

%% task setting
c = 0.5;               % fixed evidence accumulation cost for varying sigmu2
sigmu2 = 1;            % fixed prior mu variance for varying c
cs = linspace(0.1, 2, 10);       % varying costs
sigmu2s = linspace(0.1, 2, 10);  % varying task difficulties


%% dynamic programming settings
dp_dt = 0.005;         % time steps for dynamic programming
dp_ng = 200;           % discretization steps for belief
dp_maxt = 10;          % maximum time for dynamic programming


%% fixed boundary settings
fb_nmu = 100;          % number of discretization steps in mu


%% for fixed signmu2, iterate over c's
opter_c = NaN(1, length(cs));
conster_c = NaN(1, length(cs));
fprintf('Evaluating strategies for costs');
for ic = 1:length(cs)
    fprintf(' %.2f', cs(ic));
    % find expected reward for optimal dynamic programming solution with
    % cost cs(ic) and prior variance sigmu2
    % Hint: use dp_getvalues_gauss_hyp & dp_discretized_g

    opter_c(ic) = % assign V(t=0, g=1/2)
    
    % find expected reward for constant bound diffusion model with cost
    % cs(ic) and prior variance sigmu2
    % Hint: use fminsearch or fminbnd to find bound theta that mimimizes
    %       the negative expected reward returned by fixedbound_er

    conster_c(ic) = % assign expected reward for best theta
end
fprintf('\n');


%% for fixed c, iterate over sigmu2's
% replicate the above code for varying sigmu2 rather than varying c
opter_sigmu2 = NaN(1, length(cs));
conster_sigmu2 = NaN(1, length(cs));
fprintf('Evaluating strategies for variances');
for isigmu2 = 1:length(sigmu2s)
    fprintf(' %.2f', sigmu2s(isigmu2));
    % find expected reward for optimal dynamic programming solution with
    % cost c and prior variance sigmu2s(isigmu2)
    
    opter_sigmu2(isigmu2) = % assign V(t=0, g=1/2)

    % find expected reward for constant bound diffusion model with cost
    % c and prior variance sigmu2s(isigmu2)
    
    conster_sigmu2(isigmu2) = % assign expected reward for best theta;
end
fprintf('\n');


%% plot results
% plot opter_c and conster_c over cs & do the same for a varying sigmu2
figure('Color', 'white');  hold on;
plot(cs, opter_c, 'k-', 'LineWidth', 2);
plot(cs, conster_c, 'r--', 'LineWidth', 2);
legend('optimal', 'constant');
xlabel('accumulation cost');
ylabel('expected reward');

figure('Color', 'white');  hold on;
plot(sigmu2s, opter_sigmu2, 'k-', 'LineWidth', 2);
plot(sigmu2s, conster_sigmu2, 'r--', 'LineWidth', 2);
legend('optimal', 'constant');
xlabel('prior variance');
ylabel('expected reward');


function er = fixedbound_er(theta, c, sigmu2, nmu)
%% returns the expected reward for a diffusion model with fixed bounds
%
% theta is the bound height (needs to be non-negative), c is the evidence
% accumulation cost, sigmu2 is the prior variance, and nmu is the number of
% steps to approximate the average over all possible mu's.

% make sure that bound is always non-negative
if theta < 0, theta = 0; end

% mu's as percentiles of p(mu), such that each has equal probability mass
mus = sqrt(sigmu2) * norminv(linspace(0.5/nmu, 1-0.5/nmu, nmu));

% compute probability correct and average decision time
pcs = % compute <PC|mu> for all mu's
dts = % compute <DT|mu> for all mu's

% compute er by averaging across pcs and dts
er = % compute expected reward as average over <PC|mu> and <DT|mu>


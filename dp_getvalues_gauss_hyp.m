function [Vd, Ve] = dp_getvalues_gauss_hyp(gs, dt, T, sigmu2, c)
%% computes values for deciding and accumulating by backwards induction
%
% gs is the discretised belief (row) vector, dt is the time-steps for the
% belief transition density, T is the time of the last computed value,
% sigmu2 is the a-priori variance of mu (determining the overall task
% difficulty), and c is the accumulation cost per unit time.
%
% The returned Vd is the value function (as row vector) associated with
% immediate decisions, max(g, 1-g).
%
% Ve is the value function per time-step, associated with continuing to
% accumulate more evidence. This value function is computed for N
% time-steps 0:dt:T, and is returned in the N x K matrix, where K is the
% length of gs. Ve(1,:) corresponds to time t = 0.
%
% The intersection between Ve and Vd determined the bound at which it is
% best to stop accumulating evidence. This intersection can be found by
% the function valueintersect(.).
%
% Jan Drugowitsch, July 2017

%% value function for immediate decisions
Vd = max(gs, 1-gs);


%% time steps
ts = 0:dt:T;
N = length(ts);


%% compute Ve by backwards induction
invgs = norminv(gs);
Ve = NaN(N, length(gs));
for i = N:-1:1
    % compute next value, V(g, t(i) + dt)
    if i == N
        % in the last step, there is no next Ve
        Vt1 = Vd;
    else
        Vt1 = max(Vd, Ve(i+1, :));
    end
    % based on this, compute current value for accumulating more evidence
    gg = dp_g_trans_gauss_hyp(invgs, dt / (ts(i) + 1/sigmu2));
    % Vt1 * gg' results in the expected future value
    Ve(i, :) = Vt1 * gg' - c * dt;
end

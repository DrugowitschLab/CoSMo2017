function gg = dp_g_trans_gauss_hyp(invgs, dteff)
%% Returns the belief transition matrix p(g' | g, t)
%
% The N x N belief transition matrix gg specifies for a given time t for
% each belief gk the probability p(gj | gk, t) of transitioning to belief
% gj after observing dt more evidence. Element gg(k, j) holds p(gj | gk,
% t). The entries in the matrix are adequately normalised such that sum_j
% gg(k, j) = 1.
% 
% The matrix is computed over the N-element inverse belief row vector
% invgs. invgs contains the normal inverse cumulatives of the discretised
% beliefs in gs. They can be computed from the (row) belief vector by invgs
% = norminv(gs). This computation is not performed by the function, to
% avoid replicating the same computation for different t's. The underlying
% gs should neither include 0 as 1, as these cause numerical issues.
%
% dteff is the effective time-step, given by
% dteff = dt / (t + 1 / sig_mu^2),
% where dt is the desired time-step size, t is the time of interest, and
% sig_mu^2 is the width of the prior of the mu that determines the hidden
% state and evidence strength.
%
% Jan Drugowitsch, July 2017

% the below computes
% p(gj | gk, t) = 1/Z exp( invgj^2 / 2 - 
%                          (invgj - sqrt(1 + dteff) invgk)^2 / 2 dteff)
% which only includes terms that are vary with g' (i.e. gj).

% invgdiff(k,j) = invgj - sqrt(1 + dteff) invgk
invgdiff = bsxfun(@minus, invgs, sqrt(1 + dteff) * invgs');
% unnormalised gg
gg = exp(bsxfun(@minus, invgs.^2 / 2, invgdiff.^2 / (2 * dteff)));
% normalise gg
gg = bsxfun(@rdivide, gg, sum(gg, 2));
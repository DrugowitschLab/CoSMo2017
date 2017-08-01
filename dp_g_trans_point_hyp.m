function gg = dp_g_trans_point_hyp(gs, dt, mu0)
%% Returns the belief transition matrix p(g' | g)
%
% The N x N belief transition matrix gg specifies for each belief gk the
% probability p(gj | gk) of transitioning to belief gj after observing dt
% more evidence. Element gg(k, j) holds p(gj | gk). The entries in the
% matrix are adequately normalised such that sum_j gg(k, j) = 1.
% 
% The matrix is computed over the N-element belief row vector gs. gs should
% neither include 0 as 1, as these cause numerical issues.
% 
% The assumed momentary evidence likleihood is p(dx | mu0 dt, dt).
%
% Jan Drugowitsch, July 2017

% the below computes
% p(gj | gk) = 1/Z exp(-(X(gj)-X(gk))^2 / 2dt) / (gj (1-gj)) *
%              ( gk exp(mu0 * (X(gj) - X(gk)) + 
%                (1-gk) exp(mu0 * (X(gk) - X(gj))
% which only includes terms that vary with g' (i.e. gj).

% sufficient statistics X(g) corresponding to each belief in gs
Xs = log(gs ./ (1 - gs)) / (2 * mu0);
% matrix of X(g') - X(g), with g along columns and g' along rows
Xdiff = bsxfun(@minus, Xs, Xs');

% mixture components of the transition matrix
ggmix = bsxfun(@times, gs', exp(Xdiff * mu0)) + ...
        bsxfun(@times, 1 - gs', exp(-Xdiff * mu0));
% common pre-factor
ggpre = bsxfun(@rdivide, exp(- Xdiff.^2 / (2 * dt)), gs .* (1 - gs));

% compute gg and normalize it
gg = ggmix .* ggpre;
gg = bsxfun(@rdivide, gg, sum(gg, 2));
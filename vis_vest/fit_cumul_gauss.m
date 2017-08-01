function [sig, bias, a, b] = fit_cumul_gauss(oris, choice, verbose)
%% fits a cumulative Gaussian to the psychometric data
%
% For the given vector of orientations and choices, the function finds the
% maximum likelihood parameters [sig, bias, a, b], assuming the choice
% likelihood to be given by
%
% p(choice_n = 1 | ori_n) = (1-a) Phi( (ori_n - bias) / sig ) + a b
%
% where Phi(.) is the cumulative function of the standard Gaussian.
%
% If verbose is given and true, the optimization is verbose.
%
% Jan Drugowitsch, July 2017


%% process arguments
assert(all(size(oris) == size(choice)));  % oris and choice have same size
verbose = nargin > 2 && logical(verbose);


%% perform minimization of negative log-likelihood of data
if verbose
    opt = optimset('Display','iter','GradObj','on');
else
    opt = optimset('Display','notify','GradObj','on');
end
x = fmincon(@(x) llh_f(x, oris, choice), [1 0 0.2 0.2], [], [], [], [], ...
           [0 -Inf 0 0], [Inf Inf 1 1], [], opt);
sig = x(1);
bias = x(2);
a = x(3);
b = x(4);


function [neg_llh, neg_llh_grad] = llh_f(x, oris, choice)
%% returns the negative log-likelihood and its gradient
%
% The function computes the log-likelihood
%
% llh = sum_n log p(choice_n | ori_n)
%
% with parameters x = [sig, bias, a, b], and returns the negative
% log-likelihood and its gradient with respect to all parameters.


%% extract parameters and constraint their values
sig = x(1);
bias = x(2);
a = x(3);
b = x(4);
if sig <= 0 || a < 0 || a > 1 || b < 0 || b > 1
    neg_llh = Inf;
    neg_llh_grad = Inf(1, 4);
    return
end

%% pre-compute some statistics
res = (oris - bias) / sig;
Phires = normcdf(res);
aNres = exp(- 0.5 * res.^2) * ((1-a) / sqrt(2 * pi));
% split into components related to different choices
choice1 = choice == 1;
res1 = res(choice1);        res0 = res(~choice1);
Phires1 = Phires(choice1);  Phires0 = Phires(~choice1);
aNres1 = aNres(choice1);    aNres0 = aNres(~choice1);
% avoid too small p's
pchoice1 = max(1e-60, (1-a) * Phires1 + a * b);
pchoice0 = max(1e-60, 1 - (1-a) * Phires0 - a * b);

% negative log-likelihood
neg_llh = - sum(log(pchoice1)) - sum(log(pchoice0));
% log-likelihood gradient components
grad_sig = (- sum((aNres1 .* res1) ./ pchoice1) + sum((aNres0 .* res0) ./ pchoice0)) / sig;
grad_bias = (- sum(aNres1 ./ pchoice1) + sum(aNres0 ./ pchoice0)) / sig;
grad_a = sum((b - Phires1) ./ pchoice1) - sum((b - Phires0) ./ pchoice0);
grad_b = a / (sum(1 ./ pchoice1) - sum(1 ./ pchoice0));
neg_llh_grad = - [grad_sig grad_bias grad_a grad_b];

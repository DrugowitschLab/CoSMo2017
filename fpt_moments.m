function [m1, m2, v1, v2, p1] = fpt_moments(g1, g2, dt)
%% computes mean and variance for the given FPT densities
%
% The two first-passage time densities, g1 and g2, are given as vectors,
% specifying the densities in steps of dt, starting at t=0. The function
% computes the mean and variance of the first-passage times, and returns
% them for both densities.
%
% The function also works if the densities overall don't sum up to 1, by
% re-balancing their respective weights. It returns the overall weight of
% g1 (corresponding to the probability that boundary 1 is hit) as p1.
% WARNING: if there is a significant amount of first-passage time
% probability mass meyond the range of g1 and g2, then the means,
% variances, and p1 will be inaccurate!
%
% Jan Drugowitsch, July 2017

%% check inputs
n = length(g1);
assert(length(g2) == n);


%% re-balancing g1 and g2
gsum = sum(g1) + sum(g2);
if gsum < 1e-10
    error('insufficient probability mass: sum(g1) + sum(g2) < 1e-10');
end
% ensures that sum(g1) + sum(g2) = 1
g1 = g1(:) / gsum;
g2 = g2(:) / gsum;
p1 = sum(g1);


%% compute moments
g1sum = sum(g1);
g2sum = sum(g2);
ts = (0:(n-1))' * dt;
m1 = sum(ts .* g1) / g1sum;
m2 = sum(ts .* g2 / g2sum);
% using var(x) = <x^2> - <x>^2
v1 = max(0, sum(ts.^2 .* g1) / g1sum - m1^2);
v2 = max(0, sum(ts.^2 .* g2) / g2sum - m2^2);
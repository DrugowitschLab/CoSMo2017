function g = dp_valueintersect(gs, Vd, Ve)
%% returns the belief at which the two value functions intersect.
%
% gs is the discretised belief (row) vector, Vd is the vector of values
% corresponding to immediate decisions, and Ve is the vector of value for
% continuing to accumulate evidence. Both Vd and Ve are assumed to be
% symmetric around g=0.5, and gs is assumes to have an even number of
% elements.
%
% The function uses linear interpolation to return the belief (above 0.5)
% at which Vd and Ve intersect.
%
% Jan Drugowitsch, July 2017

%% check inputs
% gs needs to have an even number of elements
N = length(gs);
assert(mod(N, 2) == 0);
% Vd and Ve need to have the same size as gs
assert(length(Vd) == N);
assert(length(Ve) == N);


%% remove the bottom half (g < 0.5) from all vectors
N2 = N / 2 + 1;
gs = gs(N2:end);
Vd = Vd(N2:end);
Ve = Ve(N2:end);


%% find first point at which Vd > Ve, computing corresponding g
i = find(Vd > Ve, 1);
if isempty(i)
    % Vd is never larger than Ve -> bound at 1
    g = 1;
elseif i == 1
    % Vd is always larger than Ve -> bound at 0.5
    g = 0.5;
else
    % bound by linear interpolation between indices i-1 and i
    g = gs(i-1) + (Vd(i-1) - Ve(i-1)) * (gs(i) - gs(i-1)) / ...
                  (Ve(i) - Vd(i) - Ve(i-1) + Vd(i-1));
end
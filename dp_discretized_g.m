function [gs, dg] = dp_discretized_g(ng)
%% returns a row vector gs of discretised beliefs
%
% The beliefs are evenly discretised in steps of 1/ng, while skipping 0
% and 1.
%
% The returned dg is the step size in which the beliefs are discretised.
%
% Jan Drugowitsch, July 2017

dg = 1 / ng;
gs = linspace(dg / 2, 1 - dg / 2, ng);
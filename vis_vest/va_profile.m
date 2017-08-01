function [vn, an, ts] = va_profile(dt)
%% returns the velocity and acceleration profile for the vis/vest RT task
%
% dt is the time step size in which the two profiles are discretized. The
% function returns row vectors vn, an, and ts, containing the velocity
% profile, acceleration profile, and times, in steps of dt, spanning the
% whole 2 seconds of stimulus duration.
%
% See plot_va_profile(.) for an example of how to use this function.
%
% Jan Drugowitsch, July 2017

%% settings
% the velocity profile is a Gaussian with standard deviation sigv centered
% on 1s, and extending from 0 to 2s. The total distance traveled,
% corresponding to the time-integral of the velocity, is 30cm.
sigv = 1 / (2 * 8^0.25);   % width of Gaussian profile
smax = 0.3;                % total distance traveled after 2s.


%% compute profiles
vgain = smax / (2 * normcdf(1/sigv) - 1);   % Gaussian gain to ensure smax
ts = (0:ceil(2 / dt)) * dt;            % times from 0 to 2s in steps of dt
vn = (vgain / (sqrt(2 * pi) * sigv)) * exp(- (ts - 1).^2 / (2 * sigv^2));
% don't compute an if not requested
if nargout > 1
    an = vn .* (1 - ts) / sigv^2;
end
return

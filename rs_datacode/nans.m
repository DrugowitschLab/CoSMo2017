function x = nans(m,n,o,p,q,r)
% makes an array of nans, analogous to the matlab functions ones and zeros.
% this just saves typing of nan* ones(...)

% 5/9/97 mns wrote it

if nargin < 1
  error('nans requires an argument')
end

if nargin > 6
  error('dimensions too high.  try nan*ones(...)')
end

switch nargin
case 1
  x = ones(m);
case 2
  x = ones(m,n);
case 3
  x = ones(m,n,o);
case 4
  x = ones(m,n,o,p);
case 5
  x = ones(m,n,o,p,q)
case 6
  x = onese(m,n,o,p,q,r)
end  

x = nan*x;


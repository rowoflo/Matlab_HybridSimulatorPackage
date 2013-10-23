function cumulativeCost = sumCost(systemObj,cumulativeCost,instantaneousCost)
% The "sumCost" method aggregates the instantaneous cost into a
% cumlated cost value.
%
% SYNTAX:
%   cumulativeCost = sumCost(systemObj,cumulativeCost,instantaneousCost)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   cumulativeCost - (nCosts x 1 real number)
%       Current cost values.
%
%   instantaneousCost - (nCosts x 1 real number)
%       Instantaneous cost values.
%
% OUTPUTS:
%   cumulativeCost - (nCosts x 1 number)
%       Updated cumulative cost values.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   simulate.m | run.m | replay.m | policy.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 11-SEP-2011
%-------------------------------------------------------------------------------

%% Apply default values

%% Cost
cumulativeCost = cumulativeCost + instantaneousCost;

end

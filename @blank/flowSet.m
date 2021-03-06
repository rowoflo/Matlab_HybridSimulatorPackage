function flowSetValue = flowSet(blankObj,time,state,flowTime,jumpCount)
% The "flowSet" method sets the set where continuous time dynamics take
% place.
%
% SYNTAX:
%   flowSetValue = blankObj.flowSet()
%   ...
%   flowSetValue = blankObj.flowSet(time,state,flowTime,jumpCount)
%
% INPUTS:
%   blankObj - (1 x 1 simulate.blank)
%       An instance of the "simulate.blank" class.
%
%   time - (1 x 1 real number) [blankObj.time]
%       Current time.
%
%   state - (1 x 1 number) [blankObj.state]
%       Current state.
%
%   flowTime - (1 x 1 semi-positive real number) [blankObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [blankObj.jumpCount] 
%       Current jump count value.
%
% OUTPUTS:
%   flowSetValue - (1 x 1 number)
%      A value that defines if the system is in the flow set.
%      Positive values are in the set and negative values are outside
%      the set.
%
% NOTES:
%   It works best when the function outputs a series of smooth decreasing or
%   increasing values instead of boolean values for being in the set or out
%   of the set.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate, +simulate
%
% AUTHOR:
%    Rowland O'Flaherty (rowlandoflaherty.com)
%
% VERSION: 
%   Created 29-OCT-2013
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = blankObj.time; end
if nargin < 3, state = blankObj.state; end
if nargin < 4, flowTime = blankObj.flowTime; end
if nargin < 5, jumpCount = blankObj.jumpCount; end

%% Parameters


%% Variables


%% Set Definition


%% Status
flowSetValue = 1;

end

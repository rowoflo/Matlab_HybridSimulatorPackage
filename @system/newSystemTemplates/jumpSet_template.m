function jumpSetValue = jumpSet(SYSTEM_NAMEObj,time,state,flowTime,jumpCount)
% The "jumpSet" method sets the set where discrete time dynamics take
% place.
%
% SYNTAX:
%   jumpSetValue = SYSTEM_NAMEObj.jumpSet()
%   ...
%   jumpSetValue = SYSTEM_NAMEObj.jumpSet(time,state,flowTime,jumpCount)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%
%   time - (1 x 1 real number) [SYSTEM_NAMEObj.time]
%       Current time.
%
%   state - (NSTATES x 1 number) [SYSTEM_NAMEObj.state]
%       Current state.
%
%   flowTime - (1 x 1 semi-positive real number) [SYSTEM_NAMEObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [SYSTEM_NAMEObj.jumpCount] 
%       Current jump count value.
%
% OUTPUTS:
%   jumpSetValue - (1 x 1 number)
%      A value that defines if the system is in the jump set.
%      Positive values are in the set and negative values are outside
%      the set.
%
% NOTES:
%   It works best when the function outputs a series of smooth decreasing or
%   increasing values instead of boolean values for being in the set or out
%   of the set.
%
% NECESSARY FILES AND/OR PACKAGES:
%   NECESSARY_PACKAGE+simulate
%
% AUTHOR:
%    FULL_NAME (WEBSITE)
%
% VERSION: 
%   Created DD-MMM-YYYY
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = SYSTEM_NAMEObj.time; end
if nargin < 3, state = SYSTEM_NAMEObj.state; end
if nargin < 4, flowTime = SYSTEM_NAMEObj.flowTime; end
if nargin < 5, jumpCount = SYSTEM_NAMEObj.jumpCount; end

%% Parameters


%% Variables


%% Set Definition


%% Status
jumpSetValue = -1;

end

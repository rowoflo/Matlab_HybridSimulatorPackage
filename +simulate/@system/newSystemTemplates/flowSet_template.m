function flowSetValue = flowSet(SYSTEM_NAMEObj,time,state,flowTime,jumpCount)
% The "flowSet" method sets the set where continuous time dynamics take
% place.
%
% SYNTAX:
%   flowSetValue = flowSet(SYSTEM_NAMEObj,time,state)
%   flowSetValue = flowSet(SYSTEM_NAMEObj,time,state,flowTime)
%   flowSetValue = flowSet(SYSTEM_NAMEObj,time,state,flowTime,jumpCount)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "SYSTEM_NAMEObj.nStates" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
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
%   NECESSARY_PACKAGE+simulate
%
% AUTHOR:
%    FULL_NAME
%
% VERSION: 
%   Created DD-MMM-YYYY
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 4, flowTime = 0; end
if nargin < 5, jumpCount = 0; end

%% Parameters


%% Variables


%% Set Definition


%% Status
flowSetValue = 1;

end

function [statePlus,timePlus,setPriority] = jumpMap(SYSTEM_NAMEObj,time,state,input,flowTime,jumpCount)
% The "jumpMap" method sets the discrete time dynamics of the system.
%
% SYNTAX:
%   [statePlus,timePlus,setPriority] = SYSTEM_NAMEObj.jumpMap()
%   ...
%   [statePlus,timePlus,setPriority] = SYSTEM_NAMEObj.jumpMap(time,state,input,flowTime,jumpCount)
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
%   input - (NINPUTS x 1 number) [SYSTEM_NAMEObj.input]
%       Current input value.
%
%   flowTime - (1 x 1 semi-positive real number) [SYSTEM_NAMEObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [SYSTEM_NAMEObj.jumpCount] 
%       Current jump count value.
%
% OUTPUTS:
%   statePlus - (NSTATES x 1 number)
%       Updated states.
%
%   timePlus - (1 x 1 real number)
%       Updated time.
%
%   setPriority - ('flow','jump', or 'random')
%       Sets the priority to what takes place if the state is in both
%       the flow set and the jump set.
%
% NOTES:
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
if nargin < 4, input = SYSTEM_NAMEObj.input; end
if nargin < 5, flowTime = SYSTEM_NAMEObj.flowTime; end
if nargin < 6, jumpCount = SYSTEM_NAMEObj.jumpCount; end
timePlus = time;
setPriority = SYSTEM_NAMEObj.setPriority;

%% Parameters


%% Variables


%% Updates Of Motion


%% Output
statePlus = state;

end

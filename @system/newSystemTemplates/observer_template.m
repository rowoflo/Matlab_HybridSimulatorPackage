function stateHat = observer(SYSTEM_NAMEObj,time,state,input,flowTime,jumpCount)
% The "observer" method will produce estimates of the state values given
% the current time, state, and input of the system.
%
% SYNTAX:
%   stateHat = SYSTEM_NAMEObj.observer()
%   stateHat = SYSTEM_NAMEObj.observer(time)
%   stateHat = SYSTEM_NAMEObj.observer(time,state)
%   stateHat = SYSTEM_NAMEObj.observer(time,state,input)
%   stateHat = SYSTEM_NAMEObj.observer(time,state,input,flowTime)
%   stateHat = SYSTEM_NAMEObj.observer(time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%
%   time - (1 x 1 real number) [SYSTEM_NAMEObj.time]
%       Current time.
%
%   state - (? x 1 number) [SYSTEM_NAMEObj.state]
%       Current state. Must be a "SYSTEM_NAMEObj.nStates" x 1 vector.
%
%   input - (? x 1 number) [SYSTEM_NAMEObj.input]
%       Current input value. Must be a "SYSTEM_NAMEObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [SYSTEM_NAMEObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [SYSTEM_NAMEObj.jumpCount] 
%       Current jump count value.
%
% OUTPUTS:
%   stateHat - (? x 1 number)
%       Estimates of the states of the system. A "SYSTEM_NAMEObj.nStates" x
%       1 vector.
%
% NOTES:
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
if nargin < 2, time = SYSTEM_NAMEObj.time; end
if nargin < 3, state = SYSTEM_NAMEObj.state; end
if nargin < 4, input = SYSTEM_NAMEObj.input; end
if nargin < 5, flowTime = SYSTEM_NAMEObj.flowTime; end
if nargin < 6, jumpCount = SYSTEM_NAMEObj.jumpCount; end

%% Parameters


%% Variables


%% Observer Definition


%% Set output
stateHat = state;

end

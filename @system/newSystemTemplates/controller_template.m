function input = controller(SYSTEM_NAMEObj,time,state,flowTime,jumpCount)
% The "controller" method will produce input values given the current
% time and state of the system.
%
% SYNTAX:
%   input = SYSTEM_NAMEObj.controller()
%   input = SYSTEM_NAMEObj.controller(time)
%   input = SYSTEM_NAMEObj.controller(time,state)
%   input = SYSTEM_NAMEObj.controller(time,state,flowTime)
%   input = SYSTEM_NAMEObj.controller(time,state,flowTime,jumpCount)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%
%   time - (1 x 1 real number) [SYSTEM_NAMEObj.time]
%       Current time.
%
%   state - (NSTATES x 1 number) [SYSTEM_NAMEObj.state]
%       Current state. Must be a "SYSTEM_NAMEObj.nStates" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [SYSTEM_NAMEObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [SYSTEM_NAMEObj.jumpCount] 
%       Current jump count value.
%
% OUTPUTS:
%   input - (NINPUTS x 1 number)
%       Input values for the system. A "SYSTEM_NAMEObj.nInputs" x 1 vector.
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
if nargin < 4, flowTime = SYSTEM_NAMEObj.flowTime; end
if nargin < 5, jumpCount = SYSTEM_NAMEObj.jumpCount; end

%% Parameters


%% Variables


%% Controller Definition


%% Set input
input = zeros(SYSTEM_NAMEObj.nInputs,1);


end

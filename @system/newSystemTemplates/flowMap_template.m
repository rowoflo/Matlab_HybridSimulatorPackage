function [stateDot,setPriority] = flowMap(SYSTEM_NAMEObj,time,state,input,flowTime,jumpCount)
% The "flowMap" method sets the continuous time dynamics of the system.
%
% SYNTAX:
%   [stateDot,setPriority] = SYSTEM_NAMEObj.flowMap()
%   [stateDot,setPriority] = SYSTEM_NAMEObj.flowMap(time)
%   [stateDot,setPriority] = SYSTEM_NAMEObj.flowMap(time,state)
%   [stateDot,setPriority] = SYSTEM_NAMEObj.flowMap(time,state,input)
%   [stateDot,setPriority] = SYSTEM_NAMEObj.flowMap(time,state,input,flowTime)
%   [stateDot,setPriority] = SYSTEM_NAMEObj.flowMap(time,state,input,flowTime,jumpCount)
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
%   input - (NINPUTS x 1 number) [SYSTEM_NAMEObj.input]
%       Current input value. Must be a "SYSTEM_NAMEObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [SYSTEM_NAMEObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [SYSTEM_NAMEObj.jumpCount] 
%       Current jump count value.
%
% OUTPUTS:
%   stateDot - (NSTATES x 1 number)
%       Updated state derivatives. A "SYSTEM_NAMEObj.nStates" x 1 vector.
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
setPriority = SYSTEM_NAMEObj.setPriority;

%% Parameters


%% Variables


%% Equations Of Motion


%% Output
stateDot(:,1) = zeros(SYSTEM_NAMEObj.nStates,1);

end

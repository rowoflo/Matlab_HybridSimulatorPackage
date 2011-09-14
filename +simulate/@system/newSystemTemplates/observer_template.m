function stateHat = observer(SYSTEM_NAMEObj,time,state,input,flowTime,jumpCount)
% The "observer" method will produce estimates of the state values given
% the current time, state, and input of the system.
%
% SYNTAX:
%   stateHat = SYSTEM_NAMEObj.observer(time,state)
%   stateHat = SYSTEM_NAMEObj.observer(time,state,input)
%   stateHat = SYSTEM_NAMEObj.observer(time,state,input,flowTime)
%   stateHat = SYSTEM_NAMEObj.observer(time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 simulate.SYSTEM_NAME)
%       An instance of the "simulate.SYSTEM_NAME" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 real number)
%       Current state. Must be a "SYSTEM_NAMEObj.nStates" x 1 vector.
%
%   input - (? x 1 real number) [zeros(SYSTEM_NAMEObj.nInputs,1)]
%       Current input. Must be a "SYSTEM_NAMEObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
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
%   +simulate
%
% AUTHOR:
%   DD-MMM-YYYY by FULL_NAME
%
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 4, input = zeros(SYSTEM_NAMEObj.nInputs,1);
if nargin < 5, flowTime = 0; end
if nargin < 6, jumpCount = 0; end

%% Parameters


%% Variables


%% Observer Definition


%% Set output
stateHat = state;

end

function input = policy(systemObj,time,state,flowTime,jumpCount)
% The "policy" method creates input values based time and state information
% for either open-loop control or closed loop control. This is determined
% by the "openLoopControl" property ("true" for open-loop control and
% "false" for closed loop control). The open-loop controller is determined
% by the "openLoopTimeTape" and "openLoopInputTape" properties and the
% closed loop control is determined by the "controller" method.
%
% SYNTAX:
%   input = policy(systemObj,time)
%   input = policy(systemObj,time,state)
%   input = policy(systemObj,time,state,flowTime)
%   input = policy(systemObj,time,state,flowTime,jumpCount)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number) [systemoObj.state]
%       Current state. Must be a "systemObj.nStates" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS: TODO: Add outputs
%   input - (? x 1 number)
%       Input values for the system. A "systemObj.nInputs" x 1 vector.
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
if nargin < 3, state = systemObj.state; end
if nargin < 4, flowTime = 0; end
if nargin < 5, jumpCount = 0; end

%% Input Policy
if systemObj.openLoopControl
    timeIndex = find(time >= systemObj.openLoopTimeTape,1,'last');
    if isempty(timeIndex)
        input = zeros(systemObj.nInputs,1);
    else
        input = systemObj.openLoopInputTape(:,timeIndex);
    end
else
    input = systemObj.controller(time,state,flowTime,jumpCount);
end

end

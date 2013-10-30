function input = policy(systemObj,time,state,input,output,flowTime,jumpCount)
% The "policy" method creates input values based on time and state information
% for either open-loop control or closed-loop control. This is determined
% by the "openLoopControl" property ("true" for open-loop control and
% "false" for closed-loop control). The open-loop controller is determined
% by the "openLoopTimeTape" and "openLoopInputTape" properties and the
% closed loop control is determined by the "controller" method.
%
% SYNTAX:
%   input = policy(systemObj,time)
%   ...
%   input = policy(systemObj,time,state,input,output,flowTime,jumpCount)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (nStates x 1 number) [systemObj.state]
%       Current state.
%
%   input - (nInputs x 1 number) [systemObj.input]
%       Current input value.
%
%   output - (nOuputs x 1 number) [systemObj.output]
%       Output values for the plant.
%
%   flowTime - (1 x 1 semi-positive real number) [systemObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [systemObj.jumpCount] 
%       Current jump count value.
%
% OUTPUTS:
%   input - (nInputs x 1 number)
%       Input values for the system.
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
%   Rowland O'Flaherty (rowlandoflaherty.com)
%
% VERSION: 
%   Created 11-SEP-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 3, state = systemObj.state; end
if nargin < 4, input = systemObj.input; end
if nargin < 5, output = systemObj.output; end
if nargin < 6, flowTime = systemObj.flowTime; end
if nargin < 7, jumpCount = systemObj.jumpCount; end

%% Input Policy
if systemObj.openLoopControl
    timeIndex = find(time >= systemObj.openLoopTimeTape,1,'last');
    if isempty(timeIndex)
        input = zeros(systemObj.nInputs,1);
    else
        input = systemObj.openLoopInputTape(:,timeIndex);
    end
else
    stateHat = systemObj.observer(time,state,input,output,flowTime,jumpCount);
    systemObj.stateBar = stateTraj2stateBar(time,systemObj.timeTrajTape,systemObj.stateTrajTape);
    input = systemObj.controller(time,stateHat,input,output,flowTime,jumpCount);
end

end

function stateBar = stateTraj2stateBar(time,timeTrajTape,stateTrajTape)
tInd = find(time >= timeTrajTape,1,'last');
if isempty(tInd)
    stateBar = zeros(size(stateTrajTape,1),1);
else
    stateBar = stateTrajTape(:,tInd);
end
end

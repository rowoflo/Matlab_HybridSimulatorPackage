function stateHat = observer(pendulumObj,time,state,input,output,flowTime,jumpCount)
% The "observer" method will produce estimates of the state values given
% the current time, state, and input of the system.
%
% SYNTAX:
%   stateHat = pendulumObj.observer(time,state)
%   stateHat = pendulumObj.observer(time,state,input)
%   stateHat = pendulumObj.observer(time,state,input,output)
%   stateHat = pendulumObj.observer(time,state,input,output,flowTime)
%   stateHat = pendulumObj.observer(time,state,input,output,flowTime,jumpCount)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.pendulum)
%       An instance of the "simulate.pendulum" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 real number)
%       Current state. Must be a "pendulumObj.nStates" x 1 vector.
%
%   input - (? x 1 real number) [zeros(pendulumObj.nInputs,1)]
%       Current input. Must be a "pendulumObj.nInputs" x 1 vector.
%
%   output - (? x 1 number) [pendulumObj.output]
%       Output values for the plant. A "triadObj.nOutputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   stateHat - (? x 1 number)
%       Estimates of the states of the system. A "pendulumObj.nStates" x
%       1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate, +simulate
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 23-OCT-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = pendulumObj.time; end
if nargin < 3, state = pendulumObj.state; end
if nargin < 4, input = pendulumObj.input; end
if nargin < 5, output = pendulumObj.output; end
if nargin < 6, flowTime = pendulumObj.flowTime; end
if nargin < 7, jumpCount = pendulumObj.jumpCount; end


%% Parameters


%% Variables


%% Observer Definition


%% Set output
stateHat = state;

end

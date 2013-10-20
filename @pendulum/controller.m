function input = controller(pendulumObj,time,state,input,flowTime,jumpCount)
% The "controller" method will produce input values given the current
% time and state of the system.
%
% SYNTAX:
%   input = pendulumObj.controller()
%   input = pendulumObj.controller(time)
%   input = pendulumObj.controller(time,state)
%   input = pendulumObj.controller(time,state,input)
%   input = pendulumObj.controller(time,state,input,flowTime)
%   input = pendulumObj.controller(time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.pendulum)
%       An instance of the "simulate.pendulum" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "pendulumObj.nStates" x 1 vector.
%
%   input - (? x 1 number) [pendulumObj.input]
%       Current input value. Must be a "pendulumObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   input - (? x 1 number)
%       Input values for the system. A "pendulumObj.nInputs" x 1 vector.
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
if nargin < 5, flowTime = pendulumObj.flowTime; end
if nargin < 6, jumpCount = pendulumObj.jumpCount; end

%% Parameters


%% Variables


%% Controller Definition


%% Set input
input = zeros(pendulumObj.nInputs,1);


end

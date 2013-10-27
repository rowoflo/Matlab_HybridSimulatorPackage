function input = controller(pendulumObj,time,state,input,output,flowTime,jumpCount)
% The "controller" method will produce input values given the current
% time and state of the system.
%
% SYNTAX:
%   input = pendulumObj.controller()
%   input = pendulumObj.controller(time)
%   input = pendulumObj.controller(time,state)
%   input = pendulumObj.controller(time,state,input)
%   input = pendulumObj.controller(time,state,input,output)
%   input = pendulumObj.controller(time,state,input,output,flowTime)
%   input = pendulumObj.controller(time,state,input,output,flowTime,jumpCount)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.pendulum)
%       An instance of the "simulate.pendulum" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (nStates x 1 number)
%       Current state.
%
%   input - (nInputs x 1 number) [pendulumObj.input]
%       Current input value.
%
%   output - (nOuputs x 1 number) [pendulumObj.output]
%       Output values for the plant.
%
%   flowTime - (1 x 1 semi-positive real number) [pendulumObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [pendulumObj.jumpCount] 
%       Current jump count value.
%
% OUTPUTS:
%   input - (? x 1 number)
%       Input values for the system.
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
if nargin < 5, output = tyroObj.output; end
if nargin < 6, flowTime = tyroObj.flowTime; end
if nargin < 7, jumpCount = tyroObj.jumpCount; end

%% Parameters


%% Variables


%% Controller Definition


%% Set input
input = zeros(pendulumObj.nInputs,1);


end

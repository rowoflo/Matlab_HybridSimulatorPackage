function instantaneousCost = cost(blankObj,time,state,input,output,flowtime,jumpCount)
% The "cost" method will produce cost values given the current
% time and state of the system.
%
% SYNTAX:
%   instantaneousCost = pendulumObj.cost(time)
%   instantaneousCost = pendulumObj.cost(time,state)
%   instantaneousCost = pendulumObj.cost(time,state,input)
%   instantaneousCost = pendulumObj.cost(time,state,input,output)
%   instantaneousCost = pendulumObj.cost(time,state,input,output,flowtime)
%   instantaneousCost = pendulumObj.cost(time,state,input,output,flowtime,jumpCount)
%
% INPUTS:
%   blankObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number) [blankObj.time]
%       Current time.
%
%   state - (1 x 1 number) [blankObj.state]
%       Current state.
%
%   input - (1 x 1 number) [blankObj.input]
%       Current input value.
%
%   output - (1 x 1 number) [blankObj.output]
%       Output values for the plant.
%
%   flowTime - (1 x 1 semi-positive real number) [blankObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [blankObj.jumpCount]
%       Current jump count value.
%
% OUTPUTS:
%   instantaneousCost - (1 x 1 real number)
%       Instantaneous cost values for the system.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 26-OCT-2013
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = blankObj.time; end
if nargin < 3, state = blankObj.state; end
if nargin < 4, input = blankObj.input; end
if nargin < 5, output = blankObj.output; end
if nargin < 6, flowTime = blankObj.flowTime; end
if nargin < 7, jumpCount = blankObj.jumpCount; end


%% Parameters


%% Variables


%% Cost Definition


%% Set output
instantaneousCost = zeros(blankObj.nCosts,1);

end

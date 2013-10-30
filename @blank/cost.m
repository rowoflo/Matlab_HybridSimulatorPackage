function instantaneousCost = cost(blankObj,time,state,input,output,flowTime,jumpCount,...
    timeBar,stateBar,inputBar,outputBar)
% The "cost" method will produce cost values given the current
% time and state of the system.
%
% SYNTAX:
%   instantaneousCost = blankObj.cost(time)
%   ...
%   instantaneousCost = blankObj.cost(time,state,input,output,flowTime,jumpCount,...
%       timeBar,stateBar,inputBar,outputBar)
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
%   timeBar - (1 x 1 real number) [blankObj.time]
%       Reference time value.
%
%   stateBar - (1 x 1 number) [blankObj.state]
%       Reference state value
%
%   inputBar - (1 x 1 number) [blankObj.input]
%       Reference input value.
%
%   outputBar - (1 x 1 number) [blankObj.output]
%       Reference output value.
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
%    Rowland O'Flaherty (rowlandoflaherty.com)
%
% VERSION: 
%   Created 29-OCT-2013
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = blankObj.time; end
if nargin < 3, state = blankObj.state; end
if nargin < 4, input = blankObj.input; end
if nargin < 5, output = blankObj.output; end
if nargin < 6, flowTime = blankObj.flowTime; end
if nargin < 7, jumpCount = blankObj.jumpCount; end
if nargin < 8, timeBar = blankObj.timeBar; end
if nargin < 9, stateBar = blankObj.stateBar; end 
if nargin < 10, inputBar = blankObj.inputBar; end
if nargin < 11, outputBar = blankObj.outputBar; end


%% Parameters


%% Variables


%% Cost Definition


%% Set output
instantaneousCost = zeros(blankObj.nCosts,1);

end

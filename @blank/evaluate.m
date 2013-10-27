function evaluate(blankObj,time,state,input,output,flowTime,jumpCount)
% The "evaluate" method is execute at each time step.
%
% SYNTAX:
%   blankObj.evaluate(time)
%   blankObj.evaluate(time,state)
%   blankObj.evaluate(time,state,input)
%   blankObj.evaluate(time,state,input,output)
%   blankObj.evaluate(time,state,input,output,flowtime)
%   blankObj.evaluate(time,state,input,output,flowtime,jumpCount)
%
% INPUTS:
%   blankObj - (1 x 1 simulate.blank)
%       An instance of the "simulate.blank" class.
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
%
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


%% Run


end

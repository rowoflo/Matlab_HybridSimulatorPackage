function evaluate(blankObj,time,state,input,output,...
        instantaneousCost,cumulativeCost,flowtime,jumpCount,...
        timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape) %#ok<INUSD,INUSL>
% The "evaluate" method is execute at each time step.
%
% SYNTAX:
%   blankObj.evaluate(time)
%   ...
%   blankObj.evaluate(time,state,input,output,...
%       instantaneousCost,cumulativeCost,flowtime,jumpCount,...
%       timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape)
%
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
%       Current input value from previous time to current time. Not the
%       input that will be applied from the current time to the next time.
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
%   timeTapeC - (1 x ? number) [blankObj.timeTapeC]
%       Current record of continuous times.
%
%   stateTape - (1 x ? number) [blankObj.timeTapeC]
%       Current record of continuous states.
%
%   timeTapeD - (1 x ? number) [blankObj.timeTapeD]
%       Current record of discrete times.
%
%   inputTape - (1 x ? number) [blankObj.inputTape]
%       Current record of discrete inputs.
%
%   outputTape - (1 x ? number) [blankObj.outputTape]
%       Current record of discrete outputs.
%
%   instantaneousCostTape - (nCosts x ? number) [blankObj.instantaneousCostTape]
%       Current record of discrete instantaneous costs.
%
%   cumulativeCostTape - (nCosts x ? number) [blankObj.cumulativeCostTape]
%       Current record of discrete comulative costs.
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
if nargin < 8, timeTapeC = blankObj.timeTapeC; end 
if nargin < 9, stateTape = blankObj.stateTape; end 
if nargin < 10, timeTapeD = blankObj.timeTapeD; end 
if nargin < 11, inputTape = blankObj.inputTape; end
if nargin < 12, outputTape = blankObj.outputTape; end
if nargin < 13, instantaneousCostTape = blankObj.instantaneousCostTape; end
if nargin < 14, cumulativeCostTape = blankObj.cumulativeCostTape; end

%% Parameters


%% Variables


%% Run


end

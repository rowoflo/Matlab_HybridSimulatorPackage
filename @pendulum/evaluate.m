function evaluate(pendulumObj,time,state,input,output,...
        instantaneousCost,cumulativeCost,flowtime,jumpCount,...
        timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape) %#ok<INUSD>
% The "evaluate" method is execute at each time step.
%
% SYNTAX:
%   pendulumObj.evaluate(time)
%   ...
%   pendulumObj.evaluate(time,state,input,output,...
%       instantaneousCost,cumulativeCost,flowtime,jumpCount,...
%       timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape)
%
% INPUTS:
%   pendulumObj - (1 x 1 tyro)
%       An instance of the "tyro" class.
%
%   time - (1 x 1 real number) [pendulumObj.time]
%       Current time.
%
%   state - (nStates x 1 number) [pendulumObj.state]
%       Current state.
%
%   input - (nInputs x 1 number) [pendulumObj.input]
%       Current input value from previous time to current time. Not the
%       input that will be applied from the current time to the next time.
%
%   output - (nOutputs x 1 number) [pendulumObj.output]
%       Output values for the plant.
%
%   flowTime - (1 x 1 semi-positive real number) [pendulumObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [pendulumObj.jumpCount] 
%       Current jump count value.
%
%   timeTapeC - (1 x ? number) [pendulumObj.timeTapeC]
%       Current record of continuous times.
%
%   stateTape - (nStates x ? number) [pendulumObj.timeTapeC]
%       Current record of continuous states.
%
%   timeTapeD - (1 x ? number) [pendulumObj.timeTapeD]
%       Current record of discrete times.
%
%   inputTape - (nInputs x ? number) [pendulumObj.inputTape]
%       Current record of discrete inputs.
%
%   outputTape - (nOutputs x ? number) [pendulumObj.outputTape]
%       Current record of discrete outputs.
%
%   instantaneousCostTape - (nCosts x ? number) [pendulumObj.instantaneousCostTape]
%       Current record of discrete instantaneous costs.
%
%   cumulativeCostTape - (nCosts x ? number) [pendulumObj.cumulativeCostTape]
%       Current record of discrete comulative costs.
%
% OUTPUTS:
%
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   NECESSARY_PACKAGE+simulate
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 23-OCT-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = pendulumObj.time; end %#ok<NASGU>
if nargin < 3, state = pendulumObj.state; end %#ok<NASGU>
if nargin < 4, input = pendulumObj.input; end %#ok<NASGU>
if nargin < 5, output = pendulumObj.output; end %#ok<NASGU>
if nargin < 6, flowTime = pendulumObj.flowTime; end %#ok<NASGU>
if nargin < 7, jumpCount = pendulumObj.jumpCount; end %#ok<NASGU>
if nargin < 8, timeTapeC = pendulumObj.timeTapeC; end %#ok<NASGU>
if nargin < 9, stateTape = pendulumObj.stateTape; end %#ok<NASGU>
if nargin < 10, timeTapeD = pendulumObj.timeTapeD; end %#ok<NASGU>
if nargin < 11, inputTape = pendulumObj.inputTape; end %#ok<NASGU>
if nargin < 12, outputTape = pendulumObj.outputTape; end %#ok<NASGU>
if nargin < 13, instantaneousCostTape = pendulumObj.instantaneousCostTape; end %#ok<NASGU>
if nargin < 14, cumulativeCostTape = pendulumObj.cumulativeCostTape; end %#ok<NASGU>

%% Parameters


%% Variables


%% Run


end
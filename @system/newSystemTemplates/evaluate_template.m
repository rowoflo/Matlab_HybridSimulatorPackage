function evaluate(SYSTEM_NAMEObj,time,state,input,output,...
        instantaneousCost,cumulativeCost,flowtime,jumpCount,...
        timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape) %#ok<INUSD,INUSL>
% The "evaluate" method is execute at each time step.
%
% SYNTAX:
%   SYSTEM_NAMEObj.evaluate(time)
%   ...
%   SYSTEM_NAMEObj.evaluate(time,state,input,output,...
%       instantaneousCost,cumulativeCost,flowtime,jumpCount,...
%       timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape)
%
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%
%   time - (1 x 1 real number) [SYSTEM_NAMEObj.time]
%       Current time.
%
%   state - (NSTATES x 1 number) [SYSTEM_NAMEObj.state]
%       Current state.
%
%   input - (NINPUTS x 1 number) [SYSTEM_NAMEObj.input]
%       Current input value.
%
%   output - (NOUTPUTS x 1 number) [SYSTEM_NAMEObj.output]
%       Output values for the plant.
%
%   flowTime - (1 x 1 semi-positive real number) [SYSTEM_NAMEObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [SYSTEM_NAMEObj.jumpCount] 
%       Current jump count value.
%
%   timeTapeC - (1 x ? number) [SYSTEM_NAMEObj.timeTapeC]
%       Current record of continuous times.
%
%   stateTape - (NSTATES x ? number) [SYSTEM_NAMEObj.timeTapeC]
%       Current record of continuous states.
%
%   timeTapeD - (1 x ? number) [SYSTEM_NAMEObj.timeTapeD]
%       Current record of discrete times.
%
%   inputTape - (NINPUTS x ? number) [SYSTEM_NAMEObj.inputTape]
%       Current record of discrete inputs.
%
%   outputTape - (NOUTPUTS x ? number) [SYSTEM_NAMEObj.outputTape]
%       Current record of discrete outputs.
%
%   instantaneousCostTape - (nCosts x ? number) [SYSTEM_NAMEObj.instantaneousCostTape]
%       Current record of discrete instantaneous costs.
%
%   cumulativeCostTape - (nCosts x ? number) [SYSTEM_NAMEObj.cumulativeCostTape]
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
%    FULL_NAME
%
% VERSION: 
%   Created DD-MMM-YYYY
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = SYSTEM_NAMEObj.time; end
if nargin < 3, state = SYSTEM_NAMEObj.state; end 
if nargin < 4, input = SYSTEM_NAMEObj.input; end
if nargin < 5, output = SYSTEM_NAMEObj.output; end
if nargin < 6, flowTime = SYSTEM_NAMEObj.flowTime; end
if nargin < 7, jumpCount = SYSTEM_NAMEObj.jumpCount; end
if nargin < 8, timeTapeC = SYSTEM_NAMEObj.timeTapeC; end 
if nargin < 9, stateTape = SYSTEM_NAMEObj.stateTape; end 
if nargin < 10, timeTapeD = SYSTEM_NAMEObj.timeTapeD; end 
if nargin < 11, inputTape = SYSTEM_NAMEObj.inputTape; end
if nargin < 12, outputTape = SYSTEM_NAMEObj.outputTape; end
if nargin < 13, instantaneousCostTape = SYSTEM_NAMEObj.instantaneousCostTape; end
if nargin < 14, cumulativeCostTape = SYSTEM_NAMEObj.cumulativeCostTape; end

%% Parameters


%% Variables


%% Run


end

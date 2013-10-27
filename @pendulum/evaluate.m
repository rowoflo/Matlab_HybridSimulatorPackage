function evaluate(pendulumObj,time,state,input,output,flowTime,jumpCount)
% The "evaluate" method is execute at each time step.
%
% SYNTAX:
%   pendulumObj.evaluate(time)
%   pendulumObj.evaluate(time,state)
%   pendulumObj.evaluate(time,state,input)
%   pendulumObj.evaluate(time,state,input,output)
%   pendulumObj.evaluate(time,state,input,output,flowtime)
%   pendulumObj.evaluate(time,state,input,output,flowtime,jumpCount)
%
% INPUTS:
%   pendulumObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%
%   time - (1 x 1 real number) [pendulumObj.time]
%       Current time.
%
%   state - (2 x 1 number) [pendulumObj.state]
%       Current state.
%
%   input - (1 x 1 number) [pendulumObj.input]
%       Current input value.
%
%   output - (2 x 1 number) [pendulumObj.output]
%       Output values for the plant.
%
%   flowTime - (1 x 1 semi-positive real number) [pendulumObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [pendulumObj.jumpCount] 
%       Current jump count value.
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
if nargin < 2, time = pendulumObj.time; end
if nargin < 3, state = pendulumObj.state; end
if nargin < 4, input = pendulumObj.input; end
if nargin < 5, output = pendulumObj.output; end
if nargin < 6, flowTime = pendulumObj.flowTime; end
if nargin < 7, jumpCount = pendulumObj.jumpCount; end

%% Parameters


%% Variables


%% Run


end
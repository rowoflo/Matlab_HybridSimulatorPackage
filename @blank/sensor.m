function output = sensor(blankObj,time,state,input,flowTime,jumpCount)
% The "sensor" method will produce output values given the current
% time and state of the system.
%
% SYNTAX:
%   output = blankObj.sensor()
%   output = blankObj.sensor(time)
%   output = blankObj.sensor(time,state)
%   output = blankObj.sensor(time,state,input)
%   output = blankObj.sensor(time,state,input,flowTime)    
%   output = blankObj.sensor(time,state,input,flowTime,jumpCount)
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
%   flowTime - (1 x 1 semi-positive real number) [blankObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [blankObj.jumpCount] 
%       Current jump count value.
%
% OUTPUTS:
%   output - (1 x 1 number)
%       Output values for the plant.
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
%   Created 21-OCT-2013
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = blankObj.time; end
if nargin < 3, state = blankObj.state; end
if nargin < 4, input = blankObj.input; end
if nargin < 5, flowTime = blankObj.flowTime; end
if nargin < 6, jumpCount = blankObj.jumpCount; end

%% Parameters


%% Variables


%% Sensor Definition


%% Set output
output = zeros(blankObj.nOutputs,1);

end

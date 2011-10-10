function output = sensor(pendulumObj,time,state,flowTime,jumpCount)
% The "sensor" method will produce output values given the current
% time and state of the system.
%
% SYNTAX:
%   output = pendulumObj.sensor(time,state)
%   output = pendulumObj.sensor(time,state,flowTime)
%   output = pendulumObj.sensor(time,state,flowTime,jumpCount)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.pendulum)
%       An instance of the "simulate.pendulum" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 real number)
%       Current state. Must be a "pendulumObj.nStates" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   output - (? x 1 number)
%       Output values for the plant. A "pendulumObj.nOutputs" x 1 vector.
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
%   Created 01-OCT-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 5, flowTime = 0; end
if nargin < 6, jumpCount = 0; end

%% Parameters


%% Variables


%% Sensor Definition


%% Set output
output = zeros(pendulumObj.nOutputs,1);

end

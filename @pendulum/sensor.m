function output = sensor(pendulumObj,time,state,input,flowTime,jumpCount) %#ok<INUSD,INUSL>
% The "sensor" method will produce output values given the current
% time and state of the system.
%
% SYNTAX:
%   output = pendulumObj.sensor()
%   output = pendulumObj.sensor(time)
%   output = pendulumObj.sensor(time,state)
%   output = pendulumObj.sensor(time,state,input)
%   output = pendulumObj.sensor(time,state,input,flowTime)    
%   output = pendulumObj.sensor(time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number) [pendulumObj.time]
%       Current time.
%
%   state - (? x 1 number) [pendulumObj.state]
%       Current state. Must be a "pendulumObj.nStates" x 1 vector.
%
%   input - (? x 1 number) [pendulumObj.input]
%       Current input value. Must be a "pendulumObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [pendulumObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [pendulumObj.jumpCount]
%       Current jump count value.
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
%   Created 23-OCT-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 5, flowTime = 0; end %#ok<*NASGU>
if nargin < 6, jumpCount = 0; end

%% Parameters


%% Variables


%% Sensor Definition


%% Set output
output = state;

end

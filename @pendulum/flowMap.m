function [stateDot,setPriority] = flowMap(pendulumObj,time,state,input,flowTime,jumpCount)
% The "flowMap" method sets the continuous time dynamics of the system.
%
% SYNTAX:
%   [stateDot,setPriority] = flowMap(pendulumObj,time,state,input)
%   [stateDot,setPriority] = flowMap(pendulumObj,time,state,input,flowTime)
%   [stateDot,setPriority] = flowMap(pendulumObj,time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.pendulum)
%       An instance of the "simulate.pendulum" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "pendulumObj.nStates" x 1 vector.
%
%   input - (? x 1 number)
%       Current input value. Must be a "pendulumObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   stateDot - (? x 1 number)
%       Updated state derivatives. A "pendulumObj.nStates" x 1 vector.
%
%   setPriority - ('flow','jump', or 'random')
%       Sets the priority to what takes place if the state is in both
%       the flow set and the jump set.
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
%   Created 23-OCT-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 5, flowTime = 0; end
if nargin < 6, jumpCount = 0; end
setPriority = pendulumObj.setPriority;

%% Parameters
l = pendulumObj.l;
m = pendulumObj.m;
b = pendulumObj.b;
g = pendulumObj.g;

%% Variables
x = state(1);
dx = state(2);
u = input;

%% Equations Of Motion
ddx = -b/(m*l^2)*dx - g/l*sin(x) + 1/(m*l^2)*u;

%% Output
stateDot(1,1) = dx;
stateDot(2,1) = ddx;

end

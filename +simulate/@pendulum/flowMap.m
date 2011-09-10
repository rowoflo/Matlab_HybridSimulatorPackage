function stateDot = flowMap(pendulumObj,~,state,input,~,~)
% The "flowMap" method sets the continuous time dynamics of the pendulum.
%
% SYNTAX:
%   dStates = pendulumObj.flowMap(time,state,input)
%   dStates = pendulumObj.flowMap(time,state,input,flowTime)
%   dStates = pendulumObj.flowMap(time,state,input,flowTime,jumpCount)
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
%   dStates - (? x 1 number)
%       Updated state derivatives. A "pendulumObj.nStates" x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   17-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments
% 
% Check number of arguments
% error(nargchk(4,6,nargin))
% 
% Apply default values
% if nargin < 5, flowTime = 0; end
% if nargin < 6, jumpCount = 0; end
% 
% Check arguments for errors
% assert(isa(pendulumObj,'simulate.pendulum') && numel(pendulumObj) == 1,...
%     'simulate:pendulum:flowMap:pendulumObj',...
%     'Input argument "pendulumObj" must be a 1 x 1 simulate.pendulum object.')
% 
% assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
%     'simulate:pendulum:flowMap:time',...
%     'Input argument "time" must be a 1 x 1 real number.')
% 
% assert(isnumeric(state) && isequal(size(state),[pendulumObj.nStates,1]),...
%     'simulate:pendulum:flowMap:state',...
%     'Input argument "state" must be a %d x 1 vector of numbers.',pendulumObj.nStates)
% 
% assert(isnumeric(input) && isequal(size(input),[pendulumObj.nInputs,1]),...
%     'simulate:pendulum:flowMap:input',...
%     'Input argument "input" must be a %d x 1 vector of numbers.',pendulumObj.nInputs)
% 
% assert(isnumeric(flowTime) && isreal(flowTime) && numel(flowTime) == 1 && flowTime >= 0,...
%     'simulate:pendulum:flowMap:flowTime',...
%     'Input argument "flowTime" must be a 1 x 1 semi-positive real number.')
% 
% assert(isnumeric(jumpCount) && isreal(jumpCount) && numel(jumpCount) == 1 && jumpCount >= 0 && mod(jumpCount,1) == 0,...
%     'simulate:pendulum:flowMap:jumpCount',...
%     'Input argument "jumpCount" must be a 1 x 1 semi-positive integer.')

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

%% Process Noise
dx = dx + .2*randn;
ddx = ddx + .5*randn;

%% Output
stateDot(1,1) = dx;
stateDot(2,1) = ddx;

end

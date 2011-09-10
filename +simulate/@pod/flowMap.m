function stateDot = flowMap(podObj,~,state,input,~,~)
% The "flowMap" method sets the continuous time dynamics of the system.
%
% SYNTAX:
%   stateDot = flowMap(podObj,time,state,input)
%   stateDot = flowMap(podObj,time,state,input,flowTime)
%   stateDot = flowMap(podObj,time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   podObj - (1 x 1 simulate.pod)
%       An instance of the "simulate.pod" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "podObj.nStates" x 1 vector.
%
%   input - (? x 1 number)
%       Current input value. Must be a "podObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   dStates - (? x 1 number)
%       Updated state derivatives. A "podObj.nStates" x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   26-APR-2011 by Rowland O'Flaherty
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
% assert(isa(podObj,'simulate.pod') && numel(podObj) == 1,...
%     'simulate:pod:flowMap:podObj',...
%     'Input argument "podObj" must be a 1 x 1 simulate.pod object.')
% 
% assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
%     'simulate:pod:flowMap:time',...
%     'Input argument "time" must be a 1 x 1 real number.')
% 
% assert(isnumeric(state) && isequal(size(state),[podObj.nStates,1]),...
%     'simulate:pod:flowMap:state',...
%     'Input argument "state" must be a %d x 1 vector of numbers.',podObj.nStates)
% 
% assert(isnumeric(input) && isequal(size(input),[podObj.nInputs,1]),...
%     'simulate:pod:flowMap:input',...
%     'Input argument "input" must be a %d x 1 vector of numbers.',podObj.nInputs)
% 
% assert(isnumeric(flowTime) && isreal(flowTime) && numel(flowTime) == 1 && flowTime >= 0,...
%     'simulate:pod:flowMap:flowTime',...
%     'Input argument "flowTime" must be a 1 x 1 semi-positive real number.')
% 
% assert(isnumeric(jumpCount) && isreal(jumpCount) && numel(jumpCount) == 1 && jumpCount >= 0 && mod(jumpCount,1) == 0,...
%     'simulate:pod:flowMap:jumpCount',...
%     'Input argument "jumpCount" must be a 1 x 1 semi-positive integer.')

%% Parameters
I = podObj.I;
m = podObj.m;
r = podObj.r;

%% Variables
theta = state(3);
dx = state(4);
dy = state(5);
dtheta = state(6);
uf = input(1);
ur = input(2);

%% Equations Of Motion
ddx = cos(theta)/m * uf;
ddy = sin(theta)/m * uf;
ddtheta = r/I * ur;

%% Output
stateDot(1,1) = dx;
stateDot(2,1) = dy;
stateDot(3,1) = dtheta;
stateDot(4,1) = ddx;
stateDot(5,1) = ddy;
stateDot(6,1) = ddtheta;

end

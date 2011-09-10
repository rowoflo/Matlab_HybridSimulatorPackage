function stateDot = flowMap(puckObj,~,state,input,~,~)
% The "flowMap" method sets the continuous time dynamics of the system.
%
% SYNTAX:
%   dStates = flowMap(puckObj,time,state,input)
%   dStates = flowMap(puckObj,time,state,input,flowTime)
%   dStates = flowMap(puckObj,time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   puckObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "puckObj.nStates" x 1 vector.
%
%   input - (? x 1 number)
%       Current input value. Must be a "puckObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   dStates - (? x 1 number)
%       Updated state derivatives. A "puckObj.nStates" x 1 vector.
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
% assert(isa(puckObj,'simulate.puck') && numel(puckObj) == 1,...
%     'simulate:puck:flowMap:puckObj',...
%     'Input argument "puckObj" must be a 1 x 1 simulate.puck object.')
% 
% assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
%     'simulate:puck:flowMap:time',...
%     'Input argument "time" must be a 1 x 1 real number.')
% 
% assert(isnumeric(state) && isequal(size(state),[puckObj.nStates,1]),...
%     'simulate:puck:flowMap:state',...
%     'Input argument "state" must be a %d x 1 vector of numbers.',puckObj.nStates)
% 
% assert(isnumeric(input) && isequal(size(input),[puckObj.nInputs,1]),...
%     'simulate:puck:flowMap:input',...
%     'Input argument "input" must be a %d x 1 vector of numbers.',puckObj.nInputs)
% 
% assert(isnumeric(flowTime) && isreal(flowTime) && numel(flowTime) == 1 && flowTime >= 0,...
%     'simulate:puck:flowMap:flowTime',...
%     'Input argument "flowTime" must be a 1 x 1 semi-positive real number.')
% 
% assert(isnumeric(jumpCount) && isreal(jumpCount) && numel(jumpCount) == 1 && jumpCount >= 0 && mod(jumpCount,1) == 0,...
%     'simulate:puck:flowMap:jumpCount',...
%     'Input argument "jumpCount" must be a 1 x 1 semi-positive integer.')

%% Parameters
m = puckObj.m;

%% Variables
dx = state(3);
dy = state(4);
ux = input(1);
uy = input(2);

%% Equations Of Motion
ddx = ux/m;
ddy = uy/m;

%% Output
stateDot(1,1) = dx;
stateDot(2,1) = dy;
stateDot(3,1) = ddx;
stateDot(4,1) = ddy;

end

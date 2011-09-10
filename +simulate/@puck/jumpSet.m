function jumpSetValue = jumpSet(puckObj,~,state,~,~)
% The "jumpSet" method sets the set where discrete time dynamics take
% place.
%
% SYNTAX:
%   jumpSetValue = jumpSet(puckObj,time,state,input)
%   jumpSetValue = jumpSet(puckObj,time,state,input,flowTime)
%   jumpSetValue = jumpSet(puckObj,time,state,input,flowTime,jumpCount)
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
%   jumpSetValue - (1 x 1 number)
%      A value that defining if the system is in the jump set.
%      Positive values are in the set and negative values are outside
%      the set.
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
%     'simulate:puck:jumpSet:puckObj',...
%     'Input argument "puckObj" must be a 1 x 1 simulate.puck object.')
% 
% assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
%     'simulate:puck:jumpSet:time',...
%     'Input argument "time" must be a 1 x 1 real number.')
% 
% assert(isnumeric(state) && isequal(size(state),[puckObj.nStates,1]),...
%     'simulate:puck:jumpSet:state',...
%     'Input argument "state" must be a %d x 1 vector of numbers.',puckObj.nStates)
% 
% assert(isnumeric(input) && isequal(size(input),[puckObj.nInputs,1]),...
%     'simulate:puck:jumpSet:input',...
%     'Input argument "input" must be a %d x 1 vector of numbers.',puckObj.nInputs)
% 
% assert(isnumeric(flowTime) && isreal(flowTime) && numel(flowTime) == 1 && flowTime >= 0,...
%     'simulate:puck:jumpSet:flowTime',...
%     'Input argument "flowTime" must be a 1 x 1 semi-positive real number.')
% 
% assert(isnumeric(jumpCount) && isreal(jumpCount) && numel(jumpCount) == 1 && jumpCount >= 0 && mod(jumpCount,1) == 0,...
%     'simulate:puck:jumpSet:jumpCount',...
%     'Input argument "jumpCount" must be a 1 x 1 semi-positive integer.')

%% Parameters
r = puckObj.r;

%% Variables
x = state(1);
y = state(2);

%% Distance to walls
distance = puckObj.localMap.distanceToNearestFrom([x;y]);

%% Status
jumpSetValue = -(distance - r);

end

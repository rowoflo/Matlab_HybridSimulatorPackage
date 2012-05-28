function flowSetValue = flowSet(puckObj,~,state,~,~)
% The "flowSet" method sets the set where continuous time dynamics take
% place.
%
% SYNTAX:
%   flowSetValue = flowSet(puckObj,time,state,input)
%   flowSetValue = flowSet(puckObj,time,state,input,flowTime)
%   flowSetValue = flowSet(puckObj,time,state,input,flowTime,jumpCount)
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
%   flowSetValue - (1 x 1 number)
%      A value that defining if the system is in the flow set.
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
%     'simulate:puck:flowSet:puckObj',...
%     'Input argument "puckObj" must be a 1 x 1 simulate.puck object.')
% 
% assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
%     'simulate:puck:flowSet:time',...
%     'Input argument "time" must be a 1 x 1 real number.')
% 
% assert(isnumeric(state) && isequal(size(state),[puckObj.nStates,1]),...
%     'simulate:puck:flowSet:state',...
%     'Input argument "state" must be a %d x 1 vector of numbers.',puckObj.nStates)
% 
% assert(isnumeric(input) && isequal(size(input),[puckObj.nInputs,1]),...
%     'simulate:puck:flowSet:input',...
%     'Input argument "input" must be a %d x 1 vector of numbers.',puckObj.nInputs)
% 
% assert(isnumeric(flowTime) && isreal(flowTime) && numel(flowTime) == 1 && flowTime >= 0,...
%     'simulate:puck:flowSet:flowTime',...
%     'Input argument "flowTime" must be a 1 x 1 semi-positive real number.')
% 
% assert(isnumeric(jumpCount) && isreal(jumpCount) && numel(jumpCount) == 1 && jumpCount >= 0 && mod(jumpCount,1) == 0,...
%     'simulate:puck:flowSet:jumpCount',...
%     'Input argument "jumpCount" must be a 1 x 1 semi-positive integer.')

%% Parameters
r = puckObj.r;

%% Variables
x = state(1);
y = state(2);
dx = state(3);
dy = state(4);

%% Status
switch lower(puckObj.controllerType)
    case lower('none')
        flowSetValue = norm(state - puckObj.goalState) - norm(puckObj.goalSize);
        
    case lower('LQR')
        flowSetValue = norm(state - puckObj.waypointState) - norm(puckObj.goalSize);
        
    case lower('RRTPath')
        flowSetValue = norm(state - puckObj.goalState) - norm(puckObj.goalSize);
    
    case lower('Bounce')
        flowSetValue = norm(state - puckObj.waypointState) - norm(puckObj.goalSize);
        
    case lower('RRTPathWithBounce')
        flowSetValue = norm(state - puckObj.goalState) - norm(puckObj.goalSize);
        
    case lower('OpenLoop')
        flowSetValue = norm(state - puckObj.goalState) - norm(puckObj.goalSize);
        
    otherwise
        error('simulate:puck:flowSet:controllerSelect',...
            'Unknown controller select: %s',puckObj.controllerSelect)
end
end

function input = controller(puckObj,time,state,~,jumpCount)
% The "controller" method will produce input values given the current
% time and state of the system.
%
% SYNTAX:
%   input = controller(puckObj,time,state)
%   input = controller(puckObj,time,state,input,flowTime)
%   input = controller(puckObj,time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   puckObj - (1 x 1 simulate.puck)
%       An instance of the "simulate.puck" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "puckObj.nStates" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   input - (? x 1 number)
%       Input values for the plant. A "puckObj.nInputs"  x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   18-APR-2011 by Rowland O'Flaherty
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
%     'simulate:puck:controller:puckObj',...
%     'Input argument "puckObj" must be a 1 x 1 simulate.puck object.')
% 
% assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
%     'simulate:puck:controller:time',...
%     'Input argument "time" must be a 1 x 1 real number.')
% 
% assert(isnumeric(state) && isequal(size(state),[puckObj.nStates,1]),...
%     'simulate:puck:controller:state',...
%     'Input argument "state" must be a %d x 1 vector of numbers.',puckObj.nStates)
% 
% assert(isnumeric(input) && isequal(size(input),[puckObj.nInputs,1]),...
%     'simulate:puck:controller:input',...
%     'Input argument "input" must be a %d x 1 vector of numbers.',puckObj.nInputs)
% 
% assert(isnumeric(flowTime) && isreal(flowTime) && numel(flowTime) == 1 && flowTime >= 0,...
%     'simulate:puck:controller:flowTime',...
%     'Input argument "flowTime" must be a 1 x 1 semi-positive real number.')
% 
% assert(isnumeric(jumpCount) && isreal(jumpCount) && numel(jumpCount) == 1 && jumpCount >= 0 && mod(jumpCount,1) == 0,...
%     'simulate:puck:controller:jumpCount',...
%     'Input argument "jumpCount" must be a 1 x 1 semi-positive integer.')


%% Parameters

%% Variables
x = state;

%% Controller
switch lower(puckObj.controllerType)
    case lower('None')
        u = zeros(2,1);
        
    case lower('LQR')
        K = puckObj.K;
        xOP = puckObj.stateOP;
        uOP = puckObj.inputOP;
        u = -K*(x - xOP) + uOP;
        
    case lower('OpenLoop')
        timeIndex = find(time >= puckObj.openLoopTimeTape,1,'last');
        u = puckObj.openLoopInputTape(:,timeIndex);
        
    case lower('RRTPath')
        timeInd = find([0 puckObj.stateNodeTime(1:end-1)] <= time);
        timeInd = timeInd(end);
        u = -K*(x - puckObj.stateNodeRoute(:,timeInd));
        
    case lower('Bounce')
        if jumpCount == 0 && ~isempty(puckObj.stateMirrorWaypoint)
            u = -K*(x - puckObj.stateMirrorWaypoint);
        else
            u = -K*(x - puckObj.waypointState);
        end
        
    case lower('RRTPathWithBounce')
        timeInd = find([0 puckObj.stateNodeTime(1:end-1)] <= time);
        timeInd = timeInd(end);
        
        if jumpCount == 0 && puckObj.stateNodeReflectionInd(:,timeInd) ~= 1;
            u = -K*(x - [puckObj.stateNodeReflection(:,timeInd);puckObj.stateNodeRoute(3:4,timeInd)]);
        else
            u = -K*(x - puckObj.stateNodeRoute(:,timeInd));
        end
        
    otherwise
      error('simulate:puck:controller:controllerSelect',...
          'Unknown controller select: %s',puckObj.controllerSelect)
end

%% Set input
input = min(max(u,puckObj.forceLimits(:,1)),puckObj.forceLimits(:,2));

end

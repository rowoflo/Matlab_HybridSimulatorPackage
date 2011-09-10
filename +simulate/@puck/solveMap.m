function route = solveMap(puckObj,initialState,goalState,varargin)
% The "solveMap" method finds a route from the current position of the
% "initialState" to the "goalState".
%
% SYNTAX:
%   route = puckObj.solveMap(initialState,goalState)
%   route = puckObj.solveMap(initialState,goalState,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   puckObj - (1 x 1 simulate.puck)
%       An instance of the "simulate.puck" class.
%
%   initialState - (2 x 1 real number) [puckObj.state(1:2)]
%       Initial state in the map.
%
%   goalState - (2 x 1 real number) [puckObj.goalState(1:2)]
%       Goal state to find a route to in the map.
%
% PROPERTIES:
%   'goalSize' - (2 x 1 positive number) [puckObj.goalSize(1:2)]
%       The size of the goal. The solver won't stop until a solution ends
%       at the state within this size.
%
%   'stateLimits' - (2 x 2 real number) [reshape(puckObj.localMap.limits,2,2)']
%       The limits of the map. Sets where random points will be drawn from.
%
%   'growthRatio' - (1 x 1 positive real number) [0.25]
%       Sets how far each branch grows from a node to a new random point.
%
%   'bufferSize' - (1 x 1 semi-positive real number) [puckObj.r]
%       This is closest distance a random point will get to a feature in the map.
%
%   'plotFlag' = (1 x 1 logical) [false]
%       If true the solution to the map will be plotted as it is solved.
%
% OUTPUTS:
%   route - (? x ? number)
%       Route from "initialState" to "goalState". The matrix is
%       "puckObj.nStates" x number of nodes in the route.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   02-MAY-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Apply default values
if nargin < 2, initialState = puckObj.state(1:2); end
if nargin < 3, goalState = puckObj.goalState(1:2); end

% Check arguments for errors
assert(isa(puckObj,'simulate.puck') && numel(puckObj) == 1,...
    'simulate:puck:solveMap:puckObj',...
    'Input argument "puckObj" must be a 1 x 1 "simulate.puck" object.')

assert(isempty(initialState) || (isnumeric(initialState) && isreal(initialState) && numel(initialState) == 2),...
    'simulate:puck:solveMap:initialState',...
    'Input argument "initialState" must be a 2 x 1 vector of real numbers or empty.')
if isempty(initialState)
    initialState = puckObj.state(1:2);
end
initialState = initialState(:);

assert(isempty(goalState) || (isnumeric(goalState) && isreal(goalState) && numel(goalState) == 2),...
    'simulate:puck:solveMap:goalState',...
    'Input argument "goalState" must be a 2 x 1 vector of real numbers or empty.')
if isempty(goalState)
    goalState = puckObj.goalState(1:2);
end
goalState = goalState(:);

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'puck:solveMap:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('goalSize')
            goalSize = propValues{iParam};
        case lower('stateLimits')
            stateLimits = propValues{iParam};
        case lower('growthRatio')
            growthRatio = propValues{iParam};
        case lower('bufferSize')
            bufferSize = propValues{iParam};
        case lower('plotFlag')
            plotFlag = propValues{iParam};
        otherwise
            error('simulate:puck:solveMap:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('goalSize','var'), goalSize = puckObj.goalSize(1:2); end
if ~exist('stateLimits','var'), stateLimits = reshape(puckObj.localMap.limits,2,2)'; end
if ~exist('growthRatio','var'), growthRatio = 0.25; end
if ~exist('bufferSize','var'), bufferSize = puckObj.r; end
if ~exist('plotFlag','var'), plotFlag = false; end

% Check property values for errors
assert(isnumeric(goalSize) && isreal(goalSize) && numel(goalSize) == 2,...
    'simulate:puck:solveMap:goalSize',...
    'Property "goalSize" must be a 2 x 1 vector of real numbers.')
goalSize = goalSize(:);

assert(isnumeric(stateLimits) && isreal(stateLimits) && isequal(size(stateLimits),[2 2]) && ...
    all(stateLimits(:,1) <= stateLimits(:,2)),...
    'simulate:puck:solveMap:stateLimits',...
    'Property "stateLimits" must be a 2 x 2 matrix of real numbers and the first column must be less than or equal to the second column.')

assert(isnumeric(growthRatio) && isreal(growthRatio) && numel(growthRatio) == 1 && growthRatio > 0,...
    'simulate:puck:solveMap:growthRatio',...
    'Property "growthRatio" must be a 1 x 1 positive number.')

assert(isnumeric(bufferSize) && isreal(bufferSize) && numel(bufferSize) == 1 && bufferSize >= 0,...
    'simulate:puck:solveMap:bufferSize',...
    'Property "bufferSize" must be a 1 x 1 semi-positive real number.')

assert(islogical(plotFlag) && numel(plotFlag) == 1,...
    'simulate:puck:solveMap:plotFlag',...
    'Property "plotFlag" must be a 1 x 1 logical.')

%% Parameters
goalBubble = 3;

%% Initialize Map
if plotFlag
    puckObj.sketch;
    axisHandle = puckObj.sketchAxisHandle;
else
    axisHandle = [];
end

%% Run RRT
route = simulate.rapidRandomTrees(initialState,goalState,goalSize,stateLimits,@isValidState,@stateToNodeDistances,@extendForward,'axisHandle',axisHandle);

%% Helper Functions
    function validFlag = isValidState(x)
        validFlag = puckObj.localMap.distanceToNearestFrom(x) > bufferSize;
    end

    function distances = stateToNodeDistances(nodes,states)
        % Dimension 1-x y 2-node 3-state
        nNodes = size(nodes,2);
        nStates = size(states,2);
        stateCube = repmat(permute(states,[1 3 2]),[1,size(nodes,2),1]);
        nodeCube = repmat(nodes,[1,1,size(states,2)]);
        nodeToStateCube = stateCube - nodeCube;
        newNodeCube = growthRatio*nodeToStateCube + nodeCube;
        distCube = sqrt(sum(nodeToStateCube.^2,1));
        
        lineSegments = [reshape(nodeCube,[2 1 nNodes*nStates]) reshape(stateCube,[2 1 nStates*nNodes])];
        points = puckObj.localMap.intersectionWith(lineSegments);
        validLineFlag = all(all(isnan(points),1),2);
        validLineFlag = reshape(validLineFlag,[1 nNodes nStates]);
        
        validNewNodeFlag = isValidState(reshape(newNodeCube,[2 nNodes*nStates 1]));
        validNewNodeFlag = reshape(validNewNodeFlag,[1 nNodes nStates]);
        
        distCube(~(validLineFlag & validNewNodeFlag)) = inf;
        
        % Dimension 1-node 2-state
        distances = reshape(distCube,[nNodes nStates]);
        
    end

    function [xOut,xPolices,xParents] = extendForward(x0,xG)
        xOut = growthRatio*(xG-x0)+x0;
        goalLogic = ismember(xG',goalState','rows')';
        if any(goalLogic)
            if any(sqrt(sum((repmat(goalState,1,sum(goalLogic)) - x0(:,goalLogic)).^2,1)) <= goalBubble)
                xOut(:,goalLogic) = repmat(goalState,1,sum(goalLogic));
            end
        end
        points = puckObj.localMap.intersectionWith(cat(2,permute(x0,[1 3 2]),permute(xOut,[1 3 2])));
        xPolices = repmat({0},1,size(xOut,2));
        xParents = 1:size(xOut,2);
        if ~all(isnan(points(:)))
            error('simulate:project:puckMapRRT:points',...
                '"points" variable should always be all NaNs.')
            
            % xpoints = points(:,~isnan(points(1,:)));
            % dist = stateToNodeDistances(x0,xpoints);
            % [~,ind] = min(dist);
            % xline = xpoints(:,ind);
            % xOut = (norm(xline - x0) - bufferSize)*(xline - x0)/norm(xline - x0) + x0;
        end
    end
end

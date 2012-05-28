function route = solve(mapObj,initialState,goalState,varargin)
% The "solve" method finds a route from the  the "initialState" to the
% "goalState".
%
% SYNTAX:
%   route = mapObj.solve(initialState,goalState)
%   route = mapObj.solve(initialState,goalState,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   mapObj - (1 x 1 simulate.map)
%       An instance of the "simulate.map" class.
%
%   initialState - (2 x 1 real number) [[0;0]]
%       Initial state in the map.
%
%   goalState - (2 x 1 real number) [[1;1]]
%       Goal state to find a route to in the map.
%
% PROPERTIES:
%   'goalSize' - (2 x 1 positive number) [[.5;.5]]
%       The size of the goal. The solver won't stop until a solution ends
%       at the state within this size.
%
%   'growthRatio' - (1 x 1 positive real number) [0.25]
%       Sets how far each branch grows from a node to a new random point.
%
%   'bufferSize' - (1 x 1 semi-positive real number) [.25]
%       This is closest distance a random point will get to a feature in the map.
%
%   'plotFlag' = (1 x 1 logical or 1 x 1 axes handle) [false]
%       If true or an axes handle the solution to the map will be plotted
%       as it is solved. If an axes handle is provided the plot will be in
%       that axis.
%
% OUTPUTS:
%   route - (2 x ? number)
%       Route from "initialState" to "goalState". The matrix is 2 x number
%       of nodes in the route.
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
if nargin < 2, initialState = [0;0]; end
if nargin < 3, goalState = [1;1]; end

% Check arguments for errors
assert(isa(mapObj,'simulate.map') && numel(mapObj) == 1,...
    'simulate:pod:solve:mapObj',...
    'Input argument "mapObj" must be a 1 x 1 "simulate.map" object.')

assert(isnumeric(initialState) && isreal(initialState) && numel(initialState) == 2,...
    'simulate:pod:solve:initialState',...
    'Input argument "initialState" must be a 2 x 1 vector of real numbers.')
initialState = initialState(:);

assert(isnumeric(goalState) && isreal(goalState) && numel(goalState) == 2,...
    'simulate:pod:solve:goalState',...
    'Input argument "goalState" must be a 2 x 1 vector of real numbers.')
goalState = goalState(:);

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'pod:solve:properties',...
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
            error('simulate:pod:solve:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('goalSize','var'), goalSize = [.5;.5]; end
if ~exist('growthRatio','var'), growthRatio = .25; end
if ~exist('bufferSize','var'), bufferSize = .25; end
if ~exist('plotFlag','var'), plotFlag = false; end

% Check property values for errors
assert(isnumeric(goalSize) && isreal(goalSize) && numel(goalSize) == 2,...
    'simulate:pod:solve:goalSize',...
    'Property "goalSize" must be a 2 x 1 vector of real numbers.')
goalSize = goalSize(:);

assert(isnumeric(growthRatio) && isreal(growthRatio) && numel(growthRatio) == 1 && growthRatio > 0,...
    'simulate:pod:solve:growthRatio',...
    'Property "growthRatio" must be a 1 x 1 positive number.')

assert(isnumeric(bufferSize) && isreal(bufferSize) && numel(bufferSize) == 1 && bufferSize >= 0,...
    'simulate:pod:solve:bufferSize',...
    'Property "bufferSize" must be a 1 x 1 semi-positive real number.')

assert((islogical(plotFlag) || (ishghandle(plotFlag) && strcmp(get(plotFlag,'Type'),'axes'))) && numel(plotFlag) == 1,...
    'simulate:pod:solve:plotFlag',...
    'Property "plotFlag" must be a 1 x 1 logical or an valid axes handle.')

%% Parameters
goalBubble = 3;

%% Initialize Map
if islogical(plotFlag)
    if plotFlag
        graphicsHandle = mapObj.sketch;
        axis equal
        grid on
        axisHandle = get(graphicsHandle,'Parent');
    else
        axisHandle = [];
    end
else
    axisHandle = plotFlag;
end

%% Run RRT
route = simulate.rapidRandomTrees(initialState,goalState,goalSize,reshape(mapObj.limits,2,2)',@isValidState,@stateToNodeDistances,@extendForward,'axisHandle',axisHandle);

%% Helper Functions
    function validFlag = isValidState(x)
        validFlag = mapObj.distanceToNearestFrom(x) > bufferSize;
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
        points = mapObj.intersectionWith(lineSegments);
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
        points = mapObj.intersectionWith(cat(2,permute(x0,[1 3 2]),permute(xOut,[1 3 2])));
        xPolices = repmat({0},1,size(xOut,2));
        xParents = 1:size(xOut,2);
        if ~all(isnan(points(:)))
            error('simulate:project:podMapRRT:points',...
                '"points" variable should always be all NaNs.')
            
            % xpoints = points(:,~isnan(points(1,:)));
            % dist = stateToNodeDistances(x0,xpoints);
            % [~,ind] = min(dist);
            % xline = xpoints(:,ind);
            % xOut = (norm(xline - x0) - bufferSize)*(xline - x0)/norm(xline - x0) + x0;
        end
    end
end

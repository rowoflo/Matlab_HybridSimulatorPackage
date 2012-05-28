function [route,policy] = solveMap(podObj,initialState,goalState,varargin)
% The "solveMap" method finds a route from the current position of the
% "initialState" to the "goalState".
%
% SYNTAX:
%   route = podObj.solveMap(initialState,goalState)
%   route = podObj.solveMap(initialState,goalState,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   podObj - (1 x 1 simulate.pod)
%       An instance of the "simulate.pod" class.
%
%   initialState - (6 x 1 real number) [podObj.nStates]
%       Initial state in the map.
%
%   goalState - (6 x 1 real number) [podObj.goalState]
%       Goal state to find a route to in the map. Length is "podObj.nStates"
%
% PROPERTIES:
%   'goalSize' - (6 x 1 positive number) [[5*podObj.goalSize(1:2);inf;inf;inf;inf]]
%       The size of the goal. The solver won't stop until a solution ends
%       at the state within this size.
%
%   'stateLimits' - (6 x 2 real number) [[reshape(podObj.localMap.limits,2,2)';[-pi pi];zeros(3,2)]]
%       The limits of the map. Sets where random points will be drawn from.
%
%   'simTime' - (1 x 1 positive real number) [20]
%       Sets the simulation time for the growth of each node.
%
%   'bufferSize' - (1 x 1 semi-positive real number) [podObj.r]
%       This is closest distance a random point will get to a feature in the map.
%
%   'plotFlag' = (1 x 1 logical) [false]
%       If true the solution to the map will be plotted as it is solved.
%
% OUTPUTS:
%   route - (? x ? number)
%       Route from "initialState" to "goalState". The matrix is
%       "podObj.nStates" x number of nodes in the route.
%
%   policy - (size type) TODO
%       Description.
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
if nargin < 2, initialState = podObj.state; end
if nargin < 3, goalState = podObj.goalState; end

% Check arguments for errors
assert(isa(podObj,'simulate.pod') && numel(podObj) == 1,...
    'simulate:pod:solveMap:podObj',...
    'Input argument "podObj" must be a 1 x 1 "simulate.pod" object.')

assert(isempty(initialState) || (isnumeric(initialState) && isreal(initialState) && numel(initialState) == 6),...
    'simulate:pod:solveMap:initialState',...
    'Input argument "initialState" must be a 6 x 1 vector of real numbers or empty.')
if isempty(initialState)
    initialState = podObj.state;
end
initialState = initialState(:);

assert(isempty(goalState) || (isnumeric(goalState) && isreal(goalState) && numel(goalState) == 6),...
    'simulate:pod:solveMap:goalState',...
    'Input argument "goalState" must be a 6 x 1 vector of real numbers or empty.')
if isempty(goalState)
    goalState = podObj.goalState;
end
goalState = goalState(:);

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'pod:solveMap:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('goalSize')
            goalSize = propValues{iParam};
        case lower('stateLimits')
            stateLimits = propValues{iParam};
        case lower('simTime')
            simTime = propValues{iParam};
        case lower('bufferSize')
            bufferSize = propValues{iParam};
        case lower('plotFlag')
            plotFlag = propValues{iParam};
        otherwise
            error('simulate:pod:solveMap:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('goalSize','var'), goalSize = [5*podObj.goalSize(1:2);inf;inf;inf;inf]; end
if ~exist('stateLimits','var'), stateLimits = [reshape(podObj.localMap.limits,2,2)';[-pi pi];zeros(3,2)]; end
if ~exist('simTime','var'), simTime = 20; end
if ~exist('bufferSize','var'), bufferSize = podObj.r; end
if ~exist('plotFlag','var'), plotFlag = false; end

% Check property values for errors
assert(isnumeric(goalSize) && isreal(goalSize) && numel(goalSize) == 6,...
    'simulate:pod:solveMap:goalSize',...
    'Property "goalSize" must be a 6 x 1 vector of real numbers.')
goalSize = goalSize(:);

assert(isnumeric(stateLimits) && isreal(stateLimits) && isequal(size(stateLimits),[6 2]) && ...
    all(stateLimits(:,1) <= stateLimits(:,2)),...
    'simulate:pod:solveMap:stateLimits',...
    'Property "stateLimits" must be a 6 x 2 matrix of real numbers and the first column must be less than or equal to the second column.')

assert(isnumeric(simTime) && isreal(simTime) && numel(simTime) == 1 && simTime > 0,...
    'simulate:pod:solveMap:simTime',...
    'Property "simTime" must be a 1 x 1 positive number.')

assert(isnumeric(bufferSize) && isreal(bufferSize) && numel(bufferSize) == 1 && bufferSize >= 0,...
    'simulate:pod:solveMap:bufferSize',...
    'Property "bufferSize" must be a 1 x 1 semi-positive real number.')

assert(islogical(plotFlag) && numel(plotFlag) == 1,...
    'simulate:pod:solveMap:plotFlag',...
    'Property "plotFlag" must be a 1 x 1 logical.')

%% Parameters
goalBubble = 3;

%% Initialize Map
if plotFlag
    podObj.sketch;
    axisHandle = podObj.sketchAxisHandle;
else
    axisHandle = [];
end

%% Initialize Pod LQR Controller Parameters
podObj.odeSolver = @ode113;
podObj.controllerType = 'HybridLQR';
podObj.stateOP = podObj.goalState;
podObj.inputOP = [0;0];

Af = [0 1;0 0];
Bf = [0;1/podObj.m];
podObj.Qf = diag([1 60]);
podObj.Rf = 50;
[podObj.Kf,podObj.Sf] = lqrd(Af,Bf,podObj.Qf,podObj.Rf,podObj.timeStep);

Ar = [0 1;0 0];
Br = [0;podObj.r/podObj.I];
podObj.Qr = diag([1 1]);
podObj.Rr = 1;
[podObj.Kr,podObj.Sr] = lqrd(Ar,Br,podObj.Qr,podObj.Rr,podObj.timeStep);

podObj.Ke = 10000;

timeVector = 0:podObj.timeStep:simTime;

%% Run RRT
[route,policy] = simulate.rapidRandomTrees(initialState,goalState,goalSize,stateLimits,@isValidState,@stateToNodeDistances,@extendForward,'axisHandle',axisHandle);

%% Helper Functions
    function validFlag = isValidState(states)
        points = states(1:2,:);
        validFlag = podObj.localMap.distanceToNearestFrom(points) > bufferSize;
    end

    function distances = stateToNodeDistances(nodes,states)
        nodes = nodes(1:2,:);
        points = states(1:2,:);
        
        % Dimension 1-x y 2-node 3-state
        nNodes = size(nodes,2);
        nPoints = size(points,2);
        pointCube = repmat(permute(points,[1 3 2]),[1,size(nodes,2),1]);
        nodeCube = repmat(nodes,[1,1,size(points,2)]);
        nodeToStateCube = pointCube - nodeCube;
        newNodeCube = nodeToStateCube + nodeCube;
        distCube = sqrt(sum(nodeToStateCube.^2,1));
        
        lineSegments = [reshape(nodeCube,[2 1 nNodes*nPoints]) reshape(pointCube,[2 1 nPoints*nNodes])];
        points = podObj.localMap.intersectionWith(lineSegments);
        validLineFlag = all(all(isnan(points),1),2);
        validLineFlag = reshape(validLineFlag,[1 nNodes nPoints]);
        
        validNewNodeFlag = isValidState(reshape(newNodeCube,[2 nNodes*nPoints 1]));
        validNewNodeFlag = reshape(validNewNodeFlag,[1 nNodes nPoints]);
        
        distCube(~(validLineFlag & validNewNodeFlag)) = inf;
        
        % Dimension 1-node 2-point
        distances = reshape(distCube,[nNodes nPoints]);
        
    end

    function [newNodes,newNodePolicies,parentNodeIndices] = extendForward(nodes,states)
        nDims = size(nodes,1);
        nNodes = size(nodes,2);
        nSteps = size(timeVector,2);
        % Dim: 1-states 2-nodes
        newNodes = nan(nDims,nNodes);
        newNodePolicies = cell(1,nNodes);
        parentNodeIndices = nan(1,nNodes);
        
        if plotFlag
            axisChildren = get(axisHandle,'Children');
            axisChildren = [podObj.sketchGraphicsHandle;axisChildren(~ismember(axisChildren,podObj.sketchGraphicsHandle))];
            set(axisHandle,'Children',axisChildren);
        end
        for iNode = 1:nNodes
            podObj.stateOP = states(:,iNode);
            [~,~,timeTapeD,inputTape,outputTape] = podObj.simulate(timeVector,nodes(:,iNode));
            newNodes(:,iNode) = outputTape(:,end);
            newNodePolicies{1,iNode} = [{timeTapeD};{inputTape}];
            parentNodeIndices(1,iNode) = iNode;
        end
    end
end

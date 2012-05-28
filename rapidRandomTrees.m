function [route,policy,nodeCnt] = rapidRandomTrees(initialState,goalState,goalSize,stateLimits,stateValidation,distanceCalculation,extendForward,varargin)
% The "rapidRandomTrees" function runs the Rapidly-Exploring Random Tree
% algorithm 
%
% SYNTAX:
%   [route,policy] = simulate.rapidRandomTrees(initialState,goalState,goalSize,stateLimits,stateValidation,distanceCalculation,extendForward)
%   [route,policy] = simulate.rapidRandomTrees(initialState,goalState,goalSize,stateLimits,stateValidation,distanceCalculation,extendForward,'PropertyName',PropertyValue,...)
% 
% INPUTS:
%   initialState - (? x 1 number) 
%       The state where the trunk of the tree is initialized to.
%
%   goalState - (? x 1 number) 
%       The state where the tree is trying to get to. Must be a
%       "length(initialState)" x 1 vector.
%
%   goalSize - (? x 1 number)
%       Absolute value difference from the goal for each state to determine
%       if the tree is within the area of the goal. Must be
%       "length(initialState)" x 1.
%
%   stateLimits - (? x 2 number)
%       The min and max limits on each for which random values are drawn
%       from. Must be "length(initialState)" x 2. First column in the min
%       values and second column is the max values.
%
%   stateValidation - (function handle)
%       A function that validates given states. This function is used when
%       picking random state points. Only valid states will be choosen.
%       SYNTAX:
%       valid = stateValidation(states)
%       INPUTS:
%          states - (? x ? number)
%               The states to validate. Is a
%               "length(initialState)" x "M" matrix, "M" is the number of
%               states in the set of states.
%       OUTPUTS:
%           valid - (1 x ? logical)
%               True if the state is valid, false otherwise. Must be a 1 x
%               "M" vector. The columns must correspond to the columns in
%               the "states" input.
%
%   distanceCalculation - (function handle)
%       A function that calculates the distance from each state-to-node
%       pair. Note, you may set distance to infinate if path from node to
%       state is not valid.
%       SYNTAX:
%       distanceMatrix = distanceCalculation(nodes,states)
%       INPUTS:
%           nodes - (? x ? number)
%               All the nodes in the current tree. Is a "length(initialState)"
%               x "M" matrix, where "M" is the number of nodes in the tree.
%           states - (? x ? number)
%               A set of states to calculate the distance to all the nodes.
%               Is a "length(initialState)" x "N" matrix, where "N" is
%               the number of states in the set.
%       OUTPUTS:
%           distanceMatrix - (? x ? number)
%               A distance matrix from each node to each state. Must be a
%               "M" x "N" matrix, where "M is the number of nodes and "N"
%               is the number of states.
%
%   extendForward - (function handle)
%       A function that extends the tree forward from nodes towards states.
%       SYNTAX:
%       [newNodes,newNodePolicies,parentNodeIndices] = extendForward(nodes,states)
%       INPUTS:
%           nodes - (? x ? number)
%               Nodes in the current tree that will grow a new branch. Is a
%               "length(initialState)" x "B" matrix, where "B" is the number
%               of nodes in the tree that need new branches.
%           states - (? x ? number)
%               A set of states that branches of the tree will be grown
%               towards. Is a "length(initialState)" x "B" matrix.
%       OUTPUTS:
%           newNodes - (? x ? number)
%               New nodes to be added to the tree. Must be a
%               "length(initialState)" x "C" matrix, where "C" is the
%               number of new nodes.
%           newNodePolicies - (1 x ? cell)
%               Cell array of input policies for each of the new nodes. Is
%               a 1 x "C" cell array of matrices, where each matrix is a
%               inputs x time samples.
%           parentNodeIndices - (1 x ? positive integer)
%               This vector informs which parent node (a column from
%               "nodes") the new nodes are offspring from. Must be a 1 x
%               "C" vector with values that are integers between 1 and "B".
%
% PROPERTIES:
%   'axisHandle' - (1 x 1 axes handle) [[]]
%       If not empty the creation of the tree will be plotted in
%       this axis.
%
%   'nRandPoints' - (1 x 1 positive integer) [1]
%       Number of random points drawn at each iteration.
% 
% OUTPUTS:
%   route - (? x ? number)
%       Route from "initialState" to "goalState". The matrix is dimension of
%       the state by number of nodes in the route.
%
%   policy - (size type) TODO
%       Description.
%
%   nodeCnt - (1 x 1 positive integer)
%       Number of nodes in the tree.
%
% EXAMPLES: TODO: Add examples
%
% NOTES:
%   Reference paper: 
%   "Rapidly-Exploring Random Trees: Progress and Prospects" by S. LaValle,
%   J. Kuffner
%
% NECESSARY FILES:
%   +simulate
%
% AUTHOR:
%   27-APR-2011 by Rowland O'Flaherty
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% VERSION: 1.0
%-------------------------------------------------------------------------------

%% Check Inputs

% Check number of inputs
error(nargchk(7,inf,nargin))

% Check input arguments for errors
assert(isnumeric(initialState) && isvector(initialState),...
    'simulate:rapidRandomTrees:initialState',...
    'Input argument "initialState" must be a numeric vector.')
initialState = initialState(:);
nStates = size(initialState,1);

assert(isnumeric(goalState) && isequal(size(goalState),[nStates,1]),...
    'simulate:rapidRandomTrees:goalState',...
    'Input argument "goalState" must be a %d x 1 vector.',nStates)

assert(isnumeric(goalSize) && isequal(size(goalSize),[nStates,1]),...
    'simulate:rapidRandomTrees:goalSize',...
    'Input argument "goalSize" must be a %d x 1 vector.',nStates)

assert(isnumeric(stateLimits) && isequal(size(stateLimits),[nStates,2]) && all(stateLimits(:,1) <= stateLimits(:,2)),...
    'simulate:rapidRandomTrees:stateLimits',...
    'Input argument "stateLimits" must be a %d x 2 matrix with the values in the first column less than or equal to the values in the second column.',stateLimits)

assert(isa(stateValidation,'function_handle'),...
    'simulate:rapidRandomTrees:stateValidation',...
    'Input argument "stateValidation" must be a a function handle.')

assert(isa(distanceCalculation,'function_handle'),...
    'simulate:rapidRandomTrees:distanceCalculation',...
    'Input argument "distanceCalculation" must be a a function handle.')

assert(isa(extendForward,'function_handle'),...
    'simulate:rapidRandomTrees:extendForward',...
    'Input argument "extendForward" must be a a function handle.')

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'rapidRandomTrees:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('axisHandle')
            axisHandle = propValues{iParam};
        case lower('nRandPoints')
            nRandPoints = propValues{iParam};
        otherwise
            error('simulate:rapidRandomTrees:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('axisHandle','var'), axisHandle = []; end
if ~exist('nRandPoints','var'), nRandPoints = 1; end

% Check property values for errors TODO: Add property error checks
assert(isempty(axisHandle) || (ishandle(axisHandle) && numel(axisHandle) == 1 && strcmp(get(axisHandle,'Type'),'axes')),...
    'simulate:rapidRandomTrees:axisHandle',...
    'Property "axisHandle" must be empty or a 1 x 1 axes handle.')

assert(isnumeric(nRandPoints) && isreal(nRandPoints) && numel(nRandPoints) == 1 && mod(nRandPoints,1) == 0 && nRandPoints > 0,...
    'simulate:rapidRandomTrees:axisHandle',...
    'Property "nRandPoints" must be a 1 x 1 positive integer.')

% Check if goal state is valid state by given validation function
assert(stateValidation(goalState),...
    'simulate:rapidRandomTrees:goalSize',...
    'Input argument "goalSize" does not valid from "stateValidation" function.')

%% Parameters % TODO: add these parameters to input arguments parameters
maxNodeCnt = 10000; % Maximum number of nodes in the tree
nodeCatSize = 3000; % Node preallocation size
plotStates = [1 2]; % States indices to plot if axesHandle is set
movieFlag = false; % True if movie should be made of tree creation
movieFile = ''; % File to where movie is saved
movieFrameRate = 15; % Movie frame rate
movieQuality = 85; % Movie quality
nodeColor = [139 69 19]/255;
routeColor = [255 165 0]/255;

%% Variables
if ~isempty(axisHandle) && ishandle(axisHandle)
    plotFlag = true;
    set(get(axisHandle,'Parent'),'Visible','on')
else
    plotFlag = false;
end

if plotFlag
    nextPlot = get(axisHandle,'NextPlot');
    set(axisHandle,'NextPlot','add');
    title(axisHandle,'Number Of Nodes: 1')
    plot(axisHandle,initialState(plotStates(1)),initialState(plotStates(2)),'bo','LineWidth',2,'MarkerSize',10);
    plot(axisHandle,goalState(plotStates(1)),goalState(plotStates(2)),'rx','LineWidth',2,'MarkerSize',10);
end

%% Initialize
% Preallocate
nNodeSlots = nodeCatSize;
nodes = nan(nStates,nodeCatSize);
edges = nan(1,nodeCatSize);
policies = cell(1,nodeCatSize);
paths = cell(1,nodeCatSize);

% Initialize first node
nodeCnt = 1;
nodes(:,1) = initialState;
edges(1,1) = 0;
policies{1,1} = 0; % TODO
paths{1,1} = 1;

% Initialize movie
if plotFlag && movieFlag
    vidObj = VideoWriter(movieFile);
    vidObj.Quality = movieQuality;
    vidObj.FrameRate = movieFrameRate;
    open(vidObj);
end

%% Loop
iterationCnt = 0;
foundGoal = all(abs(initialState - goalState) <= goalSize);
while ~foundGoal && nodeCnt < maxNodeCnt
    iterationCnt = iterationCnt + 1;
    
    % Pick random state points, plus goal state
    randStates = [randomState(nRandPoints,stateLimits,stateValidation) goalState];
    
    % Calculate distance
    distanceMatrix = distanceCalculation(nodes(:,1:nodeCnt),randStates);
    if all(distanceMatrix(:) == inf)
        continue
    end
    if plotFlag
        randHandle = scatter(axisHandle,randStates(plotStates(1),:),randStates(plotStates(2),:),'mo','filled','LineWidth',2);
    end
    goodDistLogic = any(distanceMatrix ~= inf,1);
    goodDistMat = distanceMatrix(:,goodDistLogic);
    goodStates = randStates(:,goodDistLogic);
    [~,nodeInd] = min(goodDistMat,[],1);
    
    % Extend Forward
    [newNodes,newNodePolicies,parentNodeIndices] = extendForward(nodes(:,nodeInd),goodStates);
    nodeInd = nodeInd(parentNodeIndices);
    [~,uniqueNodeInds] = unique(newNodes','rows'); uniqueNodeInds = uniqueNodeInds'; % Make sure nodes are unique
    nodeInd = nodeInd(:,uniqueNodeInds);
    newNodes = newNodes(:,uniqueNodeInds);
    newNodePolicies = newNodePolicies(1,uniqueNodeInds);
    
    isNotNodeAlreadyLogic = ~ismember(newNodes',nodes(:,1:nodeCnt)','rows')'; % Make sure nodes are not already in node set
    nodeInd = nodeInd(:,isNotNodeAlreadyLogic);
    newNodes = newNodes(:,isNotNodeAlreadyLogic);
    newNodePolicies = newNodePolicies(:,isNotNodeAlreadyLogic);

    nNewNodes = size(newNodes,2);
    if nNewNodes == 0
        if plotFlag
            delete(randHandle)
        end
        continue
    end
    
    nodeCntPrev = nodeCnt;
    nodeCnt = nodeCnt + nNewNodes;
    nodeInds = nodeCntPrev+1:nodeCnt;
    while nodeCnt > nNodeSlots
        nNodeSlots = nNodeSlots + nodeCatSize;
        nodes = [nodes nan(nStates,nodeCatSize)]; %#ok<AGROW>
        edges = [edges nan(1,nodeCatSize)]; %#ok<AGROW>
        policies = [policies cell(1,nodeCatSize)]; %#ok<AGROW>
        paths = [paths cell(1,nodeCatSize)]; %#ok<AGROW>
    end
    nodes(:,nodeInds) = newNodes;
    edges(1,nodeInds) = nodeInd;
    policies(1,nodeInds) = newNodePolicies;
    paths(1,nodeInds) = generatePath(nodeInds,edges,paths);
    
    % Check goal
    foundGoal = any(all(abs(newNodes - repmat(goalState,1,nNewNodes)) <= repmat(goalSize,1,nNewNodes),1));
    
    % Plot
    if plotFlag
        title(axisHandle,['Number Of Nodes: ' num2str(nodeCnt)])
        scatter(axisHandle,newNodes(plotStates(1),:),newNodes(plotStates(2),:),20,nodeColor,'o','filled','MarkerEdgeColor',nodeColor,'MarkerFaceColor',nodeColor,'LineWidth',2);
        for iNewNode = 1:nNewNodes
            plot(axisHandle,[newNodes(plotStates(1),iNewNode) nodes(plotStates(1),edges(1,nodeInds(iNewNode)))],...
                [newNodes(plotStates(2),iNewNode) nodes(plotStates(2),edges(1,nodeInds(iNewNode)))],'-','Color',nodeColor,'LineWidth',2);
        end
        drawnow
        
        if movieFlag
            currentFrame = getframe; %#ok<UNRCH>
            writeVideo(vidObj,currentFrame);
        end
        delete(randHandle)
    end
    
end

%% Output
goalNode = newNodes(:,all(abs(newNodes - repmat(goalState,1,nNewNodes)) <= repmat(goalSize,1,nNewNodes),1));
goalNodeInd = find(ismember(nodes',goalNode','rows'));

nodes = nodes(:,1:goalNodeInd);
edges = edges(1,1:goalNodeInd); %#ok<NASGU>
policies = policies(:,1:goalNodeInd);
paths = paths(:,1:goalNodeInd);

route = nodes(:,paths{end});
route = route(:,end:-1:1);
policy = policies(paths{end});
policy = policy(end-1:-1:1);

if plotFlag
    scatter(axisHandle,route(plotStates(1),:),route(plotStates(2),:),20,nodeColor,'o','filled','MarkerEdgeColor',nodeColor,'MarkerFaceColor',nodeColor,'LineWidth',2);
    plot(axisHandle,route(plotStates(1),:),route(plotStates(2),:),'-','Color',routeColor,'LineWidth',2);
    if movieFlag
        currentFrame = getframe; %#ok<UNRCH>
        for ii = 1:ceil(movieFrameRate/2)
            writeVideo(vidObj,currentFrame);
        end
        close(vidObj)
        fprintf(1,'Movie:\n');
        fprintf(1,'\tQuality: %d\n',movieQuality);
        fprintf(1,'\tFrame Rate: %d\n',movieFrameRate);
        fprintf(1,'\tSaved to: %s\n\n',movieFile);
    end
end

%% Reset plot properties
if plotFlag
    set(axisHandle,'NextPlot',nextPlot);
end

end


%% Helper Functions
function randStates = randomState(nRandPoints,stateLimits,stateValidation)
% The "randomState" function generates a valid random state using a uniform
% distribution limited by the "stateLimits" variable.
nStates = size(stateLimits,1);
randStates = zeros(nStates,nRandPoints);
validStates = false(1,nRandPoints);
validFlag = false;
while ~validFlag
    nRandPoints = sum(~validStates);
    someRandPoints = rand(nStates,nRandPoints).*repmat((stateLimits(:,2) - stateLimits(:,1)),1,nRandPoints) + repmat(stateLimits(:,1),1,nRandPoints);
    validPoints = stateValidation(someRandPoints);
    randStates(:,sum(validStates)+1:sum(validStates)+sum(validPoints)) = someRandPoints(:,validPoints);
    validStates(1,sum(validStates)+1:sum(validStates)+sum(validPoints)) = true;
    validFlag = all(validStates);
end
end

function path = generatePath(nodeInds,edges,paths)
% The "generatePath" function generates the path from provided node to the
% tree trunk node.
nNodeInds = numel(nodeInds);
path = cell(1,nNodeInds);
for iNodeInd = 1:nNodeInds
    path{iNodeInd} = [nodeInds(iNodeInd);paths{1,edges(1,nodeInds(iNodeInd))}];
end
end

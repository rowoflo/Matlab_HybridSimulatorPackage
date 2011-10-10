function phase(systemObj,state,stateTape,varargin)
% The "phase" method plots the phase history or the system or plots the
% give state and state tape.
%
% SYNTAX:
%   systemObj.phase()
%   systemObj.phase(state,stateTape)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   state - (? x 1 number) [systemObj.state]
%       Current state to be plotted.
%
%   stateTape - (? x ? number) [systemObj.stateTape]
%       The state tape used for plotting.
%
% PROPERTIES:
%   'legendFlag' - (1 x 1 logical) [true]
%       Sets whether the legend will be displayed.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   plot.m | plotInput.m | plotOutput.m | plotState.m | sketch.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 23-APR-2011
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Apply default values
if nargin < 2, state = systemObj.state; end
if nargin < 3, stateTape = systemObj.stateTape; end

% Check arguments for errors
assert(isa(systemObj,'simulate.system') && numel(systemObj) == 1,...
    'simulate:system:phase:systemObj',...
    'Input argument "systemObj" must be a 1 x 1 simulate.system object.')

assert(isempty(state) || (isnumeric(state) && isvector(state) && numel(state) == systemObj.nStates),...
    'simulate:system:phase:time',...
    'Input argument "state" must be a %d x 1 vector of numbers.',systemObj.nStates)
state = state(:);

assert(isempty(stateTape) || (isnumeric(stateTape) && size(stateTape,1) == systemObj.nStates),...
    'simulate:system:phase:stateTape',...
    'Input argument "stateTape" must be a %d x ? matrix of numbers.',systemObj.nStates)

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'system:phase:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('legendFlag')
            legendFlag = propValues{iParam};
        otherwise
            error('simulate:system:phase:options',...
                'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('legendFlag','var'), legendFlag = true; end

% Check property values for errors
assert(islogical(legendFlag) && numel(legendFlag) == 1,...
    'simulate:system:phase:legendFlag',...
    'Property "legendFlag" must be a 1 x 1 logical.')

%% Initialize
% Create Figure
if isempty(systemObj.phaseFigureHandle) || ~ishghandle(systemObj.phaseFigureHandle)
    systemObj.phaseFigureHandle = figure;
    if ~isempty(systemObj.phaseFigureProperties)
        set(systemObj.phaseFigureHandle,systemObj.phaseFigureProperties{:});
    end
end

% Create Axis
if isempty(systemObj.phaseAxisHandle) || ~ishghandle(systemObj.phaseAxisHandle)
    figure(systemObj.phaseFigureHandle);
    systemObj.phaseAxisHandle = gca;
    set(systemObj.phaseAxisHandle,'DrawMode','fast')
    title(systemObj.phaseAxisHandle,[systemObj.name ' Phase Plot'])
    set(systemObj.phaseAxisHandle,'NextPlot','add');
    if ~isempty(systemObj.phaseAxisProperties)
        set(systemObj.phaseAxisHandle,systemObj.phaseAxisProperties{:});
    end
end
colorOrder = get(systemObj.phaseAxisHandle,'ColorOrder');

% Create Graphics
if ~isempty(systemObj.phaseGraphicsHandle) && all(ishghandle(systemObj.phaseGraphicsHandle))
    nextPlotStatus = get(systemObj.phaseAxisHandle,'NextPlot');
    set(systemObj.phaseAxisHandle,'NextPlot','add');
end

%% Phase plot
nPairs = size(systemObj.phaseStatePairs,1);
if ~isempty(state)
    if isempty(systemObj.phaseGraphicsHandle) || ~all(ishghandle(systemObj.phaseGraphicsHandle)) % Create new marks
        systemObj.phaseGraphicsHandle = zeros(nPairs,1);
        for iPair = 1:nPairs
            systemObj.phaseGraphicsHandle(iPair,1) = plot(systemObj.phaseAxisHandle,...
                state(systemObj.phaseStatePairs(iPair,1)),state(systemObj.phaseStatePairs(iPair,2)),...
                'o','Color',colorOrder(iPair,:),systemObj.phaseGraphicsProperties{:});
            set(systemObj.phaseGraphicsHandle(iPair,1),'DisplayName',...
                [systemObj.stateNames{systemObj.phaseStatePairs(iPair,2)} ' vs. ' systemObj.stateNames{systemObj.phaseStatePairs(iPair,1)}]);
        end
    else % Update  marks
        set(systemObj.phaseGraphicsHandle,{'XData' 'YData'},...
            [num2cell(state(systemObj.phaseStatePairs(:,1))),...
            num2cell(state(systemObj.phaseStatePairs(:,2)))],...
            systemObj.phaseGraphicsProperties{:});
    end
end

if ~isempty(stateTape)
    set(systemObj.phaseAxisHandle,'NextPlot','add');
    if isempty(systemObj.phaseTapeGraphicsHandle) || ~all(ishghandle(systemObj.phaseTapeGraphicsHandle)) % Create new lines
        systemObj.phaseTapeGraphicsHandle = zeros(nPairs,1);
        for iPair = 1:nPairs
            systemObj.phaseTapeGraphicsHandle(iPair,1) = plot(systemObj.phaseAxisHandle,...
                [stateTape(systemObj.phaseStatePairs(iPair,1),:) state(systemObj.phaseStatePairs(iPair,1))],...
                [stateTape(systemObj.phaseStatePairs(iPair,2),:) state(systemObj.phaseStatePairs(iPair,2))],...
                'Color',colorOrder(iPair,:),systemObj.phaseGraphicsProperties{:});
            set(get(get(systemObj.phaseTapeGraphicsHandle(iPair,1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        end
        
    else % Update lines
        set(systemObj.phaseTapeGraphicsHandle,{'XData' 'YData'},...
            [mat2cell([stateTape(systemObj.phaseStatePairs(:,1),:) state(systemObj.phaseStatePairs(:,1))],ones(1,nPairs),size(stateTape,2)+1) ...
            mat2cell([stateTape(systemObj.phaseStatePairs(:,2),:) state(systemObj.phaseStatePairs(:,2))],ones(1,nPairs),size(stateTape,2)+1)],...
            systemObj.phaseGraphicsProperties{:});
    end
end

if exist('nextPlotStatus','var')
    set(systemObj.phaseAxisHandle,'NextPlot',nextPlotStatus);
end


%% Legend
if legendFlag && systemObj.legendFlag
    legend(systemObj.phaseAxisHandle,'Location','best')
end

end

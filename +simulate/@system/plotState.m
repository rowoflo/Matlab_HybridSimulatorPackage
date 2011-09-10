function plotState(systemObj,time,state,timeTape,stateTape,varargin)
% The "plotState" method plots the state history of the system or
% plots the given state vs. the given time.
%
% SYNTAX:
%   systemObj.plotState()
%   systemObj.plotState(time,state,timeTape,stateTape)
%   systemObj.plotState(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number) [systemObj.time]
%       The time used for plotting current state.
%
%   state - (? x 1 number) [systemObj.state]
%       Current state to be plotted.
%
%   timeTape - (1 x ? real number) [systemObj.timeTape]
%       The time tape used for plotting the state tape and input tape.
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
% AUTHOR:
%   19-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Apply default values
if nargin < 2, time = systemObj.time; end
if nargin < 3, state = systemObj.state; end
if nargin < 4, timeTape = systemObj.timeTape; end
if nargin < 5, stateTape = systemObj.stateTape; end

% Check arguments for errors
assert(isa(systemObj,'simulate.system') && numel(systemObj) == 1,...
    'simulate:system:plotState:systemObj',...
    'Input argument "systemObj" must be a 1 x 1 simulate.system object.')

assert(isempty(time) || (isnumeric(time) && isreal(time) && numel(time) == 1),...
    'simulate:system:plotState:time',...
    'Input argument "time" must be a 1 x 1 real number.')

assert(isempty(state) || (isnumeric(state) && isvector(state) && numel(state) == systemObj.nStates),...
    'simulate:system:plotState:time',...
    'Input argument "state" must be a %d x 1 vector of numbers.',systemObj.nStates)
state = state(:);

assert(isempty(timeTape) || (isnumeric(timeTape) && isreal(timeTape) && isvector(timeTape)),...
    'simulate:system:plotState:timeTape',...
    'Input argument "timeTape" must be a 1 x ? vector of real numbers.')
timeTape = timeTape(:)';
nTimeTape = length(timeTape);

assert(isempty(stateTape) || (isnumeric(stateTape) && isequal(size(stateTape),[systemObj.nStates,nTimeTape])),...
    'simulate:system:plotState:stateTape',...
    'Input argument "stateTape" must be a %d x %d matrix of numbers.',systemObj.nStates,nTimeTape)

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'system:plotState:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('legendFlag')
            legendFlag = propValues{iParam};
        otherwise
            error('simulate:system:plotState:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('legendFlag','var'), legendFlag = true; end

% Check property values for errors
assert(islogical(legendFlag) && numel(legendFlag) == 1,...
    'simulate:system:plotState:legendFlag',...
    'Property "legendFlag" must be a 1 x 1 logical.')

%% Initialize
% Create Figure
if isempty(systemObj.stateFigureHandle) || ~ishghandle(systemObj.stateFigureHandle)
    systemObj.stateFigureHandle = figure;
    if ~isempty(systemObj.stateFigureProperties)
        set(systemObj.stateFigureHandle,systemObj.stateFigureProperties{:});
    end
end

% Create Axis
if isempty(systemObj.stateAxisHandle) || ~ishghandle(systemObj.stateAxisHandle)
    figure(systemObj.stateFigureHandle);
    systemObj.stateAxisHandle = gca;
    set(systemObj.stateAxisHandle,'DrawMode','fast')
    title(systemObj.stateAxisHandle,[systemObj.name ' State Plot'])
    xlabel(systemObj.stateAxisHandle,'Time')
    ylabel(systemObj.stateAxisHandle,'Value')
    set(systemObj.stateAxisHandle,'NextPlot','replacechildren');
    if ~isempty(systemObj.stateAxisProperties)
        set(systemObj.stateAxisHandle,systemObj.stateAxisProperties{:});
    end
end

% Create Graphics
if ~isempty(systemObj.stateTapeGraphicsHandle) && all(ishghandle(systemObj.stateGraphicsHandle))
    nextPlotStatus = get(systemObj.stateAxisHandle,'NextPlot');
    set(systemObj.stateAxisHandle,'NextPlot','add');
end

%% Plot State
if ~isempty(state)
    if isempty(systemObj.stateGraphicsHandle) || ~all(ishghandle(systemObj.stateGraphicsHandle)) % Create new marks
        systemObj.stateGraphicsHandle = plot(systemObj.stateAxisHandle,time,state,'o',systemObj.stateGraphicsProperties{:});
        for iState = 1:systemObj.nStates
            set(systemObj.stateGraphicsHandle(iState,1),'DisplayName',systemObj.stateNames{iState});
        end
    else % Update  marks
        set(systemObj.stateGraphicsHandle,{'XData' 'YData'},...
            [repmat({time},systemObj.nStates,1),...
            num2cell(state)],...
            systemObj.stateGraphicsProperties{:});
    end
end

if ~isempty(stateTape)
    set(systemObj.stateAxisHandle,'NextPlot','add');
    if isempty(systemObj.stateTapeGraphicsHandle) || ~all(ishghandle(systemObj.stateTapeGraphicsHandle)) % Create new lines
        systemObj.stateTapeGraphicsHandle = plot(systemObj.stateAxisHandle,[timeTape time],[stateTape state]',systemObj.stateGraphicsProperties{:});
        for iState = 1:systemObj.nStates
            set(get(get(systemObj.stateTapeGraphicsHandle(iState,1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        end
    else % Update lines
        set(systemObj.stateTapeGraphicsHandle,{'XData' 'YData'},...
            [repmat({[timeTape time]},size(stateTape,1),1),...
            mat2cell([stateTape state],ones(1,size(stateTape,1)),size(stateTape,2)+1)],...
            systemObj.stateGraphicsProperties{:});
    end
end

if exist('nextPlotStatus','var')
    set(systemObj.stateAxisHandle,'NextPlot',nextPlotStatus);
end


%% Legend
if legendFlag && systemObj.legendFlag
    legend(systemObj.stateAxisHandle,'Location','best')
end

end

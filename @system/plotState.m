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
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   plot.m | plotInput.m | plotOutput.m | plotPhase.m | plotSketch.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 23-APR-2011 
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = systemObj.time; end
if nargin < 3, state = systemObj.state; end
if nargin < 4, timeTape = zeros(1,0); end
if nargin < 5, stateTape = zeros(systemObj.nStates,0); end


%% Initialize
% Create Figure
if isempty(systemObj.stateFigureHandle) || ~ishghandle(systemObj.stateFigureHandle) || ~ishghandle(systemObj.stateAxisHandle)
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
    if ~isempty(systemObj.stateAxisProperties)
        set(systemObj.stateAxisHandle,systemObj.stateAxisProperties{:});
    end
end
set(systemObj.stateAxisHandle,'NextPlot','add');

%% Plot State
if ~isempty(state)
    if isempty(systemObj.stateGraphicsHandle) || ~all(ishghandle(systemObj.stateGraphicsHandle)) % Create new marks
        systemObj.stateGraphicsHandle = plot(systemObj.stateAxisHandle,time,state,'o',systemObj.stateGraphicsProperties{:});
        for iState = 1:systemObj.nStates
            set(systemObj.stateGraphicsHandle(iState,1),'DisplayName',systemObj.stateNames{iState});
        end
    else % Update marks
        set(systemObj.stateGraphicsHandle,{'XData' 'YData'},...
            [repmat({time},systemObj.nStates,1),...
            num2cell(state)],...
            systemObj.stateGraphicsProperties{:});
    end
end

if ~isempty([systemObj.stateTape stateTape])
    if isempty(systemObj.stateTapeGraphicsHandle) || ~all(ishghandle(systemObj.stateTapeGraphicsHandle)) % Create new lines
        systemObj.stateTapeGraphicsHandle = plot(systemObj.stateAxisHandle,[systemObj.timeTapeC timeTape time],[systemObj.stateTape stateTape state]',systemObj.stateGraphicsProperties{:});
        for iState = 1:systemObj.nStates
            set(get(get(systemObj.stateTapeGraphicsHandle(iState,1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        end
    else % Update lines
        set(systemObj.stateTapeGraphicsHandle,{'XData' 'YData'},...
            [repmat({[systemObj.timeTapeC timeTape time]},size(stateTape,1),1),...
            mat2cell([systemObj.stateTape stateTape state],ones(1,size(stateTape,1)),size([systemObj.stateTape stateTape state],2))],...
            systemObj.stateGraphicsProperties{:});
    end
end

end

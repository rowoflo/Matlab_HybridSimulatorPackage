function plotPhase(systemObj,state,stateTape,varargin)
% The "plotPhase" method plots the phase history of the system (i.e plots the
% given state and state tape).
%
% SYNTAX:
%   systemObj.plotPhase()
%   systemObj.plotPhase(state,stateTape)
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
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   plot.m | plotState.m | plotInput.m | plotOutput.m | plotSketch.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 23-APR-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, state = systemObj.state; end
if nargin < 3, stateTape = zeros(systemObj.nStates,0); end

%% Variables
pairs = systemObj.phaseStatePairs;

%% Initialize
% Create Figure
if isempty(systemObj.phaseFigureHandle) || ~ishghandle(systemObj.phaseFigureHandle) || ~ishghandle(systemObj.phaseAxisHandle)
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
    if ~isempty(systemObj.phaseAxisProperties)
        set(systemObj.phaseAxisHandle,systemObj.phaseAxisProperties{:});
    end
end
set(systemObj.phaseAxisHandle,'NextPlot','add');
colorOrder = get(systemObj.phaseAxisHandle,'ColorOrder');

%% Phase plot
nPairs = size(pairs,1);
if ~isempty(state)
    if isempty(systemObj.phaseGraphicsHandle) || ~all(ishghandle(systemObj.phaseGraphicsHandle)) % Create new marks
        systemObj.phaseGraphicsHandle = zeros(nPairs,1);
        for iPair = 1:nPairs
            systemObj.phaseGraphicsHandle(iPair,1) = plot(systemObj.phaseAxisHandle,...
                state(pairs(iPair,1)),state(pairs(iPair,2)),...
                'o','Color',colorOrder(iPair,:),systemObj.phaseGraphicsProperties{:});
            set(systemObj.phaseGraphicsHandle(iPair,1),'DisplayName',...
                [systemObj.stateNames{pairs(iPair,2)} ' vs. ' systemObj.stateNames{pairs(iPair,1)}]);
        end
    else % Update  marks
        set(systemObj.phaseGraphicsHandle,{'XData' 'YData'},...
            [num2cell(state(pairs(:,1))),...
            num2cell(state(pairs(:,2)))],...
            systemObj.phaseGraphicsProperties{:});
    end
end

if ~isempty([systemObj.stateTape stateTape])
    totalStateTape = [systemObj.stateTape stateTape state];
    if isempty(systemObj.phaseTapeGraphicsHandle) || ~all(ishghandle(systemObj.phaseTapeGraphicsHandle)) % Create new lines
        systemObj.phaseTapeGraphicsHandle = zeros(nPairs,1);
        for iPair = 1:nPairs
            systemObj.phaseTapeGraphicsHandle(iPair,1) = plot(systemObj.phaseAxisHandle,...
                totalStateTape(pairs(iPair,1),:), totalStateTape(pairs(iPair,2),:),...
                'Color',colorOrder(iPair,:),systemObj.phaseGraphicsProperties{:});
            set(get(get(systemObj.phaseTapeGraphicsHandle(iPair,1),'Annotation'),'LegendInformation'),'IconDisplayStyle','off');
        end        
    else % Update lines
        set(systemObj.phaseTapeGraphicsHandle,{'XData' 'YData'},...
            [mat2cell(totalStateTape(systemObj.phaseStatePairs(:,1),:),ones(1,nPairs),size(totalStateTape,2)) ...
            mat2cell(totalStateTape(systemObj.phaseStatePairs(:,2),:),ones(1,nPairs),size(totalStateTape,2))],...
            systemObj.phaseGraphicsProperties{:});
    end
end

end

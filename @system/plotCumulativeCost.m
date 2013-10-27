function plotCumulativeCost(systemObj,time,timeTape,cumulativeCostTape,varargin)
% The "plotCumulativeCost" method plots the cumulativeCost history of the system or
% plots the given cumulativeCost vs. the given time.
%
% SYNTAX:
%   systemObj.plot()
%   systemObj.plot(time,timeTape,cumulativeCostTape)
%   systemObj.plot(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number) [systemObj.time]
%       The time used for plotting current state.
%
%   timeTape - (1 x ? real number) [systemObj.timeTape]
%       The time tape used for plotting the state tape and cumulativeCost tape.
%
%   cumulativeCostTape - (? x ? number) [systemObj.cumulativeCostTape] 
%       The cumulativeCost tape used for plotting
%
% PROPERTIES:
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   plot.m | plotInput.m | plotState.m | plotPhase.m | plotSketch.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 20-Oct-2013 
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = systemObj.time; end
if nargin < 3, timeTape = zeros(1,0); end
if nargin < 4, cumulativeCostTape = zeros(systemObj.nCosts,0); end

%% Initialize
% Create Figure
if isempty(systemObj.cumulativeCostFigureHandle) || ~ishghandle(systemObj.cumulativeCostFigureHandle) || ~ishghandle(systemObj.cumulativeCostAxisHandle)
    systemObj.cumulativeCostFigureHandle = figure;
    if ~isempty(systemObj.cumulativeCostFigureProperties)
        set(systemObj.cumulativeCostFigureHandle,systemObj.cumulativeCostFigureProperties{:});
    end
end

% Create Axis
if isempty(systemObj.cumulativeCostAxisHandle) || ~ishghandle(systemObj.cumulativeCostAxisHandle)
    figure(systemObj.cumulativeCostFigureHandle);
    systemObj.cumulativeCostAxisHandle = gca;
    set(systemObj.cumulativeCostAxisHandle,'DrawMode','fast')
    title(systemObj.cumulativeCostAxisHandle,[systemObj.name 'Cumulative Cost Plot'])
    xlabel(systemObj.cumulativeCostAxisHandle,'Time')
    ylabel(systemObj.cumulativeCostAxisHandle,'Value')
    if ~isempty(systemObj.cumulativeCostAxisProperties)
        set(systemObj.cumulativeCostAxisHandle,systemObj.cumulativeCostAxisProperties{:});
    end
end
set(systemObj.cumulativeCostAxisHandle,'NextPlot','add');

%% Plot Cost
toPlot = systemObj.costsToPlot';
nCosts = length(toPlot);
if ~isempty([systemObj.cumulativeCostTape cumulativeCostTape])
    if isempty(cumulativeCostTape)
        cumulativeCostLast = systemObj.cumulativeCostTape(:,end);
    else
        cumulativeCostLast = cumulativeCostTape(:,end);
    end
    totalTimeTape = [systemObj.timeTapeD timeTape time];
    totalCostTape = [systemObj.cumulativeCostTape cumulativeCostTape cumulativeCostLast];
    if isempty(systemObj.cumulativeCostTapeGraphicsHandle) || ~all(ishghandle(systemObj.cumulativeCostTapeGraphicsHandle(toPlot))) % Create new lines
        colorOrder = get(systemObj.cumulativeCostAxisHandle,'ColorOrder');
        nColors = size(colorOrder,1);
        timeTemp = repmat(totalTimeTape(2:end-1),2,1);
        timeVector = [totalTimeTape(1) timeTemp(:)' totalTimeTape(end)];
        cumulativeCostTemp = repmat(permute(totalCostTape(toPlot,1:end-1),[3 2 1]),[2 1 1]);
        cumulativeCostVector = permute(reshape(cumulativeCostTemp ,[1 2*size(cumulativeCostTemp,2) nCosts]),[3 2 1]);
        
        systemObj.cumulativeCostTapeGraphicsHandle = nan(systemObj.nCosts,1);
        for iCost = 1:nCosts
            systemObj.cumulativeCostTapeGraphicsHandle(toPlot(iCost),1) = plot(systemObj.cumulativeCostAxisHandle,...
            timeVector,cumulativeCostVector(iCost,:),...
            'Color',colorOrder(mod(toPlot(iCost)-1,nColors)+1,:),...
            systemObj.cumulativeCostGraphicsProperties{:});
            set(systemObj.cumulativeCostTapeGraphicsHandle(toPlot(iCost),1),'DisplayName',systemObj.costNames{toPlot(iCost)});
        end
    else % Update lines
        timeTemp = repmat(totalTimeTape(2:end-1),2,1);
        timeVector = [totalTimeTape(1) timeTemp(:)' totalTimeTape(end)];
        cumulativeCostTemp = repmat(permute(totalCostTape(toPlot,1:end-1),[3 2 1]),[2 1 1]);
        cumulativeCostVector = permute(reshape(cumulativeCostTemp ,[1 2*size(cumulativeCostTemp,2) nCosts]),[3 2 1]);
        set(systemObj.cumulativeCostTapeGraphicsHandle(toPlot),{'XData' 'YData'},...
            [repmat({timeVector},size(cumulativeCostVector,1),1),...
            mat2cell(cumulativeCostVector,ones(1,size(cumulativeCostVector,1)),size(cumulativeCostVector,2))],...
            systemObj.cumulativeCostGraphicsProperties{:});
    end
end


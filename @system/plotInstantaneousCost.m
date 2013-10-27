function plotInstantaneousCost(systemObj,time,timeTape,instantaneousCostTape,varargin)
% The "plotInstantaneousCost" method plots the instantaneousCost history of the system or
% plots the given instantaneousCost vs. the given time.
%
% SYNTAX:
%   systemObj.plot()
%   systemObj.plot(time,timeTape,instantaneousCostTape)
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
%       The time tape used for plotting the state tape and instantaneousCost tape.
%
%   instantaneousCostTape - (? x ? number) [systemObj.instantaneousCostTape] 
%       The instantaneousCost tape used for plotting
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
if nargin < 4, instantaneousCostTape = zeros(systemObj.nCosts,0); end

%% Initialize
% Create Figure
if isempty(systemObj.instantaneousCostFigureHandle) || ~ishghandle(systemObj.instantaneousCostFigureHandle) || ~ishghandle(systemObj.instantaneousCostAxisHandle)
    systemObj.instantaneousCostFigureHandle = figure;
    if ~isempty(systemObj.instantaneousCostFigureProperties)
        set(systemObj.instantaneousCostFigureHandle,systemObj.instantaneousCostFigureProperties{:});
    end
end

% Create Axis
if isempty(systemObj.instantaneousCostAxisHandle) || ~ishghandle(systemObj.instantaneousCostAxisHandle)
    figure(systemObj.instantaneousCostFigureHandle);
    systemObj.instantaneousCostAxisHandle = gca;
    set(systemObj.instantaneousCostAxisHandle,'DrawMode','fast')
    title(systemObj.instantaneousCostAxisHandle,[systemObj.name ' Instantaneous Cost Plot'])
    xlabel(systemObj.instantaneousCostAxisHandle,'Time')
    ylabel(systemObj.instantaneousCostAxisHandle,'Value')
    if ~isempty(systemObj.instantaneousCostAxisProperties)
        set(systemObj.instantaneousCostAxisHandle,systemObj.instantaneousCostAxisProperties{:});
    end
end
set(systemObj.instantaneousCostAxisHandle,'NextPlot','add');

%% Plot Cost
toPlot = systemObj.costsToPlot';
nCosts = length(toPlot);
if ~isempty([systemObj.instantaneousCostTape instantaneousCostTape])
    if isempty(instantaneousCostTape)
        instantaneousCostLast = systemObj.instantaneousCostTape(:,end);
    else
        instantaneousCostLast = instantaneousCostTape(:,end);
    end
    totalTimeTape = [systemObj.timeTapeD timeTape time];
    totalCostTape = [systemObj.instantaneousCostTape instantaneousCostTape instantaneousCostLast];
    if isempty(systemObj.instantaneousCostTapeGraphicsHandle) || ~all(ishghandle(systemObj.instantaneousCostTapeGraphicsHandle(toPlot))) % Create new lines
        colorOrder = get(systemObj.instantaneousCostAxisHandle,'ColorOrder');
        nColors = size(colorOrder,1);
        timeTemp = repmat(totalTimeTape(2:end-1),2,1);
        timeVector = [totalTimeTape(1) timeTemp(:)' totalTimeTape(end)];
        instantaneousCostTemp = repmat(permute(totalCostTape(toPlot,1:end-1),[3 2 1]),[2 1 1]);
        instantaneousCostVector = permute(reshape(instantaneousCostTemp ,[1 2*size(instantaneousCostTemp,2) nCosts]),[3 2 1]);
        
        systemObj.instantaneousCostTapeGraphicsHandle = nan(systemObj.nCosts,1);
        for iCost = 1:nCosts
            systemObj.instantaneousCostTapeGraphicsHandle(toPlot(iCost),1) = plot(systemObj.instantaneousCostAxisHandle,...
            timeVector,instantaneousCostVector(iCost,:),...
            'Color',colorOrder(mod(toPlot(iCost)-1,nColors)+1,:),...
            systemObj.instantaneousCostGraphicsProperties{:});
            set(systemObj.instantaneousCostTapeGraphicsHandle(toPlot(iCost),1),'DisplayName',systemObj.costNames{toPlot(iCost)});
        end
    else % Update lines
        timeTemp = repmat(totalTimeTape(2:end-1),2,1);
        timeVector = [totalTimeTape(1) timeTemp(:)' totalTimeTape(end)];
        instantaneousCostTemp = repmat(permute(totalCostTape(toPlot,1:end-1),[3 2 1]),[2 1 1]);
        instantaneousCostVector = permute(reshape(instantaneousCostTemp ,[1 2*size(instantaneousCostTemp,2) nCosts]),[3 2 1]);
        set(systemObj.instantaneousCostTapeGraphicsHandle(toPlot),{'XData' 'YData'},...
            [repmat({timeVector},size(instantaneousCostVector,1),1),...
            mat2cell(instantaneousCostVector,ones(1,size(instantaneousCostVector,1)),size(instantaneousCostVector,2))],...
            systemObj.instantaneousCostGraphicsProperties{:});
    end
end


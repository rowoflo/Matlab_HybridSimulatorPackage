function plotOutput(systemObj,time,timeTape,outputTape,varargin)
% The "plotOutput" method plots the output history of the system or
% plots the given output vs. the given time.
%
% SYNTAX:
%   systemObj.plot()
%   systemObj.plot(time,timeTape,outputTape)
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
%       The time tape used for plotting the state tape and output tape.
%
%   outputTape - (? x ? number) [systemObj.outputTape] 
%       The output tape used for plotting
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
%   Created 23-APR-2011 
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = systemObj.time; end
if nargin < 3, timeTape = zeros(1,0); end
if nargin < 4, outputTape = zeros(systemObj.nOutputs,0); end

%% Initialize
% Create Figure
if isempty(systemObj.outputFigureHandle) || ~ishghandle(systemObj.outputFigureHandle) || ~ishghandle(systemObj.outputAxisHandle)
    systemObj.outputFigureHandle = figure;
    if ~isempty(systemObj.outputFigureProperties)
        set(systemObj.outputFigureHandle,systemObj.outputFigureProperties{:});
    end
end

% Create Axis
if isempty(systemObj.outputAxisHandle) || ~ishghandle(systemObj.outputAxisHandle)
    figure(systemObj.outputFigureHandle);
    systemObj.outputAxisHandle = gca;
    set(systemObj.outputAxisHandle,'DrawMode','fast')
    title(systemObj.outputAxisHandle,[systemObj.name ' Output Plot'])
    xlabel(systemObj.outputAxisHandle,'Time')
    ylabel(systemObj.outputAxisHandle,'Value')
    if ~isempty(systemObj.outputAxisProperties)
        set(systemObj.outputAxisHandle,systemObj.outputAxisProperties{:});
    end
end
set(systemObj.outputAxisHandle,'NextPlot','add');

%% Plot Output
if ~isempty([systemObj.outputTape outputTape])
    if isempty(outputTape)
        outputLast = systemObj.outputTape(:,end);
    else
        outputLast = outputTape(:,end);
    end
    totalTimeTape = [systemObj.timeTapeD timeTape time];
    totalOutputTape = [systemObj.outputTape outputTape outputLast];
    if isempty(systemObj.outputTapeGraphicsHandle) || ~all(ishghandle(systemObj.outputTapeGraphicsHandle)) % Create new lines
        timeTemp = repmat(totalTimeTape(2:end-1),2,1);
        timeVector = [totalTimeTape(1) timeTemp(:)' totalTimeTape(end)];
        outputTemp = repmat(permute(totalOutputTape(:,1:end-1),[3 2 1]),[2 1 1]);
        outputVector = permute(reshape(outputTemp ,[1 2*size(outputTemp,2) systemObj.nOutputs]),[3 2 1]);
        systemObj.outputTapeGraphicsHandle = plot(systemObj.outputAxisHandle,...
            timeVector,outputVector',...
            systemObj.outputGraphicsProperties{:});
        for iOutput = 1:systemObj.nOutputs
            set(systemObj.outputTapeGraphicsHandle(iOutput,1),'DisplayName',systemObj.outputNames{iOutput});
        end
    else % Update lines
        timeTemp = repmat(totalTimeTape(2:end-1),2,1);
        timeVector = [totalTimeTape(1) timeTemp(:)' totalTimeTape(end)];
        outputTemp = repmat(permute(totalOutputTape(:,1:end-1),[3 2 1]),[2 1 1]);
        outputVector = permute(reshape(outputTemp ,[1 2*size(outputTemp,2) systemObj.nOutputs]),[3 2 1]);
        set(systemObj.outputTapeGraphicsHandle,{'XData' 'YData'},...
            [repmat({timeVector},size(outputVector,1),1),...
            mat2cell(outputVector,ones(1,size(outputVector,1)),size(outputVector,2))],...
            systemObj.outputGraphicsProperties{:});
    end
end


function plotInput(systemObj,time,timeTape,inputTape,varargin)
% The "plotInput" method plots the input history of the system or
% plots the given input vs. the given time.
%
% SYNTAX:
%   systemObj.plot()
%   systemObj.plot(time,timeTape,inputTape)
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
%       The time tape used for plotting the state tape and input tape.
%
%   inputTape - (? x ? number) [systemObj.inputTape] 
%       The input tape used for plotting
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
if nargin < 4, inputTape = zeros(systemObj.nInputs,0); end

%% Initialize
% Create Figure
if isempty(systemObj.inputFigureHandle) || ~ishghandle(systemObj.inputFigureHandle) || ~ishghandle(systemObj.inputAxisHandle)
    systemObj.inputFigureHandle = figure;
    if ~isempty(systemObj.inputFigureProperties)
        set(systemObj.inputFigureHandle,systemObj.inputFigureProperties{:});
    end
end

% Create Axis
if isempty(systemObj.inputAxisHandle) || ~ishghandle(systemObj.inputAxisHandle)
    figure(systemObj.inputFigureHandle);
    systemObj.inputAxisHandle = gca;
    set(systemObj.inputAxisHandle,'DrawMode','fast')
    title(systemObj.inputAxisHandle,[systemObj.name ' Input Plot'])
    xlabel(systemObj.inputAxisHandle,'Time')
    ylabel(systemObj.inputAxisHandle,'Value')
    if ~isempty(systemObj.inputAxisProperties)
        set(systemObj.inputAxisHandle,systemObj.inputAxisProperties{:});
    end
end
set(systemObj.inputAxisHandle,'NextPlot','add');

%% Plot Input
if ~isempty([systemObj.inputTape inputTape])
    if isempty(inputTape)
        inputLast = systemObj.inputTape(:,end);
    else
        inputLast = inputTape(:,end);
    end
    totalTimeTape = [systemObj.timeTapeD timeTape time];
    totalInputTape = [systemObj.inputTape inputTape inputLast];
    if isempty(systemObj.inputTapeGraphicsHandle) || ~all(ishghandle(systemObj.inputTapeGraphicsHandle)) % Create new lines
        timeTemp = repmat(totalTimeTape(2:end-1),2,1);
        timeVector = [totalTimeTape(1) timeTemp(:)' totalTimeTape(end)];
        inputTemp = repmat(permute(totalInputTape(:,1:end-1),[3 2 1]),[2 1 1]);
        inputVector = permute(reshape(inputTemp ,[1 2*size(inputTemp,2) systemObj.nInputs]),[3 2 1]);
        systemObj.inputTapeGraphicsHandle = plot(systemObj.inputAxisHandle,...
            timeVector,inputVector',...
            systemObj.inputGraphicsProperties{:});
        for iInput = 1:systemObj.nInputs
            set(systemObj.inputTapeGraphicsHandle(iInput,1),'DisplayName',systemObj.inputNames{iInput});
        end
    else % Update lines
        timeTemp = repmat(totalTimeTape(2:end-1),2,1);
        timeVector = [totalTimeTape(1) timeTemp(:)' totalTimeTape(end)];
        inputTemp = repmat(permute(totalInputTape(:,1:end-1),[3 2 1]),[2 1 1]);
        inputVector = permute(reshape(inputTemp ,[1 2*size(inputTemp,2) systemObj.nInputs]),[3 2 1]);
        set(systemObj.inputTapeGraphicsHandle,{'XData' 'YData'},...
            [repmat({timeVector},size(inputVector,1),1),...
            mat2cell(inputVector,ones(1,size(inputVector,1)),size(inputVector,2))],...
            systemObj.inputGraphicsProperties{:});
    end
end

end

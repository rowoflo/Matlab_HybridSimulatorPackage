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
%   plot.m | plotOutput.m | plotState.m | plotSketch.m | plotPhase.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 23-APR-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = systemObj.time; end
if nargin < 3, timeTape = systemObj.timeTape; end
if nargin < 4, inputTape = systemObj.inputTape; end

%% Initialize
% Create Figure
if isempty(systemObj.inputFigureHandle) || ~ishghandle(systemObj.inputFigureHandle)
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
set(systemObj.inputAxisHandle,'NextPlot','replacechildren');

%% Plot Input
if ~isempty(inputTape)
    if isempty(systemObj.inputTapeGraphicsHandle) || ~all(ishghandle(systemObj.inputTapeGraphicsHandle)) % Create new lines
        systemObj.inputTapeGraphicsHandle = plot(systemObj.inputAxisHandle,[timeTape time],[inputTape inputTape(:,end)],systemObj.inputGraphicsProperties{:});
        for iInput = 1:systemObj.nInputs
            set(systemObj.inputTapeGraphicsHandle(iInput,1),'DisplayName',systemObj.inputNames{iInput});
        end
    else % Update lines
        timeTemp = repmat(timeTape(2:end),2,1);
        timeVector = [timeTape(1) timeTemp(:)' time];
        inputTemp = repmat(permute(inputTape,[3 2 1]),[2 1 1]);
        inputVector = permute(reshape(inputTemp,[1 2*size(inputTape,2) size(inputTape,1)]),[3 2 1]);
        set(systemObj.inputTapeGraphicsHandle,{'XData' 'YData'},...
            [repmat({timeVector},size(inputVector,1),1),...
            mat2cell(inputVector,ones(1,size(inputVector,1)),size(inputVector,2))],...
            systemObj.inputGraphicsProperties{:});
    end
end

end

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
%   'legendFlag' - (1 x 1 logical) [systemObj.legendFlag]
%       Sets whether the legend will be displayed.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   plot.m | plotInput.m | plotState.m | sketch.m | phase.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 23-APR-2011 
%-------------------------------------------------------------------------------

%% Check Output Arguments

% Apply default values
if nargin < 2, time = systemObj.time; end
if nargin < 3, timeTape = systemObj.timeTape; end
if nargin < 4, outputTape = systemObj.outputTape; end

% Check arguments for errors
assert(isa(systemObj,'simulate.system') && numel(systemObj) == 1,...
    'simulate:system:plotOutput:systemObj',...
    'Output argument "systemObj" must be a 1 x 1 simulate.system object.')

assert(isempty(time) || (isnumeric(time) && isreal(time) && numel(time) == 1),...
    'simulate:system:plotOutput:time',...
    'Output argument "time" must be a 1 x 1 real number.')

assert(isempty(timeTape) || (isnumeric(timeTape) && isreal(timeTape) && isvector(timeTape)),...
    'simulate:system:plotOutput:timeTape',...
    'Output argument "timeTape" must be a 1 x ? vector of real numbers.')
timeTape = timeTape(:)';
nTimeTape = length(timeTape);

assert(isempty(outputTape) || (isnumeric(outputTape) && isequal(size(outputTape),[systemObj.nOutputs,nTimeTape])),...
    'simulate:system:plotOutput:outputTape',...
    'Output argument "outputTape" must be a %d x %d matrix of numbers.',systemObj.nOutputs,nTimeTape)

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'system:plotOutput:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('legendFlag')
            legendFlag = propValues{iParam};
        otherwise
            error('simulate:system:plotOutput:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('legendFlag','var'), legendFlag = systemObj.legendFlag; end

% Check property values for errors
assert(islogical(legendFlag) && numel(legendFlag) == 1,...
    'simulate:system:plotOutput:legendFlag',...
    'Property "legendFlag" must be a 1 x 1 logical.')

%% Initialize
% Create Figure
if isempty(systemObj.outputFigureHandle) || ~ishghandle(systemObj.outputFigureHandle)
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
    set(systemObj.outputAxisHandle,'NextPlot','replacechildren');
    if ~isempty(systemObj.outputAxisProperties)
        set(systemObj.outputAxisHandle,systemObj.outputAxisProperties{:});
    end
end

%% Plot Output
if ~isempty(outputTape)
    if isempty(systemObj.outputTapeGraphicsHandle) || ~all(ishghandle(systemObj.outputTapeGraphicsHandle)) % Create new lines
        systemObj.outputTapeGraphicsHandle = plot(systemObj.outputAxisHandle,[timeTape time],[outputTape outputTape],systemObj.outputGraphicsProperties{:});
        for iOutput = 1:systemObj.nOutputs
            set(systemObj.outputTapeGraphicsHandle(iOutput,1),'DisplayName',systemObj.outputNames{iOutput});
        end
    else % Update lines
        timeTemp = repmat(timeTape(2:end),2,1);
        timeVector = [timeTape(1) timeTemp(:)' time];
        outputTemp = repmat(permute(outputTape,[3 2 1]),[2 1 1]);
        outputVector = permute(reshape(outputTemp,[1 2*size(outputTape,2) size(outputTape,1)]),[3 2 1]);
        set(systemObj.outputTapeGraphicsHandle,{'XData' 'YData'},...
            [repmat({timeVector},size(outputVector,1),1),...
            mat2cell(outputVector,ones(1,size(outputVector,1)),size(outputVector,2))],...
            systemObj.outputGraphicsProperties{:});
    end
end

%% Legend
if legendFlag
    legend(systemObj.outputAxisHandle,'Location','best')
else
    legend(systemObj.outputAxisHandle,'off')
end

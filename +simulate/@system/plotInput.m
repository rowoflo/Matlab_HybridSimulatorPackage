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
if nargin < 3, timeTape = systemObj.timeTape; end
if nargin < 4, inputTape = systemObj.inputTape; end

% Check arguments for errors
assert(isa(systemObj,'simulate.system') && numel(systemObj) == 1,...
    'simulate:system:plotInput:systemObj',...
    'Input argument "systemObj" must be a 1 x 1 simulate.system object.')

assert(isempty(time) || (isnumeric(time) && isreal(time) && numel(time) == 1),...
    'simulate:system:plotInput:time',...
    'Input argument "time" must be a 1 x 1 real number.')

assert(isempty(timeTape) || (isnumeric(timeTape) && isreal(timeTape) && isvector(timeTape)),...
    'simulate:system:plotInput:timeTape',...
    'Input argument "timeTape" must be a 1 x ? vector of real numbers.')
timeTape = timeTape(:)';
nTimeTape = length(timeTape);

assert(isempty(inputTape) || (isnumeric(inputTape) && isequal(size(inputTape),[systemObj.nInputs,nTimeTape])),...
    'simulate:system:plotInput:inputTape',...
    'Input argument "inputTape" must be a %d x %d matrix of numbers.',systemObj.nInputs,nTimeTape)

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'system:plotInput:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('legendFlag')
            legendFlag = propValues{iParam};
        otherwise
            error('simulate:system:plotInput:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('legendFlag','var'), legendFlag = true; end

% Check property values for errors
assert(islogical(legendFlag) && numel(legendFlag) == 1,...
    'simulate:system:plotInput:legendFlag',...
    'Property "legendFlag" must be a 1 x 1 logical.')

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
    set(systemObj.inputAxisHandle,'NextPlot','replacechildren');
    if ~isempty(systemObj.inputAxisProperties)
        set(systemObj.inputAxisHandle,systemObj.inputAxisProperties{:});
    end
end

%% Plot Input
if ~isempty(inputTape)
    if isempty(systemObj.inputTapeGraphicsHandle) || ~all(ishghandle(systemObj.inputTapeGraphicsHandle)) % Create new lines
        systemObj.inputTapeGraphicsHandle = plot(systemObj.inputAxisHandle,[timeTape time],[inputTape inputTape],systemObj.inputGraphicsProperties{:});
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

%% Legend
if legendFlag && systemObj.legendFlag
    legend(systemObj.inputAxisHandle,'Location','best')
end

end

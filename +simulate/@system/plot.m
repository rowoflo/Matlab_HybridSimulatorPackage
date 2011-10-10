function plot(systemObj,time,state,timeTape,stateTape,inputTape,varargin)
% The "plot" method plots the input and state history of the system or
% plots the given state and input vs. the given time.
%
% SYNTAX:
%   systemObj.plot()
%   systemObj.plot(time,state,timeTape,stateTape,inputTape)
%   systemObj.plot(...,'PropertyName',PropertyValue,...)
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
%   inputTape - (? x ? number) [systemObj.inputTape] 
%       The input tape used for plotting
%
% PROPERTIES:
%   Properties are passed to the plotState, plotInput, and plotOutput
%   methods.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   plotInput.m | plotOutput.m | plotState.m | sketch.m | phase.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 23-APR-2011
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Apply default values
if nargin < 2, time = systemObj.time; end
if nargin < 3, state = systemObj.state; end
if nargin < 4, timeTape = systemObj.timeTape; end
if nargin < 5, stateTape = systemObj.stateTape; end
if nargin < 6, inputTape = systemObj.inputTape; end

% Check arguments for errors
assert(isa(systemObj,'simulate.system') && numel(systemObj) == 1,...
    'simulate:system:plot:systemObj',...
    'Input argument "systemObj" must be a 1 x 1 simulate.system object.')

assert(isempty(time) || (isnumeric(time) && isreal(time) && numel(time) == 1),...
    'simulate:system:plot:time',...
    'Input argument "time" must be a 1 x 1 real number.')

assert(isempty(state) || (isnumeric(state) && isvector(state) && numel(state) == systemObj.nStates),...
    'simulate:system:plot:time',...
    'Input argument "state" must be a %d x 1 vector of numbers.',systemObj.nStates)
state = state(:);

assert(isempty(timeTape) || (isnumeric(timeTape) && isreal(timeTape) && isvector(timeTape)),...
    'simulate:system:plot:timeTape',...
    'Input argument "timeTape" must be a 1 x ? vector of real numbers.')
timeTape = timeTape(:)';
nTimeTape = length(timeTape);

assert(isempty(stateTape) || (isnumeric(stateTape) && isequal(size(stateTape),[systemObj.nStates,nTimeTape])),...
    'simulate:system:plot:stateTape',...
    'Input argument "stateTape" must be a %d x %d matrix of numbers.',systemObj.nStates,nTimeTape)

assert(isempty(inputTape) || (isnumeric(inputTape) && isequal(size(inputTape),[systemObj.nInputs,nTimeTape])),...
    'simulate:system:plot:inputTape',...
    'Input argument "inputTape" must be a %d x %d matrix of numbers.',systemObj.nInputs,nTimeTape)

%% Plot State
systemObj.plotState(time,state,timeTape,stateTape,varargin{:});


%% Plot Input
systemObj.plotInput(time,timeTape,inputTape,varargin{:});


end

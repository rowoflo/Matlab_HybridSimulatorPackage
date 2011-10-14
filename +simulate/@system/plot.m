function plot(systemObj,time,state,timeTapeC,stateTape,timeTapeD,inputTape,varargin)
% The "plot" method plots the input and state history of the system or
% plots the given state and input vs. the given time.
%
% SYNTAX:
%   systemObj.plot()
%   systemObj.plot(time,state,timeTapeC,stateTape,timeTapeD,inputTape)
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
%   timeTapeC - (1 x ? real number) [systemObj.timeTapeC]
%       The time tape used for plotting the state tape.
%
%   stateTape - (? x ? number) [systemObj.stateTape]
%       The state tape used for plotting.
%
%   timeTapeD - (1 x ? real number) [systemObj.timeTapeD]
%       The time tape used for plotting the input tape.
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
if nargin < 4, timeTapeC = systemObj.timeTapeC; end
if nargin < 5, stateTape = systemObj.stateTape; end
if nargin < 4, timeTapeD = systemObj.timeTapeD; end
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

assert(isempty(timeTapeC) || (isnumeric(timeTapeC) && isreal(timeTapeC) && isvector(timeTapeC)),...
    'simulate:system:plot:timeTapeC',...
    'Input argument "timeTapeC" must be a 1 x ? vector of real numbers.')
timeTapeC = timeTapeC(:)';
nTimeTapeC = length(timeTapeC);

assert(isempty(stateTape) || (isnumeric(stateTape) && isequal(size(stateTape),[systemObj.nStates,nTimeTapeC])),...
    'simulate:system:plot:stateTape',...
    'Input argument "stateTape" must be a %d x %d matrix of numbers.',systemObj.nStates,nTimeTapeC)

assert(isempty(timeTapeD) || (isnumeric(timeTapeD) && isreal(timeTapeD) && isvector(timeTapeD)),...
    'simulate:system:plot:timeTapeD',...
    'Input argument "timeTapeD" must be a 1 x ? vector of real numbers.')
timeTapeD = timeTapeD(:)';
nTimeTapeD = length(timeTapeD);

assert(isempty(inputTape) || (isnumeric(inputTape) && isequal(size(inputTape),[systemObj.nInputs,nTimeTapeD])),...
    'simulate:system:plot:inputTape',...
    'Input argument "inputTape" must be a %d x %d matrix of numbers.',systemObj.nInputs,nTimeTapeD)

%% Plot State
systemObj.plotState(time,state,timeTapeC,stateTape,varargin{:});


%% Plot Input
systemObj.plotInput(time,timeTapeD,inputTape,varargin{:});


end

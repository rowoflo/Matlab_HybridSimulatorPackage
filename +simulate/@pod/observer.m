function output = observer(~,~,state,~,~,~)
% The "observer" method will produce output values given the current
% time and state of the pod.
%
% SYNTAX:
%   output = podObj.observer(time,state)
%   output = podObj.observer(time,state,input,flowTime)
%   output = podObj.observer(time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   podObj - (1 x 1 simulate.pod)
%       An instance of the "simulate.pod" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 real number)
%       Current state. Must be a "podObj.nStates" x 1 vector.
%
%   input - (? x 1 real number)
%       Current input. Must be a "podObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   output - (? x 1 number)
%       Output values for the plant. A "podObj.nOutputs" x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES
%   +simulate
%
% AUTHOR:
%   13-MAY-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments
% 
% Check number of arguments
% error(nargchk(4,6,nargin))
% 
% Apply default values
% if nargin < 5, flowTime = 0; end
% if nargin < 6, jumpCount = 0; end
% 
% Check arguments for errors
% assert(isa(podObj,'simulate.pod') && numel(podObj) == 1,...
%     'simulate:pod:observer:podObj',...
%     'Input argument "podObj" must be a 1 x 1 simulate.pod object.')
% 
% assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
%     'simulate:pod:observer:time',...
%     'Input argument "time" must be a 1 x 1 real number.')
% 
% assert(isnumeric(state) && isequal(size(state),[podObj.nStates,1]),...
%     'simulate:pod:observer:state',...
%     'Input argument "state" must be a %d x 1 vector of numbers.',podObj.nStates)
% 
% assert(isnumeric(input) && isequal(size(input),[podObj.nInputs,1]),...
%     'simulate:pod:observer:input',...
%     'Input argument "input" must be a %d x 1 vector of numbers.',podObj.nInputs)
% 
% assert(isnumeric(flowTime) && isreal(flowTime) && numel(flowTime) == 1 && flowTime >= 0,...
%     'simulate:pod:observer:flowTime',...
%     'Input argument "flowTime" must be a 1 x 1 semi-positive real number.')
% 
% assert(isnumeric(jumpCount) && isreal(jumpCount) && numel(jumpCount) == 1 && jumpCount >= 0 && mod(jumpCount,1) == 0,...
%     'simulate:pod:observer:jumpCount',...
%     'Input argument "jumpCount" must be a 1 x 1 semi-positive integer.')

%% Parameters

%% Variables

%% Observer

%% Set output
output = state; 

end

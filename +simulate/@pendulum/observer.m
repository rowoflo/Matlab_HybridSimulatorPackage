function output = observer(~,~,state,~,~,~)
% The "observer" method will produce output values given the current
% time and state of the pendulum.
%
% SYNTAX:
%   output = pendulumObj.observer(time,state)
%   output = pendulumObj.observer(time,state,input,flowTime)
%   output = pendulumObj.observer(time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.pendulum)
%       An instance of the "simulate.pendulum" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 real number)
%       Current state. Must be a "pendulumObj.nStates" x 1 vector.
%
%   input - (? x 1 real number)
%       Current input. Must be a "pendulumObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   output - (? x 1 number)
%       Output values for the plant. A "pendulumObj.nOutputs" x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES
%   +simulate
%
% AUTHOR:
%   11-MAY-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments
% 
% % Check number of arguments
% error(nargchk(2,6,nargin))
% 
% % Check arguments for errors
% assert(isa(pendulumObj,'simulate.pendulum') && numel(pendulumObj) == 1,...
%     'simulate:pendulum:observer:pendulumObj',...
%     'Input argument "pendulumObj" must be a 1 x 1 simulate.pendulum object.')
% 
% assert(isnumeric(time) && isreal(time) && isequal(size(time),[1,1]),...
%     'simulate:pendulum:observer:time',...
%     'Input argument "time" must be a 1 x 1 real numbers.')
% 
% assert(isnumeric(state) && isequal(size(state),[pendulumObj.nStates,1]),...
%     'simulate:pendulum:observer:state',...
%     'Input argument "state" must be a %d x 1 vector of numbers.',pendulumObj.nStates)

%% Parameters

%% Variables

%% Observer

%% Set output
output = state;

end

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
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +simulate, someFile.m
%
% AUTHOR:
%   30-AUG-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

% %% Check Input Arguments
% 
% % Check number of arguments TODO: Add number argument check
% error(nargchk(1,2,nargin))
% 
% % Apply default values TODO: Add apply defaults
% if nargin < 2, arg1 = 0; end
% 
% % Check arguments for errors TODO: Add error checks
% assert(isa(botObj,'simulate.bot') && numel(botObj) == 1,...
%     'simulate:bot:observer:botObj',...
%     'Input argument "botObj" must be a 1 x 1 "simulate.bot" object.')
%
% assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
%     'simulate:bot:observer:arg1',...
%     'Input argument "arg1" must be a ? x ? matrix of real numbers.')

%% Set output
output = state;

end

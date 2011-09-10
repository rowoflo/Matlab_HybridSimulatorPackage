function input = controller(botObj,time,~,~,~)
% The "controller" method will produce input values given the current
% time and state of the system.
%
% SYNTAX:
%   input = controller(botObj,time,state)
%   input = controller(botObj,time,state,flowTime)
%   input = controller(botObj,time,state,flowTime,jumpCount)
%
% INPUTS:
%   botObj - (1 x 1 simulate.bot)
%       An instance of the "simulate.bot" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "botObj.nStates" q 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   input - (? x 1 number)
%       Input values for the plant. A "botObj.nInputs"  q 1 vector.
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
%     'simulate:bot:controller:botObj',...
%     'Input argument "botObj" must be a 1 x 1 "simulate.bot" object.')
%
% assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
%     'simulate:bot:controller:arg1',...
%     'Input argument "arg1" must be a ? x ? matrix of real numbers.')

%% Parameters

%% Variables

%% Controller
timeIndex = find((time - botObj.openLoopTimeTape) > -1e-10,1,'last');
u = botObj.openLoopInputTape(:,timeIndex);

%% Set input
input = min(max(u,botObj.inputLimits(:,1)),botObj.inputLimits(:,2));


end

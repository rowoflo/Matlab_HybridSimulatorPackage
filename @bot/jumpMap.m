function statePlus = jumpMap(~,~,state,~,~,~)
% The "jumpMap" method sets the discrete time dynamics of the system.
%
% SYNTAX:
%   statePlus = jumpMap(botObj,time,state,input)
%   statePlus = jumpMap(botObj,time,state,input,flowTime)
%   statePlus = jumpMap(botObj,time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   botObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "botObj.nStates" x 1 vector.
%
%   input - (? x 1 number)
%       Current input value. Must be a "botObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   statePlus - (? x 1 number)
%       Updated states. A "botObj.nStates" x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   30-AUG-2011 by Rowland O'Flaherty
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
% assert(isa(botObj,'simulate.bot') && numel(botObj) == 1,...
%     'simulate:bot:jumpMap:botObj',...
%     'Input argument "botObj" must be a 1 x 1 simulate.bot object.')
% 
% assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
%     'simulate:bot:jumpMap:time',...
%     'Input argument "time" must be a 1 x 1 real number.')
% 
% assert(isnumeric(state) && isequal(size(state),[botObj.nStates,1]),...
%     'simulate:bot:jumpMap:state',...
%     'Input argument "state" must be a %d x 1 vector of numbers.',botObj.nStates)
% 
% assert(isnumeric(input) && isequal(size(input),[botObj.nInputs,1]),...
%     'simulate:bot:jumpMap:input',...
%     'Input argument "input" must be a %d x 1 vector of numbers.',botObj.nInputs)
% 
% assert(isnumeric(flowTime) && isreal(flowTime) && numel(flowTime) == 1 && flowTime >= 0,...
%     'simulate:bot:jumpMap:flowTime',...
%     'Input argument "flowTime" must be a 1 x 1 semi-positive real number.')
% 
% assert(isnumeric(jumpCount) && isreal(jumpCount) && numel(jumpCount) == 1 && jumpCount >= 0 && mod(jumpCount,1) == 0,...
%     'simulate:bot:jumpMap:jumpCount',...
%     'Input argument "jumpCount" must be a 1 x 1 semi-positive integer.')

%% Parameters


%% Variables

%% Collision walls


%% Updates To Motion


%% Output
statePlus = state;
end

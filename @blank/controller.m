function input = controller(blankObj,time,state,input,flowTime,jumpCount)
% The "controller" method will produce input values given the current
% time and state of the system.
%
% SYNTAX:
%   input = blankObj.controller()
%   input = blankObj.controller(time)
%   input = blankObj.controller(time,state)
%   input = blankObj.controller(time,state,input)
%   input = blankObj.controller(time,state,input,flowTime)
%   input = blankObj.controller(time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   blankObj - (1 x 1 simulate.blank)
%       An instance of the "simulate.blank" class.
%
%   time - (1 x 1 real number) [blankObj.time]
%       Current time.
%
%   state - (1 x 1 number) [blankObj.state]
%       Current state.
%
%   input - (1 x 1 number) [blankObj.input]
%       Current input value.
%
%   flowTime - (1 x 1 semi-positive real number) [blankObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [blankObj.jumpCount] 
%       Current jump count value.
%
% OUTPUTS:
%   input - (1 x 1 number)
%       Input values for the system.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate, +simulate
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 21-OCT-2013
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = blankObj.time; end
if nargin < 3, state = blankObj.state; end
if nargin < 4, input = blankObj.input; end
if nargin < 5, flowTime = blankObj.flowTime; end
if nargin < 6, jumpCount = blankObj.jumpCount; end

%% Parameters


%% Variables


%% Controller Definition


%% Set input
input = zeros(blankObj.nInputs,1);


end
function [statePlus,timePlus,setPriority] = jumpMap(blankObj,time,state,input,flowTime,jumpCount)
% The "jumpMap" method sets the discrete time dynamics of the system.
%
% SYNTAX:
%   [statePlus,timePlus,setPriority] = blankObj.jumpMap()
%   [statePlus,timePlus,setPriority] = blankObj.jumpMap(time)
%   [statePlus,timePlus,setPriority] = blankObj.jumpMap(time,state)
%   [statePlus,timePlus,setPriority] = blankObj.jumpMap(time,state,input)
%   [statePlus,timePlus,setPriority] = blankObj.jumpMap(time,state,input,flowTime)
%   [statePlus,timePlus,setPriority] = blankObj.jumpMap(time,state,input,flowTime,jumpCount)
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
%   statePlus - (1 x 1 number)
%       Updated states.
%
%   timePlus - (1 x 1 real number)
%       Updated time.
%
%   setPriority - ('flow','jump', or 'random')
%       Sets the priority to what takes place if the state is in both
%       the flow set and the jump set.
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
%   Created 27-OCT-2013
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = blankObj.time; end
if nargin < 3, state = blankObj.state; end
if nargin < 4, input = blankObj.input; end
if nargin < 5, flowTime = blankObj.flowTime; end
if nargin < 6, jumpCount = blankObj.jumpCount; end
timePlus = time;
setPriority = blankObj.setPriority;

%% Parameters


%% Variables


%% Updates Of Motion


%% Output
statePlus = state;

end

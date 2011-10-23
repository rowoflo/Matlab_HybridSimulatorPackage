function [statePlus,timePlus,setPriority] = jumpMap(pendulumObj,time,state,input,flowTime,jumpCount)
% The "jumpMap" method sets the discrete time dynamics of the system.
%
% SYNTAX:
%   [statePlus,timePlus,setPriority] = jumpMap(pendulumObj,time,state,input)
%   [statePlus,timePlus,setPriority] = jumpMap(pendulumObj,time,state,input,flowTime)
%   [statePlus,timePlus,setPriority] = jumpMap(pendulumObj,time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.pendulum)
%       An instance of the "simulate.pendulum" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "pendulumObj.nStates" x 1 vector.
%
%   input - (? x 1 number)
%       Current input value. Must be a "pendulumObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   statePlus - (? x 1 number)
%       Updated states. A "pendulumObj.nStates" x 1 vector.
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
%   Created 23-OCT-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 5, flowTime = 0; end
if nargin < 6, jumpCount = 0; end
timePlus = time;
setPriority = pendulumObj.setPriority;

%% Parameters


%% Variables


%% Updates Of Motion


%% Output
statePlus = state;

end

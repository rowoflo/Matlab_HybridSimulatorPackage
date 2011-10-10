function statePlus = jumpMap(pendulumObj,time,state,input,flowTime,jumpCount)
% The "jumpMap" method sets the discrete time dynamics of the system.
%
% SYNTAX:
%   statePlus = jumpMap(pendulumObj,time,state,input)
%   statePlus = jumpMap(pendulumObj,time,state,input,flowTime)
%   statePlus = jumpMap(pendulumObj,time,state,input,flowTime,jumpCount)
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
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate, +simulate
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 01-OCT-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 5, flowTime = 0; end
if nargin < 6, jumpCount = 0; end

%% Parameters


%% Variables


%% Updates To Motion


%% Output
statePlus = state;

end

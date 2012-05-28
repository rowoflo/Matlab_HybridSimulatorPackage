function input = controller(pendulumObj,time,state,flowTime,jumpCount)
% The "controller" method will produce input values given the current
% time and state of the system.
%
% SYNTAX:
%   input = controller(pendulumObj,time,state)
%   input = controller(pendulumObj,time,state,flowTime)
%   input = controller(pendulumObj,time,state,flowTime,jumpCount)
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
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   input - (? x 1 number)
%       Input values for the system. A "pendulumObj.nInputs" x 1 vector.
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
if nargin < 4, flowTime = 0; end
if nargin < 5, jumpCount = 0; end

%% Parameters


%% Variables


%% Controller Definition


%% Set input
input = zeros(pendulumObj.nInputs,1);


end

function stateDot = flowMap(SYSTEM_NAMEObj,time,state,input,flowTime,jumpCount)
% The "flowMap" method sets the continuous time dynamics of the system.
%
% SYNTAX:
%   stateDot = flowMap(SYSTEM_NAMEObj,time,state,input)
%   stateDot = flowMap(SYSTEM_NAMEObj,time,state,input,flowTime)
%   stateDot = flowMap(SYSTEM_NAMEObj,time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 simulate.SYSTEM_NAME)
%       An instance of the "simulate.SYSTEM_NAME" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "SYSTEM_NAMEObj.nStates" x 1 vector.
%
%   input - (? x 1 number)
%       Current input value. Must be a "SYSTEM_NAMEObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   stateDot - (? x 1 number)
%       Updated state derivatives. A "SYSTEM_NAMEObj.nStates" x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   DD-MMM-YYYY by FULL_NAME
%
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 5, flowTime = 0; end
if nargin < 6, jumpCount = 0; end

%% Parameters


%% Variables


%% Equations Of Motion


%% Output
stateDot(:,1) = zeros(SYSTEM_NAMEObj.nStates);

end

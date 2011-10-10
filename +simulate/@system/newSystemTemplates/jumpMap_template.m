function statePlus = jumpMap(SYSTEM_NAMEObj,time,state,input,flowTime,jumpCount)
% The "jumpMap" method sets the discrete time dynamics of the system.
%
% SYNTAX:
%   statePlus = jumpMap(SYSTEM_NAMEObj,time,state,input)
%   statePlus = jumpMap(SYSTEM_NAMEObj,time,state,input,flowTime)
%   statePlus = jumpMap(SYSTEM_NAMEObj,time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
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
%   statePlus - (? x 1 number)
%       Updated states. A "SYSTEM_NAMEObj.nStates" x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   NECESSARY_PACKAGE+simulate
%
% AUTHOR:
%    FULL_NAME
%
% VERSION: 
%   Created DD-MMM-YYYY
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

function input = controller(SYSTEM_NAMEObj,time,state,flowTime,jumpCount)
% The "controller" method will produce input values given the current
% time and state of the system.
%
% SYNTAX:
%   input = controller(SYSTEM_NAMEObj,time,state)
%   input = controller(SYSTEM_NAMEObj,time,state,flowTime)
%   input = controller(SYSTEM_NAMEObj,time,state,flowTime,jumpCount)
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
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   input - (? x 1 number)
%       Input values for the system. A "SYSTEM_NAMEObj.nInputs" x 1 vector.
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
if nargin < 4, flowTime = 0; end
if nargin < 5, jumpCount = 0; end

%% Parameters


%% Variables


%% Controller Definition


%% Set input
input = zeros(SYSTEM_NAMEObj.nInputs,1);


end

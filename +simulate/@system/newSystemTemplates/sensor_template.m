function output = sensor(SYSTEM_NAMEObj,time,state,flowTime,jumpCount)
% The "sensor" method will produce output values given the current
% time and state of the system.
%
% SYNTAX:
%   output = SYSTEM_NAMEObj.sensor(time,state)
%   output = SYSTEM_NAMEObj.sensor(time,state,flowTime)
%   output = SYSTEM_NAMEObj.sensor(time,state,flowTime,jumpCount)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 real number)
%       Current state. Must be a "SYSTEM_NAMEObj.nStates" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   output - (? x 1 number)
%       Output values for the plant. A "SYSTEM_NAMEObj.nOutputs" x 1 vector.
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


%% Sensor Definition


%% Set output
output = zeros(SYSTEM_NAMEObj.nOutputs,1);

end

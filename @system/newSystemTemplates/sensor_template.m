function output = sensor(SYSTEM_NAMEObj,time,state,input,flowTime,jumpCount)
% The "sensor" method will produce output values given the current
% time and state of the system.
%
% SYNTAX:
%   output = SYSTEM_NAMEObj.sensor()
%   output = SYSTEM_NAMEObj.sensor(time)
%   output = SYSTEM_NAMEObj.sensor(time,state)
%   output = SYSTEM_NAMEObj.sensor(time,state,input)
%   output = SYSTEM_NAMEObj.sensor(time,state,input,flowTime)    
%   output = SYSTEM_NAMEObj.sensor(time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%
%   time - (1 x 1 real number) [SYSTEM_NAMEObj.time]
%       Current time.
%
%   state - (NSTATES x 1 number) [SYSTEM_NAMEObj.state]
%       Current state. Must be a "SYSTEM_NAMEObj.nStates" x 1 vector.
%
%   input - (NINPUTS x 1 number) [SYSTEM_NAMEObj.input]
%       Current input value. Must be a "SYSTEM_NAMEObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [SYSTEM_NAMEObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [SYSTEM_NAMEObj.jumpCount] 
%       Current jump count value.
%
% OUTPUTS:
%   output - (NOUTPUTS x 1 number)
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
if nargin < 2, time = SYSTEM_NAMEObj.time; end
if nargin < 3, state = SYSTEM_NAMEObj.state; end
if nargin < 4, input = SYSTEM_NAMEObj.input; end
if nargin < 5, flowTime = SYSTEM_NAMEObj.flowTime; end
if nargin < 6, jumpCount = SYSTEM_NAMEObj.jumpCount; end

%% Parameters


%% Variables


%% Sensor Definition


%% Set output
output = zeros(SYSTEM_NAMEObj.nOutputs,1);

end

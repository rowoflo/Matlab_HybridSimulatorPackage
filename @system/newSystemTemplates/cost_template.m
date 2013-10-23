function instantaneousCost = cost(SYSTEM_NAMEObj,time,state,input,output,flowtime,jumpCount)
% The "cost" method will produce cost values given the current
% time and state of the system.
%
% SYNTAX:
%   instantaneousCost = pendulumObj.cost(time)
%   instantaneousCost = pendulumObj.cost(time,state)
%   instantaneousCost = pendulumObj.cost(time,state,input)
%   instantaneousCost = pendulumObj.cost(time,state,input,output)
%   instantaneousCost = pendulumObj.cost(time,state,input,output,flowtime)
%   instantaneousCost = pendulumObj.cost(time,state,input,output,flowtime,jumpCount)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number) [SYSTEM_NAMEObj.time]
%       Current time.
%
%   state - (NSTATES x 1 number) [SYSTEM_NAMEObj.state]
%       Current state.
%
%   input - (NINPUTS x 1 number) [SYSTEM_NAMEObj.input]
%       Current input value.
%
%   output - (NOUTPUTS x 1 number) [SYSTEM_NAMEObj.output]
%       Output values for the plant.
%
%   flowTime - (1 x 1 semi-positive real number) [SYSTEM_NAMEObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [SYSTEM_NAMEObj.jumpCount]
%       Current jump count value.
%
% OUTPUTS:
%   instantaneousCost - (NCOSTS x 1 real number)
%       Instantaneous cost values for the system.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
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
if nargin < 5, output = SYSTEM_NAMEObj.output; end
if nargin < 6, flowTime = SYSTEM_NAMEObj.flowTime; end
if nargin < 7, jumpCount = SYSTEM_NAMEObj.jumpCount; end


%% Parameters


%% Variables


%% Observer Definition


%% Set output
instantaneousCost = zeros(SYSTEM_NAMEObj.nCosts,1);

end

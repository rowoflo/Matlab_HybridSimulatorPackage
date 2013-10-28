function instantaneousCost = cost(pendulumObj,time,state,input,output,flowTime,jumpCount,...
    timeBar,stateBar,inputBar,outputBar) %#ok<INUSL,INUSD>
% The "cost" method will produce cost values given the current time and
% state of the system.
%
% SYNTAX:
%   instantaneousCost = pendulumObj.cost(time)
%   ...
%   instantaneousCost = pendulumObj.cost(time,state,input,output,flowTime,jumpCount,...
%       timeBar,stateBar,inputBar,outputBar)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number) [pendulumObj.time]
%       Current time.
%
%   state - (nStates x 1 number) [pendulumObj.state]
%       Current state.
%
%   input - (nInputs x 1 number) [pendulumObj.input]
%       Current input value.
%
%   output - (nOuputs x 1 number) [pendulumObj.output]
%       Output values for the plant.
%
%   flowTime - (1 x 1 semi-positive real number) [pendulumObj.flowTime]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [pendulumObj.jumpCount]
%       Current jump count value.
%
%   timeBar - (1 x 1 real number) [pendulumObj.time]
%       Reference time value.
%
%   stateBar - (NSTATES x 1 number) [pendulumObj.state]
%       Reference state value
%
%   inputBar - (NINPUTS x 1 number) [pendulumObj.input]
%       Reference input value.
%
%   outputBar - (NOUTPUTS x 1 number) [pendulumObj.output]
%       Reference output value.
%
% OUTPUTS:
%   instantaneousCost - (1 x 1 real number)
%       Instantaneous cost values for the system.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 23-OCT-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, time = pendulumObj.time; end
if nargin < 3, state = pendulumObj.state; end
if nargin < 4, input = pendulumObj.input; end
if nargin < 5, output = pendulumObj.output; end
if nargin < 6, flowTime = pendulumObj.flowTime; end
if nargin < 7, jumpCount = pendulumObj.jumpCount; end


%% Parameters


%% Variables


%% Observer Definition


%% Set output
instantaneousCost = 1/2*(state'*state+input'*input);

end

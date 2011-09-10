function input = controller(pendulumObj,time,state,~,~)
% The "controller" method will produce input values given the current
% time and state of the system.
%
% SYNTAX:
%   input = pendulumObj.controller(time,state)
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
% OUTPUTS:
%   input - (? x 1 number)
%       Input values for the plant. A "pendulumObj.nInputs"  x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   18-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments
% 
% Check number of arguments
% error(nargchk(3,5,nargin))
% 
% % Check arguments for errors
% assert(isa(pendulumObj,'simulate.pendulum') && numel(pendulumObj) == 1,...
%     'simulate:pendulum:controller:pendulumObj',...
%     'Input argument "pendulumObj" must be a 1 x 1 simulate.pendulum object.')
% 
% assert(isnumeric(time) && isreal(time) && isequal(size(time),[1,1]),...
%     'simulate:pendulum:controller:time',...
%     'Input argument "time" must be a 1 x 1 real numbers.')
% 
% assert(isnumeric(state) && isequal(size(state),[pendulumObj.nStates,1]),...
%     'simulate:pendulum:controller:state',...
%     'Input argument "state" must be a %d x 1 vector of numbers.',pendulumObj.nStates)

%% Parameters

%% Variables
x = state;

%% Controller
switch lower(pendulumObj.controllerType)
    case lower('None')
        u = 0;
        
    case lower('LQR')
        K = pendulumObj.K;
        xOP = pendulumObj.stateOP;
        uOP = pendulumObj.inputOP;
        u = -K*(x - xOP) + uOP;
        
    case lower('openloop')
        timeIndex = find(time >= pendulumObj.openLoopTimeTape,1,'last');
        u = pendulumObj.openLoopInputTape(:,timeIndex);
        
    otherwise
        error('simulate:pendulum:controller:controllerType',...
            'Unknown coontroller type: %s.',pendulumObj.controllerType)
end

%% Set input
input = min(max(u,pendulumObj.torqueLimits(1)),pendulumObj.torqueLimits(2));

end

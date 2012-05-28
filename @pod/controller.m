function input = controller(podObj,time,state,~,jumpCount)
% The "controller" method will produce input values given the current
% time and state of the system.
%
% SYNTAX:
%   input = controller(podObj,time,state)
%   input = controller(podObj,time,state,input,flowTime)
%   input = controller(podObj,time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   podObj - (1 x 1 simulate.pod)
%       An instance of the "simulate.pod" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "podObj.nStates" q 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   input - (? x 1 number)
%       Input values for the plant. A "podObj.nInputs"  q 1 vector.
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
% error(nargchk(4,6,nargin))
% 
% Apply default values
% if nargin < 5, flowTime = 0; end
% if nargin < 6, jumpCount = 0; end
% 
% Check arguments for errors
% assert(isa(podObj,'simulate.pod') && numel(podObj) == 1,...
%     'simulate:pod:controller:podObj',...
%     'Input argument "podObj" must be a 1 q 1 simulate.pod object.')
% 
% assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
%     'simulate:pod:controller:time',...
%     'Input argument "time" must be a 1 q 1 real number.')
% 
% assert(isnumeric(state) && isequal(size(state),[podObj.nStates,1]),...
%     'simulate:pod:controller:state',...
%     'Input argument "state" must be a %d q 1 vector of numbers.',podObj.nStates)
% 
% assert(isnumeric(input) && isequal(size(input),[podObj.nInputs,1]),...
%     'simulate:pod:controller:input',...
%     'Input argument "input" must be a %d q 1 vector of numbers.',podObj.nInputs)
% 
% assert(isnumeric(flowTime) && isreal(flowTime) && numel(flowTime) == 1 && flowTime >= 0,...
%     'simulate:pod:controller:flowTime',...
%     'Input argument "flowTime" must be a 1 q 1 semi-positive real number.')
% 
% assert(isnumeric(jumpCount) && isreal(jumpCount) && numel(jumpCount) == 1 && jumpCount >= 0 && mod(jumpCount,1) == 0,...
%     'simulate:pod:controller:jumpCount',...
%     'Input argument "jumpCount" must be a 1 q 1 semi-positive integer.')


%% Parameters

%% Variables
q = state;

%% Controller
switch lower(podObj.controllerType)
    case lower('None')
        u = zeros(2,1);
        
    case lower('OpenLoop')
        timeIndex = find(time >= podObj.openLoopTimeTape,1,'last');
        u = podObj.openLoopInputTape(:,timeIndex);
        
    case lower('LQR')
        xOP = podObj.stateOP;
        uOP = podObj.inputOP;
        K = podObj.K;
        u = -K*(q - xOP) + uOP;

    case {lower('HybridLQR'),lower('HybridLQRWithBounce')}
        if strcmpi(podObj.controllerType,'HybridLQRWithBounce')
            if jumpCount < 1
                qOP = podObj.waypointReflectionState;
            else
                qOP = podObj.waypointState;
            end
        else
            qOP = podObj.stateOP;
        end
        qTilda = q - qOP;
        theta = q(3);
        dx = q(4);
        dy = q(5);
        
        velDirection = atan2(dy,dx);
        velHeading = wrapToPi(theta - velDirection);
        
        goalDirection = atan2(-qTilda(2),-qTilda(1));
        goalHeading = wrapToPi(theta - goalDirection);
        
        inGoalArea = all(abs(qTilda(1:2)) <= podObj.goalSize(1:2));
        inGoalVel = all(abs(qTilda(4:5)) <= podObj.goalSize(4:5));
        inGoalHeading = abs(goalHeading) <= podObj.goalSize(3);
        inGoalMovingDir = abs(wrapToPi(goalDirection - velDirection)) <= podObj.goalSize(3);
        
        if ~inGoalArea
            if ~inGoalVel
                if ~inGoalMovingDir && ~inGoalHeading
                    controllerMode = 'stop';
                    thetaTilda = velHeading;
                else
                    if ~inGoalHeading
                        controllerMode = 'coast';
                        thetaTilda = velHeading;
                    else
                        controllerMode = 'move';
                        thetaTilda = goalHeading;
                    end
                end
            else
                if ~inGoalHeading
                    controllerMode = 'turn';
                    thetaTilda = goalHeading;
                else
                    controllerMode = 'move';
                    thetaTilda = goalHeading;
                end
            end
        else
            if ~inGoalVel
                controllerMode = 'stop';
                thetaTilda = velHeading;
            else
                controllerMode = 'turn';
                thetaTilda = qTilda(3);
            end
        end
        
        switch lower(controllerMode)
            case 'stop'
                % Rotation (Align with forward direction)
                Kr = podObj.Kr;
                ur = -Kr*[thetaTilda;qTilda(6)];
                
                % Thrust (Lose forward energy)
                Ke = podObj.Ke;
                m = podObj.m;
                h = [cos(theta);sin(theta)];
                dh = h'*q(4:5);
                eh = 1/2*m*dh^2;
                uf = -Ke*dh*eh;
                
            case 'turn'
                % Rotation (Align with direction to goal)
                Kr = podObj.Kr;
                ur = -Kr*[thetaTilda;qTilda(6)];
                
                % Thrust (Do nothing)
                uf = 0;
                
            case 'move'
                % Rotation (Align with direction to goal)
                Kr = podObj.Kr;
                ur = -Kr*[thetaTilda;qTilda(6)];
                
                % Thrust (Move towards goal)
                Kf = podObj.Kf;
                h = [cos(theta);sin(theta)];
                d = qTilda(1:2)'*h;
                dd = q(4:5)'*h;
                uf = -Kf*[d;dd];
                
            case 'coast'
                % Rotation (Align with forward direction)
                Kr = podObj.Kr;
                ur = -Kr*[thetaTilda;qTilda(6)];
                
                % Thrust (Do nothing)
                uf = 0;
                
            case 'nothing'
                % Rotation (Do nothing)
                ur = 0;
                
                % Thrust (Do nothing)
                uf = 0;
                
        end
        
        u = [uf;ur];
        
    otherwise
      error('simulate:pod:controller:controllerSelect',...
          'Unknown controller select: %s',podObj.controllerSelect)
end

%% Set input
input = min(max(u,podObj.forceLimits(:,1)),podObj.forceLimits(:,2));

end

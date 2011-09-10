classdef pod < simulate.system
% The "simulate.pod" class models the dynmaics of a pod on ice.
%
% NOTES:
%   To get more information on this class type "doc simulate.pod" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   18-APR-2011 by Rowland O'Flaherty
%
% SEE ALSO:
%    simulate.system | simulate.pendulum
%
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (SetAccess = private) % Superclass Abstract Properties
    type = 'pod' % (string) Type of system.
end

properties (Access = public) % Superclass Abstract Properties    
    localMap % (1 x 1 simulate.map) The local map of the walls for the pod system.
    localMapGraphicsHandle % (1 x 1 graphics handle) Handle to local  map graphics object.
    localMapGraphicsProperties = {}; % (1 x ? cell array) Local map graphics properties to be applied to the sketch method. (e.g. {'FontWeight','bold'})
       
end    

properties (SetAccess = private)
    I % (1 x 1 real positive number) Moment of inertia of the pod.
    m % (1 x 1 real positive number) Mass of the pod.
    r % (1 x 1 real positive number) Radius of the pod.
    rho = .9 % (1 x 1 real positive number) Restitution coefficient of the pod.  
end

properties (Access = public)
    forceLimits = [-inf,inf;-inf,inf]; % (2 x 2 real number) Force limits on system. Must be in [min max] format. The rows correspond to the states.
    controllerType = 'None'; % (string) Type of controller to use. Must be of the set defined in the controller method.
    
    % General
    goalState % (6 x 1 real number) The state the system is trying to reach.
    waypointState % (6 x 1 real number) Intermediate state the system is trying to reach on the way to the goal.
    waypointReflectionState  % (6 x 1 real number) Intermediate reflection state the system is trying to reach on the way to the goal.
    stateOP = zeros(6,1) %(6 x 1 real number) State operating point.
    inputOP = zeros(2,1); % (2 x 1 real number) Input operating point.
    goalSize = zeros(6,1) % (6 x 1 positive real number) Goal size for each state.
    
    % Open-loop controller
    openLoopTimeTape = []; % (1 x ? real number) Open-loop control time tape.
    openLoopInputTape = []; % (1 x ? real number) Open-loop control input tape.
    
    % LQR controller
    Q = eye(6); % (6 x 6 real number) State weight.
    R = eye(2); % (2 x 2 real number) Input weight.
    K = zeros(6,2); % (6 x 2 real number) LQR controller state-feedback gains.
    S = zeros(6); % (6 x 6 real number) Solution to Riccati equation.
    
    % Hybrid LQR controller
    Qf % (2 x 2 real number) State weight for forward thrust.
    Rf % (1 x 1 real number) Input weight for forward thrust.
    Kf % (1 x 2 real number) LQR controller state-feedback gains for forward thrust.
    Sf % (2 x 2 real number) Solution to Riccati equation for forward thrust.
    
    Qr % (2 x 2 real number) State weight for rotation.
    Rr % (1 x 1 real number) Input weight for rotation.
    Kr % (1 x 2 real number) LQR controller state-feedback gains for rotation.
    Sr % (2 x 2 real number) Solution to Riccati equation for rotation.
    
    Ke % (1 x 1 real number) State-feedback gain for energy.
    
end

%% Constructor -----------------------------------------------------------------
methods
    function podObj = pod(I,m,r,localMap,t0,x0,dt)
        % Constructor function for the "pod" class.
        %
        % SYNTAX:
        %   podObj = pod(I,m,r,localMap,t0,x0,dt)
        %
        % INPUTS:
        %   I - (1 x 1 real positive number) [1]
        %       Sets the "podObj.I" property.
        %
        %   m - (1 x 1 real positive number) [1] 
        %       Sets the "podObj.m" property.
        %
        %   r - (1 x 1 real positive number) [1] 
        %       Sets the "podObj.r" property.
        %
        %   localMap - (1 x 1 simulate.map) [simulate.map]
        %       Sets the "podObj.localMap" property.
        %
        %   t0 - (1 x 1 real number) [0]
        %       Initializes the system time.
        %
        %   x0 - (6 x 1 number) [zeros(6,1)]
        %       Initializes the system state.
        %
        %   dt - (1 x 1 positive real number) [0.1]
        %       Sets the "podObj.timeStep" property.
        %
        % OUTPUTS:
        %   podObj - (1 x 1 pod object) 
        %       A new instance of the "simulate.pod" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        error(nargchk(0,7,nargin))
        
        % Apply default values
        if nargin < 1, I = 1; end
        if nargin < 2, m = 1; end
        if nargin < 3, r = 1; end
        if nargin < 4, localMap = simulate.map; end
        if nargin < 5, t0 = 0; end
        if nargin < 6, x0 = zeros(6,1); end
        if nargin < 7, dt = 0.1; end
        

        % Check input arguments for errors
        assert(isnumeric(I) && isreal(I) && isequal(size(I),[1,1]) && I > 0,...
            'simulate:pod:I',...
            'Input argument "I" must be a 1 x 1 positive real number.')
        
        assert(isnumeric(m) && isreal(m) && isequal(size(m),[1,1]) && m > 0,...
            'simulate:pod:m',...
            'Input argument "m" must be a 1 x 1 positive real number.')
        
        assert(isnumeric(r) && isreal(r) && isequal(size(r),[1,1]) && r > 0,...
            'simulate:pod:r',...
            'Input argument "r" must be a 1 x 1 positive real number.')
        
        assert(isa(localMap,'simulate.map') && numel(localMap) == 1,...
            'simulate:pod:localMap',...
            'Input argument "localMap" must be a 1 x 1 simulate.map object.')
        
        assert(isnumeric(x0) && isreal(x0) && length(x0) == 6,...
            'simulate:pod:x0',...
            'Input argument "x0" must be a 6 x 1 vector of real numbers.')
        
        % Initialize Superclass
        nInputs = 2;
        nOutputs = 6;
        podObj = podObj@simulate.system(dt,t0,x0,nInputs,nOutputs);
        
        % Assign properties
        podObj.I = I;
        podObj.m = m;
        podObj.r = r;
        podObj.localMap = localMap;
        podObj.sketchFlag = true;
        
        podObj.name = 'Pod';
        podObj.stateNames = {'x';'y';'theta';'dx';'dy';'dtheta'};
        podObj.inputNames = {'forward';'rotate'};
        podObj.outputNames = {'x';'y';'theta';'dx';'dy';'dtheta'};
        podObj.phaseStatePairs = [1 4;2 5;3 6];
    end
end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
methods
%     function podObj = set.prop1(podObj,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %   podObj.prop1 = prop1
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[1,1]),...
%             'simulate:pod:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         podObj.prop1 = prop1;
%     end
%
%     function prop1 = get.prop1(podObj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %	  prop1 = podObj.prop1
%         %
%         % NOTES:
%         %
%         %---------------------------------------------------------------------
% 
%         prop1 = podObj.prop1;
%     end
end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
% methods (AttributeName = value)
%     function podObj = method_name(podObj,arg1)
%         % The "method_name" method ...
%         %
%         % SYNTAX:
%         %   podObj = podObj.method_name(arg1)
%         %
%         % INPUTS:
%         %   podObj - (1 x 1 simulate.pod)
%         %       An instance of the "simulate.pod" class.
%         %
%         %   arg1 - (size type) [default ???] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   podObj - (1 x 1 simulate.pod)
%         %       An instance of the "simulate.pod" class ... 
%         %
%         % NOTES:
%         %
%         %---------------------------------------------------------------------
% 
%         % Check number of arguments
%         error(nargchk(1,2,nargin))
%         
%         % Apply default values
%         if nargin < 2, arg1 = 0; end
%         
%         % Check arguments for errors
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
%             'simulate:pod:method_name:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
%     
% end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public) % Superclass Abstract Methods
    stateDot = flowMap(podObj,time,state,input,flowTime,jumpCount)
    statePlus = jumpMap(podObj,time,state,input,flowTime,jumpCount)
    flowState = flowSet(podObj,time,state,flowTime,jumpCount)
    jumpState = jumpSet(podObj,time,state,flowTime,jumpCount)
    
    input = controller(podObj,time,state,flowTime,jumpCount)
    output = observer(podObj,time,state,input,flowTime,jumpCount)
    [A,B,C,D] = jacobian(podObj,stateOP,inputOP)
    sketchGraphics(podObj,time,state,varargin)
    
    [route,policy] = solveMap(podObj,initialState,goalState,varargin)
end
%-------------------------------------------------------------------------------
    
end

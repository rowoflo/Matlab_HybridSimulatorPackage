classdef pendulum < simulate.system
% The "simulate.pendulum" class models the dynamics of a simple pendulum.
%
% NOTES:
%   To get more information on this class type "doc simulate.pendulum" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   17-APR-2011 by Rowland O'Flaherty
%
% SEE ALSO:
%    simulate.system | simulate.puck
%
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (SetAccess = private) % Superclass Abstract Properties
    type = 'pendulum' % (string) Type of system.
end

properties (Access = public) % Superclass Abstract Properties
    name = 'Pendulum'; % (string) Name of them pendulum.
    stateNames = {'theta';'dTheta'} % (? x 1 cell array of strings) Names of the state variables.
    inputNames = {'torque'}; % (? x 1 cell array of strings) Names of the input variables.
    outputNames = {'theta';'dTheta'} % (? x 1 cell array of strings) Names of the output variables.
    phaseStatePairs = [1 2]; % (? x 2 positive integer) State pairs for the phase plot. One pair per row of the matrix. The first column is the x-axis and the second column is the y-axis.
end

properties (SetAccess = private) % Pendulum system parameters
    l % (1 x 1 real positive number) Length of the pendulum.
    m % (1 x 1 real positive number) Mass of the pendulum.
    b % (1 x 1 real semi-positive number) Damping of the pendulum.
    w = .05; % (1 x 1 real positive number) Width of the pendulum.
    g = 9.8; % (1 x 1 real number) Gravity for the pendulum.
end

properties (Access = public) % Pendulum controller parameters
    torqueLimits = [-inf,inf]; % (1 x 2 real number) Torque limits on system. Must be in [min max] format.
    controllerType = 'None'; % (string) Type of controller to use. Must be of the set defined in the controller method.
    
    % LQR controller
    Q = eye(2); % (2 x 2 real number) Process gain.
    R = 10*eye(1); % (2 x 2 real number) Measurement gain.
    K = [0 0]; % (1 x 2 real number) LQR controller state-feedback gains.
    S = zeros(2); % (2 x 2 real number) Solution to Riccati equation.
    stateOP = [0;0] %(2 x 1 real number) State operating point.
    inputOP = 0; % (1 x 1 real number) Input operating point.
    
    % Open-loop controller
    openLoopTimeTape = []; % (1 x ? real number) Open-loop control time tape.
    openLoopInputTape = []; % (1 x ? real number) Open-loop control input tape.
end

%% Constructor -----------------------------------------------------------------
methods
    function pendulumObj = pendulum(l,m,b,t0,x0,dt)
        % Constructor function for the "pendulum" class.
        %
        % SYNTAX:
        %   pendulumObj = pendulum(l,m,b,t0,x0)
        %
        % INPUTS:
        %   l - (1 x 1 real positive number) [1] 
        %       Sets the "pendulumObj.l" property.
        %
        %   m - (1 x 1 real positive number) [1] 
        %       Sets the "pendulumObj.m" property.
        %
        %   b - (1 x 1 real semi-positive number) [1] 
        %       Sets the "pendulumObj.b" property.
        %
        %   t0 - (1 x 1 real number) [0]
        %       Initializes the system time.
        %
        %   x0 - (2 x 1 number) [[0;0]]
        %       Initializes the system state.
        %
        %   dt - (1 x 1 positive real number) [0.1]
        %       Sets the "pendulumObj.timeStep" property.
        %
        % OUTPUTS:
        %   pendulumObj - (1 x 1 pendulum object) 
        %       A new instance of the "simulate.pendulum" class.
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        
        % Check number of arguments
        error(nargchk(0,6,nargin))
        
        % Apply default values
        if nargin < 1, l = 1; end
        if nargin < 2, m = 1; end
        if nargin < 3, b = 1; end
        if nargin < 4, t0 = 0; end
        if nargin < 5, x0 = [0;0]; end
        if nargin < 6, dt = 0.1; end
        
        % Check input arguments for errors
        assert(isnumeric(l) && isreal(l) && isequal(size(l),[1,1]) && l > 0,...
            'simulate:pendulum:l',...
            'Input argument "l" must be a 1 x 1 real positive number.')
        
        assert(isnumeric(m) && isreal(m) && isequal(size(m),[1,1]) && m > 0,...
            'simulate:pendulum:m',...
            'Input argument "m" must be a 1 x 1 real positive number.')
        
        assert(isnumeric(b) && isreal(b) && isequal(size(b),[1,1]) && b >= 0,...
            'simulate:pendulum:b',...
            'Input argument "b" must be a 1 x 1 real semi-positive number.')
        
        assert(isnumeric(x0) && isreal(x0) && length(x0) == 2,...
            'simulate:pendulum:x0',...
            'Input argument "x0" must be a 2 x 1 vector of real numbers.')
        
        % Initialize Superclass
        nInputs = 1;
        nOutputs = 2;
        pendulumObj = pendulumObj@simulate.system(dt,t0,x0,nInputs,nOutputs);
        
        
        % Assign properties
        pendulumObj.l = l;
        pendulumObj.m = m;
        pendulumObj.b = b;
        pendulumObj.sketchFlag = true;
        
    end
end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
methods
    function set.name(pendulumObj,name)
        % Overloaded assignment operator function for the "name" property.
        %
        % SYNTAX:
        %   pendulumObj.name = name
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(ischar(name),...
            'simulate:set:name',...
            'Property "name" must be a string.')

        pendulumObj.name = name;
    end
    
    function set.stateNames(pendulumObj,stateNames)
        % Overloaded assignment operator function for the "stateNames" property.
        %
        % SYNTAX:
        %   pendulumObj.stateNames = stateNames
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(iscellstr(stateNames),...
            'simulate:set:stateNames',...
            'Property "stateNames" must be a cell array of strings.')
        stateNames = stateNames(:);

        pendulumObj.stateNames = stateNames;
    end
    
    function set.inputNames(pendulumObj,inputNames)
        % Overloaded assignment operator function for the "inputNames" property.
        %
        % SYNTAX:
        %   pendulumObj.inputNames = inputNames
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(iscellstr(inputNames),...
            'simulate:set:inputNames',...
            'Property "inputNames" must be a cell array of strings.')
        inputNames = inputNames(:);

        pendulumObj.inputNames = inputNames;
    end
    
    function set.phaseStatePairs(pendulumObj,phaseStatePairs)
        % Overloaded assignment operator function for the "phaseStatePairs" property.
        %
        % SYNTAX:
        %   pendulumObj.phaseStatePairs = phaseStatePairs
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(isnumeric(phaseStatePairs) && isreal(phaseStatePairs) && ...
            size(phaseStatePairs,2) == 2 && all(phaseStatePairs(:) > 0) && ...
            all(phaseStatePairs(:) <= pendulumObj.nStates),...
            'simulate:set:phaseStatePairs',...
            'Property "phaseStatePairs" must be ? x 2 matrix of integers between 1 and %d.',pendulumObj.nStates)

        pendulumObj.phaseStatePairs = phaseStatePairs;
    end
    
%     function prop1 = get.prop1(pendulumObj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %	  prop1 = pendulumObj.prop1
%         %
%         % NOTES:
%         %
%         %---------------------------------------------------------------------
% 
%         prop1 = pendulumObj.prop1;
%     end
end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
methods (Access = public)
    function statePlus = jumpMap(pendulumObj,~,state,~,~,~)
        % The "jumpMap" method sets the discrete time dynamics of the pendulum.
        %
        % SYNTAX:
        %   statePlus = pendulumObj.jumpMap([],state)
        %
        % INPUTS:
        %   pendulumObj - (1 x 1 simulate.pendulum)
        %       An instance of the "simulate.pendulum" class.
        %
        %
        %   state - (? x 1 number)
        %       Current state. Must be a "pendulumObj.nStates" x 1 vector.
        %
        %
        % OUTPUTS:
        %   statePlus - (? x 1 number)
        %       Updated states. A "pendulumObj.nStates" x 1 vector.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------

        % Check number of arguments
        error(nargchk(3,inf,nargin))
        
        % Check arguments for errors
        assert(isa(pendulumObj,'simulate.pendulum') && numel(pendulumObj) == 1,...
            'simulate:pendulum:jumpMap:pendulumObj',...
            'Input argument "pendulumObj" must be a 1 x 1 simulate.pendulum object.')

        assert(isnumeric(state) && isequal(size(state),[pendulumObj.nStates,1]),...
            'simulate:pendulum:jumpMap:state',...
            'Input argument "state" must be a %d x 1 vector of numbers.',pendulumObj.nStates)
        
        statePlus = state;
    end
    
    function flowState = flowSet(~,~,~,~,~)
        % The "flowSet" method sets the set where continuous time dynamics take
        % place.
        %
        % SYNTAX:
        %   flowSetValue = pendulumObj.flowSet()
        %
        % INPUTS:
        %
        % OUTPUTS:
        %   flowSetValue - (1 x 1 number)
        %      A value that defining if the pendulum is in the flow set.
        %      Positive values are in the set and negative values are outside
        %      the set.
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        
        flowState = 1;
    end
    
    function jumpState = jumpSet(~,~,~,~,~)
        % The "jumpSet" method sets the set where discrete time dynamics take
        % place.
        %
        % SYNTAX:
        %   jumpSetValue = pendulumObj.jumpSet()
        %
        % INPUTS:
        %
        % OUTPUTS:
        %   jumpSetValue - (1 x 1 number)
        %      A value that defining if the pendulum is in the jump set.
        %      Positive values are in the set and negative values are outside
        %      the set.
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        
        jumpState = 0;
    end
end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public) % Superclass Abstract Methods
    stateDot = flowMap(pendulumObj,time,state,input,flowTime,jumpCount)
    input = controller(pendulumObj,time,state,flowTime,jumpCount)
    output = observer(pendulumObj,time,state,input,flowTime,jumpCount)
    [A,B,C,D] = jacobian(pendulumObj,stateOP,inputOP)
    sketchGraphics(pendulumObj,time,state,varargin)
end
%-------------------------------------------------------------------------------
    
end

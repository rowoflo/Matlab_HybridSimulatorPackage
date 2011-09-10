classdef puck < simulate.system
% The "simulate.puck" class models the dynmaics of a puck on ice.
%
% NOTES:
%   To get more information on this class type "doc simulate.puck" into the
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
    type = 'puck'; % (string) Type of system.
end

properties (Access = public) % Superclass Abstract Properties
    localMap % (1 x 1 simulate.map) The local map of the walls for the puck system.
    localMapGraphicsHandle % (1 x 1 graphics handle) Handle to local  map graphics object.
    localMapGraphicsProperties = {}; % (1 x ? cell array) Local map graphics properties to be applied to the sketch method. (e.g. {'FontWeight','bold'})
       
end    

properties (SetAccess = private)
    m % (1 x 1 real positive number) Mass of the puck.
    r % (1 x 1 real positive number) Radius of the puck.
    rho = .95 % (1 x 1 real positive number) Restitution coefficient of the puck.  
end

properties (Access = public) % Pendulum controller parameters
    forceLimits = [-inf,inf;-inf,inf]; % (2 x 2 real number) Force limits on system. Must be in [min max] format. The rows correspond to the states.
    controllerType = 'None'; % (string) Type of controller to use. Must be of the set defined in the controller method.
    
    % General
    goalState % (4 x 1 real number) The state the system is trying to reach.
    waypointState % (4 x 1 real number) Intermediate state the system is trying to reach on the way to the goal.
    
    % LQR controller
    Q = diag([10 10 1 1]); % (4 x 4 real number) Process gain.
    R = 15*eye(2); % (2 x 2 real number) Input gain.
    K = zeros(2,4); % (4 x 2 real number) LQR controller state-feedback gains.
    S = zeros(4); % (4 x 4 real number) Solution to Riccati equation.
    stateOP = [0;0] %(2 x 1 real number) State operating point.
    inputOP = 0; % (1 x 1 real number) Input operating point.
    goalSize = [0;0;0;0] % (4 x 1 positive real number) Goal size for each state.
    
    % Open-loop controller
    openLoopTimeTape = []; % (1 x ? real number) Open-loop control time tape.
    openLoopInputTape = []; % (1 x ? real number) Open-loop control input tape.
end

%% Constructor -----------------------------------------------------------------
methods
    function puckObj = puck(m,r,localMap,t0,x0,dt)
        % Constructor function for the "puck" class.
        %
        % SYNTAX:
        %   puckObj = puck(m,r,localMap,t0,x0,dt)
        %
        % INPUTS:
        %   m - (1 x 1 real positive number) [1] 
        %       Sets the "puckObj.m" property.
        %
        %   r - (1 x 1 real positive number) [1] 
        %       Sets the "puckObj.r" property.
        %
        %   localMap - (1 x 1 simulate.map) [simulate.map]
        %       Sets the "puckObj.localMap" property.
        %
        %   t0 - (1 x 1 real number) [0]
        %       Initializes the system time.
        %
        %   x0 - (4 x 1 number) [[0;0;0;0]]
        %       Initializes the system state.
        %
        %   dt - (1 x 1 positive real number) [0.1]
        %       Sets the "puckObj.timeStep" property.
        %
        % OUTPUTS:
        %   puckObj - (1 x 1 puck object) 
        %       A new instance of the "simulate.puck" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        error(nargchk(0,6,nargin))
        
        % Apply default values
        if nargin < 1, m = 1; end
        if nargin < 2, r = 1; end
        if nargin < 3, localMap = simulate.map; end
        if nargin < 4, t0 = 0; end
        if nargin < 5, x0 = [0;0;0;0]; end
        if nargin < 6, dt = 0.1; end
        

        % Check input arguments for errors
        assert(isnumeric(m) && isreal(m) && isequal(size(m),[1,1]) && m > 0,...
            'simulate:puck:m',...
            'Input argument "m" must be a 1 x 1 positive real number.')
        
        assert(isnumeric(r) && isreal(r) && isequal(size(r),[1,1]) && r > 0,...
            'simulate:puck:r',...
            'Input argument "r" must be a 1 x 1 positive real number.')
        
        assert(isa(localMap,'simulate.map') && numel(localMap) == 1,...
            'simulate:puck:localMap',...
            'Input argument "localMap" must be a 1 x 1 simulate.map object.')
        
        assert(isnumeric(x0) && isreal(x0) && length(x0) == 4,...
            'simulate:puck:x0',...
            'Input argument "x0" must be a 4 x 1 vector of real numbers.')
        
        % Initialize Superclass
        nInputs = 2;
        nOutputs = 4;
        puckObj = puckObj@simulate.system(dt,t0,x0,nInputs,nOutputs);
        
        % Assign properties
        puckObj.m = m;
        puckObj.r = r;
        puckObj.localMap = localMap;
        puckObj.sketchFlag = true;
        
        puckObj.name = 'Puck';
        puckObj.stateNames = {'x';'y';'dx';'dy'};
        puckObj.inputNames = {'x';'y'};
        puckObj.outputNames = {'x';'y';'dx';'dy'};
        puckObj.phaseStatePairs = [1 3;2 4];
        
    end
end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
methods
%     function puckObj = set.prop1(puckObj,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %   puckObj.prop1 = prop1
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[1,1]),...
%             'simulate:puck:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         puckObj.prop1 = prop1;
%     end
%  
%     function prop1 = get.prop1(puckObj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %	  prop1 = puckObj.prop1
%         %
%         % NOTES:
%         %
%         %---------------------------------------------------------------------
% 
%         prop1 = puckObj.prop1;
%     end
end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
% methods (AttributeName = value)
%     function puckObj = method_name(puckObj,arg1)
%         % The "method_name" method ...
%         %
%         % SYNTAX:
%         %   puckObj = puckObj.method_name(arg1)
%         %
%         % INPUTS:
%         %   puckObj - (1 x 1 simulate.puck)
%         %       An instance of the "simulate.puck" class.
%         %
%         %   arg1 - (size type) [default ???] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   puckObj - (1 x 1 simulate.puck)
%         %       An instance of the "simulate.puck" class ... 
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
%             'simulate:puck:method_name:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
%     
% end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public) % Superclass Abstract Methods
    stateDot = flowMap(puckObj,time,state,input,flowTime,jumpCount)
    statePlus = jumpMap(puckObj,time,state,input,flowTime,jumpCount)
    flowState = flowSet(puckObj,time,state,flowTime,jumpCount)
    jumpState = jumpSet(puckObj,time,state,flowTime,jumpCount)
    
    input = controller(puckObj,time,state,flowTime,jumpCount)
    output = observer(puckObj,time,state,input,flowTime,jumpCount)
    [A,B,C,D] = jacobian(puckObj,stateOP,inputOP)
    sketchGraphics(puckObj,time,state,varargin)
    
    route = solveMap(puckObj,initialState,goalState,varargin)
end
%-------------------------------------------------------------------------------
    
end

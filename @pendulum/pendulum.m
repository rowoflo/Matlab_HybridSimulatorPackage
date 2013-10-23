classdef pendulum < simulate.system
% The "simulate.pendulum" class ... TODO: Add description
%
% NOTES:
%   To get more information on this class type "doc simulate.pendulum" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate, +simulate
%
% SEE ALSO: TODO: Add see alsos
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 23-OCT-2011
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Constant = true, Hidden = true)
    systemVersion = '1.7' % (string) Current version of the super class.
end

properties (SetAccess = private) % Superclass Abstract Properties
    type = 'pendulum' % (string) Type of system.
end

properties (SetAccess = private)
    l % (1 x 1 real positive number) Length of the pendulum.
    m % (1 x 1 real positive number) Mass of the pendulum.
    b % (1 x 1 real semi-positive number) Damping of the pendulum.
    w = .05; % (1 x 1 real positive number) Width of the pendulum.
    g = 9.8; % (1 x 1 real number) Gravity for the pendulum.
end

properties (Access = public)

end

%% Constructor -----------------------------------------------------------------
methods
    function pendulumObj = pendulum(x0,t0,dt,l,m,b)
        % Constructor function for the "pendulum" class.
        %
        % SYNTAX:
        %   pendulumObj = pendulum(x0,t0,dt,l,m,b)
        %
        % INPUTS:
        %   x0 - (2 x 1 number) [zeros(2,1)]
        %       Initializes the system state.
        %
        %   t0 - (1 x 1 real number) [0]
        %       Initializes the system time.
        %
        %   dt - (1 x 1 positive real number) [0.1]
        %       Sets the "pendulumObj.timeStep" property.
        %
        %   l - (1 x 1 real positive number) [1] 
        %       Sets the "pendulumObj.l" property.
        %
        %   m - (1 x 1 real positive number) [1] 
        %       Sets the "pendulumObj.m" property.
        %
        %   b - (1 x 1 real semi-positive number) [1] 
        %       Sets the "pendulumObj.b" property.
        %
        % OUTPUTS:
        %   pendulumObj - (1 x 1 pendulum object) 
        %       A new instance of the "simulate.pendulum" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(0,6)

        % Apply default values
        if nargin < 1, x0 = zeros(2,1); end
        if nargin < 2, t0 = 0; end
        if nargin < 3, dt = 0.1; end
        if nargin < 4, l = 1; end
        if nargin < 5, m = 1; end
        if nargin < 6, b = 1; end
        
        % Check input arguments for errors
        assert(isnumeric(x0) && isreal(x0) && length(x0) == 2,...
            'simulate:pendulum:x0',...
            'Input argument "x0" must be a 2 x 1 vector of real numbers.')
        
        assert(isnumeric(t0) && isreal(t0) && length(t0) == 1,...
            'simulate:pendulum:t0',...
            'Input argument "t0" must be a 1 x 1 real number.')
        
        assert(isnumeric(dt) && isreal(dt) && length(dt) == 1 && dt > 0,...
            'simulate:pendulum:dt',...
            'Input argument "dt" must be a 1 x 1 positive real number.')
        
        assert(isnumeric(l) && isreal(l) && isequal(size(l),[1,1]) && l > 0,...
            'simulate:pendulum:l',...
            'Input argument "l" must be a 1 x 1 real positive number.')
        
        assert(isnumeric(m) && isreal(m) && isequal(size(m),[1,1]) && m > 0,...
            'simulate:pendulum:m',...
            'Input argument "m" must be a 1 x 1 real positive number.')
        
        assert(isnumeric(b) && isreal(b) && isequal(size(b),[1,1]) && b >= 0,...
            'simulate:pendulum:b',...
            'Input argument "b" must be a 1 x 1 real semi-positive number.')
        
        % Initialize Superclass
        nInputs = 1;
        nOutputs = 2;
        pendulumObj = pendulumObj@simulate.system(dt,t0,x0,0,nInputs,nOutputs);
        
        % Check class compatibility with super class
        assert(strcmp(pendulumObj.systemVersion,simulate.system.currentVersion),...
            'simulate:pendulum:version',...
            ['The simulate.system class has been updated to version %s ',... 
            'and the pendulum class is only compatible with version %s.'],...
            simulate.system.currentVersion,pendulumObj.systemVersion)
        
        % Assign properties
        pendulumObj.name = 'Pendulum';
        pendulumObj.stateNames = {'theta'; 'thetaDot'};
        pendulumObj.inputNames = {'torque'};
        pendulumObj.outputNames = {'theta'; 'thetaDot'};
        pendulumObj.phaseStatePairs = [1  2];
        pendulumObj.l = l;
        pendulumObj.m = m;
        pendulumObj.b = b;
        pendulumObj.plotSketchFlag = true;
        
    end
end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
% methods
%     function pendulumObj = set.prop1(pendulumObj,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %   pendulumObj.prop1 = prop1
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[1,1]),...
%             'simulate:pendulum:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         pendulumObj.prop1 = prop1;
%     end
%     
%     function prop1 = get.prop1(pendulumObj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %	  prop1 = pendulumObj.prop1
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         prop1 = pendulumObj.prop1;
%     end
% end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
% methods (AttributeName = value)
%     function pendulumObj = method_name(pendulumObj,arg1)
%         % The "method_name" method ...
%         %
%         % SYNTAX:
%         %   pendulumObj = pendulumObj.method_name(arg1)
%         %
%         % INPUTS:
%         %   pendulumObj - (1 x 1 simulate.pendulum)
%         %       An instance of the "simulate.pendulum" class.
%         %
%         %   arg1 - (size type) [defaultArgumentValue] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   pendulumObj - (1 x 1 simulate.pendulum)
%         %       An instance of the "simulate.pendulum" class ... 
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         % Check number of arguments
%         error(nargchk(1,2,nargin))
%         
%         % Apply default values
%         if nargin < 2, arg1 = 0; end
%         
%         % Check arguments for errors
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
%             'simulate:pendulum:method_name:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
% end
%-------------------------------------------------------------------------------

%% Converting methods ----------------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Function to convert pendulum object to a otherObject object.
%         %
%         % SYNTAX:
%         %	  otherObject(pendulumObj)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         
% 
%     end
% 
% end
%-------------------------------------------------------------------------------

%% Abstract methods ------------------------------------------------------------
% methods (Abstract = true)
%     %  The "method_name" method . . .  TODO: Add description
%     %
%     % SYNTAX: TODO: Add syntax
%     %   pendulumObj = pendulumObj.method_name(arg1)
%     %
%     % INPUTS: TODO: Add inputs
%     %   pendulumObj - (1 x 1 simulate.pendulum)
%     %       An instance of the "simulate.pendulum" class.
%     %
%     %   arg1 - (size type) [defaultArgumentValue] 
%     %       Description.
%     %
%     % OUTPUTS: TODO: Add outputs
%     %   pendulumObj - (1 x 1 simulate.pendulum)
%     %       An instance of the "simulate.pendulum" class . . . ???.
%     %
%     % NOTES:
%     %
%     %---------------------------------------------------------------------------
%     output = someAbstractMethod(pendulumObj,arg1)
% end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public) % Superclass Abstract Methods
    [stateDot,setPriority] = flowMap(pendulumObj,time,state,input,flowTime,jumpCount)
    [statePlus,timePlus,setPriority] = jumpMap(pendulumObj,time,state,input,flowTime,jumpCount)
    flowState = flowSet(pendulumObj,time,state,flowTime,jumpCount)
    jumpState = jumpSet(pendulumObj,time,state,flowTime,jumpCount)
    
    input = controller(pendulumObj,time,state,input,flowTime,jumpCount)
    stateHat = observer(pendulumObj,time,state,input,output,flowTime,jumpCount)
    output = sensor(pendulumObj,time,state,input,flowTime,jumpCount)
    instantaneousCost = cost(pendulumObj,time,state,input,output,flowtime,jumpCount)
    inputOut = inputConstraints(pendulumObj,inputIn)
    [A,B,C,D] = linearize(pendulumObj,stateOP,inputOP)
    sketch(pendulumObj,state,time,varargin)
end
%-------------------------------------------------------------------------------
    
end

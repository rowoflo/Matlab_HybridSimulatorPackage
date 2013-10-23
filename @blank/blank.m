classdef blank < simulate.system
% The "simulate.blank" class ... TODO: Add description
%
% NOTES:
%   To get more information on this class type "doc simulate.blank" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate, +simulate
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 21-OCT-2013
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Constant = true, Hidden = true)
    systemVersion = '1.7' % (string) Current version of the super class.
end

properties (SetAccess = private) % Superclass Abstract Properties
    type = 'blank' % (string) Type of system.
end

properties (SetAccess = private)

end

properties (Access = public)

end

%% Constructor -----------------------------------------------------------------
methods
    function blankObj = blank(x0,t0,dt)
        % Constructor function for the "blank" class.
        %
        % SYNTAX:
        %   blankObj = blank(x0,t0,dt)
        %
        % INPUTS:
        %   x0 - (1 x 1 number) [zeros(1,1)]
        %       Initializes the system state.
        %
        %   t0 - (1 x 1 real number) [0]
        %       Initializes the system time.
        %
        %   dt - (1 x 1 positive real number) [0.1]
        %       Sets the "blankObj.timeStep" property.
        %
        % OUTPUTS:
        %   blankObj - (1 x 1 blank object) 
        %       A new instance of the "simulate.blank" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(0,3)

        % Apply default values
        if nargin < 1, x0 = zeros(1,1); end
        if nargin < 2, t0 = 0; end
        if nargin < 3, dt = 0.1; end
        
        % Check input arguments for errors
        assert(isnumeric(x0) && isreal(x0) && length(x0) == 1,...
            'simulate:blank:x0',...
            'Input argument "x0" must be a 1 x 1 vector of real numbers.')
        
        assert(isnumeric(t0) && isreal(t0) && length(t0) == 1,...
            'simulate:blank:t0',...
            'Input argument "t0" must be a 1 x 1 real number.')
        
        assert(isnumeric(dt) && isreal(dt) && length(dt) == 1 && dt > 0,...
            'simulate:blank:dt',...
            'Input argument "dt" must be a 1 x 1 positive real number.')
        
        % Initialize Superclass
        nInputs = 1;
        nOutputs = 1;
        blankObj = blankObj@simulate.system(dt,t0,x0,nInputs,nOutputs);
        
        % Check class compatibility with super class
        assert(strcmp(blankObj.systemVersion,simulate.system.currentVersion),...
            'simulate:blank:version',...
            ['The simulate.system class has been updated to version %s ',... 
            'and the blank class is only compatible with version %s.'],...
            simulate.system.currentVersion,blankObj.systemVersion)
        
        % Assign properties
        blankObj.name = 'Blank';
        blankObj.stateNames = {'x1'};
        blankObj.inputNames = {'u1'};
        blankObj.outputNames = {'y1'};
        blankObj.costNames = {'J1'};
        blankObj.phaseStatePairs = [1  1];
        
    end
end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
% methods
%     function blankObj = set.prop1(blankObj,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %   blankObj.prop1 = prop1
%         %
%         % INPUT:
%         %   prop1 - (1 x 1 real number)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[1,1]),...
%             'simulate:blank:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         blankObj.prop1 = prop1;
%     end
%     
%     function prop1 = get.prop1(blankObj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %	  prop1 = blankObj.prop1
%         %
%         % OUTPUT:
%         %   prop1 - (1 x 1 real number)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         prop1 = blankObj.prop1;
%     end
% end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
% methods (AttributeName = value)
%     function blankObj = method_name(blankObj,arg1)
%         % The "method_name" method ...
%         %
%         % SYNTAX:
%         %   blankObj = blankObj.method_name(arg1)
%         %
%         % INPUTS:
%         %   blankObj - (1 x 1 simulate.blank)
%         %       An instance of the "simulate.blank" class.
%         %
%         %   arg1 - (size type) [defaultArgumentValue] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   blankObj - (1 x 1 simulate.blank)
%         %       An instance of the "simulate.blank" class ... 
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
%             'simulate:blank:method_name:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
% end
%-------------------------------------------------------------------------------

%% Converting methods ----------------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Function to convert blank object to a otherObject object.
%         %
%         % SYNTAX:
%         %	  otherObject(blankObj)
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
%     %   blankObj = blankObj.method_name(arg1)
%     %
%     % INPUTS: TODO: Add inputs
%     %   blankObj - (1 x 1 simulate.blank)
%     %       An instance of the "simulate.blank" class.
%     %
%     %   arg1 - (size type) [defaultArgumentValue] 
%     %       Description.
%     %
%     % OUTPUTS: TODO: Add outputs
%     %   blankObj - (1 x 1 simulate.blank)
%     %       An instance of the "simulate.blank" class . . . ???.
%     %
%     % NOTES:
%     %
%     %---------------------------------------------------------------------------
%     output = someAbstractMethod(blankObj,arg1)
% end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public) % Superclass Abstract Methods
    [stateDot,setPriority] = flowMap(blankObj,time,state,input,flowTime,jumpCount)
    [statePlus,timePlus,setPriority] = jumpMap(blankObj,time,state,input,flowTime,jumpCount)
    flowState = flowSet(blankObj,time,state,flowTime,jumpCount)
    jumpState = jumpSet(blankObj,time,state,flowTime,jumpCount)
    
    input = controller(blankObj,time,state,input,flowTime,jumpCount)
    stateHat = observer(blankObj,time,state,input,output,flowTime,jumpCount)
    output = sensor(blankObj,time,state,input,output,flowTime,jumpCount)
    instantaneousCost = cost(blankObj,time,state,input,output,flowtime,jumpCount)
    inputOut = inputConstraints(blankObj,inputIn)
    [A,B,C,D] = linearize(blankObj,stateOP,inputOP)
    sketch(blankObj,state,time,varargin)
end
%-------------------------------------------------------------------------------
    
end

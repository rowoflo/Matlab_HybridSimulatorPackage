classdef SYSTEM_NAME < simulate.system
% The "PACKAGE_NAME_D_SYSTEM_NAME" class ... TODO: Add description
%
% NOTES:
%   To get more information on this class type "doc PACKAGE_NAME_D_SYSTEM_NAME" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   NECESSARY_PACKAGE+simulate
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    FULL_NAME (WEBSITE)
%
% VERSION: 
%   Created DD-MMM-YYYY
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Constant = true, Hidden = true)
    systemVersion = 'VERSION_STR' % (string) Current version of the super class.
end

properties (SetAccess = private) % Superclass Abstract Properties
    type = 'SYSTEM_NAME' % (string) Type of system.
end

properties (SetAccess = private)

end

properties (Access = public)

end

%% Constructor -----------------------------------------------------------------
methods
    function SYSTEM_NAMEObj = SYSTEM_NAME(x0,t0,dt)
        % Constructor function for the "SYSTEM_NAME" class.
        %
        % SYNTAX:
        %   SYSTEM_NAMEObj = SYSTEM_NAME(x0,t0,dt)
        %
        % INPUTS:
        %   x0 - (NSTATES x 1 number) [zeros(NSTATES,1)]
        %       Initializes the system state.
        %
        %   t0 - (1 x 1 real number) [0]
        %       Initializes the system time.
        %
        %   dt - (1 x 1 positive real number) [0.1]
        %       Sets the "SYSTEM_NAMEObj.timeStep" property.
        %
        % OUTPUTS:
        %   SYSTEM_NAMEObj - (1 x 1 SYSTEM_NAME object) 
        %       A new instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(0,3)

        % Apply default values
        if nargin < 1, x0 = zeros(NSTATES,1); end
        if nargin < 2, t0 = 0; end
        if nargin < 3, dt = 0.1; end
        
        % Check input arguments for errors
        assert(isnumeric(x0) && isreal(x0) && length(x0) == NSTATES,...
            'PACKAGE_NAME_C_SYSTEM_NAME:x0',...
            'Input argument "x0" must be a NSTATES x 1 vector of real numbers.')
        
        assert(isnumeric(t0) && isreal(t0) && length(t0) == 1,...
            'PACKAGE_NAME_C_SYSTEM_NAME:t0',...
            'Input argument "t0" must be a 1 x 1 real number.')
        
        assert(isnumeric(dt) && isreal(dt) && length(dt) == 1 && dt > 0,...
            'PACKAGE_NAME_C_SYSTEM_NAME:dt',...
            'Input argument "dt" must be a 1 x 1 positive real number.')
        
        % Initialize Superclass
        nInputs = NINPUTS;
        nOutputs = NOUTPUTS;
        SYSTEM_NAMEObj = SYSTEM_NAMEObj@simulate.system(dt,t0,x0,nInputs,nOutputs);
        
        % Check class compatibility with super class
        assert(strcmp(SYSTEM_NAMEObj.systemVersion,simulate.system.currentVersion),...
            'PACKAGE_NAME_C_SYSTEM_NAME:version',...
            ['The simulate.system class has been updated to version %s ',... 
            'and the SYSTEM_NAME class is only compatible with version %s.'],...
            simulate.system.currentVersion,SYSTEM_NAMEObj.systemVersion)
        
        % Assign properties
        SYSTEM_NAMEObj.name = 'SSYSTEM_NAME';
        SYSTEM_NAMEObj.stateNames = STATE_NAMES;
        SYSTEM_NAMEObj.inputNames = INPUT_NAMES;
        SYSTEM_NAMEObj.outputNames = OUTPUT_NAMES;
        SYSTEM_NAMEObj.costNames = COST_NAMES;
        SYSTEM_NAMEObj.phaseStatePairs = PHASE_STATE_PAIRS;
        
    end
end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
% methods
%     function SYSTEM_NAMEObj = set.prop1(SYSTEM_NAMEObj,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %   SYSTEM_NAMEObj.prop1 = prop1
%         %
%         % INPUT:
%         %   prop1 - (1 x 1 real number)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[1,1]),...
%             'PACKAGE_NAME_C_SYSTEM_NAME:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         SYSTEM_NAMEObj.prop1 = prop1;
%     end
%     
%     function prop1 = get.prop1(SYSTEM_NAMEObj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %	  prop1 = SYSTEM_NAMEObj.prop1
%         %
%         % OUTPUT:
%         %   prop1 - (1 x 1 real number)
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         prop1 = SYSTEM_NAMEObj.prop1;
%     end
% end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
% methods (AttributeName = value)
%     function SYSTEM_NAMEObj = method_name(SYSTEM_NAMEObj,arg1)
%         % The "method_name" method ...
%         %
%         % SYNTAX:
%         %   SYSTEM_NAMEObj = SYSTEM_NAMEObj.method_name(arg1)
%         %
%         % INPUTS:
%         %   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%         %       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%         %
%         %   arg1 - (size type) [defaultArgumentValue] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%         %       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class ... 
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         % Check number of arguments
%         narginchk(1,2)
%         
%         % Apply default values
%         if nargin < 2, arg1 = 0; end
%         
%         % Check arguments for errors
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
%             'PACKAGE_NAME_C_SYSTEM_NAME:method_name:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
% end
%-------------------------------------------------------------------------------

%% Converting methods ----------------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Function to convert SYSTEM_NAME object to a otherObject object.
%         %
%         % SYNTAX:
%         %	  otherObject(SYSTEM_NAMEObj)
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
%     %   SYSTEM_NAMEObj = SYSTEM_NAMEObj.method_name(arg1)
%     %
%     % INPUTS: TODO: Add inputs
%     %   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%     %       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%     %
%     %   arg1 - (size type) [defaultArgumentValue] 
%     %       Description.
%     %
%     % OUTPUTS: TODO: Add outputs
%     %   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%     %       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class . . . ???.
%     %
%     % NOTES:
%     %
%     %---------------------------------------------------------------------------
%     output = someAbstractMethod(SYSTEM_NAMEObj,arg1)
% end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public)

end
%-------------------------------------------------------------------------------
    
end

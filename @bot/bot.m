classdef bot < simulate.system
% The "simulate.bot" class ... TODO: Add description
%
% NOTES:
%   To get more information on this class type "doc simulate.bot" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +simulate, someFile.m
%
% AUTHOR:
%   26-AUG-2011 by Rowland O'Flaherty
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (SetAccess = private) % Superclass Abstract Properties
    type = 'bot'; % (string) Type of system.
end

properties (Access = public) % Superclass Abstract Properties

end

properties (SetAccess = private)
    m % (1 x 1 real positive number) Mass of the bot.
    I % (1 x 1 real positive number) Moment of inertia of the bot.
    w % (1 x 1 real positive number) Width of the bot.
    l % (1 x 1 real positive number) Length of the bot.
    wrr = .25; % (1 x 1 real positive number) Radius of right wheel.
    wrl = .25; % (1 x 1 real positive number) Radius of left wheel.
    
    inputLimits = [-1,1;-1,1]; % (2 x 2 real number) Input limits on the system. Must be in [min max] format. Top is right and botton is left.
end

properties (Access = public)
    % General
    
    
    % Open-loop controller
    openLoopTimeTape = []; % (1 x ? real number) Open-loop control time tape.
    openLoopInputTape = []; % (1 x ? real number) Open-loop control input tape.
end

%% Constructor -----------------------------------------------------------------
methods
    function botObj = bot(m,I,w,l,t0,x0,dt)
        % Constructor function for the "bot" class.
        %
        % SYNTAX: TODO: Add syntax
        %   botObj = bot(arg1,[superClass arguments])
        %
        % INPUTS: TODO: Add inputs
        %   arg1 - (size type) [defaultArg1Value] 
        %       Sets the "botObj.prop1" property.
        %
        % OUTPUTS:
        %   botObj - (1 x 1 bot object) 
        %       A new instance of the "simulate.bot" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments TODO: Add number argument check
        error(nargchk(0,7,nargin))

        % Apply default values TODO: Add apply defaults
        if nargin < 1, m = 1; end
        if nargin < 2, I = 1; end
        if nargin < 3, w = 1; end
        if nargin < 4, l = 1; end
        if nargin < 5, t0 = 0; end
        if nargin < 6, x0 = zeros(6,1); end
        if nargin < 7, dt = 0.1; end
        

        % Check input arguments for errors TODO: Add error checks
        assert(isnumeric(m) && isreal(m) && isequal(size(m),[1,1]),...
            'simulate:bot:m',...
            'Input argument "m" must be a 1 x 1 real number.')
        
        assert(isnumeric(I) && isreal(I) && isequal(size(I),[1,1]),...
            'simulate:bot:I',...
            'Input argument "I" must be a 1 x 1 real number.')
        
        assert(isnumeric(w) && isreal(w) && isequal(size(w),[1,1]),...
            'simulate:bot:w',...
            'Input argument "w" must be a 1 x 1 real number.')
        
        assert(isnumeric(l) && isreal(l) && isequal(size(l),[1,1]),...
            'simulate:bot:l',...
            'Input argument "l" must be a 1 x 1 real number.')
        
        % Initialize Superclass
        nInputs = 2;
        nOutputs = 3;
        botObj = botObj@simulate.system(dt,t0,x0,nInputs,nOutputs);
        
        % Assign properties
        botObj.m = m;
        botObj.I = I;
        botObj.w = w;
        botObj.l = l;
        
        botObj.name = 'Bot';
        botObj.stateNames = {'x';'y';'theta'};
        botObj.inputNames = {'right';'left'};
        botObj.outputNames = {'x';'y';'theta'};
        botObj.phaseStatePairs = [1 2];
        
    end
end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
% methods
%     function botObj = set.prop1(botObj,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %   botObj.prop1 = prop1
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[1,1]),...
%             'simulate:bot:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         botObj.prop1 = prop1;
%     end
%     
%     function prop1 = get.prop1(botObj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %	  prop1 = botObj.prop1
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         prop1 = botObj.prop1;
%     end
% end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
% methods (AttributeName = value)
%     function botObj = method_name(botObj,arg1)
%         % The "method_name" method ...
%         %
%         % SYNTAX:
%         %   botObj = botObj.method_name(arg1)
%         %
%         % INPUTS:
%         %   botObj - (1 x 1 simulate.bot)
%         %       An instance of the "simulate.bot" class.
%         %
%         %   arg1 - (size type) [defaultArgumentValue] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   botObj - (1 x 1 simulate.bot)
%         %       An instance of the "simulate.bot" class ... 
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
%             'simulate:bot:method_name:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
% end
%-------------------------------------------------------------------------------

%% Converting methods ----------------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Function to convert bot object to a otherObject object.
%         %
%         % SYNTAX:
%         %	  otherObject(botObj)
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
%     %   botObj = botObj.method_name(arg1)
%     %
%     % INPUTS: TODO: Add inputs
%     %   botObj - (1 x 1 simulate.bot)
%     %       An instance of the "simulate.bot" class.
%     %
%     %   arg1 - (size type) [defaultArgumentValue] 
%     %       Description.
%     %
%     % OUTPUTS: TODO: Add outputs
%     %   botObj - (1 x 1 simulate.bot)
%     %       An instance of the "simulate.bot" class . . . ???.
%     %
%     % NOTES:
%     %
%     %---------------------------------------------------------------------------
%     output = someAbstractMethod(botObj,arg1)
% end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public) % Superclass Abstract Methods
    stateDot = flowMap(botObj,time,state,input,flowTime,jumpCount)
    statePlus = jumpMap(botObj,time,state,input,flowTime,jumpCount)
    flowState = flowSet(botObj,time,state,flowTime,jumpCount)
    jumpState = jumpSet(botObj,time,state,flowTime,jumpCount)
    
    input = controller(botObj,time,state,flowTime,jumpCount)
    output = observer(botObj,time,state,input,flowTime,jumpCount)
    [A,B,C,D] = jacobian(botObj,stateOP,inputOP)
    sketchGraphics(botObj,time,state,varargin)
end
%-------------------------------------------------------------------------------
    
end

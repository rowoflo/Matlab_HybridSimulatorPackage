classdef plane
% The "simulate.plane" class is used for creating N dimensional planes.
%
% NOTES:
%   To get more information on this class type "doc simulate.plane" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +simulate, someFile.m
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 29-OCT-2011
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Access = public)
    location % (dimension x 1 number) Location of the plane.
    direction % (dimension x 1 number) Direction of the plane. Specified with a unit vector.
end

properties (SetAccess = private)
    dimension % (1 x 1 positive integer) Dimension of the space that the plane lives in.
end

properties (Dependent = true)
    angle % (1 x 1 -pi <= number < pi) When "dimension" equals 2, this is the angle from the first dimension to the "direction" in radians.
end

%% Constructor -----------------------------------------------------------------
methods
    function planeObj = plane(dimension)
        % Constructor function for the "plane" class.
        %
        % SYNTAX:
        %   planeObj = plane(dimension)
        %
        % INPUTS:
        %   dimension - (? x 1 positive integer) [2] 
        %       Sets the "planeObj.dimension" property.
        %
        % OUTPUTS:
        %   planeObj - (1 x 1 plane object) 
        %       A new instance of the "simulate.plane" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments TODO: Add number argument check
        error(nargchk(0,1,nargin))

        % Apply default values TODO: Add apply defaults
        if nargin < 1, dimension = 2; end

        % Check input arguments for errors TODO: Add error checks
        assert(isnumeric(dimension) && isreal(dimension) && isequal(size(dimension),[1,1]) && ...
            mod(dimension,1) == 0 && dimension > 0,...
            'simulate:plane:dimension',...
            'Input argument "dimension" must be a 1 x 1 positive integer.')
        
        % Assign properties
        planeObj.dimension = dimension;
        planeObj.location = zeros(dimension,1);
        planeObj.direction = [1;zeros(dimension-1,1)];
        
    end
end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
methods
    function planeObj = set.location(planeObj,location)
        % Overloaded assignment operator function for the "prop1" property.
        %
        % SYNTAX:
        %   planeObj.location = location
        %
        % INPUT:
        %   location - (dimension x 1 real number)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(isnumeric(location) && isreal(location) && numel(location) == planeObj.dimension,...
            'simulate:plane:set:location',...
            'Property "location" must be set to a %d x 1 real number.',planeObj.dimension)
        location = location(:);

        planeObj.location = location;
    end
    
    function planeObj = set.direction(planeObj,direction)
        % Overloaded assignment operator function for the "direction" property.
        %
        % SYNTAX:
        %   planeObj.direction = direction
        %
        % INPUT:
        %   direction - (dimension x 1 real number)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(isnumeric(direction) && isreal(direction) && numel(direction) == planeObj.dimension,...
            'simulate:plane:set:direction',...
            'Property "direction" must be set to a %d x 1 real number.',planeObj.dimension)
        direction = direction(:);
        
        planeObj.direction = direction / norm(direction);
    end
    
    function angle = get.angle(planeObj)
        % Overloaded query operator function for the "angle" property.
        %
        % SYNTAX:
        %	  angle = planeObj.angle
        %
        % OUTPUT:
        %   prop1 - (1 x 1 -pi <= number < pi)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(planeObj.dimension == 2,...
           'simulate:plane:get:angle',...
           'Property "angle" is only valid when "dimension" == 2.')
       
        angle = atan2(planeObj.direction(2),planeObj.direction(1));
    end
end
%-------------------------------------------------------------------------------


%% Save & Load Methods ---------------------------------------------------------
methods
    function planeStruct = saveobj(planeObj)
        % Save method
        %
        % NOTES:
        %   This method is called when the class is saved to a file.
        %
        %-----------------------------------------------------------------------
        
        planeStruct.location = planeObj.location;
        planeStruct.direction = planeObj.direction;
        planeStruct.dimension = planeObj.dimension;
    end
end

methods (Static)
    function planeObj = loadobj(planeStruct)
        % Load method
        %
        % SYNTAX:
        %   planeObj = plane.loadobj(planeStruct)
        %
        % NOTES:
        %   This method is called when the class is loaded from a file.
        %
        %-----------------------------------------------------------------------
        
        planeObj = simulate.plane(planeStruct.dimension);
        planeObj.location = planeStruct.location;
        planeObj.direction = planeStruct.direction;
    end
end
%-------------------------------------------------------------------------------


%% General Methods -------------------------------------------------------------
methods (Access = public)
    function planeObj = setAngle(planeObj,angle)
        % The "method_name" method this method sets the angle property,
        % i.e. sets the "direction" property so it has this angle. This
        % method is only valid when the "dimension" property equals 2.
        %
        % SYNTAX:
        %   planeObj = planeObj.setAngle(angle)
        %
        % INPUTS:
        %   planeObj - (1 x 1 simulate.plane)
        %       An instance of the "simulate.plane" class.
        %
        %   angle - (1 x 1 number) 
        %       Angle for new "direction" property.
        %
        % OUTPUTS:
        %   planeObj - (1 x 1 simulate.plane)
        %       An instance of the "simulate.plane" class with "direction"
        %       property that has an angle of "angle".
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------

        % Check number of arguments
        error(nargchk(2,2,nargin))
        
        % Check arguments for errors
        assert(planeObj.dimension == 2,...
           'simulate:plane:setAngle:dim',...
           'Property "angle" is only valid when "dimension" == 2.')
       
        assert(isnumeric(angle) && isreal(angle) && numel(angle) == 1,...
            'simulate:plane:setAngle:angle',...
            'Input argument "angle" must be a 1 x 1 real number.')
        
        planeObj.direction = [cos(angle);sin(angle)];
        
    end
    
end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public)
    [d,D] = distance(planeObjs,points,dType)
    pts = intercept(planeObjs)
    graphicsHandles = sketch(planeObjs,axisHandle,varargin)
end
%-------------------------------------------------------------------------------
    
end

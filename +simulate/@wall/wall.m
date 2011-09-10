classdef wall < simulate.feature
% The "simulate.wall" class ... TODO: Add description
%
% NOTES:
%   To get more information on this class type "doc simulate.wall" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +simulate, someFile.m
%
% AUTHOR:
%   17-APR-2011 by Rowland O'Flaherty
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Access = public)
    name = 'Wall'; % (string) Name of the feature.
    position = [0;0]; % (2 x 1 real number) Position or origin of the wall.
    endpoint = [0;0]; % (2 x 1 real number) Endpoint of the wall.
end

properties (SetAccess = private)
    type = 'wall'; % (string) Type of feature.
    normalVector % (2 x 1 real number) Unit vector in the direction normal to the wall.
    unitVector % (2 x 1 real number) Unit vector in the direction from "position" to "endpoint". pi/2 rotation counter-clockwise from "normalVector".
    extent % (1 x 1 real number) Length of the base of the wall.
    angle % (1 x 1 real number) The angle between the x-axis and wall in degrees.
end

%% Constructor -----------------------------------------------------------------
methods
    function wallObj = wall(position,endpoint)
        % DESCRIPTION:
        %   Constructor function for the "wall" class.
        %
        % SYNTAX:
        %   wallObj = wall(position,endpoint)
        %
        % INPUTS:
        %   position - (2 x 1 real number) [zeros(2,1)] 
        %       Sets the "position" property of the object "wallObj".
        %
        %   endpoint - (2 x 1 real number) [zeros(2,1)]
        %       Sets the "endpoint" property of the object "wallObj".
        %
        %
        % OUTPUTS:
        %   wallObj - (1 x 1 wall object) 
        %       A new instance of the "simulate.wallObj" class.
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        
        % Check number of arguments
        error(nargchk(0,2,nargin))

        % Apply default values
        if nargin < 1, position = zeros(2,1); end
        if nargin < 2, endpoint = zeros(2,1); end

        % Check input arguments for errors
        assert(isnumeric(position) && isreal(position) && isequal(size(position),[2,1]),...
            'simulate:wall:position',...
            'Input argument "position" must be a 2 x 1 vector of real numbers.')
        
        assert(isnumeric(endpoint) && isreal(endpoint) && isequal(size(endpoint),[2,1]),...
            'simulate:wall:endpoint',...
            'Input argument "endpoint" must be a 2 x 1 vector of real numbers.')
        
        % Assign properties
        wallObj.position = position;
        wallObj.endpoint = endpoint;
        
    end
end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
methods
    function wallObj = set.name(wallObj,name)
        % Overloaded assignment operator function for the "name" property.
        %
        % USAGE:
        %	wallObj.name = name
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        % Check input arguments for errors
        assert(ischar(name),...
            'simulate:wall:set:name',...
            'Input argument "name" must be a string.')
        
        wallObj.name = name;
    end
    
    function wallObj = set.position(wallObj,position)
        % Overloaded assignment operator function for the "position" property.
        %
        % USAGE:
        %	wallObj.position = position
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        % Check input arguments for errors
        assert(isnumeric(position) && isreal(position) && numel(position) == 2,...
            'simulate:wall:set:position',...
            'Input argument "position" must be a 2 x 1 real number.')
        position = position(:);
        
        wallObj.position = position;
        wallObj = wallObj.updateProperties;
    end
    
    function wallObj = set.endpoint(wallObj,endpoint)
        % Overloaded assignment operator function for the "endpoint" property.
        %
        % USAGE:
        %	wallObj.endpoint = endpoint
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        % Check input arguments for errors
        assert(isnumeric(endpoint) && isreal(endpoint) && numel(endpoint) == 2,...
            'simulate:wall:set:position',...
            'Input argument "position" must be a 2 x 1 real number.')
        endpoint = endpoint(:);
        
        wallObj.endpoint = endpoint;
        wallObj = wallObj.updateProperties;
    end
end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
methods (Access = private)
    function wallObj = updateProperties(wallObj)
        % The "updateProperties" method ... TODO
        %
        % SYNTAX: TODO
        %   wallObj = wallObj.method_name(arg1)
        %
        % INPUTS: TODO
        %   wallObj - (1 x 1 simulate.wall)
        %       An instance of the "simulate.wall" class.
        %
        %   arg1 - (size type) [defaultArgumentValue] 
        %       Description.
        %
        % OUTPUTS: TODO
        %   wallObj - (1 x 1 simulate.wall)
        %       An instance of the "simulate.wall" class ... 
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------

        % % Check number of arguments TODO
        % error(nargchk(1,2,nargin))
        % 
        % % Apply default values
        % if nargin < 2, arg1 = 0; end
        % 
        % % Check arguments for errors
        % assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
        %     'simulate:wall:method_name:arg1',...
        %     'Input argument "arg1" must be a ? x ? matrix of real numbers.')
        
        wallObj.normalVector = [0 1;-1 0]*((wallObj.endpoint - wallObj.position) / norm(wallObj.endpoint - wallObj.position));
        wallObj.unitVector = (wallObj.endpoint - wallObj.position) / norm(wallObj.endpoint - wallObj.position);
        wallObj.extent = norm(wallObj.endpoint - wallObj.position);
        wallObj.angle = atand((wallObj.endpoint(2) - wallObj.position(2)) / (wallObj.endpoint(1) - wallObj.position(1)));
    end
    
end
%-------------------------------------------------------------------------------

%% Converting methods ----------------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Function to convert wall object to a otherObject object.
%         %
%         % SYNTAX:
%         %	  otherObject(wallObj)
%         %
%         % NOTES:
%         %
%         %---------------------------------------------------------------------
%         
% 
%     end
% 
% end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = public)% Superclass Abstract Methods
    [distances,directions,endFlags] = distanceFrom(wallObjs,points)
    [points,angles] = intersectionWith(wallObjs,lineSegments)
    [reflectionPoints] = reflectionWith(wallObjs,points)
    graphicsHandles = sketch(wallObj,axesHandle,varargin)
end

methods (Access = public)
    
end
%-------------------------------------------------------------------------------
    
end

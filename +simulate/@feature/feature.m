classdef feature
% The "simulate.feature" class is an abstract class for creating map
% features. Subclasses must redefine type and position properties and the
% draw method.
%
% NOTES:
%   To get more information on this class type "doc simulate.system" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +simulate
%
% AUTHOR:
%   17-APR-2011 by Rowland O'Flaherty
%
% SEE ALSO: TODO: Add see alsos
%    simulate.map
%
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Abstract = true, Access = public)
    name % (string) Name of the feature.
    position % (2 x 1 real number) Position of the feature.
end

properties(Abstract = true, SetAccess = private)
    type % (string) Type of feature.
end

%% Constructor -----------------------------------------------------------------
% methods
%     function featureObj = feature(arg1)
%         % Constructor function for the "feature" class.
%         %
%         % SYNTAX: TODO: Add syntax
%         %   featureObj = feature(arg1)
%         %
%         % INPUTS: TODO: Add inputs
%         %   arg1 - (string) [''] 
%         %       Sets the "arg1" property.
%         %
%         % OUTPUTS: TODO: Add outputs
%         %   featureObj - (1 x 1 feature object) 
%         %       A new instance of the "simulate.feature" class.
%         %
%         %-----------------------------------------------------------------------
%         
%         % Check number of arguments
%         error(nargchk(0,1,nargin))
% 
%         % Apply default values
%         if nargin < 1, arg1 = ''; end
% 
%         % Check input arguments for errors
%         assert(ischar(arg1),...
%             'simulate:feature:arg1',...
%             'Input argument "arg1" must be a string.')
%         
%         % Assign properties
%         featureObj.arg1 = arg1;
%         
%     end
% end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
% methods
%     function class_nameObj = set.prop1(class_nameObj,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %   class_nameObj.prop1 = prop1
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[1,1]),...
%             'package_name:set:prop1',...
%             'Property "prop1" must be set to a 1 x 1 real number.')
% 
%         class_nameObj.prop1 = prop1;
%     end
%     
%     function prop1 = get.prop1(class_nameObj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % SYNTAX:
%         %	  prop1 = class_nameObj.prop1
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         prop1 = class_nameObj.prop1;
%     end
% end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
% methods (AttributeName = value)
%     function class_nameObj = method_name(class_nameObj,arg1)
%         % The "method_name" method ...
%         %
%         % SYNTAX:
%         %   class_nameObj = class_nameObj.method_name(arg1)
%         %
%         % INPUTS:
%         %   class_nameObj - (1 x 1 package_name.class_name)
%         %       An instance of the "package_name.class_name" class.
%         %
%         %   arg1 - (size type) [defaultArgumentValue] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   class_nameObj - (1 x 1 package_name.class_name)
%         %       An instance of the "package_name.class_name" class ... 
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
%             'package_name:class_name:method_name:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
% end
%-------------------------------------------------------------------------------

%% Converting methods ----------------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Function to convert class_name object to a otherObject object.
%         %
%         % SYNTAX:
%         %	  otherObject(class_nameObj)
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

%% Abstract methods ------------------------------------------------------------
methods (Abstract = true)
    % The "distanceFrom" method calculates a distance matrix for the set of points
    % to all the features.
    %
    % SYNTAX: 
    %   [distances,directions,endFlags] = featureObjs.distanceFrom(points)
    %
    % INPUTS:
    %   featureObjs - (? x 1 simulate.feature)
    %       An instance of the "simulate.feature" class.
    %
    %   points - (2 x ? number)
    %       Set of points for distance calculation.
    %
    % OUTPUTS:
    %   distances - (? x ? number)
    %       Distance matrix. Closest distance from the point to the feature.
    %       "featuresObjs" x "points"
    %
    %   directions - (? x ? number)
    %       Matrix of 1 or -1. 1 if the point is in front of the feature -1 if
    %       behind the feature.
    %
    %   endFlags - (? x ? logical)
    %       Logical matrix specifying if the point is off the end of the feature.
    %
    % NOTES:
    %
    %---------------------------------------------------------------------------
    [distances,directions] = distanceFrom(featureObjs,points)
    
    % The "intersectPoint" method ... TODO: Add description
    %
    % SYNTAX: TODO: Add syntax
    %   featureObj = featureObj.intersectPoint(arg1)
    %
    % INPUTS: TODO: Add inputs
    %   featureObj - (1 x 1 simulate.feature)
    %       An instance of the "simulate.feature" class.
    %
    %   arg1 - (size type) [defaultArgumentValue] 
    %       Description.
    %
    % OUTPUTS: TODO: Add outputs
    %   featureObj - (1 x 1 simulate.feature)
    %       An instance of the "simulate.feature" class ... ???.
    %
    % NOTES:
    %
    %
    %---------------------------------------------------------------------------
    [points,angles] = intersectionWith(featureObjs,lineSegments)
    
    % The "sketch" method draws the "featureObjs" in the given axes.
    %
    % SYNTAX:
    %   featureObjs = featureObjs.sketch()
    %   featureObjs = featureObjs.sketch(axesHandle)
    %   featureObjs = featureObjs.sketch(axesHandle,'parameterName',parameterValue)
    %
    % INPUTS:
    %   featureObjs - (simulate.feature)
    %       Instances of the "simulate.feature" class.
    %
    %   axesHandle - (1 x 1 axes handle) [gca]
    %       Handle to the axes that the "featureObjs" will be plotted in.
    %
    % OUTPUTS:
    %   graphicsHandles - (? x 1 graphics handle)
    %       Handle to line graphics object for the "featureObjs" that were just
    %       plotted.
    %
    % NOTES:
    %   All lineseries properties can be used with this method.
    %
    %---------------------------------------------------------------------------
    graphicsHandles = sketch(featureObjs,axesHandle,varargin)
end
%-------------------------------------------------------------------------------
    
end

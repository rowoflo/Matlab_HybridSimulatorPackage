classdef map
% The "simulate.map" class ...  TODO: Add description
%
% NOTES:
%   To get more information on this class type "doc simulate.map" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +simulate
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
    featureBuffer = .25; % TODO
end

properties (Access = private)
    
end

properties (SetAccess = private)
    limits % (1 x 4 real number) Map min and max limits for x and y. [minX maxX minY maxY].
    cellSize  % (1 x 2 real positive number) Quantization size of map in x and y. [sizeX sizeY].
    features % (? x 1 cell array) Feature associated with the map. Must be objects that inherit the simulate.feature class. 
    
    nFeatures % (1 x 1 positive integer) Number of features in the map.
    featureTypes % (? x 1 cell array of strings) Type of features in "features" cell array.
    gridSize % (1 x 2 real positive integer) Number of grid edges in the x and y directions
    gridXVector % (1 x ? real number) Grid x axis, marks edges of grid. Size is 1 x grisSize(1).
    gridYVector % (1 x ? real number) Grid x axis, marks edges of grid. Size is 1 x grisSize(2).
    nCells % (1 x 2 real positive integer) Number of cells in the map in the x and y directions.
    cellXCenters % (1 x ? real number) Cell centers in the x direction. Size is 1 x nCells(1).
    cellYCenters % (1 x ? real number) Cell centers in the y direction. Size is 1 x nCells(2).
    validityMask % (? x ? logical) Logical mask validating accessibility of each cell of the map. Cell size is determined by "cellSize" property.
end

%% Constructor -----------------------------------------------------------------
methods
    function mapObj = map(limits,cellSize,features)
        % Constructor function for the "map" class.
        %
        % SYNTAX:
        %   mapObj = map(limits,cellSize,features)
        %
        % INPUTS:
        %   limits - (1 x 4 real number) [zeros(1,4)]
        %       Sets the "limits" property of the object "mapObj".
        %
        %   cellSize - (1 x 2 real positive number) [ones(1,2)]
        %       Sets the "cellSize" property of the object "mapObj".
        %
        %   features - (? x 1 cell array) [{}] 
        %       Sets the "features" property of the object "mapObj".
        %
        % OUTPUTS:
        %   mapObj - (1 x 1 map object) 
        %       A new instance of the "simulate.map" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        error(nargchk(0,3,nargin))
        
        % Apply default values
        if nargin < 1, limits = zeros(1,4); end
        if nargin < 2, cellSize = ones(1,2); end
        if nargin < 3, features = {}; end
        
        
        % Check input arguments for errors
        assert(isnumeric(limits) && isreal(limits) && isvector(limits) && ...
            numel(limits) == 4 && limits(1) <= limits(2) && limits(3) <= limits(4),...
            'simulate:map:limits',...
            'Input argument "limits" must be a 1 x 2 vector of real numbers with of the form [minX maxX minY maxY].')
        limits = limits(:)';
        
        assert(isnumeric(cellSize) && isreal(cellSize) && isvector(cellSize) && ...
            numel(cellSize) == 2 && all(cellSize) > 0,...
            'simulate:map:cellSize',...
            'Input argument "cellSize" must be a 1 x 2 vector of positive numbers with of the form [sizeX sizeY].')
        cellSize = cellSize(:)';
        
        validFeatureClasses = {'simulate.wall'};
        assert(iscell(features) && ...
            (isempty(features) || all(ismember(cellfun(@(elem) class(elem),features,'UniformOutput',false),validFeatureClasses))),...
            'simulate:map:features',...
            'Input argument "features" must be an empty cell array or a ? x 1 cell array of classes that inherit from the simulate.feature class.')
        
        for iFeature = 1:length(features)
            assert(features{iFeature}.position(1) >= limits(1) && ...
                features{iFeature}.position(1) <= limits(2) && ...
                features{iFeature}.position(2) >= limits(3) && ...
                features{iFeature}.position(2) <= limits(4),...
                'simulate:map:features',...
                'Input argument "features" "position" property must be within the map limits.')
        end
        
        % Assign properties
        mapObj.limits = limits;
        mapObj.cellSize = cellSize;
        mapObj.features = features;
        mapObj.nFeatures = numel(mapObj.features);
        mapObj.featureTypes = cell(mapObj.nFeatures,1);
        for iFeature = 1:mapObj.nFeatures
            mapObj.featureTypes{iFeature} = features{iFeature}.type;
        end
        mapObj = mapObj.discritize;
        
    end
end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
methods
%     function mapObj = set.features(mapObj,features)
%         % Overloaded assignment operator function for the "features" property.
%         %
%         % SYNTAX:
%         %   mapObj.features = features
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
%         
% 
%         mapObj.features = features;
%         mapObj = mapObj.updateProperties;
%     end
% 
%     function nFeatures = get.nFeatures(mapObj)
%         % Overloaded query operator function for the "nFeatures" property.
%         %
%         % SYNTAX:
%         %	  nFeatures = mapObj.nFeatures
%         %
%         % NOTES:
%         %
%         %-----------------------------------------------------------------------
% 
%         nFeatures = numel(mapObj.features);
%     end
end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
methods (Access = private)
    function mapObj = discritize(mapObj)
        % The "discritize" method sets properties of the map to discritize
        % it.
        %
        % SYNTAX:
        %   mapObj = mapObj.makeMask
        %
        % NOTES: Grid origin is always at [minX minY] of map.
        %
        %-----------------------------------------------------------------------
        
        xLen = mapObj.limits(2) - mapObj.limits(1);
        yLen = mapObj.limits(4) - mapObj.limits(3);
        mapObj.nCells(1,1) = ceil(xLen/mapObj.cellSize(1));
        mapObj.nCells(1,2) = ceil(yLen/mapObj.cellSize(2));
        mapObj.gridSize(1) = mapObj.nCells(1,1)+1;
        mapObj.gridSize(2) = mapObj.nCells(1,2)+1;
        mapObj.gridXVector = linspace(mapObj.limits(1),mapObj.limits(2),mapObj.gridSize(1));
        mapObj.gridYVector = linspace(mapObj.limits(3),mapObj.limits(4),mapObj.gridSize(2));
        mapObj.cellXCenters = mean([mapObj.gridXVector;circshift(mapObj.gridXVector,[0 -1])],1);
        mapObj.cellXCenters = mapObj.cellXCenters(1:end-1);
        mapObj.cellYCenters = mean([mapObj.gridYVector;circshift(mapObj.gridYVector,[0 -1])],1);
        mapObj.cellYCenters = mapObj.cellYCenters(1:end-1);

        [X,Y] = meshgrid(mapObj.cellXCenters,mapObj.cellYCenters);
        mapObj.validityMask = mapObj.distanceToNearestFrom([X(:)';Y(:)']) > mapObj.featureBuffer;
        mapObj.validityMask = reshape(mapObj.validityMask,mapObj.nCells);
        
    end
    
end
%-------------------------------------------------------------------------------

%% Converting methods ----------------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Function to convert map object to a otherObject object.
%         %
%         % SYNTAX:
%         %	  otherObject(mapObj)
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
methods (Access = public)
    [distances,featureObjsCell] = distanceToNearestFrom(mapObj,points)
    [points,angles] = intersectionWith(mapObj,lineSegments)
    graphicsHandle = sketch(mapObj,axesHandle,varargin)
    featureObjs = visibleFeaturesFrom(mapObj,point)
    route = solve(mapObj,initialState,goalState,varargin)
end
%-------------------------------------------------------------------------------
    
end
function [points,angles] = intersectionWith(mapObj,lineSegments)
% The "intersectionWith" method ... TODO: Add description
%
% SYNTAX: TODO: Add syntax
%   mapObj = mapObj.intersectionWith(arg1)
%
% INPUTS: TODO: Add inputs
%   mapObj - (1 x 1 simulate.map)
%       An instance of the "simulate.map" class.
%
%   arg1 - (size type) [defaultArgumentValue] 
%       Description.
%
% OUTPUTS: TODO: Add outputs
%   mapObj - (1 x 1 simulate.map)
%       An instance of the "simulate.map" class ... ???.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +simulate, someFile.m
%
% AUTHOR:
%   27-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments
error(nargchk(2,2,nargin))

% Apply default values
% if nargin < 2, arg1 = 0; end

% Check arguments for errors TODO: Add error checks
assert(isa(mapObj,'simulate.map') && numel(mapObj) == 1,...
    'simulate:map:intersectionWith:mapObj',...
    'Input argument "mapObj" must be a 1 x 1 "simulate.map" object.')

assert(isnumeric(lineSegments) && isreal(lineSegments) && size(lineSegments,1) == 2 && size(lineSegments,2) == 2,...
    'simulate:map:intersectionWith:lineSegments',...
    'Input argument "lineSegments" must be a 2 x 2 x ? matrix cube of real numbers. First dimension is [x;y] second dimension is [point1 point2].')

%% Intersection points with all features 
nLines = size(lineSegments,3);
points = nan(2,mapObj.nFeatures,nLines);
angles = nan(mapObj.nFeatures,nLines);

typeList = unique(mapObj.featureTypes);
nTypes = length(typeList);
for iType = 1:nTypes
    typeLogic = ismember(mapObj.featureTypes,typeList{iType});
    featuresObjs = [mapObj.features{typeLogic}]';
    [points(:,typeLogic,:),angles(typeLogic,:)] = ...
        featuresObjs.intersectionWith(lineSegments);
end

end

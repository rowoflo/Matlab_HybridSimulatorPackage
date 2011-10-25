function [distances,featureObjsCell] = distanceToNearestFrom(mapObj,points)
% The "distanceToNearestFrom" method ... TODO: Add description
%
% SYNTAX: TODO: Add syntax
%   mapObj = mapObj.distanceToNearestFrom(arg1)
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
%   26-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

% %% Check Input Arguments
% 
% % Check number of arguments TODO: Add number argument check
% error(nargchk(1,2,nargin))
% 
% % Apply default values TODO: Add apply defaults
% if nargin < 2, arg1 = 0; end
% 
% % Check arguments for errors TODO: Add error checks
% assert(isa(mapObj,'simulate.map') && numel(mapObj) == 1,...
%     'simulate:map:distanceToNearestFrom:mapObj',...
%     'Input argument "mapObj" must be a 1 x 1 simulate.map object.')
%
% assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
%     'simulate:map:distanceToNearestFrom:arg1',...
%     'Input argument "arg1" must be a ? x ? matrix of real numbers.')

%% Distance to all features
nPoints = size(points,2);
allDistances = zeros(mapObj.nFeatures,nPoints);
directions = zeros(mapObj.nFeatures,nPoints);

typeList = unique(mapObj.featureTypes);
nTypes = length(typeList);
for iType = 1:nTypes
    typeLogic = ismember(mapObj.featureTypes,typeList{iType});
    featuresObjs = [mapObj.features{typeLogic}]';
    [allDistances(typeLogic,:),directions(typeLogic,:)] =...
        featuresObjs.distanceFrom(points);
end

%% Nearest
minDists = min(allDistances,[],1);
minDirs = directions .* (allDistances == repmat(minDists,mapObj.nFeatures,1));
minDirs(minDirs == 0) = nan;
minDirs = mode(minDirs,1);
minDirs(isnan(minDirs)) = 0;
distances = minDists.*minDirs;

%% Output
if nargout >= 2
    featureObjsCell = cell(1,nPoints);
    for iPoint = 1:nPoints
        featureObjsCell{iPoint} = mapObj.features(allDistances(:,iPoint) == abs(distances(iPoint)));
    end
end

end

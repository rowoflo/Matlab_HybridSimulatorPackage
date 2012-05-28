function featureObjs = visibleFeaturesFrom(mapObj,point)
% The "visibleFeaturesFrom" method ... TODO: Add description
%
% SYNTAX: TODO: Add syntax
%   mapObj = mapObj.visibleFeaturesFrom(arg1)
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
%   03-MAY-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments TODO: Add number argument check
error(nargchk(2,2,nargin))

% Check arguments for errors TODO: Add error checks
assert(isa(mapObj,'simulate.map') && numel(mapObj) == 1,...
    'simulate:map:visibleFeaturesFrom:mapObj',...
    'Input argument "mapObj" must be a 1 x 1 "simulate.map" object.')

assert(isnumeric(point) && isreal(point) && isequal(size(point),[2,1]),...
    'simulate:map:visibleFeaturesFrom:point',...
    'Input argument "point" must be a 2 x 1 vector of real numbers.')

%% Parameters
nRays = 777;

%% Variables
corner(:,1) = mapObj.limits([1 3])';
corner(:,2) = mapObj.limits([1 4])';
corner(:,3) = mapObj.limits([2 4])';
corner(:,4) = mapObj.limits([2 3])';
rayLength = max(sqrt(sum((repmat(point,1,4) - corner).^2,1)));

angVec = 0:2*pi/nRays:2*pi*(1-1/nRays);

[rayPointsX,rayPointsY] = pol2cart(angVec,rayLength);
rayPoints = [rayPointsX;rayPointsY] + repmat(point,1,nRays);
lineSegments = permute(cat(3,repmat(point,1,nRays),rayPoints),[1 3 2]);

%% Intersect
intersectPoints = mapObj.intersectionWith(lineSegments);
[~,featureInds] = min(sum((intersectPoints - repmat(point,[1,size(intersectPoints,2),size(intersectPoints,3)])).^2,1),[],2);
featureInds = unique(squeeze(featureInds));

featureObjs = mapObj.features(featureInds);

end

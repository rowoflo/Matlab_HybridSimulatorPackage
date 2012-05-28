function [d,D] = distance(planeObjs,points,dType)
% The "distance" method calculates the distance from each point in
% "points" to the nearest plane in "planeObjs".
%
% SYNTAX:
%   [d,D] = planeObjs.distance(points,dType)
%
% INPUTS:
%   planeObjs - (? x 1 simulate.plane)
%       Array of instances of the "simulate.plane" class. "nPlanes" is the
%       number of planes and "dimension" is the dimension of the planes.
%
%   points - (dimension x ? number)
%       Set of points to calculate distances from to the planes. "nPoints"
%       is the number points.
%
%   dType - (1 or 2) [1]
%       If 1 the minimum distance from a point to a plane is returned. If 2
%       the maximum inner product value with plane unit normal vector is
%       returned.
%
% OUTPUTS:
%   d - (1 x nPoints number)
%       dType = 1: Minimum distance from a point to a plane. Each element corresponds
%       to the point in the "points" input variable.
%       dType = 2: Maximum inner product value with plane unit normal
%       vector is returned.
%
%   D - (nPlanes x nPoints number)
%       Distance matrix from each point to each plane, planes are the rows
%       and points are the columns.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty 29-OCT-2011
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments 
error(nargchk(2,3,nargin))

% Apply default values
if nargin < 3, dType = 1; end

% Check arguments for errors TODO: Add error checks
% assert(isa(planeObjs,'simulate.plane'),...
%     'simulate:plane:distance:planeObjs',...
%     'Input argument "planeObjs" must be a ? x 1 "simulate.plane" object.')
planeObjs = planeObjs(:);
dimension = planeObjs(1).dimension;
nPlanes = numel(planeObjs);

assert(isnumeric(points) && isreal(points) && size(points,1) == dimension,...
    'simulate:plane:distance:points',...
    'Input argument "points" must be a %d x ? matrix of real numbers.',dimension)
nPoints = size(points,2);

assert(isnumeric(dType) && (dType == 1 || dType == 2),...
    'simulate:plane:distance:dType',...
    'Input argument "dType" must be a either 1 or 2.')

%% Calculate distance
loc = [planeObjs.location];
dir = [planeObjs.direction];
dirCube = repmat(permute(dir,[1 3 2]),[1 nPoints]); % nDim x nPoints x nPlanes
pointCube = repmat(points,[1 1 nPlanes]); % nDim x nPoints x nPlanes
locCube = repmat(permute(loc,[1 3 2]),[1 nPoints 1]); % nDim x nPoints x nPlanes
D = permute(sum(dirCube .* (pointCube - locCube),1),[3 2 1]);
if dType == 1
    [~,dInd] = min(abs(D),[],1);
    col2Ind = 0:nPlanes:nPoints*(nPlanes-1);
    d = D(dInd + col2Ind);
else
    d = max(D,[],1);
end

end
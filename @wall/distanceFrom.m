function [distances,directions,endFlags] = distanceFrom(wallObjs,points)
% The "distanceFrom" method calculates a distance matrix for the set of points
% to all the walls.
%
% SYNTAX: 
%   [distances,directions,endFlags] = wallObjs.distanceFrom(points)
%
% INPUTS:
%   wallObjs - (? x 1 simulate.wall)
%       An instance of the "simulate.wall" class.
%
%   points - (2 x ? number)
%       Set of points for distance calculation.
%
% OUTPUTS:
%   distances - (? x ? number)
%       Distance matrix. Closest distance from the point to the wall.
%       "wallsObjs" x "points"
%
%   directions - (? x ? number)
%       Matrix of 1 or -1. 1 if the point is in front of the wall -1 if
%       behind the wall.
%
%   endFlags - (? x ? logical)
%       Logical matrix specifying if the point is off the end of the wall.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES: TODO: 
%   +simulate, someFile.m
%
% AUTHOR:
%   26-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments 
error(nargchk(2,2,nargin))

% Check arguments for errors
assert(isa(wallObjs,'simulate.wall') && size(wallObjs,2) == 1,...
    'simulate:wall:distanceFrom:wallObj',...
    'Input argument "wallObj" must be a column vector of simulate.wall objects.')

assert(isnumeric(points) && size(points,1) == 2,...
    'simulate:wall:distanceFrom:points',...
    'Input argument "points" must be a 2 x ? matrix of numbers.')

%% Variables
% Dimension: 1-states 2-walls 3-points
nWalls = numel(wallObjs);
nPoints = size(points,2);

p = repmat(permute(points,[1 3 2]),1,nWalls); % Position of points
l = repmat([wallObjs.extent]',[1 nPoints]); % Length of walls
wP = repmat([wallObjs.position],[1 1 nPoints]); % Origin of walls
wE = repmat([wallObjs.endpoint],[1 1 nPoints]); % Endpoint of walls
wuv = repmat([wallObjs.unitVector],[1 1 nPoints]); % Wall unit vectors
wnv = repmat([wallObjs.normalVector],[1 1 nPoints]); % Wall normal vectors

%% Calculations
pP = p - wP; % Point vector from wall origins
pE = p - wE; % Point vector from wall ends

% Dimension: 1-walls 2-points
pPDist = permute(sum(pP.*wuv,1),[2 3 1]); % Distance of the projection of the point along the walls
pXDist = permute(sum(pP.*wnv,1),[2 3 1]); % Distance of the projection of the point out of the walls

%% Distance
distances = zeros(nWalls,nPoints);
endFlags = false(nWalls,nPoints);

directions = sign(pXDist);

% Distances from walls where point is in the middle of the wall
midLogic = pPDist > 0 & pPDist < l;
distances(midLogic) = abs(pXDist(midLogic));
endFlags(midLogic) = false;

% Distances from wall where point is off the end of the wall
outLogic = pPDist <= 0;
distances(~midLogic & outLogic) = sqrt(sum(pP(:,~midLogic & outLogic).^2,1));
distances(~midLogic & ~outLogic) = sqrt(sum(pE(:,~midLogic & ~outLogic).^2,1));
endFlags(~midLogic) = true;

end

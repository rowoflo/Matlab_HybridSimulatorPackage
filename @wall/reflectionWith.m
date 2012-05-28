function [reflectionPoints] = reflectionWith(wallObjs,points)
% The "reflectionWith" method ... TODO: Add description
%
% SYNTAX: TODO: Add syntax
%   wallObjs = wallObjs.reflectionWith(arg1)
%
% INPUTS: TODO: Add inputs
%   wallObjs - (? x 1 simulate.wall)
%       Instances of the "simulate.wall" class.
%
%   arg1 - (size type) [defaultArgumentValue] 
%       Description.
%
% OUTPUTS: TODO: Add outputs
%   wallObjs - (1 x 1 simulate.wall)
%       An instance of the "simulate.wall" class ... ???.
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

% Check number of arguments
error(nargchk(2,2,nargin))

% Check arguments for errors TODO: Add error checks
wallObjs = wallObjs(:);

assert(isnumeric(points) && isreal(points) && size(points,1) == 2,...
    'simulate:wall:reflectionWith:points',...
    'Input argument "points" must be a 2 x ? matrix of real numbers.')

%% Variables
% Dimension: 1-states 2-walls 3-points
nWalls = numel(wallObjs);
nPoints = size(points,2);

p = repmat(permute(points,[1 3 2]),1,nWalls); % Position of points
l = repmat([wallObjs.extent]',[1 nPoints]); % Length of walls
wP = repmat([wallObjs.position],[1 1 nPoints]); % Origin of walls
wE = repmat([wallObjs.endpoint],[1 1 nPoints]); % Endpoint of walls
wuv = repmat([wallObjs.unitVector],[1 1 nPoints]); % Wall unit vectors
wnv = repmat([wallObjs.normalVector],[1 1 nPoints]); % Wall unit vectors

%% Calculations
pP = p - wP; % Point vector from wall origins
pE = p - wE; % Point vector from wall ends

% Dimension: 1-walls 2-points
pPDist = permute(sum(pP.*wuv,1),[2 3 1]); % Distance of the projection of the point along the walls
pXDist = permute(sum(pP.*wnv,1),[2 3 1]); % Distance of the projection of the point out of the walls

%% Reflected points
% Dimension: 1-states 2-walls 3-points
reflectionPoints = repmat(permute(pPDist,[3 1 2]),[2,1,1]).*wuv + repmat(permute(pXDist,[3 1 2]),[2,1,1]).*-wnv + wP;
end

function [points,angles] = intersectionWith(wallObjs,lineSegments)
% The "points" method ... TODO: Add description
%
% SYNTAX: TODO: Add syntax
%   wallObj = wallObj.intersectionWith(arg1)
%
% INPUTS: TODO: Add inputs
%   wallObj - (1 x 1 simulate.wall)
%       An instance of the "simulate.wall" class.
%
%   arg1 - (size type) [defaultArgumentValue] 
%       Description.
%
% OUTPUTS: TODO: Add outputs
%   wallObj - (1 x 1 simulate.wall)
%       An instance of the "simulate.wall" class ... ???.
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
% 
% % Check number of arguments TODO: Add number argument check
% error(nargchk(1,2,nargin))
% 
% % Apply default values TODO: Add apply defaults
% if nargin < 2, arg1 = 0; end
% 
% % Check arguments for errors TODO: Add error checks
% assert(isa(wallObj,'simulate.wall') && numel(wallObj) == 1,...
%     'simulate:wall:intersectionWith:wallObj',...
%     'Input argument "wallObj" must be a 1 x 1 "simulate.wall" object.')
%
% assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
%     'simulate:wall:intersectionWith:arg1',...
%     'Input argument "arg1" must be a ? x ? matrix of real numbers.')

%% Variables
nLines = size(lineSegments,3);
nWalls = size(wallObjs,1);

wallPositions = [wallObjs.position];
wallEndpoints = [wallObjs.endpoint];

x1 = wallPositions(1,:)'; % Wall points 1 x
y1 = wallPositions(2,:)'; % Wall points 1 y
x2 = wallEndpoints(1,:)'; % Wall points 2 x
y2 = wallEndpoints(2,:)'; % Wall points 2 y

x3 = squeeze(lineSegments(1,1,:))'; % Wall points 1 x
y3 = squeeze(lineSegments(2,1,:))'; % Wall points 1 y
x4 = squeeze(lineSegments(1,2,:))'; % Wall points 2 x
y4 = squeeze(lineSegments(2,2,:))'; % Wall points 2 y

wl = [wallObjs.extent]'; % Wall lengths
wuv = [wallObjs.unitVector]; % Wall unit vectors
wuvx = wuv(1,:)'; % Wall unit vectors x component
wuvy = wuv(2,:)'; % Wall unit vectors x component

ll = sqrt(sum(([x4;y4] - [x3;y3]).^2,1)); % Line lengths
luv = ([x4;y4] - [x3;y3])./repmat(ll,2,1); % Line unit vectors
luvx = luv(1,:); % Line unit vectors x component
luvy = luv(2,:); % Line unit vectors y component

%% Intersection
% Dimension: 1-walls 2-lines
px = ((x1.*y2-y1.*x2)*(x3-x4) - (x1-x2)*(x3.*y4-y3.*x4)) ./ ...
    ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
px(abs(px) == inf) = nan; % Interesection points y component

py = ((x1.*y2-y1.*x2)*(y3-y4) - (y1-y2)*(x3.*y4-y3.*x4)) ./ ...
    ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
py(abs(py) == inf) = nan; % Interesection points y component

pw = cat(3,px,py) - repmat(cat(3,x1,y1),1,nLines); % Wall intersection point
pl = cat(3,px,py) - repmat(cat(3,x3,y3),nWalls,1); % Line intersection point

pwl = sum(pw.*repmat(cat(3,wuvx,wuvy),1,nLines),3); % Wall point length from wall origin
pll = sum(pl.*repmat(cat(3,luvx,luvy),nWalls,1),3); % Line point length from line origin

isInsectLogic = pwl >= 0 & pwl <= repmat(wl,1,nLines) & pll >= 0 & pll <= repmat(ll,nWalls,1);

%% Output
pointsX = nan(nWalls,nLines);
pointsY = nan(nWalls,nLines);
pointsX(isInsectLogic) = px(isInsectLogic);
pointsY(isInsectLogic) = py(isInsectLogic);

points = permute(cat(3,pointsX,pointsY),[3 1 2]);
angles = abs(pi/2 - acos(sum(repmat(cat(3,wuvx,wuvy),1,nLines) .* repmat(cat(3,luvx,luvy),nWalls,1),3)));
angles(~isInsectLogic) = nan;

%% Variables
% points = [];
% angles = [];
% 
% x1 = wallObj.position(1);
% y1 = wallObj.position(2);
% x2 = wallObj.endpoint(1);
% y2 = wallObj.endpoint(2);
% x3 = point1(1);
% y3 = point1(2);
% x4 = point2(1);
% y4 = point2(2);
% 
% %% Intersection
% px = ((x1*y2-y1*x2)*(x3-x4) - (x1-x2)*(x3*y4-y3*x4)) / ...
%     ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
% 
% py = ((x1*y2-y1*x2)*(y3-y4) - (y1-y2)*(x3*y4-y3*x4)) / ...
%     ((x1-x2)*(y3-y4) - (y1-y2)*(x3-x4));
% 
% if ~isnan(px) && ~isnan(py)
%     wl = wallObj.extent; % Length of wall
%     wu = wallObj.unitVector; % Unit vector of wall
%     pw = ([px;py] - [x1;y1]); % Intesection point of wall
%     
%     ll = norm(point2 - point1); % Length of line
%     lu = (point2 - point1)/ll; % Unit vector of line
%     pl = ([px;py] - point1);  % Intersection point of line
%     if (pw'*wu) >= 0 && (pw'*wu) <= wl && (pl'*lu) >= 0 && (pl'*lu) <= ll
%         points = [px;py];
%         angles = abs(pi/2 - acos(lu'*wu));
%     end
% end

end

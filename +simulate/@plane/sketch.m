function graphicsHandles = sketch(planeObjs,axisHandle,varargin)
% The "sketch" method draws the "planeObjs" in the given axis.
%
% SYNTAX:
%   planeObjs = planeObjs.sketch()
%   planeObjs = planeObjs.sketch(axisHandle)
%   planeObjs = planeObjs.sketch(axisHandle,'parameterName',parameterValue)
%
% INPUTS:
%   planeObjs - (simulate.plane)
%       Instances of the "simulate.plane" class with dimension 2.
%
%   axisHandle - (1 x 1 axis handle) [gca]
%       Handle to the axis that the "planeObjs" will be plotted in.
%
% OUTPUTS:
%   graphicsHandles - (? x 1 graphics handle)
%       Handle to line graphics object for the "planeObjs" that were just
%       plotted.
%
% NOTES:
%   All lineseries properties can be used with this method.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   17-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments
error(nargchk(1,inf,nargin))

% Apply default values
if nargin < 2, axisHandle = gca;
    cla(axisHandle,'reset');
    set(axisHandle,'DrawMode','fast');
end

% Check arguments for errors
assert(isa(planeObjs,'simulate.plane') && all([planeObjs.dimension] == 2),...
    'simulate:plane:sketch:planeObjs',...
    'Input argument "planeObjs" must be "simulate.plane" objects with dimension equal to 2.')

assert(ishghandle(axisHandle),...
    'simulate:plane:sketch:axisHandle',...
    'Input argument "axisHandle" must be a valid graphics handle.')

%% Parameters
lineLength = 10;
normLength = .5;

%% Sketch
nPlanes = numel(planeObjs);
set(axisHandle,'NextPlot','add')

%% Lines
xLines = nan(1,6*nPlanes);
yLines = nan(1,6*nPlanes);

for iPlane = 1:nPlanes
    pt1 = lineLength*[planeObjs(iPlane).direction(2);-planeObjs(iPlane).direction(1)] + planeObjs(iPlane).location;
    pt2 = -lineLength*[planeObjs(iPlane).direction(2);-planeObjs(iPlane).direction(1)] + planeObjs(iPlane).location;
    xLines(6*iPlane-5) = planeObjs(iPlane).location(1);
    yLines(6*iPlane-5) = planeObjs(iPlane).location(2);
    xLines(6*iPlane-4) = pt1(1);
    yLines(6*iPlane-4) = pt1(2);
    xLines(6*iPlane-2) = planeObjs(iPlane).location(1);
    yLines(6*iPlane-2) = planeObjs(iPlane).location(2);
    xLines(6*iPlane-1) = pt2(1);
    yLines(6*iPlane-1) = pt2(2);
end

graphicsHandles(1) = plot(axisHandle,xLines,yLines,...
    'k',...
    varargin{:});

%% Orthogonal direction
xY = nan(1,3*nPlanes);
yY = nan(1,3*nPlanes);

for iPlane = 1:nPlanes
    pt1 = normLength*planeObjs(iPlane).direction + planeObjs(iPlane).location;
    xY(3*iPlane-2) = planeObjs(iPlane).location(1);
    yY(3*iPlane-2) = planeObjs(iPlane).location(2);
    xY(3*iPlane-1) = pt1(1);
    yY(3*iPlane-1) = pt1(2);
end

graphicsHandles(2) = plot(axisHandle,xY,yY,...
    'g','lineWidth',2,...
    varargin{:});

%% Location Dots
xDots = nan(1,nPlanes);
yDots = nan(1,nPlanes);
for iPlane = 1:nPlanes
    xDots(iPlane) = planeObjs(iPlane).location(1);
    yDots(iPlane) = planeObjs(iPlane).location(2);
end

graphicsHandles(3) = plot(axisHandle,xDots,yDots,...
    'o',...
    'MarkerEdgeColor','g',...
    'MarkerFaceColor','g',...
    varargin{:});

%% Interception Dots
pts = intercept(planeObjs);
pts = squeeze(reshape(pts,1,nPlanes^2,2))';
pts = pts(:,~isnan(pts(1,:)));

graphicsHandles(4) = plot(axisHandle,pts(1,:),pts(2,:),...
    'o',...
    'MarkerEdgeColor','r',...
    'MarkerFaceColor','r',...
    varargin{:});

%% Axis limits
xmin = min(pts(1,:)) - normLength;
xmax = max(pts(1,:)) + normLength;
ymin = min(pts(2,:)) - normLength;
ymax = max(pts(2,:)) + normLength;

xlim([xmin xmax])
ylim([ymin ymax])

axis equal

%% Turn off legend components
for i = 1:length(graphicsHandles)
    set(get(get(graphicsHandles(i),'Annotation'),'LegendInformation'),'IconDisplayStyle','off')
end

%% Output handle if needed
if nargout == 0
    clear graphicsHandles
end

end

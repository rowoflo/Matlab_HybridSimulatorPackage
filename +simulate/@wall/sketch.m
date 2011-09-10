function graphicsHandles = sketch(wallObjs,axisHandle,varargin)
% The "sketch" method draws the "wallObjs" in the given axis.
%
% SYNTAX:
%   wallObjs = wallObjs.sketch()
%   wallObjs = wallObjs.sketch(axisHandle)
%   wallObjs = wallObjs.sketch(axisHandle,'parameterName',parameterValue)
%
% INPUTS:
%   wallObjs - (simulate.wall)
%       Instances of the "simulate.wall" class.
%
%   axisHandle - (1 x 1 axis handle) [gca]
%       Handle to the axis that the "wallObjs" will be plotted in.
%
% OUTPUTS:
%   graphicsHandles - (? x 1 graphics handle)
%       Handle to line graphics object for the "wallObjs" that were just
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
assert(isa(wallObjs,'simulate.wall'),...
    'simulate:wall:sketch:wallObjs',...
    'Input argument "wallObjs" must be "simulate.wall" objects.')

assert(ishghandle(axisHandle),...
    'simulate:wall:sketch:axisHandle',...
    'Input argument "axisHandle" must be a valid graphics handle.')

%% Plot
nWalls = numel(wallObjs);
x = nan(1,3*nWalls-1);
y = nan(1,3*nWalls-1);
for iWall = 1:nWalls
    x(3*iWall-2) = wallObjs(iWall).position(1);
    x(3*iWall-1) = wallObjs(iWall).endpoint(1);
    y(3*iWall-2) = wallObjs(iWall).position(2);
    y(3*iWall-1) = wallObjs(iWall).endpoint(2);
end

graphicsHandles = plot(axisHandle,x,y,varargin{:});

%% Output handle if needed
if nargout == 0
    clear graphicsHandles
end

end

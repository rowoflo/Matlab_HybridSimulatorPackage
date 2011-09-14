function sketch(systemObj,time,state,varargin)
% The "sketch" method will draw the system at either the given time and
% state or the current system object time and state in its sketch axis or create
% a new axis if it doesn't have one.
%
% SYNTAX:
%   systemObj.sketch()
%   systemObj.sketch(time)
%   systemObj.sketch(time,state)
%   systemObj.sketch(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number) [systemObj.time]
%       The time that the system will be drawn at.
%
%   state - (? x 1 real number) [systemObj.state]
%       The state that the system will be drawn in.
%
% PROPERTIES:
%
% NOTES:
%   "PropertyName" and "PropertyValue" pairs are passed on to the
%   "sketchGraphics" method.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   18-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Apply default values
if nargin < 2, time = systemObj.time; end
if nargin < 3, state = systemObj.state; end

% Check arguments for errors
assert(isa(systemObj,'simulate.system') && numel(systemObj) == 1,...
    'simulate:system:sketch:systemObj',...
    'Input argument "systemObj" must be a 1 x 1 simulate.system object.')

assert(isnumeric(time) && isreal(time) && isequal(size(time),[1,1]),...
    'simulate:system:sketch:time',...
    'Input argument "time" must be a 1 x 1 real number.')

assert(isnumeric(state) && isvector(state) && numel(state) == systemObj.nStates,...
    'simulate:system:sketch:state',...
    'Input argument "state" must be a %d x 1 real number.',systemObj.nStates)
state = state(:);

%% Initialize
% Create Figure
if isempty(systemObj.sketchFigureHandle) || ~ishghandle(systemObj.sketchFigureHandle)
    systemObj.sketchFigureHandle = figure;
    if ~isempty(systemObj.sketchFigureProperties)
        set(systemObj.sketchFigureHandle,systemObj.sketchFigureProperties{:});
    end
end

% Create Axis
if isempty(systemObj.sketchAxisHandle) || ~ishghandle(systemObj.sketchAxisHandle)
    % Create Axis
    figure(systemObj.sketchFigureHandle);
    systemObj.sketchAxisHandle = gca;
    set(systemObj.sketchAxisHandle,'DrawMode','normal')
    set(systemObj.sketchAxisHandle,'NextPlot','add')
    axis equal
    if ~isempty(systemObj.sketchAxisProperties)
        set(systemObj.sketchAxisHandle,systemObj.sketchAxisProperties{:});
    end
end
title(systemObj.sketchAxisHandle,[systemObj.name ' Sketch Plot (Time = ' num2str(time,'%.1f') ')'])

%% Sketch
systemObj.sketchGraphics(time,state,varargin{:});

end

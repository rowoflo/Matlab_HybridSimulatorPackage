function plotSketch(systemObj,time,state,varargin)
% The "plotSketch" method will draw the system at either the given time and
% state or the current system object time and state in its sketch axis or create
% a new axis if it doesn't have one.
%
% SYNTAX:
%   systemObj.plotSketch()
%   systemObj.plotSketch(time)
%   systemObj.plotSketch(time,state)
%   systemObj.plotSketch(...,'PropertyName',PropertyValue,...)
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
% SEE ALSO:
%   plot.m | plotInput.m | plotOutput.m | plotState.m | plotPhase.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 18-APR-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2 || isempty(time), time = systemObj.time; end
if nargin < 3 || isempty(state), state = systemObj.state; end

%% Initialize
% Create Figure
if isempty(systemObj.sketchFigureHandle) || ~ishghandle(systemObj.sketchFigureHandle) || isempty(systemObj.sketchAxisHandle) || ~ishghandle(systemObj.sketchAxisHandle)
    if isempty(systemObj.sketchFigureHandle)
        systemObj.sketchFigureHandle = figure;
    else
        figure(systemObj.sketchFigureHandle);
    end
    if ~isempty(systemObj.sketchFigureProperties)
        set(systemObj.sketchFigureHandle,systemObj.sketchFigureProperties{:});
    end
end

% Create Axis
if isempty(systemObj.sketchAxisHandle) || ~ishghandle(systemObj.sketchAxisHandle)
    % Create Axis
    figure(systemObj.sketchFigureHandle);
    systemObj.sketchAxisHandle = gca;
    cla(systemObj.sketchAxisHandle)
    set(systemObj.sketchAxisHandle,'DrawMode','normal')
    set(systemObj.sketchAxisHandle,'NextPlot','add')
    axis equal
    if ~isempty(systemObj.sketchAxisProperties)
        set(systemObj.sketchAxisHandle,systemObj.sketchAxisProperties{:});
    end
end
if ~isnan(time)
    title(systemObj.sketchAxisHandle,[systemObj.name ' Sketch Plot (Time = ' num2str(time,'%.1f') ')'])
end

%% Sketch
systemObj.sketch(state,time,varargin{:});

end

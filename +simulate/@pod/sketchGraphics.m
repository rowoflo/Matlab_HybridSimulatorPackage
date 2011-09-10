function sketchGraphics(podObj,time,state,varargin)
% The "sketchGraphics" method will draw the pod at either the given time and
% state or the current pod object time and state in its sketch axis or create
% a new axis if it doesn't have one.
%
% SYNTAX:
%   podObj.sketchGraphics()
%   podObj.sketchGraphics(time)
%   podObj.sketchGraphics(time,state)
%   podObj.sketchGraphics(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   podObj - (1 x 1 simulate.pod)
%       An instance of the "simulate.pod" class.
%
%   time - (1 x 1 real number) [podObj.time] 
%       The time that the pod will be drawn at.
%
%   state - (? x 1 real number) [podObj.state] 
%       The state that the pod will be drawn in.
%    
% PROPERTIES:
%
% NOTES:
%   Use line properties for "PropertyName" and "PropertyValue" pairs.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   25-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Apply default values
if nargin < 2, time = podObj.time; end
if nargin < 3, state = podObj.state; end

% Check arguments for errors
assert(isa(podObj,'simulate.pod') && numel(podObj) == 1,...
    'simulate:pod:sketchGraphics:podObj',...
    'Input argument "podObj" must be a 1 x 1 simulate.pod object.')

assert(isnumeric(time) && isreal(time) && isequal(size(time),[1,1]),...
    'simulate:pod:sketchGraphics:time',...
    'Input argument "time" must be a 1 x 1 real number.')

assert(isnumeric(state) && isvector(state) && numel(state) == podObj.nStates,...
    'simulate:pod:sketchGraphics:state',...
    'Input argument "state" must be a %d x 1 real number.',podObj.nStates)
state = state(:);

%% Parameters
r = podObj.r;

podColor = 'k';
nVertices = 128;

noseLength = 2*r;

%% Variables
x = state(1);
y = state(2);
theta = state(3);

xG = podObj.goalState(1);
yG = podObj.goalState(2);

%% Initialize Sketch
if isempty(podObj.localMapGraphicsHandle) || ~ishghandle(podObj.localMapGraphicsHandle)
    
    % Create static objects
    podObj.localMapGraphicsHandle = ...
        podObj.localMap.sketch(podObj.sketchAxisHandle,...
        podObj.localMapGraphicsProperties{:},varargin{:});
    
    plot(podObj.sketchAxisHandle,xG,yG,'xr','MarkerSize',15,'LineWidth',3);
    
    xlabel(podObj.sketchAxisHandle,'x')
    ylabel(podObj.sketchAxisHandle,'y')
    
    if ~isempty(varargin)
        set(podObj.sketchGraphicsHandle,varargin{:});
    end 
    
end


%% Update Sketch
if isempty(podObj.sketchGraphicsHandle) || ...
        ~ismember(podObj.sketchGraphicsHandle(1,1),get(podObj.sketchAxisHandle,'Children'))
    
    % Create dynamic objects
    podObj.sketchGraphicsHandle(1,1) = patch('Parent',podObj.sketchAxisHandle,...
        'XData',x+r*cos(2*pi*(0:nVertices-1)/nVertices),...
        'YData',y+r*sin(2*pi*(0:nVertices-1)/nVertices),...
        'FaceColor',podColor,...
        'EdgeColor','k',...
        'LineWidth',1);
    
    if ~isempty(varargin)
        set(podObj.sketchGraphicsHandle(1,1),varargin{:});
    end
    
else
    
    % Update dynamic objects
    set(podObj.sketchGraphicsHandle(1,1),...
        'XData',x+r*cos(2*pi*(0:nVertices-1)/nVertices),...
        'YData',y+r*sin(2*pi*(0:nVertices-1)/nVertices));
    
end

if isempty(podObj.sketchGraphicsHandle) || numel(podObj.sketchGraphicsHandle) < 2 || ...
        any(~ismember(podObj.sketchGraphicsHandle(2,1),get(podObj.sketchAxisHandle,'Children')))
    
    % Create dynamic objects
    podObj.sketchGraphicsHandle(2,1) = line('Parent',podObj.sketchAxisHandle,...
        'XData',[x x+noseLength*cos(theta)],...
        'YData',[y y+noseLength*sin(theta)],...
        'Color',podColor,...
        'LineWidth',2);
    
    if ~isempty(varargin)
        set(podObj.sketchGraphicsHandle(2,1),varargin{:});
    end
    
else
    
    % Update dynamic objects
     set(podObj.sketchGraphicsHandle(2,1),...
        'XData',[x x+noseLength*cos(theta)],...
        'YData',[y y+noseLength*sin(theta)]);
    
end


end

function sketchGraphics(puckObj,time,state,varargin)
% The "sketchGraphics" method will draw the puck at either the given time and
% state or the current puck object time and state in its sketch axis or create
% a new axis if it doesn't have one.
%
% SYNTAX:
%   puckObj.sketchGraphics()
%   puckObj.sketchGraphics(time)
%   puckObj.sketchGraphics(time,state)
%   puckObj.sketchGraphics(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   puckObj - (1 x 1 simulate.puck)
%       An instance of the "simulate.puck" class.
%
%   time - (1 x 1 real number) [puckObj.time] 
%       The time that the puck will be drawn at.
%
%   state - (? x 1 real number) [puckObj.state] 
%       The state that the puck will be drawn in.
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
if nargin < 2, time = puckObj.time; end
if nargin < 3, state = puckObj.state; end

% Check arguments for errors
assert(isa(puckObj,'simulate.puck') && numel(puckObj) == 1,...
    'simulate:puck:sketchGraphics:puckObj',...
    'Input argument "puckObj" must be a 1 x 1 simulate.puck object.')

assert(isnumeric(time) && isreal(time) && isequal(size(time),[1,1]),...
    'simulate:puck:sketchGraphics:time',...
    'Input argument "time" must be a 1 x 1 real number.')

assert(isnumeric(state) && isvector(state) && numel(state) == puckObj.nStates,...
    'simulate:puck:sketchGraphics:state',...
    'Input argument "state" must be a %d x 1 real number.',puckObj.nStates)
state = state(:);

%% Parameters
r = puckObj.r;

puckColor = 'k';
nVertices = 128;

%% Variables
x = state(1);
y = state(2);

xG = puckObj.goalState(1);
yG = puckObj.goalState(2);

%% Initialize Sketch
if isempty(puckObj.sketchGraphicsHandle) || ~ishghandle(puckObj.sketchGraphicsHandle)
    
    % Create static objects
    puckObj.localMapGraphicsHandle = ...
        puckObj.localMap.sketch(puckObj.sketchAxisHandle,...
        puckObj.localMapGraphicsProperties{:},varargin{:});
    
    plot(puckObj.sketchAxisHandle,xG,yG,'xr','MarkerSize',15,'LineWidth',3);
    
    xlabel(puckObj.sketchAxisHandle,'x')
    ylabel(puckObj.sketchAxisHandle,'y')
    
    if ~isempty(varargin)
        set(puckObj.sketchGraphicsHandle,varargin{:});
    end 
    
end


%% Update Sketch
if isempty(puckObj.sketchGraphicsHandle) || ...
        ~ismember(puckObj.sketchGraphicsHandle,get(puckObj.sketchAxisHandle,'Children'))
    
    % Create dynamic objects
    puckObj.sketchGraphicsHandle = patch('Parent',puckObj.sketchAxisHandle,...
        'XData',x+r*cos(2*pi*(0:nVertices-1)/nVertices),...
        'YData',y+r*sin(2*pi*(0:nVertices-1)/nVertices),...
        'FaceColor',puckColor,...
        'EdgeColor','k',...
        'LineWidth',1);
    if ~isempty(varargin)
        set(puckObj.sketchGraphicsHandle,varargin{:});
    end
    
else
    
    % Update dynamic objects
    set(puckObj.sketchGraphicsHandle,...
        'XData',x+r*cos(2*pi*(0:nVertices-1)/nVertices),...
        'YData',y+r*sin(2*pi*(0:nVertices-1)/nVertices));
    
end

end

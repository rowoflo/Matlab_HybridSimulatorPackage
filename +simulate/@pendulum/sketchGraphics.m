function sketchGraphics(pendulumObj,state,time,varargin)
% The "sketchGraphics" method will draw the system at a given time and
% state in the sketch axis or create a new axis if it doesn't have one.
%
% SYNTAX:
%   pendulumObj.sketchGraphics()
%   pendulumObj.sketchGraphics(state)
%   pendulumObj.sketchGraphics(state,time)
%   pendulumObj.sketchGraphics(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.pendulum)
%       An instance of the "simulate.pendulum" class.
%
%   state - (? x 1 real number) [pendulumObj.state] 
%       The state that the pendulum will be drawn in.
%
%   time - (1 x 1 real number) [pendulumObj.time] 
%       The time that the pendulum will be drawn at.
%    
% PROPERTIES:
%
% NOTES:
%   Use line properties for "PropertyName" and "PropertyValue" pairs.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate, +simulate
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 23-OCT-2011
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2 || isempty(state), state = pendulumObj.state; end
if nargin < 3 || isempty(time), time = pendulumObj.time; end

%% Parameters
w = pendulumObj.w;
l = pendulumObj.l;

triEdgeLength = .15;
triColor = 'r';
pendulumColor = 'b';

%% Variables
theta = state(1);

%% Initialize Sketch
if isempty(pendulumObj.sketchGraphicsHandles) || all(~ishghandle(pendulumObj.sketchGraphicsHandles))
    
    % Set axis limits
    xlim(1.5*[-l,l])
    ylim(1.5*[-l,l])
    
    % Create static objects
    triangleHandle = patch('Parent',pendulumObj.sketchAxisHandle,...
        'XData',...
        [0;...
        triEdgeLength/2;...
        -triEdgeLength/2],...
        'YData',...
        [triEdgeLength/2/cosd(30);...
        -triEdgeLength/2*cosd(30);...
        -triEdgeLength/2*cosd(30)],...
        'FaceColor',triColor,...
        'EdgeColor','k',...
        'LineWidth',2); %#ok<NASGU>
    
    if ~isempty(varargin)
        set(pendulumObj.sketchGraphicsHandles,varargin{:});
    end 
    
    pendulumObj.sketchGraphicsHandles = [];
end


%% Update Sketch
if isempty(pendulumObj.sketchGraphicsHandles) || ...
        any(~ismember(pendulumObj.sketchGraphicsHandles,get(pendulumObj.sketchAxisHandle,'Children')))
    
    % Create dynamic objects
    pendulumObj.sketchGraphicsHandles = patch('Parent',pendulumObj.sketchAxisHandle,...
        'XData',...
        [-w/2*cos(theta);...
        w/2*cos(theta); ...
        sqrt((w/2)^2+l^2)*sin(theta + atan((w/2)/l));...
        sqrt((w/2)^2+l^2)*sin(theta - atan((w/2)/l))],...
        'YData',...
        [-w/2*sin(theta);...
        w/2*sin(theta);...
        -sqrt((w/2)^2+l^2)*cos(theta + atan((w/2)/l));...
        -sqrt((w/2)^2+l^2)*cos(theta - atan((w/2)/l))],...
        'FaceColor',pendulumColor,...
        'EdgeColor','k',...
        'LineWidth',2);   
    
    if ~isempty(varargin)
        set(pendulumObj.sketchGraphicsHandles,varargin{:});
    end
    
else
    
    % Update dynamic objects
    set(pendulumObj.sketchGraphicsHandles,...
        'XData',...
        [-w/2*cos(theta);...
        w/2*cos(theta); ...
        sqrt((w/2)^2+l^2)*sin(theta + atan((w/2)/l));...
        sqrt((w/2)^2+l^2)*sin(theta - atan((w/2)/l))],...
        'YData',...
        [-w/2*sin(theta);...
        w/2*sin(theta);...
        -sqrt((w/2)^2+l^2)*cos(theta + atan((w/2)/l));...
        -sqrt((w/2)^2+l^2)*cos(theta - atan((w/2)/l))]);
end

end

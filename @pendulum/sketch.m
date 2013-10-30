function sketch(pendulumObj,state,~,~,~,varargin)
% The "sketch" method will draw the system at a given time and
% state in the sketch axis or create a new axis if it doesn't have one.
%
% SYNTAX:
%   pendulumObj.sketch()
%   pendulumObj.sketch(state)
%   pendulumObj.sketch(state,stateTape,time,timeTape)
%   pendulumObj.sketch(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.pendulum)
%       An instance of the "simulate.pendulum" class.
%
%   state - (nStates x 1 real number) [pendulumObj.state]
%       The state that the system will be drawn in.
%
%   stateTape - (nStates x ? number) []
%       The state tape used for plotting.
%
%   time - (1 x 1 real number) [pendulumObj.time]
%       The time that the system will be drawn at.
%
%   timeTape - (1 x ? real number) []
%       The time tape used for plotting the state path.
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
if nargin < 2, state = pendulumObj.state; end
% if nargin < 3, stateTape = zeros(pendulumObj.nStates,0); end
% if nargin < 4, time = pendulumObj.time; end
% if nargin < 5, timeTape = zeros(1,0); end

%% Parameters
w = pendulumObj.w;
l = pendulumObj.l;

theta0 = 0;
triEdgeLength = .15;
triColor = 'r';
pendulumColor = 'b';

%% Variables
theta = state(1);
Rz = makehgtform('zrotate',theta);

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
    h = patch('Parent',pendulumObj.sketchAxisHandle,...
        'XData',...
        [-w/2*cos(theta0);...
        w/2*cos(theta0); ...
        sqrt((w/2)^2+l^2)*sin(theta0 + atan((w/2)/l));...
        sqrt((w/2)^2+l^2)*sin(theta0 - atan((w/2)/l))],...
        'YData',...
        [-w/2*sin(theta0);...
        w/2*sin(theta0);...
        -sqrt((w/2)^2+l^2)*cos(theta0 + atan((w/2)/l));...
        -sqrt((w/2)^2+l^2)*cos(theta0 - atan((w/2)/l))],...
        'FaceColor',pendulumColor,...
        'EdgeColor','k',...
        'LineWidth',2);
    
    pendulumObj.sketchGraphicsHandles(1) = hgtransform('Parent',pendulumObj.sketchAxisHandle);
    set(h,'Parent',pendulumObj.sketchGraphicsHandles(1));
    set(pendulumObj.sketchGraphicsHandles(1),'Matrix',Rz);
    
    if ~isempty(varargin)
        set(pendulumObj.sketchGraphicsHandles,varargin{:});
    end
    
else
    
    % Update dynamic objects
    set(pendulumObj.sketchGraphicsHandles(1),'Matrix',Rz);
    
end

end

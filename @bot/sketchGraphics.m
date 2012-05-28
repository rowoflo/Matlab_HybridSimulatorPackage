function sketchGraphics(botObj,time,state,varargin)
% The "sketchGraphics" method will draw the bot at either the given time and
% state or the current bot object time and state in its sketch axis or create
% a new axis if it doesn't have one.
%
% SYNTAX:
%   botObj.sketchGraphics()
%   botObj.sketchGraphics(time)
%   botObj.sketchGraphics(time,state)
%   botObj.sketchGraphics(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   botObj - (1 x 1 simulate.bot)
%       An instance of the "simulate.bot" class.
%
%   time - (1 x 1 real number) [botObj.time] 
%       The time that the bot will be drawn at.
%
%   state - (? x 1 real number) [botObj.state] 
%       The state that the bot will be drawn in.
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
if nargin < 2, time = botObj.time; end
if nargin < 3, state = botObj.state; end

% Check arguments for errors
assert(isa(botObj,'simulate.bot') && numel(botObj) == 1,...
    'simulate:bot:sketchGraphics:botObj',...
    'Input argument "botObj" must be a 1 x 1 simulate.bot object.')

assert(isnumeric(time) && isreal(time) && isequal(size(time),[1,1]),...
    'simulate:bot:sketchGraphics:time',...
    'Input argument "time" must be a 1 x 1 real number.')

assert(isnumeric(state) && isvector(state) && numel(state) == botObj.nStates,...
    'simulate:bot:sketchGraphics:state',...
    'Input argument "state" must be a %d x 1 real number.',botObj.nStates)
state = state(:);

%% Parameters
% Common
lineWidth = 4;
defaultEdgeColor = [0 0 0];


% Body
bodyWidth = botObj.w;
bodyLength = botObj.l;

body = [...
     bodyLength/2  bodyWidth/2;...
    -bodyLength/2  bodyWidth/2;...
    -bodyLength/2 -bodyWidth/2;...
     bodyLength/2 -bodyWidth/2]';
 
bodyColor = [.7 .7 .7];
bodyFrontEdgeColor = [0 1 0];
bodyBackEdgeColor = [1 0 0];

% Center
center = 1/12*[...
     min(bodyLength,bodyWidth) 0;...
     0 min(bodyLength,bodyWidth);...
    -min(bodyLength,bodyWidth) 0;...
     0 -min(bodyLength,bodyWidth)]';
 
centerColor = 'y';

% Wheels
wheelRadiusRight = botObj.wrr;
wheelRadiusLeft = botObj.wrl;

wheelWidth = .25;

wheelRight = [...
     wheelRadiusRight  wheelWidth/2;...
    -wheelRadiusRight  wheelWidth/2;...
    -wheelRadiusRight -wheelWidth/2;...
     wheelRadiusRight -wheelWidth/2]' + repmat([0;-bodyWidth/2],1,4);
    

wheelLeft = [...
     wheelRadiusLeft  wheelWidth/2;...
    -wheelRadiusLeft  wheelWidth/2;...
    -wheelRadiusLeft -wheelWidth/2;...
     wheelRadiusLeft -wheelWidth/2]' + repmat([0;bodyWidth/2],1,4);
 
wheelColor = [0 0 0];

%% Variables
x = state(1);
y = state(2);
theta = state(3);

R = [cos(theta) -sin(theta); sin(theta) cos(theta)];

% xG = botObj.goalState(1);
% yG = botObj.goalState(2);

%% Points and colors
% Body
bodyPts = R * body;

bodyEdgeColors = repmat(defaultEdgeColor,size(body,2),1);
bodyEdgeColors(1,:) = bodyFrontEdgeColor;
bodyEdgeColors(3,:) = bodyBackEdgeColor;

bodyXData = x + bodyPts(1,:)';
bodyYData = y + bodyPts(2,:)';

bodyCData = permute(bodyEdgeColors,[1 3 2]);


% Center
centerPts = R * center;

centerXData = x + centerPts(1,:)';
centerYData = y + centerPts(2,:)';

% Wheels
rightWheelPts = R * wheelRight;
leftWheelPts = R * wheelLeft;

wheelRightXData = x + rightWheelPts(1,:)';
wheelRightYData = y + rightWheelPts(2,:)';

wheelLeftXData = x + leftWheelPts(1,:)';
wheelLeftYData = y + leftWheelPts(2,:)';

%% Initialize Sketch
if isempty(botObj.sketchGraphicsHandles) || all(~ishghandle(botObj.sketchGraphicsHandles))
    
    % Create static objects
    % plot(botObj.sketchAxisHandle,xG,yG,'xr','MarkerSize',15,'LineWidth',3);
    
    xlabel(botObj.sketchAxisHandle,'x')
    ylabel(botObj.sketchAxisHandle,'y')
    
    if ~isempty(varargin)
        set(botObj.sketchGraphicsHandles,varargin{:});
    end 
    
    botObj.sketchGraphicsHandles = [];
end


%% Update Sketch
if isempty(botObj.sketchGraphicsHandles) || ...
        any(~ismember(botObj.sketchGraphicsHandles,get(botObj.sketchAxisHandle,'Children')))
    
    % Create dynamic objects
    
    % Bot body
    botObj.sketchGraphicsHandles(1) = patch('Parent',botObj.sketchAxisHandle,...
        'XData',bodyXData,...
        'YData',bodyYData,...
        'CData',bodyCData,...
        'FaceColor',bodyColor,...
        'LineWidth',lineWidth,...
        'EdgeColor','flat');
    
    % Bot center
    botObj.sketchGraphicsHandles(2) = patch('Parent',botObj.sketchAxisHandle,...
        'XData',centerXData,...
        'YData',centerYData,...
        'FaceColor',centerColor,...
        'LineWidth',lineWidth,...
        'EdgeColor',defaultEdgeColor);
    
    % Bot right wheel
    botObj.sketchGraphicsHandles(4) = patch('Parent',botObj.sketchAxisHandle,...
        'XData',wheelRightXData,...
        'YData',wheelRightYData,...
        'FaceColor',wheelColor,...
        'LineWidth',lineWidth,...
        'EdgeColor',defaultEdgeColor);
    
    % Bot left wheel
    botObj.sketchGraphicsHandles(3) = patch('Parent',botObj.sketchAxisHandle,...
        'XData',wheelLeftXData,...
        'YData',wheelLeftYData,...
        'FaceColor',wheelColor,...
        'LineWidth',lineWidth,...
        'EdgeColor',defaultEdgeColor);
    
    
    if ~isempty(varargin)
        set(botObj.sketchGraphicsHandles,varargin{:});
    end
    
else
    
    % Update dynamic objects
    
    % Bot body
    set(botObj.sketchGraphicsHandles(1),...
        'XData',bodyXData,...
        'YData',bodyYData);
    
    % Bot center
    set(botObj.sketchGraphicsHandles(2),...
        'XData',centerXData,...
        'YData',centerYData);
    
    % Bot right wheel
    set(botObj.sketchGraphicsHandles(4),...
        'XData',wheelRightXData,...
        'YData',wheelRightYData);
    
    % Bot left wheel
    set(botObj.sketchGraphicsHandles(3),...
        'XData',wheelLeftXData,...
        'YData',wheelLeftYData);
    
end

end

function sketchGraphics(SYSTEM_NAMEObj,time,state,varargin)
% The "sketchGraphics" method will draw the system at a given time and
% state in the sketch axis or create a new axis if it doesn't have one.
%
% SYNTAX:
%   SYSTEM_NAMEObj.sketchGraphics()
%   SYSTEM_NAMEObj.sketchGraphics(time)
%   SYSTEM_NAMEObj.sketchGraphics(time,state)
%   SYSTEM_NAMEObj.sketchGraphics(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 simulate.SYSTEM_NAME)
%       An instance of the "simulate.SYSTEM_NAME" class.
%
%   time - (1 x 1 real number) [SYSTEM_NAMEObj.time] 
%       The time that the SYSTEM_NAME will be drawn at.
%
%   state - (? x 1 real number) [SYSTEM_NAMEObj.state] 
%       The state that the SYSTEM_NAME will be drawn in.
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
%   DD-MMM-YYYY by FULL_NAME
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Apply default values
if nargin < 2, time = SYSTEM_NAMEObj.time; end
if nargin < 3, state = SYSTEM_NAMEObj.state; end

%% Parameters


%% Variables


%% Initialize Sketch
if isempty(SYSTEM_NAMEObj.sketchGraphicsHandles) || all(~ishghandle(SYSTEM_NAMEObj.sketchGraphicsHandles))
    
    % Create static objects
    % plot(SYSTEM_NAMEObj.sketchAxisHandle,...);
    
    if ~isempty(varargin)
        set(SYSTEM_NAMEObj.sketchGraphicsHandles,varargin{:});
    end 
    
    SYSTEM_NAMEObj.sketchGraphicsHandles = [];
end


%% Update Sketch
if isempty(SYSTEM_NAMEObj.sketchGraphicsHandles) || ...
        any(~ismember(SYSTEM_NAMEObj.sketchGraphicsHandles,get(SYSTEM_NAMEObj.sketchAxisHandle,'Children')))
    
    % Create dynamic objects
    SYSTEM_NAMEObj.sketchGraphicsHandles(1) = plot(SYSTEM_NAMEObj.sketchAxisHandle,...
        SYSTEM_NAMEObj.state(1),0);    
    
    if ~isempty(varargin)
        set(SYSTEM_NAMEObj.sketchGraphicsHandles,varargin{:});
    end
    
else
    
    % Update dynamic objects
    set(SYSTEM_NAMEObj.sketchGraphicsHandles(1),...
        'XData',SYSTEM_NAMEObj.state(1));
end

end

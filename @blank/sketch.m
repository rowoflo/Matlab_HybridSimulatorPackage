function sketch(blankObj,state,time,varargin)
% The "sketch" method will draw the system at a given time and
% state in the sketch axis or create a new axis if it doesn't have one.
%
% SYNTAX:
%   blankObj.sketch()
%   blankObj.sketch(state)
%   blankObj.sketch(state,time)
%   blankObj.sketch(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   blankObj - (1 x 1 simulate.blank)
%       An instance of the "simulate.blank" class.
%
%   state - (1 x 1 real number) [blankObj.state] 
%       The state that the blank will be drawn in.
%
%   time - (1 x 1 real number) [blankObj.time] 
%       The time that the blank will be drawn at.
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
%   Created 21-OCT-2013
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2 || isempty(state), state = blankObj.state; end
if nargin < 3 || isempty(time), time = blankObj.time; end

%% Parameters


%% Variables


%% Initialize Sketch
if isempty(blankObj.sketchGraphicsHandles) || all(~ishghandle(blankObj.sketchGraphicsHandles))
    
    % Create static objects
    % plot(blankObj.sketchAxisHandle,...);
    
    if ~isempty(varargin)
        set(blankObj.sketchGraphicsHandles,varargin{:});
    end 
    
    blankObj.sketchGraphicsHandles = [];
end


%% Update Sketch
if isempty(blankObj.sketchGraphicsHandles) || ...
        any(~ismember(blankObj.sketchGraphicsHandles,get(blankObj.sketchAxisHandle,'Children')))
    
    % Create dynamic objects
    blankObj.sketchGraphicsHandles(1) = plot(blankObj.sketchAxisHandle,...
        blankObj.state(1),0);    
    
    if ~isempty(varargin)
        set(blankObj.sketchGraphicsHandles,varargin{:});
    end
    
else
    
    % Update dynamic objects
    set(blankObj.sketchGraphicsHandles(1),...
        'XData',blankObj.state(1));
end

end

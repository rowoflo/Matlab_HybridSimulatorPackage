function replay(systemObj,varargin)
% The "replay" method replays the tapes stored in "systemObj". The plots
% that are replayed depend on the flags set in the "systemObj".
%
% SYNTAX:
%   systemObj = systemObj.replay('PropertyName',PropertyValue,...)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
% PROPERTIES:
%   'movieFile' - (string) ['']
%       If not empty and "systemObj.graphicsFlag" is true a movie of the
%       replay will be saved to the specified file.
%
% OUTPUTS:
%
% NOTES:
%   Currently movie will only record the sketch graphics.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   simulate.m | run.m | policy.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 27-APR-2011
%-------------------------------------------------------------------------------

%% Check Input Arguments
% Apply default values
if nargin < 2, movieFile = ''; end

% Check arguments for errors
assert(isa(systemObj,'simulate.system') && numel(systemObj) == 1,...
    'simulate:system:replay:systemObj',...
    'Input argument "systemObj" must be a 1 x 1 simulate.system object.')

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'system:replay:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('movieFile')
            movieFile = propValues{iParam};
        otherwise
            error('simulate:system:replay:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('movieFile','var'), movieFile = ''; end

% Check property values for errors
assert(ischar(movieFile),...
    'simulate:system:replay:movieFile',...
    'Property "movieFile" must be a string.')
if isempty(movieFile)
    movieFlag = false;
else
    movieFlag = true;
end

%% Parameters
movieFrameRate = 20; % TODO: Add these paramerters to input
movieQuality = 80;
movieHandle = get(systemObj.sketchAxisHandle,'Parent'); % TODO: Make movie record all figures

%% Variables
t = [systemObj.timeTape systemObj.time];
x = [systemObj.stateTape systemObj.state];
u = [systemObj.inputTape nan(systemObj.nInputs,1)];
y = [systemObj.outputTape nan(systemObj.nOutputs,1)];

%% Initialize
iT = 1;
if systemObj.plotStateFlag
    systemObj.plotState(t(1,iT),x(:,iT),t(1,1:iT-1),x(:,1:iT-1),'LegendFlag',false);
end
if systemObj.plotInputFlag
    systemObj.plotInput(t(1,iT),t(1,1:iT-1),u(:,1:iT-1),'LegendFlag',false);
end
if systemObj.plotOutputFlag
    systemObj.plotOutput(t(1,iT),t(1,1:iT-1),y(:,1:iT-1),'LegendFlag',false);
end
if systemObj.sketchFlag
    systemObj.sketch(t(1,iT),x(:,iT));
end
if systemObj.phaseFlag
    systemObj.phase(x(:,iT),x(:,1:iT-1),'LegendFlag',false);
end

if movieFlag
    vidObj = VideoWriter(movieFile);
    vidObj.Quality = movieQuality;
    vidObj.FrameRate = movieFrameRate;
    open(vidObj);
    
    currFrame = getframe(movieHandle);
    writeVideo(vidObj,currFrame);
end

%% Loop
for iT = 1:length(t)
    if systemObj.plotStateFlag
        systemObj.plotState(t(1,iT),x(:,iT),t(1,1:iT-1),x(:,1:iT-1),'LegendFlag',false);
    end
    if systemObj.plotInputFlag
        systemObj.plotInput(t(1,iT),t(1,1:iT-1),u(:,1:iT-1),'LegendFlag',false);
    end
    if systemObj.plotOutputFlag
        systemObj.plotOutput(t(1,iT),t(1,1:iT-1),y(:,1:iT-1),'LegendFlag',false);
    end
    if systemObj.sketchFlag
        systemObj.sketch(t(1,iT),x(:,iT));
    end
    if systemObj.phaseFlag
        systemObj.phase(x(:,iT),x(:,1:iT-1),'LegendFlag',false);
    end
    
    drawnow
    
    if movieFlag
        currFrame = getframe(movieHandle);
        writeVideo(vidObj,currFrame);
    end
end


%% End
if systemObj.plotStateFlag
    systemObj.plotState([],[],[],[],'LegendFlag',true);
end
if systemObj.plotInputFlag
    systemObj.plotInput([],[],[],'LegendFlag',true);
end
if systemObj.plotOutputFlag
    systemObj.plotOutput([],[],[],'LegendFlag',true);
end
if systemObj.phaseFlag
    systemObj.phase([],[],'LegendFlag',true);
end

if movieFlag
    currFrame = getframe(movieHandle);
    writeVideo(vidObj,currFrame);
    close(vidObj)
    fprintf(1,'Movie:\n');
    fprintf(1,'\tQuality: %d\n',movieQuality);
    fprintf(1,'\tFrame Rate: %d\n',movieFrameRate);
    fprintf(1,'\tSaved to: %s\n\n',movieFile);
end

end

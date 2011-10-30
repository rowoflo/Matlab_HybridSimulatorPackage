function run(systemObj,duration,varargin)
%   The "run" method will run the system forward in time from its current
%   time and state for a length of time of "duration" as a continuous
%   system but sample with a time step size of "systemObj.timeStep".
%
% SYNTAX:
%   systemObj.run(duration)
%   systemObj.simulate(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   duration - (1 x 1 semi-positive real number)
%       The length of time the run last. Must be a integer mulitple of
%       "systemObj.timeStep".
%
% PROPERTIES:
%   'movieFile' - (string) ['']
%       If not empty and "systemObj.graphicsFlag" is true a movie of the
%       simulation will be saved to the specified file.
%
% OUTPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class with update properties.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   simulate.m | replay.m | policy.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 19-APR-2011
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments
error(nargchk(2,inf,nargin))

% Check arguments for errors
assert(isa(systemObj,'simulate.system') && numel(systemObj) == 1,...
    'simulate:system:run:systemObj',...
    'Input argument "systemObj" must be a 1 x 1 simulate.system object.')

assert(isnumeric(duration) && isreal(duration) && isequal(size(duration),[1,1]) && duration >= systemObj.timeStep,...
    'simulate:system:run:duration',...
    'Input argument "duration" must be a 1 x 1 semi-positive real number and greater than or equal to %f.',systemObj.timeStep)

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'system:run:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('movieFile')
            movieFile = propValues{iParam};
        otherwise
            error('simulate:system:run:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('movieFile','var'), movieFile = ''; end

% Check property values for errors
assert(ischar(movieFile),...
    'simulate:system:run:movieFile',...
    'Property "movieFile" must be a string.')

%% Initialize
t0 = systemObj.time;
tFinal = t0 + duration;
timeInterval = [t0 tFinal];

%% Simulate
[timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape] = ...
    simulate(systemObj,timeInterval,systemObj.state,systemObj.flowTime,systemObj.jumpCount,'movieFile',movieFile);

%% Update
systemObj.time = timeTapeC(1,end);
systemObj.state = stateTape(:,end);
systemObj.flowTime = flowTimeTape(1,end);
systemObj.jumpCount = jumpCountTape(1,end);

systemObj.timeTapeC = [systemObj.timeTapeC timeTapeC];
systemObj.timeTapeD = [systemObj.timeTapeD timeTapeD];
systemObj.stateTape = [systemObj.stateTape stateTape];
systemObj.inputTape = [systemObj.inputTape inputTape];
systemObj.outputTape = [systemObj.outputTape outputTape];
systemObj.flowTimeTape = [systemObj.flowTimeTape flowTimeTape];
systemObj.jumpCountTape = [systemObj.jumpCountTape jumpCountTape];

end

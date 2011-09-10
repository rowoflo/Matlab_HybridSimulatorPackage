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
% AUTHOR:
%   19-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments
error(nargchk(2,inf,nargin))

% Check arguments for errors
assert(isa(systemObj,'simulate.system') && numel(systemObj) == 1,...
    'simulate:system:run:systemObj',...
    'Input argument "systemObj" must be a 1 x 1 simulate.system object.')

assert(isnumeric(duration) && isreal(duration) && isequal(size(duration),[1,1]) && duration >= 0 && mod(duration,systemObj.timeStep) == 0,...
    'simulate:system:run:duration',...
    'Input argument "duration" must be a 1 x 1 semi-positive real number and be an integer mulitple of %f.',systemObj.timeStep)

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
dt = systemObj.timeStep;
t0 = systemObj.time;
tFinal = t0 + duration;
timeVector = t0:dt:tFinal;

%% Simulate
[timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape] = ...
    simulate(systemObj,timeVector,systemObj.state,0,0,'movieFile',movieFile);

%% Update
systemObj.time = timeTapeC(1,end);
systemObj.state = stateTape(:,end);
systemObj.flowTime = flowTimeTape(1,end);
systemObj.jumpCount = jumpCountTape(1,end);

systemObj.timeTapeC = [systemObj.timeTapeC timeTapeC(1,1:end-1)];
systemObj.timeTapeD = [systemObj.timeTapeD timeTapeD(1,1:end-1)];
systemObj.stateTape = [systemObj.stateTape stateTape(:,1:end-1)];
systemObj.inputTape = [systemObj.inputTape inputTape(:,1:end-1)];
systemObj.outputTape = [systemObj.outputTape outputTape(:,1:end-1)];
systemObj.flowTimeTape = [systemObj.flowTimeTape flowTimeTape(:,1:end-1)];
systemObj.jumpCountTape = [systemObj.jumpCountTape jumpCountTape(:,1:end-1)];

end

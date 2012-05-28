%% pendulumTest.m
% The "pendulumTest" script is used to test the
% "simulate.pendulum" system class.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate, +simulate, @pendulum
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 23-OCT-2011
%-------------------------------------------------------------------------------

%% Clear
ccc

%% Load


%% Initialize
duration = 10;

% System parameters
x0 = [pi+.1;0];

% Create System
S = simulate.pendulum(x0);
timeInterval = [S.time, S.time + duration];
initialState = S.state;

%% Set up graphics
S.graphicsFlag = true;
S.plotStateFlag = true;
S.plotInputFlag = true;
S.plotOutputFlag = true;
S.plotSketchFlag = true;
S.plotPhaseFlag = true;

S.stateFigureProperties = {'Position', [1   420   480   387]};
S.inputFigureProperties = {'Position', [481   420   480   387]};
S.outputFigureProperties = {'Position', [961   420   480   387]};
S.sketchFigureProperties = {'Position', [1   -17   480   387]};
S.phaseFigureProperties = {'Position', [481   -17   480   387]};

S.stateAxisProperties = {...
    'XLim',timeInterval,...
    'XGrid','on','YGrid','on'};
S.inputAxisProperties = {...
    'XLim',timeInterval,...
    'XGrid','on','YGrid','on'};
S.outputAxisProperties = {...
    'XLim',timeInterval,...
    'XGrid','on','YGrid','on'};
S.sketchAxisProperties = {...
     'XGrid','on','YGrid','on'};
S.phaseAxisProperties = {...
    'XLim',10*[-1,1],...
    'YLim',10*[-1,1],...
    'DataAspectRatio',[1 1 1],...
    'XGrid','on','YGrid','on'};


%% Simulate
[timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = ...
    S.simulate(timeInterval,initialState);

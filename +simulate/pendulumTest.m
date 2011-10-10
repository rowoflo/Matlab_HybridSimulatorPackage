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
%   Created 01-OCT-2011
%-------------------------------------------------------------------------------

%% Clear
ccc

%% Load


%% Initialize
x0 = [pi;0];
tEnd = 10;

% System parameters

% Create System
S = simulate.pendulum(x0);

%% Set up graphics
S.graphicsFlag = true;
S.plotStateFlag = true;
S.plotInputFlag = true;
S.plotOutputFlag = true;
S.sketchFlag = true;
S.phaseFlag = true;

S.stateFigureProperties = {'Position',[1   420   480   387]};
S.inputFigureProperties = {'Position',[481   420   480   387]};
S.outputFigureProperties = {'Position',[961   420   480   387]};
S.sketchFigureProperties = {'Position',[1   -17   480   387]};
S.phaseFigureProperties = {'Position',[481   -17   480   387]};

S.stateAxisProperties = {...
    'XLim',[0 tEnd],...
    'XGrid','on','YGrid','on'};
S.inputAxisProperties = {...
    'XLim',[0 tEnd],...
    'XGrid','on','YGrid','on'};
S.outputAxisProperties = {...
    'XLim',[0 tEnd],...
    'XGrid','on','YGrid','on'};
S.sketchAxisProperties = {...
     'XGrid','on','YGrid','on'};
S.phaseAxisProperties = {...
    'XLim',2*pi*[-1,1],...
    'YLim',5*[-1,1],...
    'DataAspectRatio',[1 1 1],...
    'XGrid','on','YGrid','on'};


%%
timeVector = S.time:S.timeStep:S.time+tEnd;
initialState = S.state;
[timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = ...
    S.simulate(timeVector,initialState);

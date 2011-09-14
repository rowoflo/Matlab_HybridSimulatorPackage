%% SYSTEM_NAMETest.m
% The "SYSTEM_NAMETest" script is used to test the "SYSTEM_NAME" system class.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate, @SYSTEM_NAME
%
% AUTHOR:
%   DD-MMM-YYYY by FULL_NAME
%
% SEE ALSO:
%
%-------------------------------------------------------------------------------

%% Clear
ccc

%% Load


%% Initialize
tEnd = 1;

% System parameters

% Create System
S = SYSTEM_NAME();

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
    'DataAspectRatio',[1 1 1],...
    'XGrid','on','YGrid','on'};


%%
timeVector = S.time:S.timeStep:1;
initialState = S.state;
[timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = ...
    S.simulate(timeVector,initialState);

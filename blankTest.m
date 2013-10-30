%% blankTest.m
% The "blankTest" script is used to test the
% "simulate.blank" system class.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate, +simulate, @blank
%
% SEE ALSO: TODO: Add see alsos
%    relatedFunction1 | relatedFunction2
%
% AUTHOR:
%    Rowland O'Flaherty (rowlandoflaherty.com)
%
% VERSION: 
%   Created 29-OCT-2013
%-------------------------------------------------------------------------------

%% Clear
ccc

%% Load


%% Initialize
duration = 1;

% System parameters

% Create System
S = simulate.blank();
timeInterval = [S.time, S.time + duration];
initialState = S.state;

%% Controller settings
S.openLoopControl = true;
S.openLoopTimeTape = 0;
S.openLoopInputTape = ones(S.nInputs,1);

%% Set up graphics
S.graphicsFlag = true;
S.plotStateFlag = true;
S.plotInputFlag = true;
S.plotOutputFlag = true;
S.plotInstantaneousCostFlag = true;
S.plotCumulativeCostFlag = true;
S.plotSketchFlag = true;
S.plotPhaseFlag = true;

S.stateFigureProperties = {'Position', [1   420   480   387]};
S.inputFigureProperties = {'Position', [481   420   480   387]};
S.outputFigureProperties = {'Position', [961   420   480   387]};
S.instantaneousCostFigureProperties = {'Position', [961   212   480   184]};
S.cumulativeCostFigureProperties = {'Position', [961   -17   480   183]};
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
S.instantaneousCostAxisProperties = {...
    'XLim',timeInterval,...
    'XGrid','on','YGrid','on'};
S.cumulativeCostAxisProperties = {...
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
[timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape,flowTimeTape,jumpCountTape,stopFlag] = ...
    S.simulate(timeInterval,initialState);

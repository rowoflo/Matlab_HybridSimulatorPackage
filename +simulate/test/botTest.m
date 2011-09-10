%% botTest.m
% The "botTest" script ...  TODO: Add description
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%
% AUTHOR:
%   26-AUG-2011 by Rowland O'Flaherty
%
% SEE ALSO: TODO: Add see alsos
%
%-------------------------------------------------------------------------------

%% Clear
ccc

%% Load


%% Initialize
t0 = 0;
dt = .5;
tEnd = 20;
x0 = zeros(3,1);

groundLimit = 5;

% System parameters
m = 1;
I = 1;
w = 1;
l = 1;

% Create System
S = simulate.bot(m,I,w,l,t0,x0,dt);

%% Set up graphics
S.graphicsFlag = true;
S.plotStateFlag = true;
S.plotInputFlag = true;
S.plotOutputFlag = false;
S.sketchFlag = true;
S.phaseFlag = true;

S.stateFigureProperties = {'Position',[1   420   480   387]};
S.inputFigureProperties = {'Position',[481   420   480   387]};
S.sketchFigureProperties = {'Position',[1   -17   480   387]};
S.phaseFigureProperties = {'Position',[481   -17   480   387]};

S.stateAxisProperties = {...
    'XLim',[0 tEnd],'YLim',[min(-groundLimit,-pi) max(groundLimit,pi)],...
    'XGrid','on','YGrid','on'};
S.inputAxisProperties = {...
    'XLim',[0 tEnd],'YLim',[min(S.inputLimits(:,1)) max(S.inputLimits(:,2))],...
    'XGrid','on','YGrid','on'};
S.sketchAxisProperties = {...
    'XLim',groundLimit*[-1 1],'YLim',groundLimit*[-1 1],...
     'XGrid','on','YGrid','on'};
S.phaseAxisProperties = {...
    'DataAspectRatio',[1 1 1],...
    'XLim',groundLimit*[-1 1],'YLim',groundLimit*[-1 1],...
    'XGrid','on','YGrid','on'};


%%
timeVector = t0:dt:tEnd;
initialState = x0;
[timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = ...
    S.simulate(timeVector,initialState);

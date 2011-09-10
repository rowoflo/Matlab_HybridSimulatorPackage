%% podTest.m
% The "podTest" script is used to test the "simulate.pod" class.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +robot
%
% AUTHOR:
%   18-APR-2011 by Rowland O'Flaherty
%
% SEE ALSO:
%
%-------------------------------------------------------------------------------

%% Clear
ccc

%% Load
load('localMap.mat')

%% Initialize
dt = .5;
tEnd = 100;

% Create System
r = .25;
I = .01;
m = 1;
t0 = 0;
x0 = [14;7;pi/2;0;0;0];
S = simulate.pod(I,m,r,localMap,t0,x0,dt);


S.forceLimits = [-.1,.1;-.1,.1];

S.goalState = [7;7;pi;0;0;0];
S.goalSize = [.5;.5;.5;.1;.1;.5];
S.waypointState = S.goalState;

S.graphicsFlag = true;
S.plotStateFlag = false;
S.plotInputFlag = true;
S.plotOutputFlag = false;
S.sketchFlag = true;
S.phaseFlag = false;

S.stateFigureProperties = {'Position',[1   420   480   364]};
S.inputFigureProperties = {'Position',[1   -17   480   364]};
S.outputFigureProperties = {'Position',[481   420   480   364]};
% S.sketchFigureProperties = {'Position',[481   -17   480   364]};
S.sketchFigureProperties = {'Position',[1   420   480   364]};
S.phaseFigureProperties = {'Position',[961   420   480   364]};
S.stateGraphicsProperties = {'LineWidth',2};
S.inputGraphicsProperties = {'LineWidth',2};
S.outputGraphicsProperties = {'LineWidth',2};
S.phaseGraphicsProperties = {'LineWidth',2};
S.localMapGraphicsProperties = {'LineWidth',2};


movieFlag = false;
if movieFlag
    movieFile = 'testMovie';
else
    movieFile = '';
end

%% Solve map
simTime = 20;
bufferSize = .7;
route = S.solveMap([],[],'simTime',simTime,'bufferSize',bufferSize,'plotFlag',true);

%% Simulate LQR
% S.odeSolver = @ode113;
% S.controllerType = 'LQR';
% S.stateOP = S.goalState;
% S.inputOP = [.01;0];
% [A,B] = S.jacobian(S.stateOP,S.inputOP);
% S.Q = diag([1 1 1 1 1 1]);
% S.R = diag([1 1]);
% [S.K,S.S] = lqrd(A,B,S.Q,S.R,dt);
% 
% timeVector = t0:dt:tEnd;
% initialState = x0;
% tic
% [timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = S.simulate(timeVector,initialState);
% toc
% stateTapeLQR = stateTape;
% inputTapeLQR = inputTape;

%% Simulate LQR Split
% S.odeSolver = @ode113;
% S.controllerType = 'LQRSplit';
% S.stateOP = S.goalState;
% S.inputOP = [0;0];
% 
% Af = [0 1;0 0];
% Bf = [0;1/m];
% S.Qf = diag([1 1]);
% S.Rf = 10;
% [S.Kf,S.Sf] = lqrd(Af,Bf,S.Qf,S.Rf,dt);
% 
% Ar = [0 1;0 0];
% Br = [0;r/I];
% S.Qr = diag([1 1]);
% S.Rr = 10;
% [S.Kr,S.Sr] = lqrd(Ar,Br,S.Qr,S.Rr,dt);
% 
% S.Ke = .5;
% 
% timeVector = t0:dt:tEnd;
% initialState = x0;
% tic
% [timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = S.simulate(timeVector,initialState);
% toc
% stateTapeLQR = stateTape;
% inputTapeLQR = inputTape;

%% Run
% tic
% S.run(tEnd-t0,'movieFile',movieFile)
% toc
% 
% %% Plot
% if ~S.graphicsFlag
%     S.replay;
% end


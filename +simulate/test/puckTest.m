%% puckTest.m
% The "puckTest" script is used to test the "simulate.puck" class.
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
load('puckLocalMap.mat')

%% Initialize
dt = .5;
tEnd = 10;

% Create System
r = .25;
m = 1;
t0 = 0;
x0 = [14;7;0;0];
S = simulate.puck(m,r,localMap,t0,x0,dt);

%%
S.goalState = [2;14;0;0];
S.goalSize = [.5;.5;.1;.1];
S.waypointState = S.goalState;

S.graphicsFlag = false;
S.plotStateFlag = true;
S.plotInputFlag = true;
S.plotOutputFlag = true;
S.sketchFlag = true;
S.phaseFlag = false;

S.stateFigureProperties = {'Position',[1   420   480   364]};
S.inputFigureProperties = {'Position',[1   -17   480   364]};
S.outputFigureProperties = {'Position',[481   420   480   364]};
S.sketchFigureProperties = {'Position',[481   -17   480   364]};
S.phaseFigureProperties = {'Position',[961   420   480   364]};
S.stateGraphicsProperties = {'LineWidth',2};
S.inputGraphicsProperties = {'LineWidth',2};
S.outputGraphicsProperties = {'LineWidth',2};
S.phaseGraphicsProperties = {'LineWidth',2};
S.localMapGraphicsProperties = {'LineWidth',2};

% visWallObjs = localMap.visibleFeaturesFrom(x0(1:2));
% visWallObjs = [visWallObjs{:}]';
% 
% reflectionPoints = visWallObjs.reflectionWith(S.waypointState(1:2));
% 
% S.stateMirrorWaypoint = [reflectionPoints(:,4);S.waypointState(3:4)];
% S.controllerSelect = 'LQR';
% 
% movieFlag = false;
% if movieFlag
%     movieFile = 'testMovie';
% else
%     movieFile = '';
% end

%% Solve map
bufferSize = .7;
route = S.solveMap([],[],'bufferSize',bufferSize);

%% Simulate LQR
S.odeSolver = @ode113;
S.controllerType = 'LQR';
S.stateOP = S.goalState;
S.inputOP = zeros(2,1);
[A,B] = S.jacobian(S.stateOP);
[S.K,S.S] = lqrd(A,B,S.Q,S.R,dt);


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


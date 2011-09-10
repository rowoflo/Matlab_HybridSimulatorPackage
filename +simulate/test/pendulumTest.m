%% pendulumTest.m
% The "pendulumTest" script is used to test the "simulate.pendulum" class.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   17-APR-2011 by Rowland O'Flaherty
%
% SEE ALSO:
%
%-------------------------------------------------------------------------------

%% Clear
ccc

%% Initialize
dt = .1;
tEnd = 10;

% Create System
l = 1;
m = 1;
b = .1;
% b = 10;
t0 = 0;
x0 = [0;0];
S = simulate.pendulum(l,m,b,t0,x0,dt);
% S.torqueLimits = [-3,3];

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

%% Simulate LQR
S.odeSolver = @ode15s;
S.controllerType = 'LQR';
S.stateOP = [pi;0];
% S.stateOP = [asin(3/(m*S.g*l));0];
S.inputOP = m*S.g*l*sin(S.stateOP(1)) + b*S.stateOP(2);
[A,B] = S.jacobian(S.stateOP);
[S.K,S.S] = lqrd(A,B,S.Q,S.R,dt);


timeVector = t0:dt:tEnd;
initialState = x0;
tic
[timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = S.simulate(timeVector,initialState);
toc
stateTapeLQR = stateTape;
inputTapeLQR = inputTape;

% %% Simulate Open-loop
% S.controllerType = 'OpenLoop';
% S.openLoopTimeTape = timeTapeD;
% S.openLoopInputTape = inputTape;
% 
% tic
% [stateTape,inputTape,timeTape,flowTimeTape,jumpCountTape,stopFlag] = S.simulate(timeVector,initialState);
% toc
% stateTapeOL = stateTape;
% inputTapeOL = inputTape;

%% Run
% tic
% S.run(tEnd-t0)
% toc
% 
% %% Plot
% figForward
% if ~S.graphicsFlag
%     S.replay
% end

%% mapTest.m
%
% DESCRIPTION:
%   The "mapTest" script is used to test the "robot.wall" class.
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

%%
if strcmp(getenv('USERNAME'),'rowland')
    cd('/Users/rowland/Engineering/Programming/Matlab/Packages/+simulate/test')
else
    cd('/Users/RO21531/Matlab/Packages/+simulate/test')
end
ccc

%% Load Map
load('localMap.mat')

%% Plot map
graphicsHandle = localMap.sketch;
axisHandle = get(graphicsHandle,'Parent');
axis equal
grid on
figBoldify

%% Check distanceToNearsetFrom method
% point = [14;4.5];
% 
% hold on
% plot(point(1),point(2),'o')
% hold off
%
% 
% [distance,wallObjs] = localMap.distanceToNearestFrom(point)

%% Check intersectionWith method
% lineSegments(:,:,1) = [-1 4;1 4]';
% lineSegments(:,:,2) = [0 5;1 5]';
% lineSegments(:,:,3) = [-1 10;8 10]';
% lineSegments(:,:,4) = [2 2;6 6]';
% lineSegments(:,:,5) = [0 0;0 1]';
% lineSegments(:,:,6) = [10 0;10 4]';
% lineSegments(:,:,7) = [15 0;15 5]';
% lineSegments(:,:,8) = [-1 0;-1 1]';
% lineSegments(:,:,9) = [1 1;1 2]';
% 
% hold on
% for iPair = 1:size(lineSegments,3)
%     plot(lineSegments(1,:,iPair),lineSegments(2,:,iPair),'r','LineWidth',2)
% end
% hold off
% 
% [intersectPoints,intersectAngles] = localMap.intersectionWith(lineSegments)

%% Check nearestIntersectionWith
% initialState = [14;7];
% goalState = [];
% 
% hold on
% plot(initialState(1),initialState(2),'bo','LineWidth',2,'MarkerSize',10);
% hold off

%% Check visibleFeaturesFrom
% x0 = [14;7];
% xGoal = [7;7];
% 
% hold on
% scatter(x0(1),x0(2),40,'LineWidth',2)
% scatter(xGoal(1),xGoal(2),40,'x','LineWidth',2)
% hold off
% 
% wallObjs = localMap.visibleFeaturesFrom(x0);
% wallObjs = [wallObjs{:}]';
% 
% hold on
% for iWall = 1:length(wallObjs)
%     wallObjs(iWall).sketch(gca,'r','lineWidth',2)
% end
% hold off
% 
% reflectionPoints = wallObjs.reflectionWith(xGoal);
% hold on
% scatter(reflectionPoints(1,:),reflectionPoints(2,:),40,'d','LineWidth',2)
% hold off


%% Solve
initialState = [14;7];
goalState = [2;14];
route = localMap.solve(initialState,goalState,'plotFlag',axisHandle,'growthRatio',.25);
    
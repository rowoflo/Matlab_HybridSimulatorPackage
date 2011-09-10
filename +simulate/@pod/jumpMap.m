function statePlus = jumpMap(podObj,~,state,~,~,~)
% The "jumpMap" method sets the discrete time dynamics of the system.
%
% SYNTAX:
%   statePlus = jumpMap(podObj,time,state,input)
%   statePlus = jumpMap(podObj,time,state,input,flowTime)
%   statePlus = jumpMap(podObj,time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   podObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "podObj.nStates" x 1 vector.
%
%   input - (? x 1 number)
%       Current input value. Must be a "podObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   statePlus - (? x 1 number)
%       Updated states. A "podObj.nStates" x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   26-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments
% 
% Check number of arguments
% error(nargchk(4,6,nargin))
% 
% Apply default values
% if nargin < 5, flowTime = 0; end
% if nargin < 6, jumpCount = 0; end
% 
% Check arguments for errors
% assert(isa(podObj,'simulate.pod') && numel(podObj) == 1,...
%     'simulate:pod:jumpMap:podObj',...
%     'Input argument "podObj" must be a 1 x 1 simulate.pod object.')
% 
% assert(isnumeric(time) && isreal(time) && numel(time) == 1,...
%     'simulate:pod:jumpMap:time',...
%     'Input argument "time" must be a 1 x 1 real number.')
% 
% assert(isnumeric(state) && isequal(size(state),[podObj.nStates,1]),...
%     'simulate:pod:jumpMap:state',...
%     'Input argument "state" must be a %d x 1 vector of numbers.',podObj.nStates)
% 
% assert(isnumeric(input) && isequal(size(input),[podObj.nInputs,1]),...
%     'simulate:pod:jumpMap:input',...
%     'Input argument "input" must be a %d x 1 vector of numbers.',podObj.nInputs)
% 
% assert(isnumeric(flowTime) && isreal(flowTime) && numel(flowTime) == 1 && flowTime >= 0,...
%     'simulate:pod:jumpMap:flowTime',...
%     'Input argument "flowTime" must be a 1 x 1 semi-positive real number.')
% 
% assert(isnumeric(jumpCount) && isreal(jumpCount) && numel(jumpCount) == 1 && jumpCount >= 0 && mod(jumpCount,1) == 0,...
%     'simulate:pod:jumpMap:jumpCount',...
%     'Input argument "jumpCount" must be a 1 x 1 semi-positive integer.')

%% Parameters
rho = podObj.rho;

%% Variables
x = state(1);
y = state(2);
theta = state(3);
dx = state(4);
dy = state(5);
dtheta = state(6);

%% Collision walls
[~,wallObjsCell] = podObj.localMap.distanceToNearestFrom([x;y]);
wallObjs = wallObjsCell{1};
nWalls = length(wallObjs);

%% Updates To Motion
vel = [dx;dy];
velPlus = [0;0];
for iWall = 1:nWalls
    velWith = (vel'*wallObjs{iWall}.unitVector)*wallObjs{iWall}.unitVector;
    velReflect = -rho*(vel'*wallObjs{iWall}.normalVector)*wallObjs{iWall}.normalVector;
    
    velPlus = velPlus + velWith + velReflect;
end
dxPlus = velPlus(1);
dyPlus = velPlus(2);

%% Output
statePlus(1,1) = x;
statePlus(2,1) = y;
statePlus(3,1) = theta;
statePlus(4,1) = dxPlus;
statePlus(5,1) = dyPlus;
statePlus(6,1) = dtheta;

end

function stateDot = flowMap(botObj,~,state,input,~,~)
% The "flowMap" method sets the continuous time dynamics of the system.
%
% SYNTAX:
%   stateDot = flowMap(botObj,time,state,input)
%   stateDot = flowMap(botObj,time,state,input,flowTime)
%   stateDot = flowMap(botObj,time,state,input,flowTime,jumpCount)
%
% INPUTS:
%   botObj - (1 x 1 simulate.bot)
%       An instance of the "simulate.bot" class.
%
%   time - (1 x 1 real number)
%       Current time.
%
%   state - (? x 1 number)
%       Current state. Must be a "botObj.nStates" x 1 vector.
%
%   input - (? x 1 number)
%       Current input value. Must be a "botObj.nInputs" x 1 vector.
%
%   flowTime - (1 x 1 semi-positive real number) [0]
%       Current flow time value.
%
%   jumpCount - (1 x 1 semi-positive integer) [0] 
%       Current jump count value.
%
% OUTPUTS:
%   dStates - (? x 1 number)
%       Updated state derivatives. A "botObj.nStates" x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +simulate, someFile.m
%
% AUTHOR:
%   30-AUG-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

% %% Check Input Arguments
% 
% % Check number of arguments TODO: Add number argument check
% error(nargchk(1,2,nargin))
% 
% % Apply default values TODO: Add apply defaults
% if nargin < 2, arg1 = 0; end
% 
% % Check arguments for errors TODO: Add error checks
% assert(isa(botObj,'simulate.bot') && numel(botObj) == 1,...
%     'simulate:bot:flowMap:botObj',...
%     'Input argument "botObj" must be a 1 x 1 "simulate.bot" object.')
%
% assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
%     'simulate:bot:flowMap:arg1',...
%     'Input argument "arg1" must be a ? x ? matrix of real numbers.')

%% Parameters
w = botObj.w;
wrr = botObj.wrr;
wrl = botObj.wrl;


%% Variables
x = state(1);
y = state(2);
theta = state(3);

dphir = input(1); % Right wheel angular velocity
dphil = input(2); % Left wheel angular velocity

R = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];
Xi = [x;y;theta];

%% Equations Of Motion
dXi = R * [wrr*dphir + wrl*dphil;0;wrr*dphir/w - wrl*dphil/w];

dx = dXi(1);
dy = dXi(2);
dtheta = dXi(3);

%% Output
stateDot(1,1) = dx;
stateDot(2,1) = dy;
stateDot(3,1) = dtheta;

end

function [A,B,C,D] = jacobian(podObj,stateOP,inputOP)
% The "jacobian" method outputs the pod's jacobian matrices evaluated at
% the the given operating point.
%
% SYNTAX:
%   [A,B,C,D] = podObj.jacobian(stateOP,inputOP)
%
% INPUTS:
%   podObj - (1 x 1 simulate.pod)
%       An instance of the "simulate.pod" class.
%
%   stateOP - (? x 1 number)
%       State operating point. Must be a "podObj.nStates" x 1
%       vector.
%
%   inputOP - (? x 1 number)
%       Input operating point. Must be a "podObj.nInputs" x 1
%       vector. 
%
% OUTPUTS:
%   A - (? x ? number)
%       Linearized A matrix (i.e. df/dx). A "podObj.nStates" x
%       "podObj.nStates" matrix.
%
%   B - (? x ? number)
%       Linearized B matrix (i.e. df/du). A "podObj.nStates" x 
%       "podObj.nInputs" matrix.
%
%   C - (? x ? number)
%       Linearized C matrix (i.e. dh/dx). A "podObj.nOutputs" x
%       "podObj.nStates" matrix.
%
%   D - (? x ? number)
%       Linearized D matrix (i.e. dh/du). A "podObj.nOutputs" x
%       "podObj.nInputs" matrix.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   25-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments
% 
% % Check number of arguments
% error(nargchk(2,2,nargin))
% 
% % Apply default values
% % if nargin < 2, arg1 = 0; end
% 
% % Check arguments for errors
% assert(isa(podObj,'simulate.pod') && numel(podObj) == 1,...
%     'simulate:pod:jacobian:podObj',...
%     'Input argument "podObj" must be a 1 x 1 simulate.pod object.')
% 
% assert(isnumeric(stateOP) && isequal(size(stateOP),[podObj.nStates,1]),...
%     'simulate:pod:jacobian:stateOP',...
%     'Input argument "stateOP" must be a %d x 1 vector of numbers.',podObj.nStates)
% 
% assert(isnumeric(inputOP) && isequal(size(inputOP),[podObj.nInputs,1]),...
%     'simulate:pod:jacobian:inputOP',...
%     'Input argument "inputOP" must be a %d x 1 vector of numbers.',podObj.nInputs)

%% Parameters
I = podObj.I;
m = podObj.m;
r = podObj.r;

%% Variables
% x = stateOP(1,1);
% y = stateOP(2,1);
theta = stateOP(3,1);
% dx = stateOP(4,1);
% dy = stateOP(5,1);
% dtheta = stateOP(5,1);

uf = inputOP(1,1);
% ur = inputOP(2,1);

%% Linearize
df4dq3 = -sin(theta)/m*uf;
df5dq3 = cos(theta)/m*uf;
dq3 = [df4dq3;df5dq3;0];

A = [zeros(3,3) eye(3);
     zeros(3,2) dq3 zeros(3,3)];
 
df4du1 = cos(theta)/m;
df5du1 = sin(theta)/m;
df6du2 = r/I;
du1 = [df4du1;df5du1;0];
du2 = [0;0;df6du2];

B = [zeros(3,2);
     du1 du2];
 
C = A;

D = zeros(6,2); 

end


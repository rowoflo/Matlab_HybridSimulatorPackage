function [A,B,C,D] = jacobian(pendulumObj,stateOP,~)
% The "jacobian" method outputs the pendulum's jacobian matrices evaluated at
% the the given operating point.
%
% SYNTAX:
%   [A,B,C,D] = pendulumObj.jacobian(stateOP,inputOP)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.pendulum)
%       An instance of the "simulate.pendulum" class.
%
%   stateOP - (? x 1 number)
%       State operating point. Must be a "pendulumObj.nStates" x 1
%       vector.
%
%   inputOP - (? x 1 number)
%       Input operating point. Must be a "pendulumObj.nInputs" x 1
%       vector. 
%
% OUTPUTS:
%   A - (? x ? number)
%       Linearized A matrix (i.e. df/dx). A "pendulumObj.nStates" x
%       "pendulumObj.nStates" matrix.
%
%   B - (? x ? number)
%       Linearized B matrix (i.e. df/du). A "pendulumObj.nStates" x 
%       "pendulumObj.nInputs" matrix.
%
%   C - (? x ? number)
%       Linearized C matrix (i.e. dh/dx). A "pendulumObj.nOutputs" x
%       "pendulumObj.nStates" matrix.
%
%   D - (? x ? number)
%       Linearized D matrix (i.e. dh/du). A "pendulumObj.nOutputs" x
%       "pendulumObj.nInputs" matrix.
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

% Check number of arguments
error(nargchk(2,2,nargin))

% Check arguments for errors
assert(isa(pendulumObj,'simulate.pendulum') && numel(pendulumObj) == 1,...
    'simulate:pendulum:jacobian:pendulumObj',...
    'Input argument "pendulumObj" must be a 1 x 1 simulate.pendulum object.')

assert(isnumeric(stateOP) && isequal(size(stateOP),[pendulumObj.nStates,1]),...
    'simulate:pendulum:jacobian:stateOP',...
    'Input argument "stateOP" must be a %d x 1 vector of numbers.',pendulumObj.nStates)

%% Parameters
l = pendulumObj.l;
m = pendulumObj.m;
b = pendulumObj.b;
g = pendulumObj.g;

%% Variables
x = stateOP(1,1);
dx = stateOP(2,1); %#ok<NASGU>

%% Linearize
A = [0           1;...
    -g/l*cos(x)  -b/(m*l^2)];

B = [0;...
     1/(m*l^2)];

C = A;

D = zeros(2,2);

end

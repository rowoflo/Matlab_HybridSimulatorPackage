function [A,B,C,D] = jacobian(puckObj,~,~)
% The "jacobian" method outputs the puck's jacobian matrices evaluated at
% the the given operating point.
%
% SYNTAX:
%   [A,B,C,D] = puckObj.jacobian(stateOP,inputOP)
%
% INPUTS:
%   puckObj - (1 x 1 simulate.puck)
%       An instance of the "simulate.puck" class.
%
%   stateOP - (? x 1 number)
%       State operating point. Must be a "puckObj.nStates" x 1
%       vector.
%
%   inputOP - (? x 1 number)
%       Input operating point. Must be a "puckObj.nInputs" x 1
%       vector. 
%
% OUTPUTS:
%   A - (? x ? number)
%       Linearized A matrix (i.e. df/dx). A "puckObj.nStates" x
%       "puckObj.nStates" matrix.
%
%   B - (? x ? number)
%       Linearized B matrix (i.e. df/du). A "puckObj.nStates" x 
%       "puckObj.nInputs" matrix.
%
%   C - (? x ? number)
%       Linearized C matrix (i.e. dh/dx). A "puckObj.nOutputs" x
%       "puckObj.nStates" matrix.
%
%   D - (? x ? number)
%       Linearized D matrix (i.e. dh/du). A "puckObj.nOutputs" x
%       "puckObj.nInputs" matrix.
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
% assert(isa(puckObj,'simulate.puck') && numel(puckObj) == 1,...
%     'simulate:puck:jacobian:puckObj',...
%     'Input argument "puckObj" must be a 1 x 1 simulate.puck object.')
% 
% assert(isnumeric(stateOP) && isequal(size(stateOP),[puckObj.nStates,1]),...
%     'simulate:puck:jacobian:stateOP',...
%     'Input argument "stateOP" must be a %d x 1 vector of numbers.',puckObj.nStates)
% 
% assert(isnumeric(inputOP) && isequal(size(inputOP),[puckObj.nInputs,1]),...
%     'simulate:puck:jacobian:inputOP',...
%     'Input argument "inputOP" must be a %d x 1 vector of numbers.',puckObj.nInputs)

%% Parameters
m = puckObj.m;

%% Variables
% x = stateOP(1,1);
% xD = stateOP(3,1);
% y = stateOP(2,1);
% yD = stateOP(4,1);

%% Linearize
A = [0  0  1  0;...
     0  0  0  1;...
     0  0  0  0;...
     0  0  0  0];
 
B = [0    0;...
     0    0;...
     1/m  0;...
     0    1/m];
 
C = A;

D = zeros(4,2); 

end


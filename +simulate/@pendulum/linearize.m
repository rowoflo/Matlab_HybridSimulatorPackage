function [A,B,C,D] = linearize(pendulumObj,stateOP,inputOP)
% The "linearize" method outputs the system's linearize matrices evaluated at
% the the given operating point.
%
% SYNTAX:
%   [A,B,C,D] = pendulumObj.linearize(stateOP,inputOP)
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
%   +simulate, +simulate
%
% AUTHOR:
%    Rowland O'Flaherty
%
% VERSION: 
%   Created 01-OCT-2011
%-------------------------------------------------------------------------------

%% Parameters


%% Variables


%% Linearize
A = [];

B = [];
 
C = [];

D = [];

end


function [A,B,C,D] = linearize(blankObj,stateOP,inputOP)
% The "linearize" method outputs the system's linearize matrices evaluated at
% the the given operating point.
%
% SYNTAX:
%   [A,B,C,D] = blankObj.linearize()
%   [A,B,C,D] = blankObj.linearize(stateOP,inputOP)
%
% INPUTS:
%   blankObj - (1 x 1 simulate.blank)
%       An instance of the "simulate.blank" class.
%
%   stateOP - (1 x 1 number) [blankObj.stateOP]
%       State operating point.
%
%   inputOP - (1 x 1 number) [blankObj.inputOP]
%       Input operating point.
%
% OUTPUTS:
%   A - (1 x 1 number)
%       Linearized A matrix (i.e. df/dx).
%
%   B - (1 x 1 number)
%       Linearized B matrix (i.e. df/du).
%
%   C - (1 x 1 number)
%       Linearized C matrix (i.e. dh/dx).
%
%   D - (1 x 1 number)
%       Linearized D matrix (i.e. dh/du).
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
%   Created 21-OCT-2013
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, stateOP = blankObj.stateOP; end
if nargin < 3, inputOP = blankObj.inputOP; end

%% Parameters


%% Variables


%% Linearize
A = [];

B = [];
 
C = [];

D = [];

end


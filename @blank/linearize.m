function [A,B,C,D] = linearize(blankObj,stateBar,inputBar)
% The "linearize" method outputs the system's linearize matrices evaluated at
% the the given Barerating point.
%
% SYNTAX:
%   [A,B,C,D] = blankObj.linearize()
%   [A,B,C,D] = blankObj.linearize(stateBar,inputBar)
%
% INPUTS:
%   blankObj - (1 x 1 simulate.blank)
%       An instance of the "simulate.blank" class.
%
%   stateBar - (1 x 1 number) [blankObj.stateBar]
%       State Barerating point.
%
%   inputBar - (1 x 1 number) [blankObj.inputBar]
%       Input Barerating point.
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
%    Rowland O'Flaherty (rowlandoflaherty.com)
%
% VERSION: 
%   Created 29-OCT-2013
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, stateBar = blankObj.stateBar; end
if nargin < 3, inputBar = blankObj.inputBar; end

%% Parameters


%% Variables


%% Linearize
A = [];

B = [];
 
C = [];

D = [];

end


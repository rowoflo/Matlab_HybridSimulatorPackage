function inputOut = inputConstraints(pendulumObj,inputIn)
% The "inputConstraints" method constrains the input values for the
% system.
%
% SYNTAX:
%   inputOut = pendulumObj.inputConstraints(inputIn)
%
% INPUTS:
%   pendulumObj - (1 x 1 simulate.pendulum)
%       An instance of the "simulate.pendulum" class.
%
%   inputIn - (? x 1 real number)
%       Current input value. Must be a "pendulumObj.nInputs" x 1 vector.
%
% OUTPUTS:
%   inputOut - (? x 1 number)
%       Constrained input values. A "pendulumObj.nInputs" x 1 vector.
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
%   Created 23-OCT-2011
%-------------------------------------------------------------------------------

%% Parameters


%% Variables


%% Controller Definition


%% Set input
inputOut = inputIn;


end

function inputOut = inputConstraint(SYSTEM_NAMEObj,inputIn)
% The "inputConstraint" method constrains the input values for the
% system.
%
% SYNTAX:
%   inputOut = SYSTEM_NAMEObj.inputConstraint(inputIn)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   inputIn - (? x 1 real number)
%       Current input value. Must be a "SYSTEM_NAMEObj.nInputs" x 1 vector.
%
% OUTPUTS:
%   inputOut - (? x 1 number)
%       Constrained input values. A "SYSTEM_NAMEObj.nInputs" x 1 vector.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   DD-MMM-YYYY by FULL_NAME
%
%-------------------------------------------------------------------------------

%% Parameters


%% Variables


%% Controller Definition


%% Set input
inputOut = inputIn;


end

function stateOut = stateConstraint(SYSTEM_NAMEObj,stateIn)
% The "stateConstraint" method constrains the state values for the
% system.
%
% SYNTAX:
%   stateOut = SYSTEM_NAMEObj.stateConstraint(stateIn)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   stateIn - (? x 1 real number)
%       Current input value. Must be a "SYSTEM_NAMEObj.nStates" x 1 vector.
%
% OUTPUTS:
%   stateOut - (? x 1 number)
%       Constrained state values. A "SYSTEM_NAMEObj.nStates"
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
stateOut = stateIn;


end

function stateOut = stateConstraint(SYSTEM_NAMEObj,stateIn)
% The "stateConstraint" method constrains the state values for the
% system.
%
% SYNTAX:
%   stateOut = SYSTEM_NAMEObj.stateConstraint(stateIn)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
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
%   NECESSARY_PACKAGE+simulate
%
% AUTHOR:
%    FULL_NAME
%
% VERSION: 
%   Created DD-MMM-YYYY
%-------------------------------------------------------------------------------

%% Parameters


%% Variables


%% Controller Definition


%% Set input
stateOut = stateIn;


end

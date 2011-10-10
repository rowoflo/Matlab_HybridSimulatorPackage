function inputOut = inputConstraint(SYSTEM_NAMEObj,inputIn)
% The "inputConstraint" method constrains the input values for the
% system.
%
% SYNTAX:
%   inputOut = SYSTEM_NAMEObj.inputConstraint(inputIn)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
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
inputOut = inputIn;


end

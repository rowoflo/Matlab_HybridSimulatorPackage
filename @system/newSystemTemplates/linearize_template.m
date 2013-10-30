function [A,B,C,D] = linearize(SYSTEM_NAMEObj,stateBar,inputBar)
% The "linearize" method outputs the system's linearize matrices evaluated at
% the the given Barerating point.
%
% SYNTAX:
%   [A,B,C,D] = SYSTEM_NAMEObj.linearize()
%   [A,B,C,D] = SYSTEM_NAMEObj.linearize(stateBar,inputBar)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%
%   stateBar - (NSTATES x 1 number) [SYSTEM_NAMEObj.stateBar]
%       State Barerating point.
%
%   inputBar - (NINPUTS x 1 number) [SYSTEM_NAMEObj.inputBar]
%       Input Barerating point.
%
% OUTPUTS:
%   A - (NSTATES x NSTATES number)
%       Linearized A matrix (i.e. df/dx).
%
%   B - (NSTATES x NINPUTS number)
%       Linearized B matrix (i.e. df/du).
%
%   C - (NOUTPUTS x NSTATES number)
%       Linearized C matrix (i.e. dh/dx).
%
%   D - (NOUTPUTS x NINPUTS number)
%       Linearized D matrix (i.e. dh/du).
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   NECESSARY_PACKAGE+simulate
%
% AUTHOR:
%    FULL_NAME (WEBSITE)
%
% VERSION: 
%   Created DD-MMM-YYYY
%-------------------------------------------------------------------------------

%% Apply default values
if nargin < 2, stateBar = SYSTEM_NAMEObj.stateBar; end
if nargin < 3, inputBar = SYSTEM_NAMEObj.inputBar; end

%% Parameters


%% Variables


%% Linearize
A = [];

B = [];
 
C = [];

D = [];

end


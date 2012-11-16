function [A,B,C,D] = linearize(SYSTEM_NAMEObj,stateOP,inputOP)
% The "linearize" method outputs the system's linearize matrices evaluated at
% the the given operating point.
%
% SYNTAX:
%   [A,B,C,D] = SYSTEM_NAMEObj.linearize()
%   [A,B,C,D] = SYSTEM_NAMEObj.linearize(stateOP,inputOP)
%
% INPUTS:
%   SYSTEM_NAMEObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
%       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
%
%   stateOP - (NSTATES x 1 number) [SYSTEM_NAMEObj.stateOP]
%       State operating point. Must be a "SYSTEM_NAMEObj.nStates" x 1
%       vector.
%
%   inputOP - (NINPUTS x 1 number) [SYSTEM_NAMEObj.inputOP]
%       Input operating point. Must be a "SYSTEM_NAMEObj.nInputs" x 1
%       vector. 
%
% OUTPUTS:
%   A - (NSTATES x NSTATES number)
%       Linearized A matrix (i.e. df/dx). A "SYSTEM_NAMEObj.nStates" x
%       "SYSTEM_NAMEObj.nStates" matrix.
%
%   B - (NSTATES x NINPUTS number)
%       Linearized B matrix (i.e. df/du). A "SYSTEM_NAMEObj.nStates" x 
%       "SYSTEM_NAMEObj.nInputs" matrix.
%
%   C - (NOUTPUTS x NSTATES number)
%       Linearized C matrix (i.e. dh/dx). A "SYSTEM_NAMEObj.nOutputs" x
%       "SYSTEM_NAMEObj.nStates" matrix.
%
%   D - (NOUTPUTS x NINPUTS number)
%       Linearized D matrix (i.e. dh/du). A "SYSTEM_NAMEObj.nOutputs" x
%       "SYSTEM_NAMEObj.nInputs" matrix.
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

%% Apply default values
if nargin < 2, stateOP = SYSTEM_NAMEObj.stateOP; end
if nargin < 3, inputOP = SYSTEM_NAMEObj.inputOP; end

%% Parameters


%% Variables


%% Linearize
A = [];

B = [];
 
C = [];

D = [];

end


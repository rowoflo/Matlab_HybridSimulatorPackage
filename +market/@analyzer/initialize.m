function anAnalyzer = initialize(anAnalyzer,txtListOfCompanySyms,dataDir)
% The "initialize" method will set the initial values for the properties in
% the analyzer object.
%
% USAGE:
%   anAnalyzer = anAnalyzer.initialize(txtListOfCompanySyms,dataDir)
%
% INPUTS:
%   anAnalyzer - (1 x 1 market.analyzer)
%       An instance of the analyzer class.
%
%	txtListOfCompanySyms - (1 x 1 string) [default ''] 
%       Path to txt file that has a list of company stock symbols
%       to initially import into this object.
%
%   dataDir - (string) [default '']
%       Directory of where folders of data are stored. Should have
%       "companies" and "stocks" folder inside and a file called
%       "allCompaniesByIndustry.csv".
%
% OUTPUTS:
%   anAnalyzer - (1 x 1 market.analyzer)
%       An instance of the analyzer class after being initialized.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%
% REVISION:
%   1.0 23-MAR-2010 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%% Check
% Check number of arguments
error(nargchk(1,2,nargin))

% Apply default values
if nargin < 2, arg1 = 0; end

% Check arguments for errors
assert(issomething(arg1),...
    'package_name:class_name:initialize:arg1Chk',...
    'Input argument "arg1" must be a 1 x 1 real number.')


end

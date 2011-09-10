classdef company
% The "company" class
%
% NECESSARY FILES AND/OR PACKAGES:
%   +market
%
% SEE ALSO:
% 
%
% REVISION:
%   1.0 20-FEB-2010 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Properties
%--------------------------------------------------------------------------
properties (Access = public)
    name % (string) Name of company.
    symbol % (string) Stock symbol.
    stockHistory % (1 x 1 market.stock) Historical prices of company's stock.
    sector % (string) The sector the company is in.
    industry % (string) The industry the company is in.
    address % (string) Address of company.
    phone % (string) Phone number of company.
    SIC % (1 x 1 number) Primary SIC code of company.
    description % (string) Description of business.
    FYE % (string) End financial year.
    shareStats % (4 x ? number) A per share overview. Columns are samples and rows are variables, which are described in "shareStatsDescription".
    shareStatsDescription % (4 x 1 cell array of strings) Descriptions of variables in "shareStats".
    financialRatios % (24 x ? number) Key financial ratios. Columns are samples and rows are variables, which are described in "financialRatiosDescription".
    financialRatiosDescription % (24 x 1 cell array of strings) Descriptions of variables in "financialRatios".
    financialInfo % (31 x ? number) Financial information, including income statement, balance sheet, and cash flow. Columns are samples and rows are variables, which are described in "financialInfoDescription".
    financialInfoDescription % (31 x 1 cell array of strings) Descriptions of variables in "financialInfo".
    annualSummary % (4 x ? number) Annual summary of sales and income. Columns are samples and rows are variables, which are described in "annualSummaryDescription".
    annualSummaryDescription % (4 x 1 cell array of strings)  Descriptoins of variables in "annualSummary".
    stockOwnership % (5 x ? number) Stock ownership information. Columns are samples and rows are variables, which are described in "stockOwnershipDescription".
    stockOwnershipDescription % (5 x 1 cell array of strings)  Descriptoins of variables in "stockOwnership".
    lastReportDate % (1 x 1 number) The lastest date of a report in datenum format.
end

properties (Access = private)
    dataDir % (string) Directory of where raw data is stored.    
end

%--------------------------------------------------------------------------
% Methods
%--------------------------------------------------------------------------

% Constructor -------------------------------------------------------------
methods
    function aCompany = company(symbol,name,sector,industry,dataDir) % Constructor
        % Constructor function for the "company" class.
        %
        % USAGE:
        %   aCompany = company([symbol],[name],[sector],[industry],[dataDir])
        %
        % INPUTS:
        %	[symbol] - (string) [default '']
        %       Symbol of the company stock.
        %
        %   [name] - (string) [default '']
        %       Name of company.
        %
        %   [sector] - (string) [default '']
        %       Sector of company.
        %
        %   [industry] - (string) [default '']
        %       Industry of company
        %
        %   [dataDir] - (string) [default '']
        %       Directory of where folders of data are stored. Should have
        %       "companies" and "stocks" folder inside.
        %
        % OUTPUTS:
        %	aCompany - (1 x 1 company instance) 
        %       A new instance of the "company" class.
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        % Check number of arguments
        error(nargchk(0,5,nargin))
        
        % Apply default values
        if nargin < 1, symbol = ''; end
        if nargin < 2, name = ''; end
        if nargin < 3, sector = ''; end
        if nargin < 4, industry = ''; end
        if nargin < 5, dataDir = ''; end
        
        % Check input arguments for errors
        assert(ischar(symbol),...
            'market:company:symbolChk',...
            'Input argument "symbol" must be a string.')
        
        assert(ischar(name),...
            'market:company:nameChk',...
            'Input argument "name" must be a string.')
        
        assert(ischar(sector),...
            'market:company:sectorChk',...
            'Input argument "sector" must be a string.')
        
        assert(ischar(industry),...
            'market:company:industryChk',...
            'Input argument "industry" must be a string.')
        
        assert((ischar(dataDir) && isdir(dataDir)) || isempty(dataDir),...
            'market:company:dataDirChk',...
            'Input argument "dataDir" must be a valid directory.')
        
        % Assign
        if ~isempty(dataDir)
            aCompany.symbol = upper(symbol);
            aCompany.name = name;
            aCompany.sector = sector;
            aCompany.industry = industry;
            aCompany.dataDir = dataDir;
            
            aCompany = aCompany.getInfo;
        end
    end
end
%--------------------------------------------------------------------------

% Property methods --------------------------------------------------------
% methods
%     function anObj = set.prop1(anObj,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % USAGE:
%         %	anObj.prop1 = prop1;
%         %
%         % NOTES:
%         %
%         %------------------------------------------------------------------
%         assert(issomething(prop1),...
%             'package_name:set:prop1Chk',...
%             '"prop1" property must be set to a 1 x 1 real number.')
%         anObj.prop1 = prop1;
%     end
%     
%     function prop1 = get.prop1(anObj)
%         % Overloaded query operator function for the "prop1" property.
%         %
%         % USAGE:
%         %	prop1 = anObj.prop1
%         %
%         % NOTES:
%         %
%         %------------------------------------------------------------------
% 
%         prop1 = anObj.prop1;
%     end
% end
%--------------------------------------------------------------------------

% Converting methods ------------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Function to convert company object to a otherObject object.
%         %
%         % USAGE:
%         %	otherObject(anObj)
%         %
%         % NOTES:
%         %
%         %------------------------------------------------------------------
%         
% 
%     end
% 
% end
%--------------------------------------------------------------------------

% Methods in separte files ------------------------------------------------
methods (Access = private)
    aCompany = getInfo(aCompany)
end
%--------------------------------------------------------------------------
    
end

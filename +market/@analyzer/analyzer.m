classdef analyzer
% This class is a container class for financial market objects. This class 
% contains many methods for analyzing its contained objects. 
%
% NECESSARY FILES AND/OR PACKAGES:
%   +market, loadVarsFromCSV.m
%
% SEE ALSO:
%    market.company,market.stock
%
% REVISION:
%   1.0 31-JAN-2010 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Properties
%--------------------------------------------------------------------------
properties (Access = public)
    companies % (? x 1 market.company) The company objects that are held by this object.
    industryIndex % (? x 1 market.stock) An array of stocks that are the sum of all the stocks in each industry.
end

properties (Access = private)
    
end

%--------------------------------------------------------------------------
% Methods
%--------------------------------------------------------------------------

% Constructor -------------------------------------------------------------
methods
    function anAnalyzer = analyzer(txtListOfCompanySyms,dataDir) % Constructor
        % Constructor function for the "analyzer" class.
        %
        % USAGE:
        %   anAnalyzer = analyzer([txtListOfCompanySyms],[dataDir])
        %
        % INPUTS:
        %	[txtListOfCompanySyms] - (1 x 1 string) [default ''] 
        %       Path to txt file that has a list of company stock symbols
        %       to initially import into this object.
        %
        %   [dataDir] - (string) [default '']
        %       Directory of where folders of data are stored. Should have
        %       "companies" and "stocks" folder inside and a file called "allCompaniesByIndustry.csv".
        %
        % OUTPUTS:
        %	anAnalyzer - (1 x 1 analyzer instance) 
        %       A new instance of the "analyzer" class.
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        % Check number of arguments
        error(nargchk(0,2,nargin))
        
        % Apply default values
        if nargin < 1, txtListOfCompanySyms = ''; end
        if nargin < 2, dataDir = ''; end
        
        
        % Check input arguments for errors
        assert(ischar(txtListOfCompanySyms),...
            'market:company:txtListOfCompanySymsChk',...
            'Input argument "txtListOfCompanySyms" must be a valid file path.')
        fid = fopen(txtListOfCompanySyms);
        assert(fid ~= -1,...
            'market:company:txtListOfCompanySymsChk',...
            'Input argument "txtListOfCompanySyms" must be a valid file path.')
        
        assert(ischar(dataDir) && isdir(dataDir),...
            'market:company:dataDirChk',...
            'Input argument "dataDir" must be a valid directory.')
        
        % Assign
        aCmpSym = fgetl(fid);
        nSyms = 0;
        while ischar(aCmpSym)
            nSyms = nSyms + 1;
            aCmpSym = fgetl(fid);
        end
        frewind(fid);
        loadVarsFromCSV([dataDir filesep 'allCompaniesByIndustry.csv']);
        
        aCmpSym = fgetl(fid);
        ind = find(ismember(symbol,aCmpSym));
        anAnalyzer.companies = market.company(aCmpSym,company{ind},sector{ind},industry{ind},dataDir); %#ok<*USENS>
        cntSym = 1;
        
        if nSyms > 1
            anAnalyzer.companies = repmat(anAnalyzer.companies,nSyms,1);
            aCmpSym = fgetl(fid);
            while ischar(aCmpSym)
                cntSym = cntSym + 1;
                ind = find(ismember(symbol,aCmpSym));
                anAnalyzer.companies(cntSym,1) = market.company(aCmpSym,company{ind},sector{ind},industry{ind},dataDir); %#ok<*USENS>
                aCmpSym = fgetl(fid);
            end
        end
        fclose(fid);
    end
end
%--------------------------------------------------------------------------

% % Property methods --------------------------------------------------------
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
% %--------------------------------------------------------------------------
% 
% % Converting methods ------------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Function to convert analyzer object to a otherObject object.
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
% %--------------------------------------------------------------------------
% 
% Methods in separte files ------------------------------------------------
methods (Access = private)
    anAnalyzer = initialize(anAnalyzer,txtListOfCompanySyms,dataDir)
end
%--------------------------------------------------------------------------
    
end

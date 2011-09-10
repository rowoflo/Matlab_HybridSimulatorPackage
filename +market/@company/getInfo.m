function aCompany = getInfo(aCompany)
% The "getInfo" method loads the information from the raw text file into
% the company object.
%
% USAGE:
%   aCompany = aCompany.getInfo()
%
% INPUTS:
%   aCompany - (1 x 1 market.aCompany)
%       An instance of the company class.
%
% OUTPUTS:
%   aCompany - (1 x 1 market.aCompany)
%       An instance of the aCompany class with its information initialized.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +market
%
% REVISION:
%   1.0 20-FEB-2010 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%% Check
% Check number of arguments
error(nargchk(1,1,nargin))

% Check arguments for errors
assert(isa(aCompany,'market.company') && isequal(size(aCompany),[1 1]),...
    'market:company:getInfo:aCompanyChk',...
    'Input argument "aCompany" must be a 1 x 1 +market.company object.')

%% Get company stock history
loadVarsFromCSV([aCompany.dataDir filesep 'stocks' filesep aCompany.symbol '.csv']);

historicalData(:,1) = datenum(Date);
historicalData(:,2) = str2double(High);
historicalData(:,3) = str2double(Low);
historicalData(:,4) = str2double(Open);
historicalData(:,5) = str2double(Close);
historicalData(:,6) = str2double(Volume);

aCompany.stockHistory = market.stock(aCompany.symbol,historicalData);

%% Open company data file
[fid message] = fopen([aCompany.dataDir filesep 'companies' filesep aCompany.symbol '.txt'],'r');
assert(fid ~= -1,...
    'market:company:getInfo:fidChk',...
    'Unable to open data file: %s',message)

%% Get company info
nSections = 11;
section = cell(nSections,1);
sectionCnt = 1;
lineCnt = 0;
while ~feof(fid)    
    aLine = fgetl(fid);
    if isempty(strfind(aLine, '__________'))
        lineCnt = lineCnt + 1;
        section{sectionCnt}{lineCnt,1} = aLine;
    else
        lineCnt = 0;
        sectionCnt = sectionCnt + 1;
    end
end
fclose(fid);

%% Set info from text file
if strfind(section{1}{1},'The page cannot be found')
    return
end

[aCompany.address,aCompany.phone,aCompany.SIC] = parseS2(section{2});

[aCompany.description] = parseS3(section{3});

[aCompany.shareStats,aCompany.shareStatsDescription,aCompany.FYE] = parseS4(section{4});

[financialRatios,aCompany.financialRatiosDescription,ISMultiStr] = parseS5(section{5});
if strcmp(ISMultiStr,'Millions')
    ISMulti = 10^6;
else
    error('market:company:getInfo:multiplierChk','Invalid multiplier.')
end
financialRatios(1) = datenum([aCompany.FYE '/' num2str(financialRatios(1))],'mm/dd/yyyy');
aCompany.financialRatios = financialRatios;

[incomeStatement,incomeStatementDescription,BSMultiStr] = parseS6(section{6});
if strcmp(BSMultiStr,'Millions')
    BSMulti = 10^6;
else
    error('market:company:getInfo:multiplierChk','Invalid multiplier.')
end
incomeStatement(2:end,:) = incomeStatement(2:end,:)*ISMulti;

[balanceSheet,balanceSheetDescription,CFSMultiStr] = parseS7(section{7});
if strcmp(CFSMultiStr,'Millions')
    CFSMulti = 10^6;
else
    error('market:company:getInfo:multiplierChk','Invalid multiplier.')
end
balanceSheet(2:end,:) = balanceSheet(2:end,:)*BSMulti;

[cashFlowSummary,cashFlowSummaryDescription,ASMultiStr] = parseS8(section{8});
if strcmp(ASMultiStr,'Millions')
    ASMulti = 10^6;
else
    error('market:company:getInfo:multiplierChk','Invalid multiplier.')
end
cashFlowSummary(2:end,:) = cashFlowSummary(2:end,:)*CFSMulti;

assert(isequal(repmat(incomeStatement(1,:),2,1),[balanceSheet(1,:);cashFlowSummary(1,:)]),'market:company:getInfo:dateChk','Inconsistant dates.');
aCompany.financialInfo = [incomeStatement;balanceSheet(2:end,:);cashFlowSummary(2:end,:)];
aCompany.financialInfoDescription = [incomeStatementDescription;balanceSheetDescription(2:end);cashFlowSummaryDescription(2:end)];

[annualSummary,annualSummaryDescription] = parseS9(section{9});
annualSummary(2:end,:) = annualSummary(2:end,:)*ASMulti;
aCompany.annualSummary = annualSummary;
aCompany.annualSummaryDescription = annualSummaryDescription;

[aCompany.stockOwnership,aCompany.stockOwnershipDescription] = parse10(section{10});

aCompany.lastReportDate = parse11(section{11});


end

function thisSection = fixLines(thisSection)
nLines = size(thisSection,1);

lineCnt = 0;
for iLine = 1:nLines
    thisLine = thisSection{iLine};
    mat = regexp(thisLine,'^\s*-?\d.*','match');
    if isempty(mat)
        lineCnt = lineCnt + 1;
        thisSectionCopy{lineCnt,1} = thisLine;  %#ok<AGROW>
    else
        thisSectionCopy{lineCnt,1} = [thisSectionCopy{lineCnt,1} ' ' thisLine];  %#ok<AGROW>
    end
end
thisSection = thisSectionCopy;

end

function [data,multiplier] = getColumnData(thisSection,description,multiplierStr)

nLines = size(thisSection,1);

mat = regexp(thisSection,'\d+/\d+/\d+','match');
dates = datenum(mat{~cellfun(@isempty,mat)},'mm/dd/yyyy')';
nSamples = length(dates);

data = nan(length(description),nSamples);
data(1,:) = dates;
multiplier = '';

findLineExpr = '';
findDataExpr = '';
for iSample = 1:nSamples
    findLineExpr = [findLineExpr '\s+\S+'];  %#ok<AGROW>
    findDataExpr = [findDataExpr '(\S*)(?:\s*)']; %#ok<AGROW>
end

addSlashExpr = '(\(|\))';
description = regexprep(description,addSlashExpr,'\\$0');
for iLine = 1:nLines
    thisLine = thisSection{iLine};
    
    matStrInds = find(cellfun(@(aCell) ~isempty(regexp(thisLine,[aCell findLineExpr],'match')),description));
    if length(matStrInds) > 1
       [val,ind] = max(cellfun(@length,description(matStrInds)));
       matStrInds = matStrInds(ind);
    end
    if ~isempty(matStrInds)
        tok = regexp(thisLine,['(?:' description{matStrInds} '\s*)' findDataExpr],'tokens');
        tok = regexprep(tok{1},'(\,)','');
        data(matStrInds,:) = str2double(tok);
    end
    
    tok = regexp(thisLine,['(?:' multiplierStr '\s*\()(\w*)(?:\)\s*)'],'tokens');
    if ~isempty(tok), multiplier = tok{1}{1}; end
end

end

function data = getRowData(thisSection,description)
nVars = length(description);

varExpr = '(\d+/\d+)\s+';
for iVar = 1:nVars-1
    varExpr = [varExpr '(\S+)\s*']; %#ok<AGROW>
end

tok = regexp(thisSection,varExpr,'tokens');
tok = tok(~cellfun(@isempty,tok));
nSamples = length(tok);
data = zeros(nVars,nSamples);
for iSample = 1:nSamples
    data(1,iSample) = datenum(tok{iSample}{1}{1},'mm/yyyy');
    data(2:end,iSample) = (cellfun(@(aCell) str2double(aCell),tok{iSample}{1}(2:end)))';
end
end

function [address,phone,SIC] = parseS2(thisSection)

nLines = size(thisSection,1);
street = '';
city = '';
state = '';
zip = '';
phone = '';
SIC = '';
for iLine = 1:nLines
    thisLine = thisSection{iLine};
    
    tok = regexp(thisLine,'(?:Address:\s*)(.*\w)(?:\s*)','tokens');
    if ~isempty(tok), street = [tok{1}{1} ' ']; end
    tok = regexp(thisLine,'(?:City:\s*)(.*\w)(?:\s*)','tokens');
    if ~isempty(tok), city = [tok{1}{1} ' ']; end
    tok = regexp(thisLine,'(?:State:\s*)(.*\w)(?:\s*)','tokens');
    if ~isempty(tok), state = [tok{1}{1} ' ']; end
    tok = regexp(thisLine,'(?:Zip Code:\s*)(.*\w)(?:\s*)','tokens');
    if ~isempty(tok), zip = tok{1}{1}; end
    tok = regexp(thisLine,'(?:Telephone:\s*)(.*\w)(?:\s*)','tokens');
    if ~isempty(tok), phone = tok{1}{1}; end
    tok = regexp(thisLine,'(?:Primary SIC Code:\s*)(.*\w)(?:\s*)','tokens');
    if ~isempty(tok), SIC = str2double(tok{1}{1}); end
end
street = regexprep(lower(street),'(\<[a-z])','${upper($1)}');
city = regexprep(lower(city),'(\<[a-z])','${upper($1)}');
state = upper(state);
address = [street city state zip];

end

function description = parseS3(thisSection)

nLines = size(thisSection,1);
description = '';
for iLine = 1:nLines
    thisLine = thisSection{iLine};
    
    aLine = regexp(thisLine,'\S+.*\S','match');
    if ~isempty(aLine)
            description = [description aLine{1} ' ']; %#ok<AGROW>
    end
end
tok = regexp(description,'(.*)(?:\s*)(?:\.\.\.\s\[2\]More\s\.\.\..*)','tokens');
description = tok{1}{1};

end

function [shareStats,shareStatsDescription,FYE] = parseS4(thisSection)

shareStatsDescription = {...
        'Date';...
        '12-mos Rolling EPS';...
        'Dividend';...
        'P/E Ratio';...
        };
    
shareStats = getRowData(thisSection,shareStatsDescription);

tok = regexp(thisSection,'(?:FYE:\s*)(.*\w)(?:\s*)','tokens');
tok = tok(~cellfun(@isempty,tok));
FYE = tok{1}{1}{1};

end

function [financialRatios,financialRatiosDescription,ISMultiStr] = parseS5(thisSection)

nLines = size(thisSection,1);
financialRatiosDescription = {...
    'Financial Year End';...
    'Net Inc/Comm Equity';...
    'Net Inc/Total Assets';...
    'Net Inc/Inv Cap';...
    'Pretax Inc/Net Sales';...
    'Net Inc/Net Sales';...
    'Cash Flow/Net Sales';...
    'SG&A/NetSales';...
    'Net Receivables Turnover';...
    'Inventory Turnover';...
    'Inventory Day Sales';...
    'Net Sales/Work Cap';...
    'Net Sales/PP&E';...
    'Total Liab/Total Assets';...
    'Total Liab/Inv Cap';...
    'Total Liab/Comm Equity';...
    'Interest Coverage Ratio';...
    'Curr Debt/Equity';...
    'LTD/Equity';...
    'Total Debt/Equity';...
    'Quick Ratio';...
    'Current Ratio';...
    'Net Rec/Curr Assets';...
    'Inv/Curr Assets';...
    };
financialRatios = nan(length(financialRatiosDescription),1);
ISMultiStr = '';

for iLine = 1:nLines
    thisLine = thisSection{iLine};
    
    tok = regexp(thisLine,'(?:Profitability\s*)(\w*)(?:\s*)','tokens');
    if ~isempty(tok), financialRatios(1) = str2double(tok{1}{1}); end
    
    matStrInds = find(cellfun(@(aCell) ~isempty(findstr(thisLine,aCell)),financialRatiosDescription));
    
    for iMatStr = 1:length(matStrInds)
        tok = regexp(thisLine,['(?:' financialRatiosDescription{matStrInds(iMatStr)} '\s*)(\S*)(?:\s*)'],'tokens');
        financialRatios(matStrInds(iMatStr)) = str2double(tok{1}{1});
    end
    
    tok = regexp(thisLine,'(?:Income Statement\s*\()(\w*)(?:\)\s*)','tokens');
    if ~isempty(tok), ISMultiStr = tok{1}{1}; end
end

end

function [incomeStatement,incomeStatementDescription,BSMultiStr] = parseS6(thisSection)

thisSection = fixLines(thisSection);

incomeStatementDescription = {...
    'Date';...
    'Total Revenues(Net Sales)';...
    'Cost of Goods Sold';...
    'Selling & Admin Exps';...
    'Operating Income';...
    'Interest Exp';...
    'Pretax Income';...
    'Other Income';...
    'Net Income Bef Extraordinary ...';...
    'Net Income  ';...
    };

multiplierStr = 'Balance Sheet';

[incomeStatement,BSMultiStr] = getColumnData(thisSection,incomeStatementDescription,multiplierStr);

incomeStatementDescription{9} = 'Net Income Bef Extraordinary';
incomeStatementDescription{10} = 'Net Income';

end

function [balanceSheet,balanceSheetDescription,CFSMultiStr] = parseS7(thisSection)

thisSection = fixLines(thisSection);

balanceSheetDescription = {...
    'Date';...
    'Cash & Short Term Investments';...
    'Receivables - Total';...
    'Inventories - Total';...
    'Total Current Assets';...
    'Net Property, Plant & Equipment';...
    'Total Assets';...
    'Accounts Payable';...
    'Debt in Current Liabilities';...
    'Total Current Liabilities';...
    'Long-Term Debt';...
    'Total Liabilities';...
    'Minority Interest';...
    'Preferred Stock';...
    'Common Stock';...
    'Retained Earnings';...
    'Treasury Stock';...
    'Total Stockholders'' Equity';...
    'Total Liabilities and Stockholders'' Equity';...
    };

multiplierStr = 'Cash Flow Summary';

[balanceSheet,CFSMultiStr] = getColumnData(thisSection,balanceSheetDescription,multiplierStr);

end

function [cashFlowSummary,cashFlowSummaryDescription,ASMultiStr] = parseS8(thisSection)

thisSection = fixLines(thisSection);

cashFlowSummaryDescription = {...
    'Date';...
    'Net Cash Provided by Operating Activities';...
    'Net Cash Provided by Investing Activities';...
    'Net Cash Provided by Financing Activities';...
    };

multiplierStr = 'Annual Summary Data';

[cashFlowSummary,ASMultiStr] = getColumnData(thisSection,cashFlowSummaryDescription,multiplierStr);

end

function [annualSummary,annualSummaryDescription] = parseS9(thisSection)
annualSummaryDescription = {...
        'Date';...
        'Sales';...
        'Net Income';...
        'EPS';...
        };
    
annualSummary = getRowData(thisSection,annualSummaryDescription); 
end

function [stockOwnership,stockOwnershipDescription] = parse10(thisSection)
stockOwnershipDescription = {...
        'Date';...
        'No. Owners';...
        'Shares Held';...
        '% Own';...
        };
    
tok = regexp(thisSection,'\((0*)s*\)','tokens');
tenPower = length(tok{~cellfun(@isempty,tok)}{1}{1});
tok = regexp(thisSection,'\s*(\d+/\d+/\d+)\s+([\d,.]+)\s+([\d,.]+)\s+([\d,.-]+)','tokens');
stockOwnership(1,1) = datenum(tok{3}{1}{1},'mm/dd/yy');
stockOwnership(2,1) = str2double(tok{3}{1}{2});
stockOwnership(3,1) = str2double(tok{3}{1}{3})*10^tenPower;
stockOwnership(4,1) = str2double(tok{3}{1}{4});

end

function reportDate = parse11(thisSection)
tok = regexp(thisSection,'(\d+/\d+/\d+\d+)','tokens');
reportDate = datenum(tok{~cellfun(@isempty,tok)}{1}{1},'mm/dd/yyyy');
end
function plotH = plot(aStock,varargin)
% The "plot" method will plot the data for the given stock.
%
% USAGE:
%   plotH = plot(aStock,[optionStr1,optionVal1])
%
% INPUTS:
%   aStock - (1 x 1 market.stock)
%       An instance of the stock class.
%
% OPTIONS LIST:
%   'detail' - (1 x 1 logical) [Default false]
%       If true plot includes high, low, open, and close prices.
%
%   'average' - (1 x 1 logical) [Default false]
%       If true plot includes moving average.
%
%   'volume' - (1 x 1 logical) [Default false]
%       if true a sub plot of the volume of stocks traded will be included.
%
% OUTPUTS:
%   [plotH] - (1 x 1 graphics handle)
%       Handle to the lineseries graphic objects that were just plotted.
%
% NOTES:
%   By default the average between the high, low, open, close prices is
%   plotted.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +market
%
% REVISION:
%   1.0 31-JAN-2010 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%% Check
% Check number of arguments
error(nargchk(1,inf,nargin))

% Check arguments for errors
assert(isa(aStock,'market.stock') && isequal(size(aStock),[1 1]),...
    'market:stock:plot:aStockChk',...
    'Input argument "aStock" must be a 1 x 1 market.stock.')

% Get and check options
optargin = size(varargin,2);

assert(mod(optargin,2) == 0,'market:stock:plot:optionsChk1','"options" must come in pairs of an "optionStr" and an "optionVal".')

optStrs = varargin(1:2:optargin);
optValues = varargin(2:2:optargin);

for iParam = 1:optargin/2
    switch lower(optStrs{iParam})
        case 'detail'
%             detail = optValues{iParam};
            warning('market:stock:plot:detailChk','Option string %s is currently not working.',optStrs{iParam})
            detail = false;
        case 'average'
            average = optValues{iParam};
        case 'volume'
            volume = optValues{iParam};
        otherwise
            error('market:stock:plot:optionsChk2','Option string %s is not recognized.',optStrs{iParam})
    end
end

% Set to default value if necessary
if ~exist('detail','var'), detail = false; end
if ~exist('average','var'), average = false; end
if ~exist('volume','var'), volume = false; end

% Check optional arguments for errors
assert(islogical(detail) && isequal(size(detail),[1 1]),...
    'market:stock:plot:detailChk',...
    'Optional argument "detail" must be a 1 x 1 logical.')

assert(islogical(average) && isequal(size(average),[1 1]),...
    'market:stock:plot:averageChk',...
    'Optional argument "average" must be a 1 x 1 logical.')

assert(islogical(volume) && isequal(size(volume),[1 1]),...
    'market:stock:plot:volumeChk',...
    'Optional argument "volume" must be a 1 x 1 logical.')

%% Plot
if volume
    subplot(4,1,1:3)
end
if detail
    plotH = errorbar(aStock.date,aStock.avg,aStock.avg-aStock.low,aStock.high-aStock.avg);
else
    plotH = plot(aStock.date,aStock.avg,'b');
end

if average
    hold on
    plot(aStock.date,aStock.movingAvg,'r')
    hold off
end
title(aStock.symbol)
ylabel('Price ($)')
if volume
    xlim([min(aStock.date),max(aStock.date)])
    set(gca,'xtick',[])
    subplot(4,1,4)
    bar(aStock.date,aStock.volume/(10^6))
    ylabel('Volume (10^6)')
end
xlabel('Date (mm/yy)')
datetick('x','mm/yy')
xlim([min(aStock.date),max(aStock.date)])


%% Outputs
if nargout == 0
    clear plotH
end

end

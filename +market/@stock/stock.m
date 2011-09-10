classdef stock
% The "stock" class 
%
% NECESSARY FILES AND/OR PACKAGES:
% +market
%
% SEE ALSO:
%
% REVISION:
%   1.0 25-JAN-2010 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Properties
%--------------------------------------------------------------------------
properties (SetAccess = private, GetAccess = public)
    symbol % (string) Stock symbol.
    date % (? x 1 number) Vector of dates that correspond to historical metrics of the stock, as a Matlab serial date number.
    high % (? x 1 semi-positive number) Highest price of the stock for each date.
    low % (? x 1 semi-positive number) Lowest price of the stock for each date.
    open % (? x 1 semi-positive number) Opening price of the stock for each date.
    close % (? x 1 semi-positive number) Closing price of the stock for each date.
    volume % (? x 1 semi-positive number) Volume of stocks traded for each date.
end

properties (Access = public)
    avgLength = 10; % (? x 1 positive integer) [Default 10] The length of the moving average window.
end

properties (Dependent = true)
    avg % (? x 1 semi-positive number) The average of high, low, open, close for each date.
    movingAvg % (? x 1 semi-positive number) The moving average of the "avg" price of the stock for each date, with a window the size of "avgLength".
end

%--------------------------------------------------------------------------
% Methods
%--------------------------------------------------------------------------

% Constructor -------------------------------------------------------------
methods
    function aStock = stock(symbol,historicalData) % Constructor
        % Constructor function for the "stock" class.
        %
        % USAGE:
        %   aStock = stock([symbol],[historicalData])
        %
        % INPUTS:
        %	symbol - (string) [default ''] 
        %       Symbol of the stock.
        %
        %   historicalData - (? x 6 semi-positive real number) [default zeros(0,6)]
        %       A matrix of the historical data for the stock. The columns
        %       are: (1) date (Matlab serial date number), (2) high prices,
        %       (3) low prices, (4) opening prices, (5) closing prices, and
        %       (6) volumn. Missing data points should be set to NaN.
        %
        % OUTPUTS:
        %	aStock - (1 x 1 stock instance) 
        %       A new instance of the "stock" class.
        %
        % NOTES:
        %   Numbers are converted to singles because the double precision
        %   is unnecessary.
        %
        %------------------------------------------------------------------
        
        % Check number of arguments
        error(nargchk(0,2,nargin))
        
        % Apply default values
        if nargin < 1, symbol = ''; end
        if nargin < 2, historicalData = zeros(0,6); end
        
        % Check input arguments for errors
        assert(ischar(symbol),...
            'market:stock:symbolChk',...
            'Input argument "symbol" must be a string.')
        
        assert(isnumeric(historicalData) && isreal(historicalData) && size(historicalData,2) == 6,...
            'market:stock:historicalDataChk1',...
            'Input argument "historicalData" must be a ? x 6 matrix of real numbers or NaNs.')
        assert(all(all(historicalData(:,2:6) >= 0 | isnan(historicalData(:,2:6)))),...
            'market:stock:historicalDataChk2',...
            'Input argument "historicalData" values that are not dates must be semi-positive real numbers or NaNs.')
        
        % Assign
        aStock.symbol = upper(symbol);
        aStock.date = historicalData(:,1);
        aStock.high = historicalData(:,2);
        aStock.low = historicalData(:,3);
        aStock.open = historicalData(:,4);
        aStock.close = historicalData(:,5);
        aStock.volume = historicalData(:,6);
        
    end
end
%--------------------------------------------------------------------------

% Property methods --------------------------------------------------------
methods
    function aStock = set.avgLength(aStock,avgLength)
        % Overloaded assignment operator function for the "avgLength" property.
        %
        % USAGE:
        %	aStock.avgLength = avgLength;
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        assert(isnumeric(avgLength) && isreal(avgLength) && isequal(size(avgLength),[1 1]) && mod(avgLength,1) == 0 && avgLength > 0,...
            'market:stock:set:avgLengthChk',...
            '"avgLength" property must be set to a 1 x 1 real positive ineger.')

        aStock.avgLength = avgLength;
    end
    
    function avg = get.avg(aStock)
        % Overloaded query operator function for the "avg" property.
        %
        % USAGE:
        %	avg = aStock.avg
        %
        % NOTES:
        %
        %------------------------------------------------------------------

        avg = mean([aStock.high,aStock.low,aStock.open,aStock.close],2);
    end
    
    function movingAvg = get.movingAvg(aStock)
        % Overloaded query operator function for the "movingAvg" property.
        %
        % USAGE:
        %	movingAvg = aStock.movingAvg
        %
        % NOTES:
        %
        %------------------------------------------------------------------

        movingAvg = filtfilt(ones(1,aStock.avgLength)/aStock.avgLength,1,aStock.avg);
    end
end
%--------------------------------------------------------------------------
% 
% % Converting methods ------------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Converting function to convert anObj class to otherObject class.
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
methods
    plotH = plot(aStock,varargin)
end
%--------------------------------------------------------------------------
    
end

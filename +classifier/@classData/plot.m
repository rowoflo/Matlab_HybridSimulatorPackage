function plotH = plot(aClassData,feats,axisHandle,varargin)
% The "plot" method will plot the sample data object aClassData.
%
% USAGE:
%   aClassData = plot(aClassData,[feats],[axisHandle],[plotOptions])
%
% INPUTS:
%   aClassData - (1 x 1 classifier.aClassData)
%       An instance of the aClassData class.
%
%   [feats] - (2 x 1 feature index or feature name) [[1 2]]
%       A vector of feature indexes or feature names that specify which
%       two feature to use in the plot. First feature is the x-axis and
%       second feature is the y-axis
%
%   [axisHandle] - (1 x 1 handle) [gca]
%       Axis handle to axis the plot will be in, instead of current axes.
%
%   [plotOptions] -
%       Standard plot opitions such as LineSpec, 'PropertyName',
%       PropertyValue.
%
% OUTPUTS:
%   plotH - (1 x 1 handles)
%       A handle to the lineseries object.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +classifier
%
% REVISION:
%   1.0 22-OCT-2010 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%% Check
% Check number of arguments
error(nargchk(1,inf,nargin))

% Apply default values
if nargin < 2, feats = [1 2]; end
if nargin < 3, axisHandle = gca; end

% Check arguments for errors
assert(isa(aClassData,'classifier.classData') && numel(aClassData) == 1,...
    'classifier:classData:plot:aClassData',...
    'Input argument "aClassData" must be a 1 x 1 classifier.classData object.')

assert((isnumeric(feats) && isreal(feats) && isvector(feats) && numel(unique(feats)) == 2 && all(mod(feats,1) == 0) && all(feats >= 1 & feats <= aClassData.nFeatures)) || ...
       (iscellstr(feats) && numel(unique(feats)) == 2 && all(cellfun(@(aFeat) ismember(aFeat,aClassData.featureNames),feats))),...
    'classifier:classData:plot:feats',...
    'Input argument "feats" must be a 2 x 1 vector of unique positive integers <= %d or 2 x 1 cell array of unique feature names.',aClassData.nFeatures)
if isnumeric(feats)
    feats = feats(:);
end
if iscellstr(feats)
    feats = cellfun(@(aFeat) find(ismember(aClassData.featureNames,aFeat)),feats);
end

assert(ishandle(axisHandle),...
    'classifier:classData:plot:axisHandle',...
    'Input argument "axisHandle" must be a valid axis handle.')

%% Plot
plotH = plot(axisHandle,aClassData.samples(feats(1),:),aClassData.samples(feats(2),:),varargin{:});
set(plotH,'LineStyle','none')
if isempty(varargin)
    markerToks = [];
    colorToks = [];
else
    markerToks = regexp(varargin{1},'(\+?)(o?)(\*?)(\.?)(x?)(s?)(d?)(\^?)(v?)(\>?)(\<?)(p?)(h?)','tokens');
    colorToks = regexp(varargin{1},'(b?)(g?)(r?)(c?)(m?)(y?)(k?)(w?)','tokens');
end
if isempty(markerToks)
    theMarker = '+';
else
    symInd = cellfun(@(aCell) ~isempty(aCell),markerToks{1});
    theMarker = markerToks{1}{symInd};
end
if isempty(colorToks)
    theColor = 'b';
else
    symInd = cellfun(@(aCell) ~isempty(aCell),colorToks{1});
    theColor = colorToks{1}{symInd};
end
set(plotH,'Marker',theMarker)
set(plotH,'Color',theColor)

xlabel(aClassData.featureNames{feats(1)})
ylabel(aClassData.featureNames{feats(2)})
title(aClassData.name)

%% Plot PCA
if 1
    holdState = ishold;
    hold on
    theta = linspace(0,2*pi,128);
    [x,y] = pol2cart(theta,1);
    p = [x;y];
    p = aClassData.covMat(:,feats)'*p;
    p = p + repmat(aClassData.means(feats'),1,size(p,2));
    plot(p(1,:),p(2,:),theColor)
    hold on
    ishold
    
    for iPCA = 1:aClassData.nPCAs
        X = [aClassData.means(feats(1)) aClassData.means(feats(1)) + aClassData.PCAVals(iPCA)*aClassData.PCAVecs(feats(1),iPCA)];
        Y = [aClassData.means(feats(2)) aClassData.means(feats(2)) + aClassData.PCAVals(iPCA)*aClassData.PCAVecs(feats(2),iPCA)];
        line(X,Y,'Color',theColor)
    end
    
    if ~holdState
        hold off
    end
end

%% Output
if nargout < 1
    clear plotH
end

end

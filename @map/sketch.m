function graphicsHandle = sketch(mapObj,axisHandle,varargin)
% The "sketch" method draws the "mapObj" in the given axis. 
%
% SYNTAX: TODO: Add syntax
%   mapObj = mapObj.sketch()
%   mapObj = mapObj.sketch(axisHandle)
%   mapObj = mapObj.sketch(axisHandle,'parameterName',parameterValue)
%
% INPUTS: TODO: Add inputs
%   mapObj - (1 x 1 simulate.map)
%       Instances of the "simulate.map" class.
%
%   axisHandle - (1 x 1 axis handle) [gca]
%       Handle to the axis that the "mapObj" will be plotted in.
%
% OUTPUTS: TODO: Add outputs
%   graphicsHandle - (? x 1 graphics handle)
%       Handle to group graphics object for the "mapObj" that was just
%       plotted.
%
% NOTES: TODO: Add property notes maybe 'All lineseries properties can be used with this method.'
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +simulate
%
% AUTHOR:
%   26-APR-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments
error(nargchk(1,inf,nargin))

% Apply default values
if nargin < 2, axisHandle = gca;
    cla(axisHandle,'reset');
    set(axisHandle,'DrawMode','fast');
end

% Check arguments for errors
assert(isa(mapObj,'simulate.map') && numel(mapObj) == 1,...
    'simulate:map:sketch:mapObj',...
    'Input argument "mapObj" must be a 1 x 1 "simulate.map" object.')

assert(ishghandle(axisHandle),...
    'simulate:map:sketch:axisHandle',...
    'Input argument "axisHandle" must be a valid graphics handle.')

%% Axis Setup
nextPlotOriginal = get(axisHandle,'NextPlot');
set(axisHandle,'NextPlot','add')

%% Group handle
graphicsHandle = hggroup('Parent',axisHandle);

%% Plot
for iFeature = 1:mapObj.nFeatures
    aFeatureGraphicsHandle = mapObj.features{iFeature}.sketch(axisHandle,varargin{:});
    set(aFeatureGraphicsHandle,'Parent',graphicsHandle);
end

%% Revert to original settings
set(axisHandle,'NextPlot',nextPlotOriginal);

%% Output handle if needed
if nargout < 1
    clear graphicsHandle
end

end

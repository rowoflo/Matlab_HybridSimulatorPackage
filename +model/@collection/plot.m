function plotH = plot(aCollection,axesHandle,varargin)
% The "plot" method will plot the objects in "aCollection".
%
% USAGE:
%   aCollection.plot([axesHandle],[PropertyName,PropertyValue],...)
%
% INPUTS:
%   aCollection - (1 x 1 model.collection)
%       An instance of the collection class.
%
%   [axesHandle] - (1 x 1 axes handle) [Default gca]
%       Handle to the axes that the balls will be plotted in.
%
%   [PropertyName] - (? x 1 char)
%       Plot property name as a string.
%
%   [PropertyValue] - (?)
%       Plot property value.
%
% OUTPUTS:
%   [plotH] - (? x 1 graphics handle)
%       Handle to lineseries graphics objects that were just plotted, one per
%       object.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +model
%
% REVISION:
%   1.0 02-JAN-2010 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%% Check
% Check number of arguments
error(nargchk(1,inf,nargin))

if nargin < 2, axesHandle = gca; end

% Check arguments for errors
assert(isa(aCollection,'model.collection') && issize(aCollection,1,1),...
    'model:collection:plot:aCollectionChk',...
    '"aCollection" must be a 1 x 1 model.collection')

assert(ishandle(axesHandle),...
    'model:collection:plot:axesHandleChk',...
    'Input argument ''axesHandle'' must be a valid graphics handle.')

%% Plot objects
objPlotH = aCollection.objects.plot(axesHandle);

%% Create transform object
transformH = hgtransform('Parent',axesHandle);
set(objPlotH,'Parent',transformH);

set(transformH,'Matrix',HGRep(aCollection.position,aCollection.orientation))

%% Output
if nargout == 1
    plotH = transformH;
end

end

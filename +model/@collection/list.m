function objectNames = list(aCollection)
% The "list" method will make a list of objects that the "aCollection" object
% currently contains.
%
% USAGE:
%   objectNames = aCollection.list
%
% INPUTS:
%   aCollection - (1 x 1 model.collection)
%       An instance of the collection class.
%
% OUTPUTS:
%   objectNames - (? x 1 cell array of strings)
%       List of object names.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +model, issize.m
%
% REVISION:
%   1.0 30-NOV-2009 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%% Check
% Check number of arguments
error(nargchk(1,1,nargin))

% Check arguments for errors
assert(isa(aCollection,'model.collection') && issize(aCollection,1,1),...
    'model:collection:list:aCollectionChk',...
    '"aCollection" must be a 1 x 1 model.collection')

%% List
objectNames = {aCollection.objects.name}';


end

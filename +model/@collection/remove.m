function aCollection = remove(aCollection,objectNames)
% The "remove" method will remove the objects with the names given by
% "objectNames" from the "aCollection" instance.
%
% USAGE:
%   aCollection = aCollection.remove(objectNames)
%
% INPUTS:
%   aCollection - (1 x 1 model.collection)
%       An instance of the collection class.
%
%   objectNames - (1 x ? char or cell array of strings)
%       List of object names.
%
% OUTPUTS:
%   aCollection - (1 x 1 model.collection)
%       An instance of the collection class with the selected objects removed.
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
error(nargchk(2,2,nargin))

% Check arguments for errors
assert(isa(aCollection,'model.collection') && issize(aCollection,1,1),...
    'model:collection:remove:aCollectionChk',...
    '"aCollection" must be a 1 x 1 model.collection')

assert(ischar(objectNames) || iscellstr(objectNames),...
    'model:collection:remove:objectNamesChk1',...
    '"objectNames" must be a cell array of strings')

if ~iscell(objectNames)
    objectNames = {objectNames};
end
objectNames = objectNames(:);

%% Find selected objects
% Check that selected names are part of collection
unknownInd = ~ismember(objectNames,aCollection.list);
if any(unknownInd)
    warning('model:collection:remove:objectNamesChk2',...
        'Unknown objects: %s',cell2str(objectNames(unknownInd)','singleQuotes',true))
end

% Find selected names in collection name list
keepInd = ~ismember(aCollection.list,objectNames);

%% Remove selected objects
aCollection.objects = aCollection.objects(keepInd);

%% Update inertia state
aCollection = aCollection.calcInertiaState;

end

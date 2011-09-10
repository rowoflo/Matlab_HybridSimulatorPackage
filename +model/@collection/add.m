function aCollection = add(aCollection,someObjects)
% The "add" method will add objects "someObjects" to the "aCollection"
% instance.
%
% USAGE:
%   aCollection = aCollection.add(someObjects)
%
% INPUTS:
%   aCollection - (1 x 1 model.collection)
%       An instance of the collection class.
%
%	someObjects - (? x 1 model.object)
%       Adds these objects that the collection object.
%
% OUTPUTS:
%   aCollection - (1 x 1 model.collection)
%       An instance of the collection class with the new objects added.
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

% Check input arguments for errors
assert(isa(aCollection,'model.collection') && issize(aCollection,1,1),...
    'model:collection:add:aCollectionChk',...
    'Input argument "aCollection" must be a 1 x 1 model.collection.')

assert(isa(someObjects,'model.object') && issize(someObjects,[],1),...
    'model:collection:add:someObjectsChk',...
    'Input argument "someObjects" must be a ? x 1 model.object array.')

%% Add objects
aCollection.objects = [aCollection.objects;someObjects];

%% Update inertia state
aCollection = aCollection.calcInertiaState;

end

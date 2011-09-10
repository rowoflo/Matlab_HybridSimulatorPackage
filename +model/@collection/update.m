function aCollection = update(aCollection,varargin)
% The "update" method updates the properties of "aCollection" and applies
% updates to any objects in "aCollection" that need to be updated.
%
% USAGE:
%   aCollection = aCollection.update(...)
%
% INPUTS:
%   See ?model.object.update? documentation for description of input
%   arguments.
%
% OUTPUTS:
%   aCollection - (1 x 1 model.collection)
%       An instance of the collection class after being updated.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +model
%
% REVISION:
%   1.0 23-DEC-2009 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%% Update collection
aCollection = aCollection.update@model.object(varargin{:});

%% Update objects in collection
inMotionObjs = any([[aCollection.objects.momentum];[aCollection.objects.angularMomentum]] ~= 0,1);
if any(inMotionObjs)
    aCollection.objects(inMotionObjs) = aCollection.objects(inMotionObjs).update(varargin{1});
    
    aCollection = aCollection.calcInertiaState;
end

end

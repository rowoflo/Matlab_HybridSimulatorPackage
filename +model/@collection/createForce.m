function [forceVector,forceLocation] = createForce(aCollection)
% The "createForce" method will create new forces based on the current
% object's properties.
%
% USAGE:
%   [forceVector,forceLocation] = createForce.aCollection
%
% INPUTS:
%   anObject - (1 x 1 model.object)
%       An instance of the object class.
%
% OUTPUTS:
%   forceVector - (3 x 1 number or cell array)
%       The force vector in the coordinates of the external reference
%       frame.
%
%   forceLocation - (3 x 1 number or cell array)
%       The location of the force vector in the coordinates of the external
%       reference frame.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +model, issize.m
%
% REVISION:
%   1.0 03-DEC-2009 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%% Check
% Check number of arguments
error(nargchk(1,1,nargin))

% Check arguments for errors
assert(isa(aCollection,'model.collection') && issize(aCollection,1,1),...
    'model:createForce:createForce:aCollectionChk',...
    '"aCollection" must be a 1 x 1 model.collection')

%% Gather forces of object contained in the collection
forceVector = {};
forceLocation = {};
for iObject = 1:aCollection.numOfObjects
    [aForceVector aForceLocation] = aCollection.objects(iObject).createForce;
    forceVector = [forceVector aForceVector]; %#ok<*AGROW>
    forceLocation = [forceLocation aForceLocation];
end

end

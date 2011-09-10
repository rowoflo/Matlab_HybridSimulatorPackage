function aCollection = calcInertiaState(aCollection)
% The "calcInertiaState" method will calculate the mass, center of mass,
% and inertia tensor of the collection of objects "aCollection".
%
% USAGE:
%   aCollection = aCollection.calcInertiaState
%
% INPUTS:
%   aCollection - (1 x 1 model.collection)
%       An instance of the "collection" class.
%
% OUTPUTS:
%   colletion - (1 x 1 model.collection)
%       An instance of the "collection" class with the new inertia states.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +model
%
% REVISION:
%   1.0 06-JAN-2010 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%% Calculate mass, center of mass, and inertia tensor
% Caculate mass
aCollection.mass = sum([aCollection.objects.mass]);

% Caculate center of mass
selfCM = [0;0;0];
for iObj = 1:aCollection.numOfObjects
    thisObj = aCollection.objects(iObj);
    selfCM = thisObj.centerOfMass*thisObj.mass/aCollection.mass+selfCM;
end
aCollection.selfCenterOfMass = selfCM;

% Caculate inertia tensor
selfI = zeros(3,3);
for iObj = 1:aCollection.numOfObjects
    thisObj = aCollection.objects(iObj);
    radial = aCollection.selfCenterOfMass - thisObj.centerOfMass; % Vector from collection's CM to this object's CM
    displaced = thisObj.inertiaTensor + thisObj.mass*((radial'*radial)*eye(3)-radial*radial'); % Displacement of inertia tensor in external reference frame
    selfI = selfI + displaced;
end
aCollection.selfInertiaTensor = selfI;

end

function someObjects = update(someObjects,deltaT,forceVector,forceLocation)
% The "update" method updates the properties of each object in "someObjects".
%
% USAGE:
%   someObjects = someObjects.update(deltaT,[forceVector],[forceLocation])
%
% INPUTS:
%   someObjects - (model.object)
%       An instance of the object class.
%
%   deltaT - (1 x 1 semi-positive real number)
%       The time between the beginning of the update and the end of the
%       update.
%
%   [forceVector] - (3 x numOfForces real number) [Default [0;0;0]]
%       The force vector in the coordinates of the external reference
%       frame.
%
%   [forceLocation] - (3 x numOfForces real number) [Default [NaN;NaN;NaN]
%       The location of the force vector in the coordinates of the external
%       reference frame. A NaN indicates to use the center of mass of for
%       the given object.
%
% OUTPUTS:
%   someObjects - (? x ? model.anObject)
%       Instances of the object class after being updated.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +model
%
% REVISION:
%   1.0 01-DEC-2009 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%% Check
% Check number of arguments
error(nargchk(2,4,nargin))

% Check input arguments for errors
assert(isa(someObjects,'model.object'),...
    'model:object:update:someObjectsChk',...
    'Input argument ''someObjects'' must be a model.object.')

assert(isnumeric(deltaT) && isreal(deltaT) && isequal(size(deltaT),[1,1]) && deltaT >= 0,...
    'model:object:update:deltaTChk',...
    'Input argument ''deltaT'' must be a 1 x 1 semi-positive real number.')

if nargin < 3, forceVector = [0;0;0]; end
assert(isnumeric(forceVector) && isreal(forceVector) && isequal(size(forceVector,1),3),...
    'model:object:update:forceVectorChk',...
    'Input argument ''forceVector'' must be a 3 x ? real number and have the same number of forces as impulse times.')
numOfForces = size(forceVector,2);

if nargin < 4, forceLocation = nan(3,numOfForces); end
assert(isnumeric(forceLocation) && isreal(forceLocation) && isequal(size(forceLocation),[3 numOfForces]),...
    'model:object:update:forceLocationChk',...
    'Input argument ''forceLocation'' must be a 3 x ? real number and have the same number of locations as number of forces.')

%% Check delta time
if deltaT == 0
    return
end

%% Remove force vectors equal to zero
% Remove
validForces = any(forceVector ~= 0,1);
forceVector = forceVector(:,validForces);
forceLocation = forceLocation(:,validForces);
numOfForces = sum(validForces);

% Get NaN indices
nanInd = isnan(forceLocation);

%% Loop through all objects
for iObj = 1:numel(someObjects)
    anObject = someObjects(iObj);
    
    %% Update time
    anObject.time = anObject.time + deltaT;
    
    %% Check if update is necessary
    if ~any(validForces) && all(anObject.velocity == 0) && all(anObject.angularVelocity == 0)
        someObjects(iObj) = anObject;
        continue
    end
    
    %% Get current states
    % Translation
    v0 = anObject.velocity; % Initial velocity
    s0 = anObject.position; % Initial position
    % Rotation
    w0 = anObject.angularVelocity; % Initial angular velocity
    phi0 = anObject.orientation; % Initial orientation
    
    %% Calculate forces and torques and update momentums if necessary
    if numOfForces > 0
        % Apply center of mass values to NaN values in force locations
        repCM = repmat(anObject.centerOfMass,1,numOfForces);
        forceLocation(nanInd) = repCM(nanInd);
        
        % Calculate force radials
        forceRadial = forceLocation - repCM;
        
        % Calculate torques
        torqueVector = cross(forceRadial,forceVector);
        
        % Update momentums
        anObject.momentum = sum(forceVector,2)*deltaT + anObject.momentum;
        anObject.angularMomentum = sum(torqueVector,2)*deltaT + anObject.angularMomentum;
    end
    
    %% Update anObject with new position
    % Translation
    anObject.position = 1/2*(anObject.velocity+v0)*deltaT + s0;
    % Rotation
    phiVector = 1/2*(anObject.angularVelocity+w0)*deltaT;
    
    if ~isequal(phiVector,[0;0;0])
        phiMag = norm(phiVector);
        phiUnitDir = phiVector/phiMag;
        [point,phiRot] = HGRepI(makehgtform('axisrotate',phiUnitDir,phiMag));
    else
        phiRot = eye(3);
    end
    
    anObject.orientation = phiRot*phi0;
    
    %% Update someObjects with updated anObject
    someObjects(iObj) = anObject;
end

end

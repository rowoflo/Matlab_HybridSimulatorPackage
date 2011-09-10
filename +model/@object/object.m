classdef object
% This is an abstract class for creating objects. Subclasses must redefine
% the name, mass, centerOfMass, and inertiaTensor properties and the
% plot and creatForce methods.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +model
%
% SEE ALSO:
%   model.collection
%
% REVISION:
%   1.1 01-JAN-2010 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Properties
%--------------------------------------------------------------------------
properties (Abstract = true)
    name % (1 x ? char)  Name of the object.
end

properties (Abstract = true, SetAccess = private)
    mass % (1 x 1 positive real number) Mass of the object.
    selfCenterOfMass % (3 x 1 real number) Center of mass of the object in reference to its own reference frame.
    selfInertiaTensor % (3 x 3 real number of the positive-definite matrix form) Moment of inertia (or angular mass) tensor of the object in reference to its own reference frame at its center of mass.
end

properties (SetAccess = protected)
    time % (1 x 1 real number) Current time for the object.
    position % (3 x 1 real number) Position of the object with respect to an external referecne frame.
    momentum % (3 x 1 real number) Linear momentum of the object with respect to an external reference frame.
    orientation % (3 x 3 real number of the SO(3) matrix form) Orientation of the object with respect to an outer reference frame, this is a rotation matrix of SO(3) from an external reference frame to the object frame.
    angularMomentum % (3 x 1 real number) Angular momentum of the object with respect to an external reference frame.
end

properties (Dependent = true, SetAccess = private)
    centerOfMass % (3 x 1 real number) Center of mass of the object with respect to an external referecne frame.
    inertiaTensor % (3 x 3 real number of the positive-definite matrix form) Moment of inertia (or angular mass) tensor of the object with respect to an external referecne frame.
    velocity % (3 x 1 number) Velocity vector of the object with respect to an external referecne frame.
    angularVelocity % (3 x 1 number) Angular velocity of the object with respect to an external reference frame.
end

%--------------------------------------------------------------------------
% Methods
%--------------------------------------------------------------------------

% Constructor -------------------------------------------------------------
methods
    function anObject = object(time,position,momentum,orientation,angularMomentum) % Constructor
        % Constructor function for the "object" class.
        %
        % USAGE:
        %   anObject = object([time],[position],[momentum],[orientation],[angularMomentum])
        %
        % INPUTS:
        %   [time] - (1 x 1 real number) [Default 0]
        %       Sets the "time" property of the object "anObject".
        %
        %   [position] - (3 x 1 real number) [Default zeros(3,1)]
        %       Sets the "position" property of the object "anObject".
        %
        %   [momentum] - (3 x 1 real number) [Default zeros(3,1)]
        %       Sets the "momentum" property of the object "anObject".
        %
        %   [orientation] - (3 x 3 real number of the SO(3) matrix form) [Default eye(3)]
        %       Sets the "orientation" property of the object "anObject".
        %
        %   [angularMomentum] - (3 x 1 real number) [Default zeros(3,1)]
        %       Sets the "angularMomentum" property of the object "anObject".
        %
        % OUTPUTS:
        %	anObject - (1 x 1 model.object) 
        %       A new instance of the "object" class.
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        % Check input arguments
        error(nargchk(0,5,nargin))
        
        if nargin < 1, time = 0; end
        if nargin < 2, position = zeros(3,1); end
        if nargin < 3, momentum = zeros(3,1); end
        if nargin < 4, orientation = eye(3); end
        if nargin < 5, angularMomentum = zeros(3,1); end
        
        % Check input arguments for errors
        assert(isnumeric(time) && isreal(time) && isequal(size(time),[1 1]),...
            'model:object:object:timeChk',...
            'Input argument ''time'' must be a 1 x 1 real number.')
        
        assert(isnumeric(position) && isreal(position) && isequal(size(position),[3 1]),...
            'model:object:object:positionChk',...
            'Input argument ''position'' must be a 3 x 1 real number.')
        
        assert(isnumeric(momentum) && isreal(momentum) && isequal(size(momentum),[3 1]),...
            'model:object:object:momentumChk',...
            'Input argument ''momentum'' must be a 3 x 1 real number.')
        
        assert(isnumeric(orientation) && isreal(orientation) && isequal(size(orientation),[3 3]) && isequal(orientation'*orientation,eye(3)) && det(orientation) == 1,...
            'model:object:object:orientationChk',...
            'Input argument ''orientation'' must be a 3 x 3 real number that is a valid rotation matrix.')
        
        assert(isnumeric(angularMomentum) && isreal(angularMomentum) && isequal(size(angularMomentum),[3 1]),...
            'model:object:object:angularMomentumChk',...
            'Input argument ''angularMomentum'' must be a 3 x 1 real number.')
           
        % Assign
        anObject.time = time;
        anObject.position = position;
        anObject.momentum = momentum;
        anObject.orientation = orientation;
        anObject.angularMomentum = angularMomentum;
        
    end
end
%--------------------------------------------------------------------------

% Property methods --------------------------------------------------------
methods
    function centerOfMass = get.centerOfMass(anObject)
        % Overloaded query operator function for the "centerOfMass" property.
        %
        % USAGE:
        %	centerOfMass = anObject.centerOfMass
        %
        % NOTES:
        %
        %------------------------------------------------------------------

        HG = [[anObject.orientation;zeros(1,3)] [anObject.position;1]]*[anObject.selfCenterOfMass;1];
        centerOfMass = HG(1:3,1);
    end
    
    function inertiaTensor = get.inertiaTensor(anObject)
        % Overloaded query operator function for the "inertiaTensor" property.
        %
        % USAGE:
        %	inertiaTensor = anObject.inertiaTensor
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        inertiaTensor = anObject.orientation*anObject.selfInertiaTensor*anObject.orientation';
    end
    
    function velocity = get.velocity(anObject)
        % Overloaded query operator function for the "velocity" property.
        %
        % USAGE:
        %	velocity = anObject.velocity
        %
        % NOTES:
        %
        %------------------------------------------------------------------

        velocity = anObject.momentum/anObject.mass;
    end
    
    function angularVelocity = get.angularVelocity(anObject)
        % Overloaded query operator function for the "angularVelocity" property.
        %
        % USAGE:
        %	angularVelocity = anObject.angularVelocity
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        angularVelocity = anObject.inertiaTensor^-1*anObject.angularMomentum;
    end
    
end
%--------------------------------------------------------------------------

% Methods in separte files ------------------------------------------------
methods
    someObjects = update(someObjects,deltaT,forceVector,forceLocation)
end

methods (Abstract = true)
    plotH = plot(someObjects,axesHandle,varargin)
    [forceVector,forceLocation] = createForce(anObject)
end
%--------------------------------------------------------------------------
   
end

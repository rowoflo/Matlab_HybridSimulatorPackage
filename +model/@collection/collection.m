classdef collection < model.object
% The "collection" class is a container class for the object class.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +model, issize.m,
%
% SEE ALSO: 
%   model.object
%
% REVISION:
%   1.0 28-NOV-2009 by Rowland O'Flaherty
%       Initial Revision
%
%--------------------------------------------------------------------------

%--------------------------------------------------------------------------
% Properties
%--------------------------------------------------------------------------
properties
    name = 'objects'; % (1 x ? char)  Name of the collection.
end

properties (SetAccess = public)
    objects % (? x 1 model.object) An array of object class instances.
end

properties (SetAccess = private)
    mass % (1 x 1 positive real number) Mass of the object.
    selfCenterOfMass % (3 x 1 real number) Center of mass of the object in reference to its own reference frame.
    selfInertiaTensor % (3 x 3 real number of the positive-definite matrix form) Moment of inertia (or angular mass) tensor of the object in reference to its own reference frame at its center of mass.
end

properties (Dependent = true, SetAccess = private)
    numOfObjects % (1 x 1 positive integer) Number of objects in collection.
end

%--------------------------------------------------------------------------
% Methods
%--------------------------------------------------------------------------

% Constructor -------------------------------------------------------------
methods
    function aCollection = collection(someObjects,varargin) % Constructor
        % Constructor function for the "collection" class.
        %
        % USAGE:
        %   aCollection = collection([someObjects],...)
        %
        % INPUTS:
        %	[someObjects] - (? x 1 model.object)
        %       Sets the initial set of objects that the collection will
        %       hold.
        %
        %   See ?model.object? documentation for description of other input
        %   arguments.
        %
        % OUTPUTS:
        %	aCollection - (1 x 1 collection instance) 
        %       A new instance of the "collection" class.
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        % Check input arguments
        error(nargchk(0,1,nargin))
        
        % Initialize
        aCollection = aCollection@model.object(varargin{:});
        
        % Assign
        if nargin >= 1
            % Check input arguments for errors
            assert(isa(someObjects,'model.object') && size(someObjects,2) == 1,...
                'model:collection:collection:someObjectsChk',...
                'Input argument "someObjects" must be a ? x 1 model.object.')
            
            aCollection.objects = someObjects;
            
            aCollection = aCollection.calcInertiaState;
        end
        
    end
end
%--------------------------------------------------------------------------

% Property methods
methods
    function aCollection = set.name(aCollection,name)
        % Overloaded assignment operator function for the "name" property.
        %
        % USAGE:
        %	aCollection.name = name
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        % Check input arguments for errors
        assert(ischar(name),...
            'model:collection:setName:nameChk',...
            'Input argument ''name'' must be a character array.')
        
        aCollection.name = name;
    end
    
    function numOfObjects = get.numOfObjects(aCollection)
        % Overloaded query operator function for the "numOfObjects" property.
        %
        % USAGE:
        %	numOfObjects = aCollection.numOfObjects
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        numOfObjects = numel(aCollection.objects);
    end
    
   
end

% Methods in separte files ------------------------------------------------
methods
    plotH = plot(aCollection,axesHandle,varargin)
    [forceVector,forceLocation] = createForce(aCollection)
    aCollection = update(aCollection,deltaT,forceVector,forceLocation)
    
    aCollection = add(aCollection,someObjects)
    aCollection = remove(aCollection,objectNames)
    objectNames = list(aCollection)
end

methods (Access = private)
    aCollection = calcInertiaState(aCollection)
end
%--------------------------------------------------------------------------
   
end

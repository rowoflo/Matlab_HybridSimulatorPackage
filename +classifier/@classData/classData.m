classdef classData
% This is a container class for classification data by class (or type,
% group, etc.).
%
% classData Properties:
%   name  Class name.
%   label - Class label.
%   samples - Class feature values for each sample.
%   featureNames - Feature names.
%   nFeatures - Number of features in data.
%   nSamples - Number of samples in data.
%   means - Feature mean values.
%   stds - Feature standard deviation values.
%   covMat - Feature covariance matrix.
%
% classData Methods:
%   method1 - Description.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +classifier
%
% REVISION:
%   1.0 22-OCT-2010 by Rowland O'Flaherty
%       Initial Revision
%
% SEE ALSO:
%    classifier.data
%
%--------------------------------------------------------------------------

%% Properties -------------------------------------------------------------
properties (Access = public)
    name % (string) Class name.
    label % (1 x 1 integer) Class label.
    maxNumOfPCAs = 10; % (1 x 1 positive integer) Maximum number of pricipal components. 
end

properties (GetAccess = public, SetAccess = protected)
    featureNames % (nFeatures x 1 cell array of strings) Feature names.
end

properties (GetAccess = public, SetAccess = private)
    samples % (nFeatures x nSamples number) Class feature values for each sample.
    nFeatures % (1 x 1 semi-positive integer) Number of features in data.
    nSamples % (1 x 1 semi-positive integer) Number of samples in data.
    means % (nFeatures x 1 number) Feature mean values.
    stds % (nFeatures x 1 number) Feature standard deviation values.
    covMat % (nFeatures x nFeatures number) Feature covariance matrix.
    nPCAs % (1 x 1 semi-positive integer) Number of principal components.
    PCAVals % (1 x nPCA number) Principal component values.
    PCAVecs % (nFeatures x nPCA number) Pricipal component vectors.
end

%% Constructor ------------------------------------------------------------
methods
    function aClassData = classData(samples,label,className,featureNames)
        % Constructor function for the "classData" class.
        %
        % USAGE:
        %   aClassData = classData(samples,[label],[className],[featureNames])
        %
        % INPUTS:
        %	samples - (nFeatures x nSamples number) 
        %       Feature values for each sample in the class data.
        %
        %   [label] - (1 x 1 integer) [1]
        %       Label associated with the class.
        %
        %   [className] - (string) [['Class' num2str(label)]]
        %       Name of the class
        %
        %   [featureNames] - (nFeatures x 1 cell array of strings) [{'Feature1';...;'FeatureN'}]
        %       Feature names.
        %
        % OUTPUTS:
        %	aClassData - (1 x 1 classData instance) 
        %       A new instance of the "classData" class.
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        % Check number of arguments
        error(nargchk(0,4,nargin))

        % Apply default values
        if nargin < 1, samples = 0; end
        if nargin < 2, label = 1; end
        if nargin < 3, className = ''; end
        if nargin < 4, featureNames = {}; end

        % Check input arguments for errors
        if nargin >= 1
            assert(isnumeric(samples) && ismatrix(samples),...
                'classifier:classData:samples',...
                'Input argument "samples" must be a matrix of numbers.')
            nFeatures = size(samples,1);
            
            assert(isnumeric(label) && isreal(label) && numel(label) == 1 && mod(label,1) == 0,...
                'classifier:classData:label',...
                'Input argument "label" must be a 1 x 1 of real integer.')
            
            assert(ischar(className),...
                'classifier:classData:className',...
                'Input argument "className" must be a string.')
            if isempty(className)
                className = ['Class' num2str(label)];
            end
            
            assert((iscellstr(featureNames) && isvector(featureNames) && numel(featureNames) == nFeatures) || isempty(featureNames),...
                'classifier:classData:featureNames',...
                'Input argument "featureNames" must be %d x 1 cell array of strings.',nFeatures)
            featureNames = featureNames(:);
            if isempty(featureNames)
                featureNames = cell(nFeatures,1);
                for iFeat = 1:nFeatures
                    featureNames{iFeat} = ['Feature' num2str(iFeat)];
                end
            end
        end
        
        % Assign properties
        aClassData.name = className;
        aClassData.label = label;
        aClassData.featureNames = featureNames;
        aClassData.samples = samples;
        
        aClassData.nFeatures = size(aClassData.samples,1);
        aClassData.nSamples = size(aClassData.samples,2);
        aClassData.means = mean(aClassData.samples,2);
        aClassData.stds = std(aClassData.samples,0,2);
        aClassData.covMat = cov(aClassData.samples');
        aClassData.nPCAs = min(aClassData.nFeatures,aClassData.maxNumOfPCAs);
        [V,D] = eigs(aClassData.covMat,aClassData.nPCAs);
        aClassData.PCAVals = diag(D)';
        aClassData.PCAVecs = V;
    end
end
%--------------------------------------------------------------------------

%% Property methods -------------------------------------------------------
methods
    function aClassData = set.name(aClassData,name)
        % Overloaded assignment operator function for the "name" property.
        %
        % USAGE:
        %	aClassData.name = name
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        assert(ischar(name),...
            'classifier:set:name',...
            'Property "name" must be a string.')
        
        aClassData.name = name;
    end
    
    function aClassData = set.label(aClassData,label)
        % Overloaded assignment operator function for the "label" property.
        %
        % USAGE:
        %	aClassData.label = label
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        assert(isnumeric(label) && isreal(label) && numel(label) == 1 && mod(label,1) == 0,...
            'classifier:set:label',...
            'Property "label" must be a 1 x 1 of real integer.')
        
        aClassData.label = label;
    end
    
%     function nFeatures = get.nFeatures(aClassData)
%         % Overloaded query operator function for the "nFeatures" property.
%         %
%         % USAGE:
%         %	nFeatures = aClassData.nFeatures
%         %
%         % NOTES:
%         %
%         %------------------------------------------------------------------
%         
%         nFeatures = size(aClassData.samples,1);
%     end
%     
%     function nSamples = get.nSamples(aClassData)
%         % Overloaded query operator function for the "nSamples" property.
%         %
%         % USAGE:
%         %	nSamples = aClassData.nSamples
%         %
%         % NOTES:
%         %
%         %------------------------------------------------------------------
%         
%         nSamples = size(aClassData.samples,2);
%     end
%     
%     function means = get.means(aClassData)
%         % Overloaded query operator function for the "means" property.
%         %
%         % USAGE:
%         %	means = aClassData.means
%         %
%         % NOTES:
%         %
%         %------------------------------------------------------------------
%         
%         means = mean(aClassData.samples,2);
%     end
%     
%     function stds = get.stds(aClassData)
%         % Overloaded query operator function for the "stds" property.
%         %
%         % USAGE:
%         %	stds = aClassData.stds
%         %
%         % NOTES:
%         %
%         %------------------------------------------------------------------
%         
%         stds = std(aClassData.samples,0,2);
%     end
%     
%     function covMat = get.covMat(aClassData)
%         % Overloaded query operator function for the "covMat" property.
%         %
%         % USAGE:
%         %	covMat = aClassData.covMat
%         %
%         % NOTES:
%         %
%         %------------------------------------------------------------------
%         
%         covMat = cov(aClassData.samples');
%     end
end
%--------------------------------------------------------------------------

%% General Methods --------------------------------------------------------
% methods (AttributeName = value,...)
%     function thisObj = classData(thisObj,arg1)
%         % The "classData" method will ??? the ??? object thisObj.
%         %
%         % USAGE:
%         %   thisObj = thisObj.classData(arg1)
%         %
%         % INPUTS:
%         %   thisObj - (1 x 1 package.thisObj)
%         %       An instance of the ??? class.
%         %
%         %   arg1 - (size type) [default ???] 
%         %       Description.
%         %
%         % OUTPUTS:
%         %   thisObj - (1 x 1 classifier.thisObj)
%         %       An instance of the ??? class ... ???.
%         %
%         % NOTES:
%         %
%         %------------------------------------------------------------------
% 
%         % Check number of arguments
%         error(nargchk(1,2,nargin))
%         
%         % Apply default values
%         if nargin < 2, arg1 = 0; end
%         
%         % Check arguments for errors
%         assert(isnumeric(arg1) && isreal(arg1) && isequal(size(arg1),[?,?]),...
%             'classifier:class_name:classData:arg1',...
%             'Input argument "arg1" must be a ? x ? matrix of real numbers.')
%         
%     end
%     
%     
% end
%--------------------------------------------------------------------------

%% Converting methods -----------------------------------------------------
% methods
%     function anOtherObject = otherObject
%         % Function to convert classData object to a otherObject object.
%         %
%         % USAGE:
%         %	otherObject(aClassData)
%         %
%         % NOTES:
%         %
%         %------------------------------------------------------------------
%         
% 
%     end
% 
% end
%--------------------------------------------------------------------------

%% Methods in separte files -----------------------------------------------
methods (Access = public)
    plotH = plot(aClassData,varargin);
end
%--------------------------------------------------------------------------
    
end

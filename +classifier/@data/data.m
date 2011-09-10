classdef data
% This is a container class for "classData" objects.
%
% data Properties:
%   prop1 - Description.
%
% data Methods:
%   method1 - Description.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +classifier, someFile.m
%
% REVISION:
%   1.0 22-OCT-2010 by Rowland O'Flaherty
%       Initial Revision
%
% SEE ALSO:
%    classifier.classData
%
%--------------------------------------------------------------------------

%% Properties -------------------------------------------------------------
properties (GetAccess = public, SetAccess = protected)
    name % (string) Data name.
    labels % (nClasses x 1 integer) Class labels.
    classes % (nClasses x 1 classifier.classData) Array of "classData" objects.
end

properties (Dependent = true, GetAccess = public)
    nClasses % (1 x 1 semi-positive integer) Number of classes in data.
    classNames % (nClasses x 1 cell array of strings) Class names.
    nFeatures % (1 x 1 semi-positive integer) Number of features in data.
    featureNames % (nFeatures x 1 cell array of strings) Feature names.
    nSamples % (1 x 1 semi-positive integer) Number of samples in data.
    means % (nFeatures x 1 number) Feature mean values.
    stds % (nFeatures x 1 number) Feature standard deviation values.
    covMat % (nFeatures x nFeatures number) Feature covariance matrix.
end

%% Constructor ------------------------------------------------------------
methods
    function aData = data(varargin)
        % Constructor function for the "data" class.
        %
        % USAGE:
        %   aData = data(samples,classLabels)
        %   aData = data(samples,classLabels,featureNames)
        %   aData = data(samples,classLabels,classNameMap)
        %   aData = data(samples,classLabels,featureNames,classNameMap)
        %   aData = data(classData1,classData2,...,classDataN)
        %   aData = data(name,...)
        %
        % INPUTS:
        %	samples - (nFeatures x nSamples number) 
        %       Feature values for each sample in the data set.
        %
        %   classLabels - (1 x nSamples integer)
        %       Class label of each sample in the data set.
        %
        %   featureNames - (nFeatures x 1 cell array of strings) [{'Feature1';...;'FeatureN'}]
        %       Feature names.
        %
        %   classNameMap - ({nClasses x 1 vector, nClasses x 1 cell array of strings}) [['Class' num2str(classLabel)]]
        %       Class label to name map. This a 2 x 1 cell array. In the
        %       first cell is a "nClasses" x 1 vector of unique labels that must contain
        %       all label values in "classLabels". In the second cell is a
        %       "nClasses" x 1 cell array of strings that are the
        %       corresponding class name to for each label. Class names do
        %       not have to be unique.
        %
        %	classData# - (1 x 1 classifier.classData)
        %       A "classData" object that will be to the "data" object.
        %
        %   name - (string) ['']
        %       Name of data set.
        %
        %
        % OUTPUTS:
        %	aData - (1 x 1 data instance) 
        %       A new instance of the "data" class.
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        % Check number of arguments
        error(nargchk(0,inf,nargin))
        
        % Check usage and apply defaults
        usageType = 'error';
        if nargin < 1
            usageType = 'noInputs';
        elseif isa(varargin{1},'char')
            nameStr = varargin{1};
            varargin = varargin(2:end);
        else
            nameStr = '';
        end
        
        if isnumeric(varargin{1}) && ismatrix(varargin{1})
            usageType = 'matrix';
        elseif isa(varargin{1},'classifier.classData')
            usageType = 'classData';
        end

        % Check input arguments for errors
        switch usageType
            case 'noInputs'
                nameStr = '';
                labelSet = [];
                
            case 'matrix'
                optargin = size(varargin,2);
                
                if optargin >= 2
                    nFeatures = size(varargin{1},1);
                    nSamples = size(varargin{1},2);
                    assert(isnumeric(varargin{2}) && isreal(varargin{2}) && isvector(varargin{2}) && size(varargin{2},2) == nSamples && all(mod(varargin{2},1) == 0),...
                        'classifier:data:classLabels',...
                        'Input argument "classLabels" must be a %d x 1 of real integers.',nSamples)
                    labelSet = unique(varargin{2})';
                    nClasses = numel(labelSet);
                    
                    featureNamesArg = cell(nFeatures,1); % Set default featureNamesArg
                    for iFeat = 1:nFeatures
                        featureNamesArg{iFeat} = ['Feature' num2str(iFeat)];
                    end
                    
                    classNameMapArg = cell(1,2); % Set default classNameMapArg
                    classNameMapArg{1} = zeros(nClasses,1);
                    classNameMapArg{2} = cell(nClasses,1);
                    for iClass = 1:nClasses
                        classNameMapArg{1}(iClass,1) = labelSet(iClass);
                        classNameMapArg{2}{iClass,1} = ['Class' num2str(labelSet(iClass))];
                    end
                end
                    
                if optargin >= 3
                    if iscellstr(varargin{3})
                        featureNamesArg = varargin{3};
                        
                        classNameMapArg = cell(1,2); % Set default classNameMapArg
                        classNameMapArg{1} = zeros(nClasses,1);
                        classNameMapArg{2} = cell(nClasses,1);
                        for iClass = 1:nClasses
                            classNameMapArg{1}(iClass,1) = labelSet(iClass);
                            classNameMapArg{2}{iClass,1} = ['Class' num2str(labelSet(iClass))];
                        end
                        
                    elseif iscell(varargin{3})
                        classNameMapArg = varargin{3};
                        
                        featureNamesArg = cell(nFeatures,1); % Set default featureNamesArg
                        for iFeat = 1:nFeatures
                            featureNamesArg{iFeat} = ['Feature' num2str(iFeat)];
                        end
                    else
                        error('classifier:data:inputArgs','Invalid input arguments.')
                    end
                end
                    
                if optargin >= 4
                    featureNamesArg = varargin{3};
                    classNameMapArg = varargin{4};
                end
                
                if optargin >= 5
                    error('classifier:data:nargin','Invalid number of input arguments.')
                end
                
                assert(isvector(featureNamesArg) && numel(featureNamesArg) == nFeatures,...
                    'classifier:data:featureNames',...
                    'Input argument "featureNames" must be %d x 1 cell array of strings.',nFeatures)
                
                assert(isequal(size(classNameMapArg),[1 2]) &&...
                    isnumeric(classNameMapArg{1}) && isreal(classNameMapArg{1}) && isvector(classNameMapArg{1}) && size(classNameMapArg{1},2) == 1 && all(mod(classNameMapArg{1},1) == 0) && all(ismember(labelSet,classNameMapArg{1})) &&...
                    iscellstr(classNameMapArg{2}) && isequal(size(classNameMapArg{2}),[size(classNameMapArg{1},1),1]),...
                    'classifier:data:classNameMap',...
                    'Input argument "classNameMap" must be a 1 x 2 cell array. First cell must be integers that contain all unique values in the "classLabels" argument. Second cell must be vertical cell array of strins the same length of the first cell.')
                
            case 'classData'
                optargin = size(varargin,2);
                labelSet = nan(optargin,1);
                for iArg = 1:optargin
                    assert(isa(varargin{iArg},'classifier.classData') && numel(varargin{iArg}) == 1,...
                        'classifier:data:aClassData',...
                        'All input arguments must be a 1 x 1 classifier.classData object.')
                    
                    assert(all(labelSet ~= varargin{iArg}.label),...
                        'classifier:data:aClassData:label',....
                        'All class labels must be unique.')
                    labelSet(iArg) = varargin{iArg}.label;
                    
                    if iArg == 1
                        featureNamesArg = varargin{iArg}.featureNames;
                    else
                        assert(isequal(varargin{iArg}.featureNames,featureNamesArg),...
                            'classifier:data:aClassData:featureNames',...
                            'All class featureNames of input arguments must be of the same set and the same order.')
                    end
                end
                nClasses = optargin;
            
            otherwise
                error('classifier:data:inputs',...
                    'Invalid input arguments')
        end
        
        % Assign properties
        aData.name = nameStr;
        aData.labels = labelSet;
        
        switch usageType
            case 'matrix'
                aData.classes = repmat(classifier.classData(),nClasses,1);
                for iClass = 1:nClasses
                    thisLabel = aData.labels(iClass);
                    thisClassName = classNameMapArg{2}{ismember(classNameMapArg{1},thisLabel)};
                    aData.classes(iClass) = classifier.classData(varargin{1}(:,varargin{2} == thisLabel),thisLabel,thisClassName,featureNamesArg);
                end
                
            case 'classData'
                aData.classes = repmat(classifier.classData(),nClasses,1);
                for iClass = 1:nClasses
                    aData.classes(iClass) = varargin{iClass};
                end
        end
        
    end
end
%--------------------------------------------------------------------------

%% Property methods -------------------------------------------------------
methods
%     function aData = set.prop1(aData,prop1)
%         % Overloaded assignment operator function for the "prop1" property.
%         %
%         % USAGE:
%         %	aData.prop1 = prop1;
%         %
%         % NOTES:
%         %
%         %------------------------------------------------------------------
%         assert(issomething(prop1),...
%             'classifier:set:prop1',...
%             '"prop1" property must be set to a 1 x 1 real number.')
%         aData.prop1 = prop1;
%     end

    function nClasses = get.nClasses(aData)
        % Overloaded query operator function for the "nClasses" property.
        %
        % USAGE:
        %	nClasses = aData.nClasses
        %
        % NOTES:
        %
        %------------------------------------------------------------------

        nClasses = numel(aData.classes);
    end
    
    function classNames = get.classNames(aData)
        % Overloaded query operator function for the "classNames" property.
        %
        % USAGE:
        %	classNames = aData.classNames
        %
        % NOTES:
        %
        %------------------------------------------------------------------

        classNames = {aData.classes.name}';
    end
    
    function nFeatures = get.nFeatures(aData)
        % Overloaded query operator function for the "nClasses" property.
        %
        % USAGE:
        %	nFeatures = aData.nFeatures
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        nFeatures = aData.classes(1).nFeatures;
    end

    function featureNames = get.featureNames(aData)
        % Overloaded query operator function for the "featureNames" property.
        %
        % USAGE:
        %	featureNames = aData.featureNames
        %
        % NOTES:
        %
        %------------------------------------------------------------------

        featureNames = aData.classes(1).featureNames;
    end
    
    function nSamples = get.nSamples(aData)
        % Overloaded query operator function for the "nSamples" property.
        %
        % USAGE:
        %	nSamples = aData.nSamples
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        nSamples = sum([aData.classes.nSamples]);
    end
    
    function means = get.means(aData)
        % Overloaded query operator function for the "means" property.
        %
        % USAGE:
        %	means = aData.means
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        means = mean([aData.classes.samples],2);
    end
    
    function stds = get.stds(aData)
        % Overloaded query operator function for the "stds" property.
        %
        % USAGE:
        %	stds = aData.stds
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        stds = std([aData.classes.samples],0,2);
    end
    
    function covMat = get.covMat(aData)
        % Overloaded query operator function for the "covMat" property.
        %
        % USAGE:
        %	covMat = aData.covMat
        %
        % NOTES:
        %
        %------------------------------------------------------------------
        
        covMat = cov([aData.classes.samples]');
    end
end
%--------------------------------------------------------------------------

%% General Methods --------------------------------------------------------
% methods (AttributeName = value,...)
%     function thisObj = data(thisObj,arg1)
%         % The "data" method will ??? the ??? object thisObj.
%         %
%         % USAGE:
%         %   thisObj = thisObj.data(arg1)
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
%             'classifier:class_name:data:arg1',...
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
%         % Function to convert data object to a otherObject object.
%         %
%         % USAGE:
%         %	otherObject(aData)
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
% methods (AttributeName = value,...)
%     output = someMethod(aData,input)
% end
%--------------------------------------------------------------------------
    
end

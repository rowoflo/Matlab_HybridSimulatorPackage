function createNew(systemName,systemLocation,varargin)
% The "createNew" method will create a new system class with the necessary
% method files.
%
% SYNTAX:
%   simulate.system.createNew(systemName)
%   simulate.system.createNew(systemName,systemLocation)
%   simulate.system.createNew(systemName,systemLocation,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   systemName - (string)
%       Name of the new system
%
%   systemLocation - (valid folder location) [pwd] 
%       Location of where the system class will be located on file system.
%
% PROPERTIES:
%   'nStates' - (1 x 1 positive integer) [1]
%       Number of states the system will have.
%
%   'stateNames' - (? x 1 cell array of strings) [{'x1';'x2';...}]
%       Names of the state variables. One per state. If this is specified
%       'nStates' property will automatically be updated. Default uses the
%       value in the 'nStates' property.
%
%   'nInputs' - (1 x 1 positive integer) [1]
%       Number of inputs the system will have.
%
%   'inputNames' - (? x 1 cell array of strings) [{'u1';'u2';...}]
%       Names of the input variables. One per input. If this is specified
%       'nInputs' property will automatically be updated. Default uses the
%       value in the 'nInputs' property.
%
%   'nOutputs' - (1 x 1 positive integer) [nStates]
%       Number of outputs the system will have.
%
%   'outputNames' - (? x 1 cell array of strings) [{'y1';'y2';...}]
%       Names of the output variables. One per output. If this is specified
%       'nOutputs' property will automatically be updated. Default uses the
%       value in the 'nOutputs' property.
%
%   'phaseStatePairs' - phaseStatePairs; % (? x 2 positive integer <=
%   nStates) [[1 1]]
%       State pairs for the phase plot. One pair per row of the matrix. The
%       first column is the x-axis and the second column is the y-axis.
%
% OUTPUTS:
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%
% AUTHOR:
%    Rowland O'Flaherty 
%
% VERSION: 
%   Created 11-SEP-2011
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments
error(nargchk(1,inf,nargin))

% Apply default values
if nargin < 2, systemLocation = pwd; end


% Check arguments for errors
assert(ischar(systemName),...
    'simulate:system:createNew:systemName',...
    'Input argument "systemName" must be a string.')

assert(ischar(systemLocation) && isdir(systemLocation),...
    'simulate:system:createNew:systemLocation',...
    'Input argument "systemLocation" must be a path to a valid directory.')
systemLocation = regexprep(systemLocation,'\.',pwd);

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,...
    'simulate:system:createNew:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('nStates')
            nStates = propValues{iParam};
        case lower('stateNames')
            stateNames = propValues{iParam};
        case lower('nInputs')
            nInputs = propValues{iParam};
        case lower('inputNames')
            inputNames = propValues{iParam};
        case lower('nOutputs')
            nOutputs = propValues{iParam};
        case lower('outputNames')
            outputNames = propValues{iParam};
        case lower('phaseStatePairs')
            phaseStatePairs = propValues{iParam};
        otherwise
            error('simulate:system:createNew:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary TODO: Add property defaults
if ~exist('nStates','var'), nStates = []; end
if ~exist('stateNames','var'), stateNames = []; end
if ~exist('nInputs','var'), nInputs = []; end
if ~exist('inputNames','var'), inputNames = []; end
if ~exist('nOutputs','var'), nOutputs = []; end
if ~exist('outputNames','var'), outputNames = []; end
if ~exist('phaseStatePairs','var'), phaseStatePairs = [1 1]; end

% Check property values for errors TODO: Add property error checks
if isempty(nStates) && isempty(stateNames)
    nStates = 1;
    stateNames = {'x1'};
elseif isempty(nStates) && ~isempty(stateNames)
    nStates = numel(stateNames);
elseif ~isempty(nStates) && isempty(stateNames)
    stateNames = cell(nStates,1);
    for iState = 1:nStates
        stateNames{iState} = ['x' num2str(iState)];
    end
end

assert(isnumeric(nStates) && isreal(nStates) && numel(nStates) == 1 && ...
    nStates > 0 && mod(nStates,1) == 0,...
    'simulate:system:createNew:nStates',...
    'Property "nStates" must be a 1 x 1 positive integer.')
if nStates > numel(stateNames)
    for iState = numel(stateNames)+1:nStates
        stateNames{iState} = ['x' num2str(iState)];
    end
end

assert(iscellstr(stateNames) && numel(stateNames) == nStates,...
    'simulate:system:createNew:stateNames',...
    'Property "stateNames" must be a 1 x 1 positive integer.')
stateNames = stateNames(:);

if isempty(nInputs) && isempty(inputNames)
    nInputs = 1;
    inputNames = {'u1'};
elseif isempty(nInputs) && ~isempty(inputNames)
    nInputs = numel(inputNames);
elseif ~isempty(nInputs) && isempty(inputNames)
    inputNames = cell(nInputs,1);
    for iInput = 1:nInputs
        inputNames{iInput} = ['u' num2str(iInput)];
    end
end

assert(isnumeric(nInputs) && isreal(nInputs) && numel(nInputs) == 1 && ...
    nInputs > 0 && mod(nInputs,1) == 0,...
    'simulate:system:createNew:nInputs',...
    'Property "nInputs" must be a 1 x 1 positive integer.')
if nInputs > numel(inputNames)
    for iInput = numel(inputNames)+1:nInputs
        inputNames{iInput} = ['u' num2str(iInput)];
    end
end

assert(iscellstr(inputNames) && numel(inputNames) == nInputs,...
    'simulate:system:createNew:inputNames',...
    'Property "inputNames" must be a 1 x 1 positive integer.')
inputNames = inputNames(:);

if isempty(nOutputs) && isempty(outputNames)
    nOutputs = nStates;
    outputNames = cell(nOutputs,1);
    for iOutput = 1:nOutputs
        outputNames{iOutput} = ['y' num2str(iOutput)];
    end
elseif isempty(nOutputs) && ~isempty(outputNames)
    nOutputs = numel(outputNames);
elseif ~isempty(nOutputs) && isempty(outputNames)
    outputNames = cell(nOutputs,1);
    for iOutput = 1:nOutputs
        outputNames{iOutput} = ['y' num2str(iOutput)];
    end
end

assert(isnumeric(nOutputs) && isreal(nOutputs) && numel(nOutputs) == 1 && ...
    nOutputs > 0 && mod(nOutputs,1) == 0,...
    'simulate:system:createNew:nOutputs',...
    'Property "nOutputs" must be a 1 x 1 positive integer.')
if nOutputs > numel(outputNames)
    for iOutput = numel(outputNames)+1:nOutputs
        outputNames{iOutput} = ['u' num2str(iOutput)];
    end
end

assert(iscellstr(outputNames) && length(outputNames) == nOutputs,...
    'simulate:system:createNew:outputNames',...
    'Property "outputNames" must be a 1 x 1 positive integer.')
outputNames = outputNames(:);

assert(isnumeric(phaseStatePairs) && isreal(phaseStatePairs) && ...
    size(phaseStatePairs,2) == 2 && all(phaseStatePairs(:) > 0) && ...
    all(phaseStatePairs(:) <= nStates) && ...
    all(mod(phaseStatePairs(:),1) == 0),...
    'simulate:system:createNew:phaseStatePairs',...
    ['Property "phaseStatePairs" must be a ? x 2 matrix of positive integers'...
    '<= %d.'],nStates)

%% Parameters
version = simulate.system.currentVersion;

systemClassPath = fileparts(which('simulate.system'));
templateFolderName = 'newSystemTemplates';
templateFileList = {...
    'classTest_template.m';...
    'class_template.m';...
    'flowMap_template.m';...
    'flowSet_template.m';...
    'jumpMap_template.m';...
    'jumpSet_template.m';...
    'controller_template.m';...
    'observer_template.m';...
    'sensor_template.m';...
    'inputConstraints_template.m';...
    'linearize_template.m';...
    'sketch_template.m'};

packageName = regexp(systemLocation,'(?<=\+)\w*(?=/)|(?<=\+)\w*$','match'); % Get package name from path
if isempty(packageName)
    packageName = '';
else
    packageName = packageName{1};
end

if isempty(packageName)
    packageDsystemName = systemName;
    packageCsystemName = systemName;
    necessaryPackage = '';
else
    packageDsystemName = [packageName '.' systemName];
    packageCsystemName = [packageName ':' systemName];
    necessaryPackage = ['+' packageName ', '];
end

SystemName = [upper(systemName(1)) systemName(2:end)];


%% Get User Name
% defaultName = 'SET DEFAULT NAME IN newDoc.m LINE 96';
defaultName = 'Rowland O''Flaherty';

% if ismac
if 0
    [status, fullName] = unix('osascript -e "long user name of (system info)"');
    fullName = fullName(1:end-1);
    if status
        fullName = 'AUTHOR_NAME_HERE';
    end
else
    fullName = defaultName;
end

%% Create class folder
systemFolderLocation = fullfile(systemLocation,['@' systemName]);
assert(~exist(systemFolderLocation,'dir'),...
    'simulate:system:createNew:systemLocation',...
    'A system of the name ''%s'' already exist at the location ''%s''.',systemName,systemLocation)

mkdir(systemFolderLocation)

%% Create new files
for iFile = 1:length(templateFileList)
    templatePath = fullfile(systemClassPath,templateFolderName,templateFileList{iFile});
    if iFile == 1
        classDocName = [systemName 'Test.m'];
        classDocPath = fullfile(systemLocation,classDocName);
        testDocPath = classDocPath;
    elseif iFile == 2
        classDocName = [systemName '.m'];
        classDocPath = fullfile(systemFolderLocation,classDocName);
    else
        tok = regexp(templateFileList{iFile},'(\w*)_template','tokens');
        classDocName = [tok{1}{1} '.m'];
        classDocPath = fullfile(systemFolderLocation,classDocName);
    end
    
    createDoc(templatePath,classDocPath);
end

%% Open test script document in editor
edit(testDocPath);

%% Imbedded function
    function createDoc(tmplPath,docPath)
        templateFileID = fopen(tmplPath,'r');
        docFileID = fopen(docPath,'w');
        
        while 1 % Loop through each line looking for specific words
            try
                aLine = fgetl(templateFileID);
                if ~ischar(aLine),   break,   end
                aLine = regexprep(aLine,'DD-MMM-YYYY',upper(date)); % Sets the current date
                aLine = regexprep(aLine,'FULL_NAME',fullName); % Set the author name
                aLine = regexprep(aLine,'VERSION_STR',version); % Set the version number
                aLine = regexprep(aLine,'PACKAGE_NAME_D_SYSTEM_NAME',packageDsystemName); % Set the package name and system name with a dot between them
                aLine = regexprep(aLine,'PACKAGE_NAME_C_SYSTEM_NAME',packageCsystemName); % Set the package name and system name with a colon between them
                aLine = regexprep(aLine,'NECESSARY_PACKAGE',necessaryPackage); % Set the package name under necessary packages
                aLine = regexprep(aLine,'SSYSTEM_NAME',SystemName); % Set the system name with capital first letter
                aLine = regexprep(aLine,'SYSTEM_NAME',systemName); % Set the system name
                aLine = regexprep(aLine,'NSTATES',num2str(nStates)); % Set the number of states
                aLine = regexprep(aLine,'STATE_NAMES',names2str(stateNames)); % Set the state names
                aLine = regexprep(aLine,'NINPUTS',num2str(nInputs)); % Set the number of inputs
                aLine = regexprep(aLine,'INPUT_NAMES',names2str(inputNames)); % Set the input names
                aLine = regexprep(aLine,'NOUTPUTS',num2str(nOutputs)); % Set the number of outputs
                aLine = regexprep(aLine,'OUTPUT_NAMES',names2str(outputNames)); % Set the output names
                aLine = regexprep(aLine,'PHASE_STATE_PAIRS',phaseMat2str(phaseStatePairs)); % Set the output names
                fprintf(docFileID,'%s\n',aLine);
            catch ME
                fclose('all'); % If error close all open files
                rethrow(ME)
            end
        end
        fclose(templateFileID);
        fclose(docFileID);
        
    end

end

function str = names2str(names)
str = '{';
for iName = 1:length(names)
    str = [str '''' names{iName} '''']; %#ok<AGROW>
    if iName ~= length(names)
        str = [str '; ']; %#ok<AGROW>
    end
end
str = [str '}'];
end

function str = phaseMat2str(phaseMat)
str = '[';
for iRow = 1:size(phaseMat,1)
    str = [str num2str(phaseMat(iRow,:))]; %#ok<AGROW>
    if iRow ~= size(phaseMat,1)
        str = [str '; ']; %#ok<AGROW>
    end
end
str = [str ']'];
end

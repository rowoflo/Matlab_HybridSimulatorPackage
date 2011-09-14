function createNew(systemName,systemLocation)
% The "createNew" method ... TODO: Add description
%
% SYNTAX:
%   simulate.system.createNew(systemName)
%   simulate.system.createNew(systemName,systemLocation)
%
% INPUTS: TODO: Add inputs
%   systemName - (string)
%       Name of the new system
%
%   systemLocation - (valid folder location) [pwd] 
%       Location of where the system class will be located on file system.
%
% OUTPUTS:
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%   +simulate, someFile.m
%
% AUTHOR:
%   11-SEP-2011 by Rowland O'Flaherty
%
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments
error(nargchk(1,2,nargin))

% Apply default values TODO: Add apply defaults
if nargin < 2, systemLocation = pwd; end

% Check arguments for errors TODO: Add error checks
assert(ischar(systemName),...
    'simulate:system:createNew:systemName',...
    'Input argument "systemName" must be a string.')

assert(ischar(systemLocation) && isdir(systemLocation),...
    'simulate:system:createNew:systemLocation',...
    'Input argument "systemLocation" must be a path to a valid directory.')

%% Parameters
nStates = 1;
nInputs = 1;
nOutputs = 1;

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
    'inputConstraint_template.m';...
    'linearize_template.m';...
    'sketchGraphics_template.m'};

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
                aLine = regexprep(aLine,'SYSTEM_NAME',systemName); % Set the system name
                aLine = regexprep(aLine,'NSTATES',num2str(nStates)); % Set the system name
                aLine = regexprep(aLine,'NINPUTS',num2str(nInputs)); % Set the system name
                aLine = regexprep(aLine,'NOUTPUTS',num2str(nOutputs)); % Set the system name
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

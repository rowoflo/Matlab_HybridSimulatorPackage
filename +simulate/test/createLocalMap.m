%% createLocalMap.m
% The "createLocalMap" script creats a "simulate.map" object for the
% puck class.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% AUTHOR:
%   26-APR-2011 by Rowland O'Flaherty
%
% SEE ALSO:
%
%-------------------------------------------------------------------------------

%% Clear
if strcmp(getenv('USERNAME'),'rowland')
    cd('/Users/rowland/Engineering/Programming/Matlab/Packages/+simulate/test')
else
    cd('/Users/RO21531/Matlab/Packages/+simulate/test')
end
ccc

%% Walls Set 1
walls = repmat({simulate.wall},22,1);

walls{1,1}.position = [0;0];
walls{1,1}.endpoint = [0;18];

walls{2,1}.position = [0;18];
walls{2,1}.endpoint = [4;22];

walls{3,1}.position = [4;22];
walls{3,1}.endpoint = [18;22];

walls{4,1}.position = [18;22];
walls{4,1}.endpoint = [22;18];

walls{5,1}.position = [22;18];
walls{5,1}.endpoint = [22;0];

walls{6,1}.position = [22;0];
walls{6,1}.endpoint = [0;0];

walls{7,1}.position = [4;4];
walls{7,1}.endpoint = [18;4];

walls{8,1}.position = [18;4];
walls{8,1}.endpoint = [18;10];

walls{9,1}.position = [18;10];
walls{9,1}.endpoint = [9;10];

walls{10,1}.position = [9;10];
walls{10,1}.endpoint = [9;9];

walls{11,1}.position = [9;9];
walls{11,1}.endpoint = [17;9];

walls{12,1}.position = [17;9];
walls{12,1}.endpoint = [17;5];

walls{13,1}.position = [17;5];
walls{13,1}.endpoint = [5;5];

walls{14,1}.position = [5;5];
walls{14,1}.endpoint = [5;17];

walls{15,1}.position = [5;17];
walls{15,1}.endpoint = [17;17];

walls{16,1}.position = [17;17];
walls{16,1}.endpoint = [17;13];

walls{17,1}.position = [17;13];
walls{17,1}.endpoint = [9;13];

walls{18,1}.position = [9;13];
walls{18,1}.endpoint = [9;12];

walls{19,1}.position = [9;12];
walls{19,1}.endpoint = [18;12];

walls{20,1}.position = [18;12];
walls{20,1}.endpoint = [18;18];

walls{21,1}.position = [18;18];
walls{21,1}.endpoint = [4;18];

walls{22,1}.position = [4;18];
walls{22,1}.endpoint = [4;4];


%% Map
tic
localMap = simulate.map([0 22 0 22],[.125 .125],walls);
toc

%% Sketch
localMap.sketch;
grid on
axis equal
figBoldify

figure
imagesc(localMap.validityMask)
axis xy
axis equal

%% Save
save('localMap.mat','localMap')

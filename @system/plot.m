function plot(systemObj,varargin)
% The "plot" method plots the input and state history of the system or
% plots the given state and input vs. the given time.
%
% SYNTAX:
%   systemObj.plot()
%   systemObj.plot(...,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
% PROPERTIES:
%   Properties are not currently passed to anything right now.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   simulate.m | run.m | replay.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 23-APR-2011
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check arguments for errors
assert(isa(systemObj,'simulate.system') && numel(systemObj) == 1,...
    'simulate:system:plot:systemObj',...
    'Input argument "systemObj" must be a 1 x 1 simulate.system object.')

%% Plot
if systemObj.plotStateFlag
    systemObj.plotState();
    if systemObj.legendFlag
        legend(systemObj.stateAxisHandle,'Location','best')
    end
end
if systemObj.plotInputFlag
    systemObj.plotInput();
    if systemObj.legendFlag
        legend(systemObj.inputAxisHandle,'Location','best')
    end
end
if systemObj.plotOutputFlag
    systemObj.plotOutput();
    if systemObj.legendFlag
        legend(systemObj.outputAxisHandle,'Location','best')
    end
end
if systemObj.plotPhaseFlag
    systemObj.plotPhase();
    if systemObj.legendFlag
        legend(systemObj.phaseAxisHandle,'Location','best')
    end
end
if systemObj.plotSketchFlag
    systemObj.plotSketch();
end

end

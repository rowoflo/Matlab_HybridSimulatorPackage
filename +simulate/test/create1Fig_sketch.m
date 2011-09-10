%% create1Fig_sketch.m
% The "create1Fig_sketch" script ...  TODO: Add description
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES: TODO: Add necessary files
%
% AUTHOR:
%   05-MAY-2011 by Rowland O'Flaherty
%
% SEE ALSO: TODO: Add see alsos
%
%-------------------------------------------------------------------------------

%% Create Figures
if strcmp(getenv('USERNAME'),'RO21531')
%     if exist('plotFig','var')
%         clf(plotFig)
%     else
%         if S.plotStateFlag || S.plotInputFlag
%             plotFig = figure('Position',[1 -17 960 1101]);
%         end
%     end
    if exist('sketchFig','var')
        clf(plotFig)
    else
        if S.sketchFlag
            sketchFig = figure('Position',[961 570 960 514]);
        end
    end
%     if exist('phaseFlag','var')
%         clf(plotFig)
%     else
%         if S.phaseFlag
%             phaseFig = figure('Position',[961 -17 960 514]);
%         end
%     end
elseif strcmp(getenv('USERNAME'),'rowland')
%     if exist('plotFig','var')
%         clf(plotFig)
%     else
%         if S.plotStateFlag || S.plotInputFlag
%             plotFig = figure('Position',[1 -17 720 801]);
%         end
%     end
    if exist('sketchFig','var')
        clf(plotFig)
    else
        if S.sketchFlag
            sketchFig = figure('Position',[721 420 720 364]);
        end
    end
%     if exist('phaseFlag','var')
%         clf(plotFig)
%     else
%         if S.phaseFlag
%             phaseFig = figure('Position',[721 -17 720 364]);
%         end
%     end
else
%     if exist('plotFig','var')
%         clf(plotFig)
%     else
%         if S.plotStateFlag || S.plotInputFlag
%             plotFig = figure;
%         end
%     end
    if exist('sketchFig','var')
        clf(plotFig)
    else
        if S.sketchFlag
            sketchFig = figure;
        end
    end
%     if exist('phaseFlag','var')
%         clf(plotFig)
%     else
%         if S.phaseFlag
%             phaseFig = figure;
%         end
%     end
end

%% Create Axes
% if S.plotStateFlag
%     figure(plotFig)
%     S.stateAxisHandle = subplot(2,1,1);
%     set(S.stateAxisHandle,...
%         'NextPlot','replacechildren',...
%         'DrawMode','fast')
%     title([S.name ' States'])
%     xlabel('Time')
%     ylabel('States')
%     xlim(S.stateAxisHandle,[t0 tEnd])
%     grid on
% end

% if  S.plotInputFlag
%     S.inputAxisHandle = subplot(2,1,2);
%     set(S.inputAxisHandle,...
%         'NextPlot','replacechildren',...
%         'DrawMode','fast')
%     title([S.name ' Inputs'])
%     xlabel('Time')
%     ylabel('Inputs')
%     xlim(S.inputAxisHandle,[t0 tEnd])
%     grid on
% end

if S.sketchFlag
    figure(sketchFig)
    S.sketchAxisHandle = axes('Parent',sketchFig,...
        'DrawMode','fast');
    set(S.sketchAxisHandle,...
        'NextPlot','add')
    axis equal
    xlim(1.5*[-1 1])
    ylim(1.5*[-1 1])
end

% if S.phaseFlag
%     figure(phaseFig)
%     S.phaseAxisHandle = axes('Parent',phaseFig,...
%         'DrawMode','fast');
%     set(S.phaseAxisHandle,...
%         'NextPlot','add')
%     xlim(pi*[-1 1])
%     ylim(6*[-1 1])
%     grid on
%     xlabel('theta')
%     ylabel('dTheta')
% end

% if S.plotStateFlag || S.plotInputFlag
%     figBoldify(plotFig);
% end
if S.sketchFlag
    figBoldify(sketchFig);
end
% if S.phaseFlag
%     figBoldify(phaseFig);
% end
function [timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = ...
    simulate(systemObj,timeInterval,initialState,initialFlowTime,initialJumpCount,varargin)
% The "simulate" method will simulate the system from the time of
% "timeInterval(1)" to the time of "timeInterval(end)" and starting in the
% state of "initialState".
%
% SYNTAX:
%   [timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = ...
%       systemObj.simulate(timeInterval)
%       systemObj.simulate(timeInterval,initialState)
%       systemObj.simulate(timeInterval,initialState,initialFlowTime)
%       systemObj.simulate(timeInterval,initialState,initialFlowTime,initialJumpCount)
%       systemObj.simulate(timeInterval,initialState,initialFlowTime,initialJumpCount,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   timeInterval - (1 x 2 real number)
%       A vector specifying the interval of the simulation. The first value
%       is the initial time of the second value is the final time.
%
%   initialState - (? x 1 number) [systemObj.state]
%       Initial state of the simulation. Must be a "systemObj.nStates" x 1
%       vector.
%
%   initialFlowTime (1 x 1 semi-positive real number) [0]
%       Initial flow time of the simulation.
%
%   initialJumpCount (1 x 1 semi-positive integer) [0]
%       Initial jump count of the simulation.
%
% PROPERTIES:
%   'movieFile' - (string) ['']
%       If not empty and "systemObj.graphicsFlag" is true a movie of the
%       simulation will be saved to the specified file.
%
% OUTPUTS:
%   timeTapeC - (1 x ? real number)
%       A vector specifying the interval of the actual simulation in (sudo)
%       continuous time. All the ODE solver time points are included.
%
%   stateTape - (? x ? number)
%       Recording of state values during simulation. A
%       "systemObj.nStates" x "length(timeTape)" maxtrix.
%
%   timeTapeD - (1 x ? real number)
%       A vector specifying the interval of the actual simulation in
%       discrete time. Will only be different from the input "timeInterval"
%       if "timeInterval" is two elements or the stop button is pushed in the plot.
%
%   inputTape - (? x ? number)
%       Recording of input values during simulation.  A
%       "systemObj.nInputs" x "length(timeTapeD)" maxtrix.
%
%   outputTape - (? x ? number)
%       Recording of output values during simulation.  A
%       "systemObj.nOutputs" x "length(timeTapeD)" maxtrix.
%
%   flowTimeTape - (1 x ? semi-positive real number)
%       Recording of flow time values during simulation. A 1 x
%       "length(timeTapeC)" vector.
%
%   jumpCountTape - (1 x ? semi-positive integer)
%       Recording of jump count values during simulation. A 1 x
%       "length(timeTapeC)" vector.
%
%   stopFlag - (1 x 1 logical)
%       True if the stop button was pushed during simulation.
%
% NOTES:
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   run.m | replay.m | plot.m
%
% AUTHOR:
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 17-APR-2011
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments
error(nargchk(2,inf,nargin))

% Apply default values
if nargin < 3, initialState = systemObj.state; end
if nargin < 4, initialFlowTime = 0; end
if nargin < 5, initialJumpCount = 0; end

% Check arguments for errors
assert(isa(systemObj,'simulate.system') && numel(systemObj) == 1,...
    'simulate:system:simulate:systemObj',...
    'Input argument "systemObj" must be a 1 x 1 simulate.system object.')

assert(isnumeric(timeInterval) && isreal(timeInterval) && isvector(timeInterval) && numel(timeInterval) == 2,...
    'simulate:system:simulate:timeInterval',...
    'Input argument "timeInterval" must be a 1 x 2 vector of real numbers.')
timeInterval = timeInterval(:)';

assert(isnumeric(initialState) && isequal(size(initialState),[systemObj.nStates 1]),...
    'simulate:system:simulate:initialState',...
    'Input argument "initialState" must be a %d x 1 vector of numbers.',systemObj.nStates)

assert(isnumeric(initialFlowTime) && isreal(initialFlowTime) && numel(initialFlowTime) == 1 && initialFlowTime >=0,...
    'simulate:system:simulate:initialFlowTime',...
    'Input argument "initialFlowTime" must be a 1 x 1 semi-positive real number.')

assert(isnumeric(initialJumpCount) && isreal(initialJumpCount) && numel(initialJumpCount) == 1 && initialJumpCount >=0 && mod(initialJumpCount,1) == 0,...
    'simulate:system:simulate:initialJumpCount',...
    'Input argument "initialJumpCount" must be a 1 x 1 semi-positive integer.')

% Get and check properties
propargin = size(varargin,2);

assert(mod(propargin,2) == 0,'system:simulate:properties',...
    'Properties must come in pairs of a "PropertyName" and a "PropertyValue".')

propStrs = varargin(1:2:propargin);
propValues = varargin(2:2:propargin);

for iParam = 1:propargin/2
    switch lower(propStrs{iParam})
        case lower('movieFile')
            movieFile = propValues{iParam};
        otherwise
            error('simulate:system:simulate:options',...
              'Option string ''%s'' is not recognized.',propStrs{iParam})
    end
end

% Set to default value if necessary
% if ~exist('movieFile','var'), movieFile = ''; end

% Check property values for errors
% assert(ischar(movieFile),...
%     'simulate:system:simulate:movieFile',...
%     'Property "movieFile" must be a string.')
% if isempty(movieFile)
%     movieFlag = false;
% else
%     movieFlag = true;
% end

%% Parameters
% movieFrameRate = 20; % TODO: Add these paramerters to input
% movieQuality = 60;
catSize = 500;

%% Initialize
zeroSize = systemObj.zeroSize;

% ODE options
switch systemObj.odeMethod
    case 'odeSolver'
        options = systemObj.odeOptions;
        if isempty(options)
            options = odeset('Events',@odeEventsFunc);
        else
            options = odeset(options{:},'Events',@odeEventsFunc);
        end
    case 'euler'
        systemObj.odeSolver = @euler;
        options.timeStep = systemObj.timeStep;
        options.events = @odeEventsFunc;
    otherwise
        error('simulate:system:simulate:odeMethod',...
            'Property "odeMethod" must be either ''odeSolver'' or ''euler''.')
end


% Time variables
initialTime = timeInterval(1);
finalTime = timeInterval(end);
timeVector = initialTime:systemObj.timeStep:finalTime;
nTimePoints = length(timeVector);

% Initial input/output variables
initialInput = systemObj.inputConstraints(systemObj.policy(initialTime,initialState,initialFlowTime,initialJumpCount));
initialOutput = systemObj.sensor(initialTime,initialState,initialInput,initialFlowTime,initialJumpCount);
uD = initialInput; % Current input. Updated discretely.

% Tape variables
cntC = 1; % Continuous
timeTapeC = nan(1,nTimePoints+catSize);
stateTape = nan(systemObj.nStates,nTimePoints+catSize);
flowTimeTape = nan(1,nTimePoints+catSize);
jumpCountTape = nan(1,nTimePoints+catSize);
timeTapeC(1, 1) = initialTime;
stateTape(:, 1) = initialState;
flowTimeTape(1, 1) = initialFlowTime;
jumpCountTape(1, 1) = initialJumpCount;
nTimePointsC = length(timeTapeC);

cntD = 1; % Discrete
timeTapeD = nan(1,nTimePoints+catSize);
inputTape = nan(systemObj.nInputs,nTimePoints+catSize);
outputTape = nan(systemObj.nOutputs,nTimePoints+catSize);
timeTapeD(1, 1) = initialTime;
inputTape(:, 1) = initialInput;
outputTape(:, 1) = initialOutput;
nTimePointsD = length(timeTapeD);

% Sim variables
breakFlag = false;
tC = initialTime; % Current continuous time
tD = initialTime; % Current discrete time
xC = initialState; % Currrent continuous state
fC = initialFlowTime; % Current continuous flow time
jC = initialJumpCount; % Current continuous jump count
ts = systemObj.timeStep; % Sampling time
tDNext = tD + ts; % Next sample time
fCDelta = fC - tC; % Offset between current time and current flow time
tF = finalTime; % Final time of simulation

% Figure variables
stopFlag = false;
figureList = [];
figureListProperties = {};

% Initialize graphics
if systemObj.graphicsFlag
    odeGraphics(...
        timeTapeC(1, 1:cntC),...
        stateTape(:, 1:cntC),...
        timeTapeD(1, 1:cntD),...
        inputTape(:, 1:cntD),...
        outputTape(:, 1:cntD),...
        'init');
end

%% Simulate
while 1
    flowSetValue = systemObj.flowSet(tC,xC,fC,jC);
    jumpSetValue = systemObj.jumpSet(tC,xC,fC,jC);
    methodStr = updateMethod(flowSetValue,jumpSetValue);
    
    switch methodStr
        case 'flow'
            [T,X,F] = flow(tC,xC,fC);
            nT = size(T,2);
            cntCPrev = cntC;
            cntC = cntC + nT;
            if cntC > nTimePointsC
                timeTapeC = [timeTapeC nan(1,catSize)]; %#ok<AGROW>
                stateTape = [stateTape nan(systemObj.nStates,catSize)]; %#ok<AGROW>
                flowTimeTape = [flowTimeTape nan(1,catSize)]; %#ok<AGROW>
                jumpCountTape = [jumpCountTape nan(1,catSize)]; %#ok<AGROW>
                nTimePointsC = length(timeTapeC);
            end
            tC = T(1, end);
            xC = X(:, end);
            fC = F(1, end);
            timeTapeC(1, cntCPrev+1:cntC) = T;
            stateTape(:, cntCPrev+1:cntC) = X;
            flowTimeTape(1, cntCPrev+1:cntC) = F;
            jumpCountTape(1, cntCPrev+1:cntC) = jC*ones(1,nT);
            
            if fC >= systemObj.maxFlowTime
                breakFlag = true;
            end
            
        case 'jump'
            [T,X,J] = jump(tC,xC,jC);
            nT = size(T,2);
            cntCPrev = cntC;
            cntC = cntC + nT;
            if cntC > nTimePointsC
                timeTapeC = [timeTapeC nan(1,catSize)]; %#ok<AGROW>
                stateTape = [stateTape nan(systemObj.nStates,catSize)]; %#ok<AGROW>
                flowTimeTape = [flowTimeTape nan(1,catSize)]; %#ok<AGROW>
                jumpCountTape = [jumpCountTape nan(1,catSize)]; %#ok<AGROW>
                nTimePointsC = length(timeTapeC);
            end
            tC = T;
            xC = X;
            jC = J;
            fC = 0;
            fCDelta = tC;
            timeTapeC(1, cntCPrev+1:cntC) = T;
            stateTape(:, cntCPrev+1:cntC) = X;
            flowTimeTape(1, cntCPrev+1:cntC) = fC*ones(1,nT);
            jumpCountTape(1, cntCPrev+1:cntC) = jC*ones(1,nT);
            
            if jC >= systemObj.maxJumpCount
                breakFlag = true;
            end
            
        case 'stop'
            break
            
        otherwise
            error('simulate:system:simulate:updateMethod',...
                ['Invalid update method: %s. ',...
                'Property "setPriority" must be either ''flow'', ''jump'', or ''random''.'''],updateMethod(flowSetFlag,jumpSetFlag))
    end
    
    % Sample
    if min(abs(T(1, end) - timeVector)) == 0
        cntD = cntD + 1;
        if cntD > nTimePointsD
            timeTapeD = [timeTapeD nan(1,catSize)]; %#ok<AGROW>
            inputTape = [inputTape nan(systemObj.nInputs,catSize)]; %#ok<AGROW>
            outputTape = [outputTape nan(systemObj.nOutputs,catSize)]; %#ok<AGROW>
            nTimePointsD = length(timeTapeD);
        end
        tD = T(1, end);
        tDNext = tD + ts;
        xD = X(:, end);
        fD = fC;
        jD = jC;
        uD = systemObj.inputConstraints(systemObj.policy(tD,xD,fD,jD));
        yD = systemObj.sensor(tD,xD,uD,fD,jD);
        timeTapeD(1, cntD) = tD;
        inputTape(:, cntD) = uD;
        outputTape(:, cntD) = yD;
        
        % Update graphics
        if systemObj.graphicsFlag
            odeGraphics(...
                timeTapeC(1, 1:cntC),...
                stateTape(:, 1:cntC),...
                timeTapeD(1, 1:cntD),...
                inputTape(:, 1:cntD),...
                outputTape(:, 1:cntD),...
                'update');
        end
    end
    
    % Break
    if breakFlag || tC == tF
        break
    end
    
end

%% Output
timeLogicC = ~isnan(timeTapeC);
timeLogicD = ~isnan(timeTapeD);

timeTapeC = timeTapeC(1,timeLogicC);
stateTape = stateTape(:,timeLogicC);
timeTapeD = timeTapeD(1,timeLogicD);
inputTape = inputTape(:,timeLogicD);
outputTape = outputTape(:,timeLogicD);
flowTimeTape = flowTimeTape(1,timeLogicC);
jumpCountTape = jumpCountTape(1,timeLogicC);

%% Finalize Graphics
if systemObj.graphicsFlag
    odeGraphics(...
                timeTapeC(1, 1:cntC),...
                stateTape(:, 1:cntC),...
                [timeTapeD(1, 1:cntD) nan],...
                [inputTape(:, 1:cntD) nan(systemObj.nInputs,1)],...
                [outputTape(:, 1:cntD) nan(systemObj.nOutputs,1)],...
                'update');
    
    if systemObj.clearStopButtonFlag || stopFlag
        odeGraphics([],[],[],[],[],'done');
    end
    
%     if movieFlag
%         for iFigCnt = 1:length(figureList)
%             vidObj{iFigCnt}.close;
%         end
%     end
end

%% Nested Functions ------------------------------------------------------------
%% Update Method Function
    function methodStr = updateMethod(flowArg,jumpArg)
        if flowArg >= -systemObj.zeroSize && jumpArg >= -systemObj.zeroSize
            if strcmp(systemObj.setPriority,'random')
                if rand < .5
                    methodStr = 'flow';
                else
                    methodStr = 'jump';
                end
            else
                methodStr = systemObj.setPriority;
            end
        elseif flowArg >= -systemObj.zeroSize
            methodStr = 'flow';
        elseif jumpArg >= -systemObj.zeroSize
            methodStr = 'jump';
        else
            methodStr = 'stop';
        end
        if stopFlag
            methodStr = 'stop';
        end
    end

%% Flow Function
    function [t,x,f] = flow(t0,x0,f0)
        [t,x,te,~,ie] = systemObj.odeSolver(@odeInputFunc,[t0 tF],x0,options);
        totalTimeTapeC = [systemObj.timeTapeC timeTapeC(1, 1:cntC)];
        totalJumpCountTape = [systemObj.jumpCountTape jumpCountTape(1, 1:cntC)];
        if ~isempty(te(ie == 2)) && ...
                any(abs(te(ie == 2) - totalTimeTapeC([0 diff(totalJumpCountTape)] == 1)) < zeroSize) % Remove repeated jump
            te = te(ie ~= 2);
            ie = ie(ie ~= 2);
        end
        x(abs(x) <= zeroSize) = 0; % Set X's close to zero to zero
        if any(ie == 4) % Set T's with updates to update time
            [~,ind] = min(abs(te(ie == 4) - timeVector));
            t(t == te(ie == 4)) = timeVector(ind);
            te(te == te(ie == 4)) = timeVector(ind);
        end
        if ~isempty(te) % Only progress to next event
            t = t(t <= min(te));
            x = x(t <= min(te),:);
        end
        % Return
        if length(t) > 1
            t = t(2:end, :)';
            x = x(2:end, :)';
        else
            x = x';
        end
        f = t - t0 + f0;
        [~,systemObj.setPriority] = systemObj.flowMap(t(end),x(:,end),uD,f(end),jC);
    end

%% Jump Function
    function [t,x,j] = jump(t0,x0,j0)
        [x,t,systemObj.setPriority] = systemObj.jumpMap(t0,x0,uD,fC,j0);
        j = j0 + 1;
    end

%% ODE Input Function
    function dx = odeInputFunc(t,x)
        f = t + fCDelta;
        [dx,systemObj.setPriority] = systemObj.flowMap(t,x,uD,f,jC);
    end

%% ODE Event Function
    function [value,isTerminal,direction] = odeEventsFunc(t,x)
        f = t + fCDelta;

        value = [systemObj.flowSet(t,x,f,jC);...
            systemObj.jumpSet(t,x,f,jC);...
            systemObj.maxFlowTime - f;...
            tDNext - t];
        
        % Stop for all crossings
        isTerminal = [1; 1; 1; 1];
        
        % Local min for flow, local max for jump, local min for flow time,
        % local min for time
        direction = [-1; 1; -1; -1];
    end

%% ODE Graphics Function
    function odeGraphics(tc,x,td,u,y,flag)
        switch flag
            case 'init'
                if systemObj.plotStateFlag
                    systemObj.plotState(tc(1,end),x(:,end),tc(1,1:end-1),x(:,1:end-1));
                    legend(systemObj.stateAxisHandle,'off')
                end
                if systemObj.plotInputFlag
                    systemObj.plotInput(td(1,end),td(1,1:end-1),u(:,1:end-1));
                    legend(systemObj.inputAxisHandle,'off')
                end
                if systemObj.plotOutputFlag
                    systemObj.plotOutput(td(1,end),td(1,1:end-1),y(:,1:end-1));
                    legend(systemObj.outputAxisHandle,'off')
                end
                if systemObj.plotPhaseFlag
                    systemObj.plotPhase(x(:,end),x(:,1:end-1));
                    legend(systemObj.phaseAxisHandle,'off')
                end
                if systemObj.plotSketchFlag
                    systemObj.plotSketch(td(1,end),x(:,end));
                end
                                
                % Figure setup
                figureList = [...
                    systemObj.stateFigureHandle;...
                    systemObj.inputFigureHandle;...
                    systemObj.outputFigureHandle;...
                    systemObj.phaseFigureHandle;...
                    systemObj.sketchFigureHandle];
                
                figureList = unique(figureList);
                figureListProperties = cell(size(figureList));
                
                for iFig = 1:length(figureList)
                    figureListProperties{iFig}{1,1} = 'MenuBar';
                    figureListProperties{iFig}{1,2} = get(figureList(iFig),'MenuBar');
                    figureListProperties{iFig}{1,3} = 'ToolBar';
                    figureListProperties{iFig}{1,4} = get(figureList(iFig),'ToolBar');
                    
                    set(figureList(iFig),'MenuBar','none','Visible','on');
                    
                    % Stop button
                    uicontrol(figureList(iFig),'Style','pushbutton',...
                        'String', 'Stop',...
                        'Position', [10 10 50 20],...
                        'Callback', @stopButtonCallback,...
                        'Tag','stop');
                end
                
                drawnow
                
                % Movie setup
                if systemObj.movieFlag && isempty(systemObj.movieObj)
                    systemObj.movieObj = cell(length(figureList),1);
                    for iFig = 1:length(figureList)
                        systemObj.movieObj{iFig} = VideoWriter([systemObj.movieFileName '_' num2str(iFig)]);
                        systemObj.movieObj{iFig}.Quality = systemObj.movieQuality;
                        systemObj.movieObj{iFig}.FrameRate = systemObj.movieFrameRate;
                        open(systemObj.movieObj{iFig});
                        
                        figure(figureList(iFig));
                        systemObj.movieObj{iFig}.writeVideo(getframe(figureList(iFig)));
                    end
                end
                
            case 'update'
                
                if systemObj.plotStateFlag
                    systemObj.plotState(tc(1,end),x(:,end),tc(1,1:end-1),x(:,1:end-1));
                end
                if systemObj.plotInputFlag
                    systemObj.plotInput(td(1,end),td(1,1:end-1),u(:,1:end-1));
                end
                if systemObj.plotOutputFlag
                    systemObj.plotOutput(td(1,end),td(1,1:end-1),y(:,1:end-1));
                end
                if systemObj.plotPhaseFlag
                    systemObj.plotPhase(x(:,end),x(:,1:end-1));
                end
                if systemObj.plotSketchFlag
                    systemObj.plotSketch(td(1,end),x(:,end));
                end
                
                if stopFlag
                    for iFig = 1:length(figureList)
                        delete(findobj(figureList(iFig),'Tag','stop'));
                        set(figureList(iFig),figureListProperties{iFig}{:});
                    end
                end
                
                drawnow
                
                % Movie
                if systemObj.movieFlag
                    for iFig = 1:length(figureList)                       
                        systemObj.movieObj{iFig}.writeVideo(getframe(figureList(iFig)));
                    end
                end
            case 'done'
                for iFig = 1:length(figureList)
                    delete(findobj(figureList(iFig),'Tag','stop'));
                    set(figureList(iFig),figureListProperties{iFig}{:});
                end
                
                if systemObj.legendFlag
                    if systemObj.plotStateFlag
                        legend(systemObj.stateAxisHandle,'Location','best')
                    end
                    if systemObj.plotInputFlag
                        legend(systemObj.inputAxisHandle,'Location','best')
                    end
                    if systemObj.plotOutputFlag
                        legend(systemObj.outputAxisHandle,'Location','best')
                    end
                    if systemObj.plotPhaseFlag
                        legend(systemObj.phaseAxisHandle,'Location','best')
                    end
                end
                
                % Movie
                if systemObj.movieFlag
                    for iFig = 1:length(figureList)
                        systemObj.movieObj{iFig}.writeVideo(getframe(figureList(iFig)));
                    end
                end
        end
    end

%% Stop Button Callback
    function stopButtonCallback(~,~)
        stopFlag = true;
    end

end

%% Helper Functions ------------------------------------------------------------
function [T,X,TE,XE,IE] = euler(odefun,tspan,x0,options)
    eventsFun = options.events;
    t0 = tspan(1);
    ts = options.timeStep;
    t = t0 + ts;
    dx = odefun(t0,x0);
    x = x0 + dx*ts;
    [value,isTerminal,direction] = eventsFun(t,x); %#ok<NASGU,ASGLU>
    T(1,1) = t0;
    T(2,1) = t;
    X(1,:) = x0';
    X(2,:) = x';
    TE = T(2,1);
    XE = X(2,:);
    IE = 4;
end


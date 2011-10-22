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
%       "pendulumObj.nStates" x "length(timeTape)" maxtrix.
%
%   timeTapeD - (1 x ? real number)
%       A vector specifying the interval of the actual simulation in
%       discrete time. Will only be different from the input "timeInterval"
%       if "timeInterval" is two elements or the stop button is pushed in the plot.
%
%   inputTape - (? x ? number)
%       Recording of input values during simulation.  A
%       "pendulumObj.nInputs" x "length(timeTape)" maxtrix.
%
%   outputTape - (? x ? number)
%       Recording of output values during simulation.  A
%       "pendulumObj.nOutputs" x "length(timeTape)" maxtrix.
%
%   flowTimeTape - (1 x ? semi-positive real number)
%       Recording of flow time values during simulation. A 1 x
%       "length(timeTape)" vector.
%
%   jumpCountTape - (1 x ? semi-positive integer)
%       Recording of jump count values during simulation. A 1 x
%       "length(timeTape)" vector.
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
if ~exist('movieFile','var'), movieFile = ''; end

% Check property values for errors
assert(ischar(movieFile),...
    'simulate:system:simulate:movieFile',...
    'Property "movieFile" must be a string.')
if isempty(movieFile)
    movieFlag = false;
else
    movieFlag = true;
end

%% Parameters
movieFrameRate = 20; % TODO: Add these paramerters to input
movieQuality = 60;
catSize = 500;

%% Initialize
% ODE options
options = systemObj.odeOptions;
if isempty(options)
    options = odeset('Events',@odeEventsFunc);
else
    options = odeset(options{:},'Events',@odeEventsFunc);
end
zeroSize = systemObj.zeroSize;

% Time variables
initialTime = timeInterval(1);
finalTime = timeInterval(end);
timeVector = initialTime:systemObj.timeStep:finalTime;
nTimePoints = length(timeVector);
tD = initialTime;
ts = systemObj.timeStep;
tDNext = tD + ts;

% Initial input/output variables
initialInput = systemObj.inputConstraints(systemObj.policy(initialTime,initialState,initialFlowTime,initialJumpCount));
initialOutput = systemObj.sensor(initialTime,initialState,initialFlowTime,initialJumpCount);
uD = initialInput;

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
jC = initialJumpCount;

cntD = 1; % Discrete
timeTapeD = nan(1,nTimePoints+catSize);
inputTape = nan(systemObj.nInputs,nTimePoints+catSize);
outputTape = nan(systemObj.nOutputs,nTimePoints+catSize);
timeTapeD(1, 1) = initialTime;
inputTape(:, 1) = initialInput;
outputTape(:, 1) = initialOutput;
nTimePointsD = length(timeTapeD);
jD = initialJumpCount;

% ODE arguements
TSpan = [initialTime finalTime];
QPlus = [initialState; initialFlowTime]; % General state vector with control parameters

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

%% Integrate
while 1
    [T,Q,Te,~,Ie] = systemObj.odeSolver(@odeInputFunc,TSpan,QPlus,options);
    if ~isempty(Te(Ie == 2)) && ...
            any(abs(Te(Ie == 2) - timeTapeC([0 diff(jumpCountTape)] == 1)) < zeroSize) % Remove repeated jump
        Te = Te(Ie ~= 2);
        Ie = Ie(Ie ~= 2);
    end
    Q(abs(Q) <= zeroSize) = 0; % Set Q's close to zero to zero
    discreteUpdateWJump = all(ismember([2;4],Ie)); % Mark to do a discrete update with a jump
    if any(Ie == 4) % Set T's with updates to update time
        [~,ind] = min(abs(Te(Ie == 4) - timeVector));
        T(T == Te(Ie == 4)) = timeVector(ind);
        Te(Te == Te(Ie == 4)) = timeVector(ind);
    end
    if ~isempty(Te) % Only progress to next event
        T = T(T <= min(Te));
        Q = Q(T <= min(Te),:);
        Te = Te(Te == min(Te));
        Ie = Ie(Te == min(Te));
    end
    
    % Continuous time update
    nT = size(T,1);
    tC = T(end);
    tCDelta = tDNext - tC; %tCDelta(abs(tCDelta) <= zeroSize) = 0;
    xC = Q(end, 1:end-1)';
    fC = Q(end, end);
    cntCPrev = cntC;
    cntC = cntC + nT - 1;
    if cntC > nTimePointsC
        timeTapeC = [timeTapeC nan(1,catSize)]; %#ok<AGROW>
        stateTape = [stateTape nan(systemObj.nStates,catSize)]; %#ok<AGROW>
        flowTimeTape = [flowTimeTape nan(1,catSize)]; %#ok<AGROW>
        jumpCountTape = [jumpCountTape nan(1,catSize)]; %#ok<AGROW>
        nTimePointsC = length(timeTapeC);
    end
    timeTapeC(1, cntCPrev+1:cntC) = T(2:end)';
    stateTape(:, cntCPrev+1:cntC) = Q(2:end, 1:end-1)';
    flowTimeTape(1, cntCPrev+1:cntC) = Q(2:end, end)';
    jumpCountTape(1, cntCPrev+1:cntC) = jC*ones(1,nT-1);
    
    % Discrete time update
    if any(Ie == 4)
        [~,ind] = min(abs(T(end) - timeVector));
        tD = timeVector(ind);
        tDNext = tD + ts;
        xD = Q(end, 1:end-1)';
        fD = Q(end, end);
        jD = jC;
        uD = systemObj.inputConstraints(systemObj.policy(tD,xD,fD,jD));
        yD = systemObj.sensor(tD,xD,fD,jD);
        
        cntD = cntD + 1;
        if cntD > nTimePointsD
            timeTapeD = [timeTapeD nan(1,catSize)]; %#ok<AGROW>
            inputTape = [inputTape nan(systemObj.nInputs,catSize)]; %#ok<AGROW>
            outputTape = [outputTape nan(systemObj.nOutputs,catSize)]; %#ok<AGROW>
            nTimePointsD = length(timeTapeD);
        end
        timeTapeD(1, cntD) = tD;
        inputTape(:, cntD) = uD;
        outputTape(:, cntD) = yD;
        
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
    
    % Finish simulating forward
    if tC == finalTime || stopFlag
        break;
    end
    
    % Select set map to use
    if ~isempty(Ie)
        if ~any(Ie == 1) && any(Ie == 2) && ~any(Ie == 4) % In both flow set and jump set
            if strcmp(systemObj.setPriority,'random')
                if rand < .5
                    setMapToUse = 'flow';
                else
                    setMapToUse = 'jump';
                end
            else
                setMapToUse = systemObj.setPriority;
            end
            
        elseif any(Ie == 1) && ~any(Ie == 2) % Left flow set
            setMapToUse = 'flow';
            
        elseif ~any(Ie == 1) && any(Ie == 2) % Enter jump set
                setMapToUse = 'jump';
                
        elseif ~any(Ie == 1) && ~any(Ie == 2) && any(Ie == 3) % Max flow time hit
            break;
            
        elseif ~any(Ie == 1) && ~any(Ie == 2) && any(Ie == 4) % Time sample hit
            TSpan(1) = tD;
            QPlus = Q(end, :)';
            continue;
            
        else
            error('simulate:system:simulate:selectSetMap',...
                'Invalid number of simulation events: %d',numel(Ie))
        end
    else
        % Stop button pushed
        break
    end
    
    switch setMapToUse
        case 'flow' % Left flow set
            break;
            
        case 'jump' % Enter jump set
            
            % Update
            XPlus = systemObj.jumpMap(tC,xC,uD,fC,jD);
            TFlowPlus = 0;
            QPlus = [XPlus; TFlowPlus];
            JCntPlus = jC + 1;
            TSpan(1) = tC;
            
            % Continuous time
            cntC = cntC + 1;
            if cntC > nTimePointsC
                timeTapeC = [timeTapeC nan(1,catSize)]; %#ok<AGROW>
                stateTape = [stateTape nan(systemObj.nStates,catSize)]; %#ok<AGROW>
                flowTimeTape = [flowTimeTape nan(1,catSize)]; %#ok<AGROW>
                jumpCountTape = [jumpCountTape nan(1,catSize)]; %#ok<AGROW>
                nTimePointsC = length(timeTapeC);
            end
            timeTapeC(1, cntC) = tC;
            stateTape(:, cntC) = XPlus;
            flowTimeTape(1, cntC) = TFlowPlus;
            jumpCountTape(1, cntC) = JCntPlus;
            
            % Discrete time
            if discreteUpdateWJump
                tD = tC;
                tDNext = tD + ts;
                xD = XPlus;
                fD = TFlowPlus;
                jD = JCntPlus;
                uD = systemObj.inputConstraints(systemObj.policy(tD,xD,fD,jD));
                yD = systemObj.sensor(tD,xD,fD,jD);
                
                cntD = cntD + 1;
                if cntD > nTimePointsD
                    timeTapeD = [timeTapeD nan(1,catSize)]; %#ok<AGROW>
                    inputTape = [inputTape nan(systemObj.nInputs,catSize)]; %#ok<AGROW>
                    outputTape = [outputTape nan(systemObj.nOutputs,catSize)]; %#ok<AGROW>
                    nTimePointsD = length(timeTapeD);
                end
                timeTapeD(1, cntD) = tD;
                inputTape(:, cntD) = uD;
                outputTape(:, cntD) = yD;
                
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
            
            if JCntPlus >= systemObj.maxJumpCount && ...
                    fC + tCDelta < systemObj.maxFlowTime && ...
                    tDNext < finalTime
                
                TFlowNext = fC + tCDelta;
                cntC = cntC + 1;
                cntD = cntD + 1;
                
                timeTapeC(1, cntC) = tDNext;
                timeTapeD(1, cntD) = tDNext;
                stateTape(:, cntC) = XPlus;
                inputTape(:, cntD) = systemObj.inputConstraints(systemObj.policy(tDNext,XPlus,TFlowNext,JCntPlus));
                outputTape(:, cntD) = systemObj.sensor(tDNext,XPlus,TFlowNext,JCntPlus);
                flowTimeTape(1, cntC) = TFlowNext;
                jumpCountTape(1, cntC) = JCntPlus;
                break;
            end
            
            jC = JCntPlus;
            
        otherwise
            error('simulate:system:simulate:setMapToUse',...
                'Unknown property value for "setPriority": %s',setMapToUse)
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
jumpCountTape = jumpCountTape(1,timeLogicD);

%% Finalize Graphics
if systemObj.graphicsFlag
    odeGraphics([],[],[],[],[],'done');
    
    if movieFlag
        for iFigCnt = 1:length(figureList)
            vidObj{iFigCnt}.close;
        end
    end
end

%% ODE Input Function
    function dq = odeInputFunc(t,q)
        x = q(1:end-1);
        f = q(end);

        dx = systemObj.flowMap(t,x,uD,f,jC);
        df = 1;
        dq = [dx; df];
    end

%% ODE Event Function
    function [value,isTerminal,direction] = odeEventsFunc(t,q)
        x = q(1:end-1);
        f = q(end);
            
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
                if movieFlag
                    vidObj = cell(length(figureList),1);
                    for iFig = 1:length(figureList)
                        vidObj{iFig} = VideoWriter([movieFile '_' num2str(iFig)]);
                        vidObj{iFig}.Quality = movieQuality;
                        vidObj{iFig}.FrameRate = movieFrameRate;
                        open(vidObj{iFig});
                        
                        figure(figureList(iFig));
                        vidObj{iFig}.writeVideo(getframe(figureList(iFig)));
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
                if movieFlag
                    for iFig = 1:length(figureList)                       
                        vidObj{iFig}.writeVideo(getframe(figureList(iFig)));
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
                if movieFlag
                    for iFig = 1:length(figureList)
                        vidObj{iFig}.writeVideo(getframe(figureList(iFig)));
                    end
                end
        end
    end

%% Stop Button Callback
    function stopButtonCallback(~,~)
        stopFlag = true;
    end

end



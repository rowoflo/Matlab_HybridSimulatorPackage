function [timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape,flowTimeTape,jumpCountTape,stopFlag] = ...
    simulate(systemObj,timeInterval,initialState,initialCost,initialFlowTime,initialJumpCount,varargin)
% The "simulate" method will simulate the system from the time of
% "timeInterval(1)" to the time of "timeInterval(end)" and starting in the
% state of "initialState".
%
% SYNTAX:
%   [timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape,flowTimeTape,jumpCountTape,stopFlag] = ...
%       systemObj.simulate(timeInterval)
%       systemObj.simulate(timeInterval,initialState)
%       systemObj.simulate(timeInterval,initialState,initialCost)
%       systemObj.simulate(timeInterval,initialState,initialCost,initialFlowTime)
%       systemObj.simulate(timeInterval,initialState,initialCost,initialFlowTime,initialJumpCount)
%       systemObj.simulate(timeInterval,initialState,initialCost,initialFlowTime,initialJumpCount,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   timeInterval - (1 x 2 real number)
%       A vector specifying the interval of the simulation. The first value
%       is the initial time of the second value is the final time.
%
%   initialState - (nStates x 1 number) [systemObj.state]
%       Initial state of the simulation.
%
%   initialCost - (nCosts x 1 number) [systemObj.cost]
%       Initial state of the simulation.
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
%   stateTape - (nStates x length(timeTapeC) number)
%       Recording of state values during simulation.
%
%   timeTapeD - (1 x ? real number)
%       A vector specifying the interval of the actual simulation in
%       discrete time. Will only be different from the input "timeInterval"
%       if "timeInterval" is two elements or the stop button is pushed in the plot.
%
%   inputTape - (nInputs x length(timeTapeD) number)
%       Recording of input values during simulation.
%
%   outputTape - (nOutputs x length(timeTapeD) number)
%       Recording of output values during simulation.
%
%   instantaneousCostTape - (nCosts x length(timeTapeD) number)
%       Recording of instantaneous cost values during simulation.
%
%   cumulativeCostTape - (nCosts x length(timeTapeD) number)
%       Recording of cumulative cost values during simulation.
%
%   flowTimeTape - (1 x length(timeTapeC) semi-positive real number)
%       Recording of flow time values during simulation.
%
%   jumpCountTape - (1 x length(timeTapeC) semi-positive integer)
%       Recording of jump count values during simulation.
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
%   Rowland O'Flaherty (rowlandoflaherty.com)
%
% VERSION: 
%   Created 17-APR-2011
%-------------------------------------------------------------------------------

%% Check Input Arguments

% Check number of arguments
narginchk(2,inf)

% Apply default values
if nargin < 3, initialState = systemObj.state; end
if nargin < 4, initialCost = systemObj.cumulativeCost; end
if nargin < 5, initialFlowTime = 0; end
if nargin < 6, initialJumpCount = 0; end

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

assert(isnumeric(initialCost) && isequal(size(initialCost),[systemObj.nCosts 1]),...
    'simulate:system:simulate:initialCost',...
    'Input argument "initialCost" must be a %d x 1 vector of numbers.',systemObj.nCosts)

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
systemObj.catSize = 2000;

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
initialInput = zeros(systemObj.nInputs,1);
initialOutput = systemObj.sensor(initialTime,initialState,initialInput,initialFlowTime,initialJumpCount);
xBar = stateTraj2stateBar(initialTime,systemObj.timeTrajTape,systemObj.stateTrajTape);
initialInstantaneousCost = systemObj.cost(initialTime,initialState,initialInput,initialOutput,initialFlowTime,initialJumpCount,[],xBar);
initialInput = systemObj.inputConstraints(systemObj.policy(initialTime,initialState,initialInput,initialOutput,initialFlowTime,initialJumpCount));
uD = initialInput; % Current input. Updated discretely.

% Tape variables
cntC = 1; % Continuous
timeTapeC = nan(1,nTimePoints+systemObj.catSize);
stateTape = nan(systemObj.nStates,nTimePoints+systemObj.catSize);
flowTimeTape = nan(1,nTimePoints+systemObj.catSize);
jumpCountTape = nan(1,nTimePoints+systemObj.catSize);
timeTapeC(1, 1) = initialTime;
stateTape(:, 1) = initialState;
flowTimeTape(1, 1) = initialFlowTime;
jumpCountTape(1, 1) = initialJumpCount;
nTimePointsC = length(timeTapeC);

cntD = 1; % Discrete
timeTapeD = nan(1,nTimePoints+systemObj.catSize);
inputTape = nan(systemObj.nInputs,nTimePoints+systemObj.catSize);
outputTape = nan(systemObj.nOutputs,nTimePoints+systemObj.catSize);
instantaneousCostTape = nan(systemObj.nCosts,nTimePoints+systemObj.catSize);
cumulativeCostTape = nan(systemObj.nCosts,nTimePoints+systemObj.catSize);
timeTapeD(1, 1) = initialTime;
inputTape(:, 1) = initialInput;
outputTape(:, 1) = initialOutput;
instantaneousCostTape(:, 1) = initialInstantaneousCost;
cumulativeCostTape(:, 1) = initialCost;
nTimePointsD = length(timeTapeD);

% Sim variables
breakFlag = false;
tC = initialTime; % Current continuous time
tD = initialTime; % Current discrete time
xC = initialState; % Currrent continuous state
JD = initialCost; % Current discrete cost
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
        instantaneousCostTape(:, 1:cntD),...
        cumulativeCostTape(:, 1:cntD),...
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
                timeTapeC = [timeTapeC nan(1,systemObj.catSize)]; %#ok<AGROW>
                stateTape = [stateTape nan(systemObj.nStates,systemObj.catSize)]; %#ok<AGROW>
                flowTimeTape = [flowTimeTape nan(1,systemObj.catSize)]; %#ok<AGROW>
                jumpCountTape = [jumpCountTape nan(1,systemObj.catSize)]; %#ok<AGROW>
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
                timeTapeC = [timeTapeC nan(1,systemObj.catSize)]; %#ok<AGROW>
                stateTape = [stateTape nan(systemObj.nStates,systemObj.catSize)]; %#ok<AGROW>
                flowTimeTape = [flowTimeTape nan(1,systemObj.catSize)]; %#ok<AGROW>
                jumpCountTape = [jumpCountTape nan(1,systemObj.catSize)]; %#ok<AGROW>
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
            timeTapeD = [timeTapeD nan(1,systemObj.catSize)]; %#ok<AGROW>
            inputTape = [inputTape nan(systemObj.nInputs,systemObj.catSize)]; %#ok<AGROW>
            outputTape = [outputTape nan(systemObj.nOutputs,systemObj.catSize)]; %#ok<AGROW>
            instantaneousCostTape = [instantaneousCostTape nan(systemObj.nCosts,systemObj.catSize)]; %#ok<AGROW>
            cumulativeCostTape = [cumulativeCostTape nan(systemObj.nCosts,systemObj.catSize)]; %#ok<AGROW>
            nTimePointsD = length(timeTapeD);
        end
        tD = T(1, end);
        tDNext = tD + ts;
        xD = X(:, end);
        fD = fC;
        jD = jC;
        yD = systemObj.sensor(tD,xD,uD,fD,jD);
        xBar = stateTraj2stateBar(tD,systemObj.timeTrajTape,systemObj.stateTrajTape);
        LD = systemObj.cost(tD,xD,uD,yD,fD,jD,[],xBar);
        JD = systemObj.sumCost(JD,LD);
        systemObj.evaluate(tD,xD,uD,yD,LD,JD,fD,jD,...
            timeTapeC(1,1:cntC-1),stateTape(:,1:cntC-1),timeTapeD(1,1:cntD-1),inputTape(:,1:cntD-1),outputTape(:,1:cntD-1),instantaneousCostTape(1,1:cntD-1),cumulativeCostTape(1,1:cntD-1));
        uD = systemObj.inputConstraints(systemObj.policy(tD,xD,uD,yD,fD,jD));
        timeTapeD(1, cntD) = tD;
        inputTape(:, cntD) = uD;
        outputTape(:, cntD) = yD;
        instantaneousCostTape(:, cntD) = LD;
        cumulativeCostTape(:, cntD) = JD;
        
        % Update graphics
        if systemObj.graphicsFlag
            odeGraphics(...
                timeTapeC(1, 1:cntC),...
                stateTape(:, 1:cntC),...
                timeTapeD(1, 1:cntD),...
                inputTape(:, 1:cntD),...
                outputTape(:, 1:cntD),...         
                instantaneousCostTape(:, 1:cntD),...
                cumulativeCostTape(:, 1:cntD),...
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
instantaneousCostTape = instantaneousCostTape(:, timeLogicD);
cumulativeCostTape = cumulativeCostTape(:, timeLogicD);
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
                [instantaneousCostTape(:, 1:cntD) nan(systemObj.nCosts,1)],...
                [cumulativeCostTape(:, 1:cntD) nan(systemObj.nCosts,1)],...
                'update');
            
    if systemObj.clearStopButtonFlag || stopFlag
        odeGraphics([],[],[],[],[],[],[],'done');
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
    function odeGraphics(tc,x,td,u,y,L,J,flag)
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
                if systemObj.plotInstantaneousCostFlag
                    systemObj.plotInstantaneousCost(td(1,end),td(1,1:end-1),L(:,1:end-1));
                    legend(systemObj.instantaneousCostAxisHandle,'off')
                end
                if systemObj.plotCumulativeCostFlag
                    systemObj.plotCumulativeCost(td(1,end),td(1,1:end-1),J(:,1:end-1));
                    legend(systemObj.cumulativeCostAxisHandle,'off')
                end
                if systemObj.plotPhaseFlag
                    systemObj.plotPhase(x(:,end),x(:,1:end-1));
                    legend(systemObj.phaseAxisHandle,'off')
                end
                if systemObj.plotSketchFlag
                    systemObj.plotSketch(x(:,end),x(:,1:end-1),tc(1,end),tc(1,1:end-1));
                end
                                
                % Figure setup
                figureList = [...
                    systemObj.stateFigureHandle;...
                    systemObj.inputFigureHandle;...
                    systemObj.outputFigureHandle;...
                    systemObj.instantaneousCostFigureHandle;...
                    systemObj.cumulativeCostFigureHandle;...
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
                if systemObj.plotInstantaneousCostFlag
                    systemObj.plotInstantaneousCost(td(1,end),td(1,1:end-1),L(:,1:end-1));
                end
                if systemObj.plotCumulativeCostFlag
                    systemObj.plotCumulativeCost(td(1,end),td(1,1:end-1),J(:,1:end-1));
                end
                if systemObj.plotPhaseFlag
                    systemObj.plotPhase(x(:,end),x(:,1:end-1));
                end
                if systemObj.plotSketchFlag
                    systemObj.plotSketch(x(:,end),x(:,1:end-1),tc(1,end),tc(1,1:end-1));
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
                        if ~isempty(get(systemObj.stateAxisHandle, 'Children'))
                            legend(systemObj.stateAxisHandle,'Location','best')
                        end
                    end
                    if systemObj.plotInputFlag
                        if ~isempty(get(systemObj.inputAxisHandle, 'Children'))
                            legend(systemObj.inputAxisHandle,'Location','best')
                        end
                    end
                    if systemObj.plotOutputFlag
                        if ~isempty(get(systemObj.outputAxisHandle, 'Children'))
                            legend(systemObj.outputAxisHandle,'Location','best')
                        end
                    end
                    if systemObj.plotInstantaneousCostFlag
                        if ~isempty(get(systemObj.instantaneousCostAxisHandle, 'Children'))
                            legend(systemObj.instantaneousCostAxisHandle,'Location','best')
                        end
                    end
                    if systemObj.plotCumulativeCostFlag
                        if ~isempty(get(systemObj.cumulativeCostAxisHandle, 'Children'))
                            legend(systemObj.cumulativeCostAxisHandle,'Location','best')
                        end
                    end
                    if systemObj.plotPhaseFlag
                        if ~isempty(get(systemObj.phaseAxisHandle, 'Children'))
                            legend(systemObj.phaseAxisHandle,'Location','best')
                        end
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
function stateBar = stateTraj2stateBar(time,timeTrajTape,stateTrajTape)
tInd = find(time >= timeTrajTape,1,'last');
if isempty(tInd)
    stateBar = zeros(size(stateTrajTape,1),1);
else
    stateBar = stateTrajTape(:,tInd);
end
end

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


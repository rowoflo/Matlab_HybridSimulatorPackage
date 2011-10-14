function [timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = ...
    simulate(systemObj,timeVector,initialState,initialFlowTime,initialJumpCount,varargin)
% The "simulate" method will simulate the system from the time of
% "timeVector(1)" to the time of "timeVector(end)" and starting in the
% state of "initialState".
%
% SYNTAX:
%   [timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = ...
%       systemObj.simulate(timeVector)
%       systemObj.simulate(timeVector,initialState)
%       systemObj.simulate(timeVector,initialState,initialFlowTime)
%       systemObj.simulate(timeVector,initialState,initialFlowTime,initialJumpCount)
%       systemObj.simulate(timeVector,initialState,initialFlowTime,initialJumpCount,'PropertyName',PropertyValue,...)
%
% INPUTS:
%   systemObj - (1 x 1 simulate.system)
%       An instance of the "simulate.system" class.
%
%   timeVector - (1 x ? real number)
%       A vector specifying the interval of the simulation. Each element of
%       the vector specifies which time points will be in the output.
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
%       discrete time. Will only be different from the input "timeVector"
%       if "timeVector" is two elements or the stop button is pushed in the plot.
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
%   run.m | replay.m | policy.m
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

assert(isnumeric(timeVector) && isreal(timeVector) && isvector(timeVector),...
    'simulate:system:simulate:timeVector',...
    'Input argument "timeVector" must be a vector of  real numbers.')
timeVector = timeVector(:)';

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
initialTime = timeVector(1);
finalTime = timeVector(end);
initialInput = systemObj.inputConstraints(systemObj.policy(initialTime,initialState,initialFlowTime,initialJumpCount));
initialOutput = systemObj.sensor(initialTime,initialState,initialFlowTime,initialJumpCount);

TVector = [initialTime finalTime];
QPlus = [initialState;initialFlowTime;initialJumpCount]; % General state vector with control parameters

options = systemObj.odeOptions;
if isempty(options)
    options = odeset('Events',@odeEventsFunc);
else
    options = odeset(options{:},'Events',@odeEventsFunc);
end

timeTapeC = nan(1,length(timeVector)+catSize);
timeTapeD = nan(1,length(timeVector)+catSize);
stateTape = nan(systemObj.nStates,length(timeVector)+catSize);
inputTape = nan(systemObj.nInputs,length(timeVector)+catSize);
outputTape = nan(systemObj.nOutputs,length(timeVector)+catSize);
flowTimeTape = nan(1,length(timeVector)+catSize);
jumpCountTape = nan(1,length(timeVector)+catSize);

cCnt = 1;
timeTapeC(1,1) = TVector(1);
stateTape(:,1) = initialState;

dCnt = 1;
timeTapeD(1,1) = TVector(1);
inputTape(:,1) = initialInput;
outputTape(:,1) = initialOutput;
flowTimeTape(1,1) = initialFlowTime;
jumpCountTape(1,1) = initialJumpCount;

stopFlag = false;
figureList = [];
figureListProperties = {};

if systemObj.graphicsFlag
    odeGraphics(...
        timeTapeC(1,1:cCnt),...
        stateTape(:,1:cCnt),...
        timeTapeD(1,1:dCnt),...
        inputTape(:,1:dCnt),...
        outputTape(:,1:dCnt),...
        'init');
end

%% Integrate
while 1
    [T,Q,Te,Qe,Ie] = systemObj.odeSolver(@odeInputFunc,TVector,QPlus,options); %#ok<ASGLU>
    
    % Continuous time update
    cCntPrev = cCnt;
    cCnt = cCnt + size(T,1) - 1;
    timeTapeC(1,cCntPrev+1:cCnt) = T(2:end)';
    stateTape(:,cCntPrev+1:cCnt) = Q(2:end,1:end-2)';
    
    % Discrete time update
    if (~any(Ie == 1) && ~any(Ie == 2) && any(Ie == 4) ) || T(end) == timeVector(end)
        t = T(end);
        x = Q(end,1:end-2)';
        f = Q(end,end-1);
        j = Q(end,end);
        u = systemObj.inputConstraints(systemObj.policy(t,x,f,j));
        y = systemObj.sensor(t,x,f,j);
        
        dCnt = dCnt + 1;
        timeTapeD(1,dCnt) = t;
        inputTape(:,dCnt) = u;
        outputTape(:,dCnt) = y;
        flowTimeTape(1,dCnt) = f;
        jumpCountTape(1,dCnt) = j;
        
        if systemObj.graphicsFlag
            odeGraphics(...
                timeTapeC(1,1:cCnt),...
                stateTape(:,1:cCnt),...
                timeTapeD(1,1:dCnt),...
                inputTape(:,1:dCnt),...
                outputTape(:,1:dCnt),...
                'update');
        end
    end
    
    if T(end) == timeVector(end) || stopFlag
        % Finished simulating forward
        break;
    end
    
    % Select set map to use
    if ~isempty(Ie)
        if any(Ie == 1) && any(Ie == 2) % In both flow set and jump set
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
            TVector(1) = T(end);
            QPlus = Q(end,:)';
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
        case 'flow'
            % Left flow set
            break;
            
        case 'jump'
            % Enter jump set
            TC = timeTapeC(1,cCnt);
            TD = timeTapeC(1,dCnt);
            XC = stateTape(:,cCnt);
            U = inputTape(:,dCnt);
            TFlow = flowTimeTape(1,dCnt);
            JCnt = jumpCountTape(:,dCnt);
            
            XPlus = systemObj.jumpMap(TC,XC,U,TFlow,JCnt);
            QPlus = [XPlus;0;JCnt+1];
            TVector(1) = TC;
            
            if JCnt+1 >= systemObj.maxJumpCount
                timeTapeC(1,cCnt + 1) = TC;
                timeTapeD(1,dCnt + 1) = TD;
                stateTape(:,cCnt + 1) = XPlus;
                inputTape(:,dCnt + 1) = zeros(systemObj.nInputs,1);
                outputTape(:,dCnt + 1) = systemObj.sensor(TC,XPlus,TFlow,JCnt+1);
                flowTimeTape(1,dCnt + 1) = TFlow;
                jumpCountTape(1,dCnt + 1) = JCnt+1;
                break;
            end
            
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
flowTimeTape = flowTimeTape(1,timeLogicD);
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
        x = q(1:end-2);
        f = q(end-1);
        j = round(q(end));
        
        % Samples
        if dCnt == 0
            ts = timeVector(1);
            xs = initialState;
            fs = initialFlowTime;
            js = initialJumpCount;
        else
            ts = timeTapeD(1,dCnt);
            c2dLogic = ts == timeTapeC;
            if ~any(c2dLogic)
                xs = initialState;
            else
                xs = stateTape(:,c2dLogic);
            end
            fs = flowTimeTape(1,dCnt);
            js = jumpCountTape(1,dCnt);
        end
        
        us = systemObj.inputConstraints(systemObj.policy(ts,xs,fs,js));
        dx = systemObj.flowMap(t,x,us,f,j);
        df = 1;
        dj = 0;
        dq = [dx;df;dj];
    end

%% ODE Event Function
    function [value,isTerminal,direction] = odeEventsFunc(t,q)
        x = q(1:end-2);
        f = q(end-1);
        j = q(end);
        
        if dCnt == 0
            ts = systemObj.timeStep;
        else
            ts = timeTapeD(1,dCnt) + systemObj.timeStep;
        end
        
        value = [systemObj.flowSet(t,x,f,j);...
            systemObj.jumpSet(t,x,f,j);...
            systemObj.maxFlowTime-f;...
            ts - t];
        
        isTerminal = [1;1;1;1]; % Stop for all crossings
        direction = [-1;1;-1;-1]; % Local min for flow, local max for jump, local min for flow time, local min for time
    end

%% ODE Graphics Function
    function odeGraphics(tc,x,td,u,y,flag)
        switch flag
            case 'init'
                if systemObj.plotStateFlag
                    systemObj.plotState(tc(1,end),x(:,end),tc(1,1:end-1),x(:,1:end-1),'LegendFlag',false);
                end
                if systemObj.plotInputFlag
                    systemObj.plotInput(td(1,end),td(1,1:end-1),u(:,1:end-1),'LegendFlag',false);
                end
                if systemObj.plotOutputFlag
                    systemObj.plotOutput(td(1,end),td(1,1:end-1),y(:,1:end-1),'LegendFlag',false);
                end
                if systemObj.sketchFlag
                    systemObj.sketch(x(:,end),td(1,end));
                end
                if systemObj.phaseFlag
                    systemObj.phase(x(:,end),x(:,1:end-1),'LegendFlag',false);
                end
                
                % Figure setup
                figureList = [...
                    systemObj.stateFigureHandle;...
                    systemObj.inputFigureHandle;...
                    systemObj.outputFigureHandle;...
                    systemObj.sketchFigureHandle;...
                    systemObj.phaseFigureHandle];
                
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
                    systemObj.plotState(tc(1,end),x(:,end),tc(1,1:end-1),x(:,1:end-1),'LegendFlag',false);
                end
                if systemObj.plotInputFlag
                    systemObj.plotInput(td(1,end),td(1,1:end-1),u(:,1:end-1),'LegendFlag',false);
                end
                if systemObj.plotOutputFlag
                    systemObj.plotOutput(td(1,end),td(1,1:end-1),y(:,1:end-1),'LegendFlag',false);
                end
                if systemObj.sketchFlag
                    systemObj.sketch(x(:,end),td(1,end));
                end
                if systemObj.phaseFlag
                    systemObj.phase(x(:,end),x(:,1:end-1),'LegendFlag',false);
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
                    if systemObj.phaseFlag
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



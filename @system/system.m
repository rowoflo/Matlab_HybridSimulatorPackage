classdef system < dynamicprops
% The "simulate.system" class is an abstract class for creating dynamical
% systems.
%
% NOTES:
%   To get more information on this class type "doc simulate.system" into the
%   command window.
%
% NECESSARY FILES AND/OR PACKAGES:
%   +simulate
%
% SEE ALSO:
%   simulate.map
%
% AUTHOR:
%   Rowland O'Flaherty (rowlandoflaherty.com)
%
% VERSION: 
%   Created 17-APR-2011
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Access = public)
    name; % (string) Name of the system.
    stateNames % (nStates x 1 cell array of strings) Names of the state variables. One per state.
    inputNames % (nInputs x 1 cell array of strings) Names of the input variables. One per input.
    outputNames % (nOutputs x 1 cell array of strings) Names of the output variables. One per output.
    costNames % (nCosts x 1 cell array of strings) Names of the cost variables. One per cost.
    phaseStatePairs; % (? x 2 positive integer <= nStates) State pairs for the phase plot. One pair per row of the matrix. The first column is the x-axis and the second column is the y-axis.
end

properties (Abstract = true, SetAccess = private)
    type % (string) Type of system.
end

properties (Access = public)
    graphicsFlag = false; % (1 x 1 logical) Flag determining if graphics are drawn during simulation.
    legendFlag = true; % (1 x 1 logical) Flag determining if legends are displayed in plots.
    clearStopButtonFlag = true; % (1 x 1 logical) Flag determining if the stop buttons are clear after simulation.
    
    plotStateFlag = true; % (1 x 1 logical) Flag determining if the state plot is drawn during the simulation.
    plotParamsFlag = true; % (1 x 1 logical) Flag determing if the flow time and jump count will be plotted with the states.
    plotInputFlag = true; % (1 x 1 logical) Flag determining if the input plot is drawn during the simulation.
    plotOutputFlag = true; % (1 x 1 logical) Flag determining if the output plot is drawn during the simulation.
    plotInstantaneousCostFlag = false; % (1 x 1 logical) Flag determining if the instantaneous cost plot is drawn during the simulation.
    plotCumulativeCostFlag = false; % (1 x 1 logical) Flag determining if the cumulative cost plot is drawn during the simulation.
    plotPhaseFlag = false; % (1 x 1 logical) Flag determining if the phase plot is drawn during the simulation.
    plotSketchFlag = false; % (1 x 1 logical) Flag determining if the sketch plot is drawn during the simulation.
    
    setPriority = 'jump'; % ('flow','jump', or 'random') Sets the priority to what takes place if the state is in both the flow set and the jump set.
    maxFlowTime = inf; % (1 x 1 positive number) Maximum flow time for the simulation.
    maxJumpCount = inf; % (1 x 1 positive integer) Maximum jump count for the simulation.
    
    % Tape Properties
    catSize = 2000; % (1 x 1 positive integer) Concatenation size for tape properties.
    
    % Movie Properties
    movieFileName = 'systemMovie'; % (string) Name of file the movie will be saved to, with no extension.
    movieFlag = false; % (1 x 1 logical) If true a movie will be created.
    movieObj = {}; % (? x 1 cell array of VideoWriter Objects) Video objects.
    movieQuality = 60; % (1 x 1 positive integer) Sets movie quality. 0 - 100.
    movieFrameRate = 20; % (1 x 1 positive integer) Sets movie frames per second.
    
    % ODE Solver Properties
    odeMethod = 'odeSolver'; % ('odeSolver' or 'euler') Selects how the ODE is solved.
    odeSolver = @ode113; % (ODE function handle) ODE solver function handle.
    odeOptions % (ODE options structure) Stores the options of the ODE solver. See "odeset" and "odeget".
    zeroSize = 1e6*eps; % (1 x 1 positive real number) Used to set small numbers to zero. Absolute value of a number than this will be set to zero.
    
    % Control Properties
    openLoopControl = false; % (1 x 1 logical) Determines if open-loop control is used or closed loop control.
    openLoopTimeTape = []; % (1 x ? real number) Open-loop control time tape. Must be monotonically increasing.
    openLoopInputTape = []; % (1 x ? real number) Open-loop control input tape.
    timeTrajTape = []; % (1 x ? real number) Time trajectory tape. Must be monotonically increasing.
    stateTrajTape = []; % (nStates x ? real number) State trajectory tape.
    timeBar % (1 x 1 number) Current reference time value.
    stateBar % (nStates x 1 number) Current reference state value.
    inputBar % (nInputs x 1 number) Current reference input value.
    outputBar % (nOutputs x 1 number) Current reference output value.
    
    
    % Random stream    
    randSeed; % (1 x 1 semi-postive number) Random number produced with each initialization of class for setting the seed of the random numeber stream.
end

properties (Access = public, Hidden = true) % TODO: Add set methods for all of these properties
    % Graphics
    paramsToPlot = []; % (1 x ? 1 or 2 or [1 2]) List of parameters to include in the state plot.
    
    statesToPlot = []; % (1 x ? positive integer <= nStates) List of states to include in the state plot.   
    stateFigureHandle = []; % (1 x 1 graphics object) Figure handle to where state tape is plotted.
    stateFigureProperties = {}; % (1 x ? cell array) State plot figure properties to be applied to the plot method. (e.g. {'Color','w'})
    stateAxisHandle = []; % (1 x 1 graphics object) Axis handle to where state tape is plotted.
    stateAxisProperties = {}; % (1 x ? cell array) State plot axis properties to be applied to the plot method. (e.g. {'FontWeight','bold'})
    stateGraphicsHandle = []; % (? x 1 graphics object) Line graphics handle for each state.
    stateTapeGraphicsHandle = []; % (? x 1 graphics object) Line graphics handle for each state tape.
    stateGraphicsProperties = {}; % (1 x ? cell array) State plot graphics properties to be applied to the plot method. (e.g {'LineWidth',2})
    
    inputsToPlot = []; % (1 x ? positive integer <= nInputs) List of inputs to include in the input plot.
    inputFigureHandle = []; % (1 x 1 graphics object) Figure handle to where input tape is plotted.
    inputFigureProperties = {}; % (1 x ? cell array) Input plot figure properties to be applied to the plot method. (e.g. {'Color','w'})
    inputAxisHandle = []; % (1 x 1 graphics object) Axis handle to where input tape is plotted.
    inputAxisProperties = {}; % (1 x ? cell array) Input plot axis properties to be applied to the plot method. (e.g. {'FontWeight','bold'})
    inputTapeGraphicsHandle = []; % (? x 1 graphics object) Line graphics handle for each input tape.
    inputGraphicsProperties = {}; % (1 x ? cell array) Input plot graphics properties to be applied to the plot method. (e.g {'LineWidth',2})
    
    outputsToPlot = []; % (1 x ? positive integer <= nOutputs) List of outputs to include in the output plot.
    outputFigureHandle = []; % (1 x 1 graphics object) Figure handle to where output tape is plotted.
    outputFigureProperties = {}; % (1 x ? cell array) Output plot figure properties to be applied to the plot method. (e.g. {'Color','w'})
    outputAxisHandle = []; % (1 x 1 graphics object) Axis handle to where output tape is plotted.
    outputAxisProperties = {}; % (1 x ? cell array) Output plot axis properties to be applied to the plot method. (e.g. {'FontWeight','bold'})
    outputTapeGraphicsHandle = []; % (? x 1 graphics object) Line graphics handle for each output tape.
    outputGraphicsProperties = {}; % (1 x ? cell array) Output plot graphics properties to be applied to the plot method. (e.g {'LineWidth',2})
    
    costsToPlot = []; % (1 x ? positive integer <= nOutputs) List of costs to include in the cost plot.
    instantaneousCostFigureHandle = []; % (1 x 1 graphics object) Figure handle to where instantaneous cost tape is plotted.
    instantaneousCostFigureProperties = {}; % (1 x ? cell array) Instantaneous cost plot figure properties to be applied to the plot method. (e.g. {'Color','w'})
    instantaneousCostAxisHandle = []; % (1 x 1 graphics object) Axis handle to where instantaneous cost tape is plotted.
    instantaneousCostAxisProperties = {}; % (1 x ? cell array) Instantaneous cost plot axis properties to be applied to the plot method. (e.g. {'FontWeight','bold'})
    instantaneousCostTapeGraphicsHandle = []; % (? x 1 graphics object) Line graphics handle for each instantaneous cost tape.
    instantaneousCostGraphicsProperties = {}; % (1 x ? cell array) Instantaneous cost plot graphics properties to be applied to the plot method. (e.g {'LineWidth',2})
    
    cumulativeCostFigureHandle = []; % (1 x 1 graphics object) Figure handle to where cumulative cost tape is plotted.
    cumulativeCostFigureProperties = {}; % (1 x ? cell array) Cumulative cost plot figure properties to be applied to the plot method. (e.g. {'Color','w'})
    cumulativeCostAxisHandle = []; % (1 x 1 graphics object) Axis handle to where cumulative cost tape is plotted.
    cumulativeCostAxisProperties = {}; % (1 x ? cell array) Cumulative cost plot axis properties to be applied to the plot method. (e.g. {'FontWeight','bold'})
    cumulativeCostTapeGraphicsHandle = []; % (? x 1 graphics object) Line graphics handle for each cumulative cost tape.
    cumulativeCostGraphicsProperties = {}; % (1 x ? cell array) Cumulative cost plot graphics properties to be applied to the plot method. (e.g {'LineWidth',2})
    
    phasePairsToPlot = []; % (1 x ? positive integer <= nPhasePairs) List of phase to include in the phase plot.
    phaseFigureHandle = []; % (1 x 1 graphics object) Figure handle to where the system phase plot is drawn.
    phaseFigureProperties = {}; % (1 x ? cell array) Phase plot figure properties to be applied to the phase method. (e.g. {'Color','w'})
    phaseAxisHandle = []; % (1 x 1 graphics handle) Axis handle to where the system phase plot is drawn.
    phaseAxisProperties = {}; % (1 x ? cell array) Phase axis properties to be applied to the phase method. (e.g. {'FontWeight','bold'})
    phaseGraphicsHandle = []; % (? x 1 graphics handle) Object handles to graphics objects associated with the state in the phase plot.
    phaseTapeGraphicsHandle = [];  % (? x 1 graphics handle) Object handles to graphics objects associated with the state tape in the phase plot.
    phaseGraphicsProperties = {}; % (1 x ? cell array) Phase graphics properties to be applied to the phase method. (e.g {'LineWidth',2})
    
    sketchFigureHandle = []; % (1 x 1 graphics object) Figure handle to where system animation drawing is done.
    sketchFigureProperties = {}; % (1 x ? cell array) Sketch plot figure properties to be applied to the sketch method. (e.g. {'Color','w'})
    sketchAxisHandle = []; % (1 x 1 graphics handle) Axis handle to where the system animation drawing is done.
    sketchAxisProperties = {}; % (1 x ? cell array) Sketch plot axis properties to be applied to the sketch method. (e.g. {'FontWeight','bold'})
    sketchGraphicsHandles = []; % (? x 1 graphics handle) Object handles to graphics objects associated with the system animation drawing.
end

properties (SetAccess = protected)
    timeStep % (1 x 1 positive real number) Sampling time of the system.
    time % (1 x 1 real number) System time.
    state % (nStates x 1 real number) System state.
    cumulativeCost % (nCosts x 1 real number) System current cumlataed cost. 
    flowTime = 0; % (1 x 1 semi-positive real number) System current flow time.
    jumpCount = 0; % (1 x 1 semi-positive integer) System current jump count.
    timeTapeC % (1 x ? real number) Recording of past system continuous times.
    timeTapeD % (1 x ? real number) Recording of past system discrete times.
    stateTape % (nStates x ? real number) Recording of past system states. The length is the same as "timeTapeC".
    inputTape % (nInputs x ? real number) Recording of past system inputs. The length is the same as "timeTapeD".
    outputTape % (nOutputs x ? real number) Recording of past system outputs. The length is the same as "timeTapeD".
    instantaneousCostTape % (nCosts x ? real number) Recording of past system instantaneous costs. The length is the same as "timeTapeD".
    cumulativeCostTape % (nCosts x ? real number) Recording of past system cumulative costs. The length is the same as "timeTapeD".
    flowTimeTape % (1 x ? semi-positive real number) Recording of past flow time. The length is the same as "timeTapeD".
    jumpCountTape % (1 x ? semi-positive integer) Recording of past jump count. The length is the same as "timeTapeD".
    
    stopFlag = false; % (1 x 1 logical) Indicates if the stop button was hit in the run method.
end

properties (SetAccess = private)
    nInputs % (1 x 1 semi-positive integer) Number of inputs to the system.
    nOutputs % (1 x 1 semi-positive integer) Number of outputs to the system.
    
    inputMem % (nInputs x 1 number) Current input to the system stored in memory.
    outputMem % (nOutputs x 1 number) Current output from the system stored in memory.
    instantaneousCostMem % (nCosts X 1 number) Current instantaneous cost from the system stored in memory.
    
    % Random stream
    randStream; %(RandStream) Random number stream for the system. All rand functions in system methods should use this stream.
    randState; % (RandStream State) Current state of the random number stream.
    randStateTime; % (1 x 1 number) The time associated with the "randState" prorperty.
end

properties (Dependent = true)
    nStates % (1 x 1 positive integer) Number of states in the system.
    nCosts % (1 x 1 semi-positive integer) Number of costs in the system.
    nPhaseStatePairs % (1 x 1 semi-positive integer) Number of phase state pairs.
    
    input % (nInputs x 1 number) Current input to the system.
    output % (nOutputs x 1 number) Current output from the system.
    instantaneousCost % (nCosts X 1 number) Current instantaneous cost from the system.
end

%% Constructor -----------------------------------------------------------------
methods
    function systemObj = system(timeStep,initialTime,initialState,initialCost,nInputs,nOutputs,randSeed)
        % Constructor function for the "simulate.system" class.
        %
        % SYNTAX:
        %   systemObj = system(timeStep,initialTime,initialState,initialCost,nInputs,nOutputs,randSeed)
        %
        % INPUTS:
        %   timeStep - (1 x 1 positive real number) [0.1]
        %       Sets the "systemObj.timeStep" property.
        %
        %   initialTime - (1 x 1 real number) [0]
        %       Initializes the system time.
        %
        %   initialState - (nStates x 1 number) [0]
        %       Initializes the system state.
        %
        %   initialCost - (nCosts x 1  number) [0]
        %       Initializes the system cumulative cost.
        %
        %   nInputs - (1 x 1 semi-positive integer) [0]
        %       Sets the "systemObj.nInputs" property.
        %
        %   nOutputs - (1 x 1 semi-positive integer) [0]
        %       Sets the "systemObj.nOutputs" property.
        %
        %   randSeed - (1 x 1 semi-positive integer) [[]]
        %       Random number seed. If nan or empty then random seed is
        %       used.
        %
        % OUTPUTS:
        %   systemObj - (1 x 1 simulate.system) 
        %       A new instance of the "simulate.system" class.
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(0,7)
        
        % Apply default values
        if nargin < 1, timeStep = 0.1; end
        if nargin < 2, initialTime = 0; end
        if nargin < 3, initialState = 0; end
        if nargin < 4, initialCost = 0; end
        if nargin < 5, nInputs = 0; end
        if nargin < 6, nOutputs = 0; end
        if nargin < 7, randSeed = [];end
        
        % Check input arguments for errors
        assert(isnumeric(timeStep) && isreal(timeStep) && numel(timeStep) == 1 && timeStep > 0,...
            'simulate:system:timeStep',...
            'Input argument "timeStep" must be a 1 x 1 positive real number.')
        
        assert(isnumeric(initialTime) && isreal(initialTime) &&  numel(initialTime) == 1,...
            'simulate:system:initialTime',...
            'Input argument "initialTime" must be a 1 x 1 real number.')
        
        assert(isnumeric(initialState) && isreal(initialState) && isvector(initialState),...
            'simulate:system:initialState',...
            'Input argument "initialState" must be a vector of real numbers.')
        initialState = initialState(:);
        
        assert(isnumeric(initialCost) && isreal(initialCost) && isvector(initialCost),...
            'simulate:system:initialCost',...
            'Input argument "initialCost" must be a vector of real numbers.')
        initialCost = initialCost(:);
        
        assert(isnumeric(nInputs) && isreal(nInputs) && numel(nInputs) == 1 && mod(nInputs,1) == 0 && nInputs >= 0,...
            'simulate:system:nInputs',...
            'Input argument "nInputs" must be a 1 x 1 semi-positive integer.')
        
        assert(isnumeric(nOutputs) && isreal(nOutputs) && numel(nOutputs) == 1 && mod(nOutputs,1) == 0 && nOutputs >= 0,...
            'simulate:system:nOutputs',...
            'Input argument "nOutputs" must be a 1 x 1 semi-positive integer.')
        
        assert(isempty(randSeed) || isnan(randSeed) || ...
            (isnumeric(randSeed) && randSeed >= 0  && mod(randSeed,1) == 0),...
            'simulate:system:randSeed',...
            'Input argument "randSeed" must be a semi-positive integer, empty, or NaN')
        if isempty(randSeed) || isnan(randSeed)
            randSeed = 'shuffle';
        end
        
        % Assign properties
        nStates = length(initialState);
        nCosts = length(initialCost);
        systemObj.nInputs = nInputs;
        systemObj.nOutputs = nOutputs;
        systemObj.timeStep = timeStep;
        systemObj.time = initialTime;
        systemObj.state = initialState;
        systemObj.inputMem = nan;
        systemObj.outputMem = nan;
        systemObj.instantaneousCostMem = nan;
        systemObj.cumulativeCost = initialCost;
        systemObj.timeTapeC = nan(1,0);
        systemObj.timeTapeD = nan(1,0);
        systemObj.stateTape = nan(nStates,0);
        systemObj.inputTape = nan(nInputs,0);
        systemObj.outputTape = nan(nOutputs,0);
        systemObj.instantaneousCostTape = nan(nCosts,0);
        systemObj.cumulativeCostTape = nan(nCosts,0);
        systemObj.flowTimeTape = nan(1,0);
        systemObj.jumpCountTape = nan(1,0);
        
        systemObj.timeBar = 0;
        systemObj.stateBar = nan(nStates,1);
        systemObj.inputBar = nan(nInputs,1);
        systemObj.outputBar = nan(nOutputs,1);
        
        systemObj.setDefaultStateNames;
        systemObj.setDefaultInputNames;
        systemObj.setDefaultOutputNames;
        systemObj.setDefaultCostNames;
        
        systemObj.statesToPlot = 1:nStates;
        systemObj.inputsToPlot = 1:nInputs;
        systemObj.outputsToPlot = 1:nOutputs;
        systemObj.costsToPlot = 1:nCosts;
        
        systemObj.randStream = RandStream('mt19937ar','Seed',randSeed);
        systemObj.randSeed = systemObj.randStream.Seed;
        systemObj.randState = systemObj.randStream.State;
        systemObj.randStateTime = systemObj.time;
        
    end
end
%-------------------------------------------------------------------------------

%% Property methods ------------------------------------------------------------
methods
    function set.name(systemObj,name)
        % Overloaded assignment operator function for the "name" property.
        %
        % SYNTAX:
        %   systemObj.name = name
        %
        % INPUT:
        %   name - (string)
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(ischar(name),...
            'simulate:system:set:name',...
            'Property "name" must be a string.')

        systemObj.name = name;
    end
    
    function set.stateNames(systemObj,stateNames)
        % Overloaded assignment operator function for the "stateNames" property.
        %
        % SYNTAX:
        %   systemObj.stateNames = stateNames
        %
        % INPUT:
        %   stateNames - (cell array of strings)
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(iscellstr(stateNames),...,...
            'simulate:system:set:stateNames',...
            'Property "stateNames" must be a cell array of strings.')
        stateNames = stateNames(:);

        systemObj.stateNames = stateNames;
    end
    
    function set.inputNames(systemObj,inputNames)
        % Overloaded assignment operator function for the "inputNames" property.
        %
        % SYNTAX:
        %   systemObj.inputNames = inputNames
        %
        % INPUT:
        %   inputNames - (cell array of strings)
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(iscellstr(inputNames),...
            'simulate:system:set:inputNames',...
            'Property "inputNames" must be a cell array of strings.')
        inputNames = inputNames(:);

        systemObj.inputNames = inputNames;
    end
    
    function set.outputNames(systemObj,outputNames)
        % Overloaded assignment operator function for the "inputNames" property.
        %
        % SYNTAX:
        %   systemObj.outputNames = outputNames
        %
        % INPUT:
        %   outputNames - (cell array of strings)
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(iscellstr(outputNames),...
            'simulate:system:set:outputNames',...
            'Property "outputNames" must be a cell array of strings.')
        outputNames = outputNames(:);

        systemObj.outputNames = outputNames;
    end
    
    function set.costNames(systemObj,costNames)
        % Overloaded assignment operator function for the "inputNames" property.
        %
        % SYNTAX:
        %   systemObj.costNames = costNames
        %
        % INPUT:
        %   costNames - (cell array of strings)
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(iscellstr(costNames),...
            'simulate:system:set:costNames',...
            'Property "costNames" must be a cell array of strings.')
        costNames = costNames(:);
        
        systemObj.costNames = costNames;
    end
    
    function set.phaseStatePairs(systemObj,phaseStatePairs)
        % Overloaded assignment operator function for the "phaseStatePairs" property.
        %
        % SYNTAX:
        %   systemObj.phaseStatePairs = phaseStatePairs
        %
        % INPUT:
        %   phaseStatePairs - (? x 2 positive integer <= nStates)
        %
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(isnumeric(phaseStatePairs) && isreal(phaseStatePairs) && ...
            size(phaseStatePairs,2) == 2 && all(phaseStatePairs(:) > 0) && ...
            all(phaseStatePairs(:) <= systemObj.nStates),...
            'simulate:system:set:phaseStatePairs',...
            'Property "phaseStatePairs" must be ? x 2 matrix of integers between 1 and %d.',systemObj.nStates)

        systemObj.phaseStatePairs = phaseStatePairs;
    end

    function set.maxFlowTime(systemObj,maxFlowTime)
        % Overloaded assignment operator function for the "maxFlowTime" property.
        %
        % SYNTAX:
        %   systemObj.maxFlowTime = maxFlowTime
        %
        % INPUT:
        %   maxFlowTime - (1 x 1 positive number)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(isnumeric(maxFlowTime) && isreal(maxFlowTime) && numel(maxFlowTime) == 1 && maxFlowTime > 0,...
            'simulate:system:set:maxFlowTime',...
            'Property "maxFlowTime" must be a 1 x 1 positive number.')

        systemObj.maxFlowTime = maxFlowTime;
    end
    
    function set.maxJumpCount(systemObj,maxJumpCount)
        % Overloaded assignment operator function for the "maxJumpCount" property.
        %
        % SYNTAX:
        %   systemObj.maxJumpCount = maxJumpCount
        %
        % INPUT:
        %   maxJumpCount - (1 x 1 positive integer)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(isnumeric(maxJumpCount) && isreal(maxJumpCount) && numel(maxJumpCount) == 1 && maxJumpCount > 0 && (mod(maxJumpCount,1) == 0 || maxJumpCount == inf),...
            'simulate:system:set:maxJumpCount',...
            'Property "maxJumpCount" must be a 1 x 1 positive integer or "inf".')

        systemObj.maxJumpCount = maxJumpCount;
    end
    
    function set.randSeed(systemObj,randSeed)
        % Overloaded assignment operator function for the "randSeed" property.
        %
        % SYNTAX:
        %   systemObj.randSeed = randSeed
        %
        % INPUT:
        %   randSeed - (1 x 1 positive integer)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(isempty(randSeed) || isnan(randSeed) || ...
            (isnumeric(randSeed) && randSeed >= 0  && mod(randSeed,1) == 0),...
            'simulate:system:set:randSeed',...
            'Input argument "randSeed" must be a semi-positive integer, empty, or NaN')
        if isempty(randSeed) || isnan(randSeed)
            randSeed = 'shuffle';
        end
        systemObj.randStream = RandStream('mt19937ar','Seed',randSeed);
        systemObj.randSeed = systemObj.randStream.Seed;
        systemObj.randState = systemObj.randStream.State;        
    end
    
    function set.stateAxisHandle(systemObj,stateAxisHandle)
        % Overloaded assignment operator function for the "stateAxisHandle" property.
        %
        % SYNTAX:
        %   systemObj.stateAxisHandle = stateAxisHandle
        %
        % INPUT:
        %   stateAxisHandle - (1 x 1 graphics handle)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(all(ishghandle(stateAxisHandle)) && length(stateAxisHandle) == 1 && strcmp(get(stateAxisHandle,'Type'),'axes'),...
            'simulate:system:set:stateAxisHandle',...
            'Property "stateAxisHandle" must be a 1 x 1 axis handle.')

        systemObj.stateAxisHandle = stateAxisHandle;
        systemObj.stateFigureHandle = get(systemObj.stateAxisHandle,'Parent');
    end
    
    function set.inputAxisHandle(systemObj,inputAxisHandle)
        % Overloaded assignment operator function for the "inputAxisHandle" property.
        %
        % SYNTAX:
        %   systemObj.inputAxisHandle = inputAxisHandle
        %
        % INPUT:
        %   inputAxisHandle - (1 x 1 graphics handle)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(all(ishghandle(inputAxisHandle)) && length(inputAxisHandle) == 1 && strcmp(get(inputAxisHandle,'Type'),'axes'),...
            'simulate:system:set:inputAxisHandle',...
            'Property "inputAxisHandle" must be a 1 x 1 axis handle.')

        systemObj.inputAxisHandle = inputAxisHandle;
        systemObj.inputFigureHandle = get(systemObj.inputAxisHandle,'Parent');
    end
    
    function set.outputAxisHandle(systemObj,outputAxisHandle)
        % Overloaded assignment operator function for the "outputAxisHandle" property.
        %
        % SYNTAX:
        %   systemObj.outputAxisHandle = outputAxisHandle
        %
        % INPUT:
        %   outputAxisHandle - (1 x 1 graphics handle)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(all(ishghandle(outputAxisHandle)) && length(outputAxisHandle) == 1 && strcmp(get(outputAxisHandle,'Type'),'axes'),...
            'simulate:system:set:outputAxisHandle',...
            'Property "outputAxisHandle" must be a 1 x 1 axis handle.')

        systemObj.outputAxisHandle = outputAxisHandle;
        systemObj.outputFigureHandle = get(systemObj.outputAxisHandle,'Parent');
    end
    
    function set.instantaneousCostAxisHandle(systemObj,instantaneousCostAxisHandle)
        % Overloaded assignment operator function for the "instantaneousCostAxisHandle" property.
        %
        % SYNTAX:
        %   systemObj.instantaneousCostAxisHandle = instantaneousCostAxisHandle
        %
        % INPUT:
        %   instantaneousCostAxisHandle - (1 x 1 graphics handle)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(all(ishghandle(instantaneousCostAxisHandle)) && length(instantaneousCostAxisHandle) == 1 && strcmp(get(instantaneousCostAxisHandle,'Type'),'axes'),...
            'simulate:system:set:instantaneousCostAxisHandle',...
            'Property "instantaneousCostAxisHandle" must be a 1 x 1 axis handle.')

        systemObj.instantaneousCostAxisHandle = instantaneousCostAxisHandle;
        systemObj.instantaneousCostFigureHandle = get(systemObj.instantaneousCostAxisHandle,'Parent');
    end
    
    function set.cumulativeCostAxisHandle(systemObj,cumulativeCostAxisHandle)
        % Overloaded assignment operator function for the "cumulativeCostAxisHandle" property.
        %
        % SYNTAX:
        %   systemObj.cumulativeCostAxisHandle = cumulativeCostAxisHandle
        %
        % INPUT:
        %   cumulativeCostAxisHandle - (1 x 1 graphics handle)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(all(ishghandle(cumulativeCostAxisHandle)) && length(cumulativeCostAxisHandle) == 1 && strcmp(get(cumulativeCostAxisHandle,'Type'),'axes'),...
            'simulate:system:set:cumulativeCostAxisHandle',...
            'Property "cumulativeCostAxisHandle" must be a 1 x 1 axis handle.')
        
        systemObj.cumulativeCostAxisHandle = cumulativeCostAxisHandle;
        systemObj.cumulativeCostFigureHandle = get(systemObj.cumulativeCostAxisHandle,'Parent');
    end
    
    function set.phaseAxisHandle(systemObj,phaseAxisHandle)
        % Overloaded assignment operator function for the "phaseAxisHandle" property.
        %
        % SYNTAX:
        %   systemObj.phaseAxisHandle = phaseAxisHandle
        %
        % INPUT:
        %   phaseAxisHandle - (1 x 1 graphics handle)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(all(ishghandle(phaseAxisHandle)) && length(phaseAxisHandle) == 1 && strcmp(get(phaseAxisHandle,'Type'),'axes'),...
            'simulate:system:set:phaseAxisHandle',...
            'Property "phaseAxisHandle" must be a 1 x 1 axis handle.')

        systemObj.phaseAxisHandle = phaseAxisHandle;
        systemObj.phaseFigureHandle = get(systemObj.phaseAxisHandle,'Parent');
    end
    
    function set.sketchAxisHandle(systemObj,sketchAxisHandle)
        % Overloaded assignment operator function for the "sketchAxisHandle" property.
        %
        % SYNTAX:
        %   systemObj.sketchAxisHandle = sketchAxisHandle
        %
        % INPUT:
        %   sketchAxisHandle - (1 x 1 graphics handle)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(all(ishghandle(sketchAxisHandle)) && length(sketchAxisHandle) == 1 && strcmp(get(sketchAxisHandle,'Type'),'axes'),...
            'simulate:system:set:sketchAxisHandle',...
            'Property "sketchAxisHandle" must be a 1 x 1 axis handle.')

        systemObj.sketchAxisHandle = sketchAxisHandle;
        systemObj.sketchFigureHandle = get(systemObj.sketchAxisHandle,'Parent');
    end
    
    function set.odeMethod(systemObj,odeMethod)
        % Overloaded assignment operator function for the "odeMethod" property.
        %
        % SYNTAX:
        %   systemObj.odeMethod = odeMethod
        %
        % INPUT:
        %   odeMethod - (string)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(ischar(odeMethod),...
            'simulate:system:set:odeMethod',...
            'Property "odeMethod" must be a string.')

        systemObj.odeMethod = odeMethod;
    end
    
    function set.time(systemObj,time)
        % Overloaded assignment operator function for the "time" property.
        %
        % SYNTAX:
        %   systemObj.time = time
        %
        % INPUT:
        %   time - (1 x 1 number)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        systemObj.inputMem = nan;
        systemObj.outputMem = nan;
        systemObj.instantaneousCostMem = nan;
        systemObj.time = time;
    end
    
    function set.state(systemObj,state)
        % Overloaded assignment operator function for the "state" property.
        %
        % SYNTAX:
        %   systemObj.state = state
        %
        % INPUT:
        %   state - (nStates x 1 number)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        systemObj.inputMem = nan;
        systemObj.outputMem = nan;
        systemObj.instantaneousCostMem = nan;
        systemObj.state = state;
    end
    
    function set.flowTime(systemObj,flowTime)
        % Overloaded assignment operator function for the "flowTime" property.
        %
        % SYNTAX:
        %   systemObj.flowTime = flowTime
        %
        % INPUT:
        %   flowTime - (1 x 1 number)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        systemObj.inputMem = nan;
        systemObj.outputMem = nan;
        systemObj.instantaneousCostMem = nan;
        systemObj.flowTime = flowTime;
    end
    
    function set.jumpCount(systemObj,jumpCount)
        % Overloaded assignment operator function for the "jumpCount" property.
        %
        % SYNTAX:
        %   systemObj.jumpCount = jumpCount
        %
        % INPUT:
        %   jumpCount - (1 x 1 number)
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        systemObj.inputMem = nan;
        systemObj.outputMem = nan;
        systemObj.instantaneousCostMem = nan;
        systemObj.jumpCount = jumpCount;
    end
    
    function nStates = get.nStates(systemObj)
        %   Overloaded query operator function for the "nStates" property.
        %
        % SYNTAX:
        %	  nStates = systemObj.nStates
        %
        % OUTPUT:
        %   nStates - (1 x 1 positive integer)
        %
        %---------------------------------------------------------------------

        nStates = length(systemObj.state);
    end
    
    function nCosts = get.nCosts(systemObj)
        %   Overloaded query operator function for the "nCosts" property.
        %
        % SYNTAX:
        %	  nCosts = systemObj.nCosts
        %
        % OUTPUT:
        %   nCosts - (1 x 1 positive integer)
        %
        %---------------------------------------------------------------------
        
        nCosts = length(systemObj.cumulativeCost);
    end
    
    function nPhaseStatePairs = get.nPhaseStatePairs(systemObj)
        %   Overloaded query operator function for the "nPhaseStatePairs" property.
        %
        % SYNTAX:
        %	  nPhaseStatePairs = systemObj.nPhaseStatePairs
        %
        % OUTPUT:
        %   nPhaseStatePairs - (? x 2 positive integer)
        %
        %---------------------------------------------------------------------

        nPhaseStatePairs = size(systemObj.phaseStatePairs,1);
    end
    
    function input = get.input(systemObj)
        %   Overloaded query operator function for the "input" property.
        %
        % SYNTAX:
        %	  input = systemObj.input
        %
        % OUTPUT:
        %   input - (nInputs x 1 real number)
        %
        %---------------------------------------------------------------------

        if isnan(systemObj.inputMem)
            systemObj.inputMem = systemObj.inputConstraints(systemObj.policy(...
            systemObj.time,systemObj.state,zeros(systemObj.nInputs,1),systemObj.output,systemObj.flowTime,systemObj.jumpCount));
        end
        input = systemObj.inputMem;
    end
    
    function output = get.output(systemObj)
        %   Overloaded query operator function for the "output" property.
        %
        % SYNTAX:
        %	  output = systemObj.output
        %
        % OUTPUT:
        %   output - (nOutputs x 1 real number)
        %
        %---------------------------------------------------------------------
        
        if isnan(systemObj.outputMem)
            systemObj.outputMem = systemObj.sensor(systemObj.time,systemObj.state,zeros(systemObj.nInputs,1),systemObj.flowTime,systemObj.jumpCount);
        end
        output = systemObj.outputMem;
    end
    
    function instantaneousCost = get.instantaneousCost(systemObj)
        %   Overloaded query operator function for the "instantaneousCost" property.
        %
        % SYNTAX:
        %	  instantaneousCost = systemObj.instantaneousCost
        %
        % OUTPUT:
        %   instantaneousCost - (nCosts x 1 real number)
        %
        %---------------------------------------------------------------------
        
        if isnan(systemObj.instantaneousCostMem)
            systemObj.instantaneousCostMem = ...
                systemObj.cost(systemObj.time,systemObj.state,systemObj.input,systemObj.output,systemObj.flowTime,systemObj.jumpCount,...
                    systemObj.timeBar,systemObj.stateBar,systemObj.inputBar,systemObj.outputBar);
        end
        instantaneousCost = systemObj.instantaneousCostMem;
    end 
end
%-------------------------------------------------------------------------------

%% General Methods -------------------------------------------------------------
methods (Access = public)
    function setTime(systemObj,time)
        % The "setTime" method is used to set the time property of the
        % system.
        %
        % SYNTAX:
        %   systemObj = systemObj.setTime(time)
        %
        % INPUTS:
        %   systemObj - (1 x 1 simulate.system)
        %       An instance of the "simulate.system" class.
        %
        %   time - (1 x 1 real number) 
        %       The system is set to this time.
        %
        % NOTES:
        %   This is used instead of the property method because it also
        %   adds to the tape properties. Accessing other properties should
        %   not be done in the property methods.
        %
        %-----------------------------------------------------------------------

        % Check number of arguments
        narginchk(2,2)
        
        % Check arguments for errors
        assert(isnumeric(time) && isreal(time) && isequal(size(time),[1,1]),...
            'simulate:system:setTime:time',...
            'Input argument "time" must be a 1 x 1 real number.')
        
        systemObj.timeTapeC = [systemObj.timeTapeC systemObj.time];
        systemObj.timeTapeD = [systemObj.timeTapeD systemObj.time];
        systemObj.stateTape = [systemObj.stateTape systemObj.state];
        systemObj.inputTape = [systemObj.inputTape systemObj.input];
        systemObj.outputTape = [systemObj.outputTape systemObj.output];
        systemObj.instantaneousCostTape = [systemObj.instantaneousCostTape systemObj.instantaneousCost];
        systemObj.cumulativeCostTape = [systemObj.cumulativeCostTape systemObj.cumulativeCostTape];
        systemObj.flowTimeTape = [systemObj.flowTimeTape systemObj.flowTime];
        systemObj.jumpCountTape = [systemObj.jumpCountTape systemObj.jumpCount];
        
        systemObj.time = time;
        
    end
    
    function setState(systemObj,state)
        % The "setState" method is used to set the state property of the
        % system.
        %
        % SYNTAX:
        %   systemObj = systemObj.setState(state)
        %
        % INPUTS:
        %   systemObj - (1 x 1 simulate.system)
        %       An instance of the "simulate.system" class.
        %
        %   state - (nStates x 1 number) 
        %       The system is set to this state.
        %
        % NOTES:
        %   This is used instead of the property method because it also
        %   adds to the tape properties. Accessing other properties should
        %   not be done in the property methods.
        %
        %-----------------------------------------------------------------------

        % Check number of arguments
        narginchk(2,2)
        
        % Check arguments for errors
        assert(isnumeric(state) && isequal(size(state),[systemObj.nStates,1]),...
            'simulate:system:setState:state',...
            'Input argument "state" must be a %d x 1 real number.',systemObj.nStates)
        
        systemObj.timeTapeC = [systemObj.timeTapeC systemObj.time];
        systemObj.timeTapeD = [systemObj.timeTapeD systemObj.time];
        systemObj.stateTape = [systemObj.stateTape systemObj.state];
        systemObj.inputTape = [systemObj.inputTape systemObj.input];
        systemObj.outputTape = [systemObj.outputTape systemObj.output];
        systemObj.instantaneousCostTape = [systemObj.instantaneousCostTape systemObj.instantaneousCost];
        systemObj.cumulativeCostTape = [systemObj.cumulativeCostTape systemObj.cumulativeCostTape];
        systemObj.flowTimeTape = [systemObj.flowTimeTape systemObj.flowTime];
        systemObj.jumpCountTape = [systemObj.jumpCountTape systemObj.jumpCount];
        
        systemObj.state = state;
        
    end
    
    function setCost(systemObj,cost)
        % The "setCost" method is used to set the cost property of the
        % system.
        %
        % SYNTAX:
        %   systemObj = systemObj.setCost(cost)
        %
        % INPUTS:
        %   systemObj - (1 x 1 simulate.system)
        %       An instance of the "simulate.system" class.
        %
        %   cost - (nCosts x 1 number) 
        %       The system is set to this cumulative cost.
        %
        % NOTES:
        %   This is used instead of the property method because it also
        %   adds to the tape properties. Accessing other properties should
        %   not be done in the property methods.
        %
        %-----------------------------------------------------------------------

        % Check number of arguments
        narginchk(2,2)
        
        % Check arguments for errors
        assert(isnumeric(cost) && isequal(size(cost),[systemObj.nCosts,1]),...
            'simulate:system:setCost:cost',...
            'Input argument "cost" must be a %d x 1 real number.',systemObj.nCosts)
        
        systemObj.timeTapeC = [systemObj.timeTapeC systemObj.time];
        systemObj.timeTapeD = [systemObj.timeTapeD systemObj.time];
        systemObj.stateTape = [systemObj.stateTape systemObj.state];
        systemObj.inputTape = [systemObj.inputTape systemObj.input];
        systemObj.outputTape = [systemObj.outputTape systemObj.output];
        systemObj.instantaneousCostTape = [systemObj.instantaneousCostTape systemObj.instantaneousCost];
        systemObj.cumulativeCostTape = [systemObj.cumulativeCostTape systemObj.cumulativeCostTape];
        systemObj.flowTimeTape = [systemObj.flowTimeTape systemObj.flowTime];
        systemObj.jumpCountTape = [systemObj.jumpCountTape systemObj.jumpCount];
        
        systemObj.cumulativeCost = cost;
        
    end
    
    function setDefaultStateNames(systemObj)
        % The "setDefaultStateNames" method is used to set the state names
        % to their default values.
        %
        % SYNTAX:
        %   systemObj = systemObj.setDefaultStateNames()
        %
        % INPUTS:
        %   systemObj - (1 x 1 simulate.system)
        %       An instance of the "simulate.system" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(1,1)
        
        for iName = 1:systemObj.nStates
            systemObj.stateNames{iName} = ['state' num2str(iName)];
        end
    end
    
    function setDefaultInputNames(systemObj)
        % The "setDefaultInputNames" method is used to set the input names
        % to their default values.
        %
        % SYNTAX:
        %   systemObj = systemObj.setDefaultInputNames()
        %
        % INPUTS:
        %   systemObj - (1 x 1 simulate.system)
        %       An instance of the "simulate.system" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(1,1)
        
        for iName = 1:systemObj.nInputs
            systemObj.inputNames{iName} = ['input' num2str(iName)];
        end
    end
    
    function setDefaultOutputNames(systemObj)
        % The "setDefaultOutputNames" method is used to set the output names
        % to their default values.
        %
        % SYNTAX:
        %   systemObj = systemObj.setDefaultOutputNames()
        %
        % INPUTS:
        %   systemObj - (1 x 1 simulate.system)
        %       An instance of the "simulate.system" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(1,1)
        
        for iName = 1:systemObj.nOutputs
            systemObj.outputNames{iName} = ['output' num2str(iName)];
        end
    end
    
    function setDefaultCostNames(systemObj)
        % The "setDefaultCostNames" method is used to set the cost names
        % to their default values.
        %
        % SYNTAX:
        %   systemObj = systemObj.setDefaultCostNames()
        %
        % INPUTS:
        %   systemObj - (1 x 1 simulate.system)
        %       An instance of the "simulate.system" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(1,1)
        
        for iName = 1:systemObj.nCosts
            systemObj.costNames{iName} = ['cost' num2str(iName)];
        end
    end
    
    function saveMovie(systemObj)
        % The "saveMovie" method is save a movie to a file.
        %
        % SYNTAX:
        %   systemObj = systemObj.saveMovie()
        %
        % INPUTS:
        %   systemObj - (1 x 1 simulate.system)
        %       An instance of the "simulate.system" class.
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        narginchk(1,1)
        
        if systemObj.movieFlag && ~isempty(systemObj.movieObj)
            for iFigCnt = 1:length(systemObj.movieObj)
                systemObj.movieObj{iFigCnt}.close;
            end
        end
        systemObj.movieObj = {};
    end
end

%-------------------------------------------------------------------------------

%% Abstract methods ------------------------------------------------------------
methods (Abstract = true)
    % The "flowMap" method sets the continuous time dynamics of the system.
    %
    % SYNTAX:
    %   [stateDot,setPriority] = systemObj.flowMap()
    %   ...
    %   [stateDot,setPriority] = systemObj.flowMap(time,state,input,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number) [systemObj.time]
    %       Current time.
    %
    %   state - (nStates x 1 number) [systemObj.state]
    %       Current state.
    %
    %   input - (nInputs x 1 number) [systemObj.input]
    %       Current input value.
    %
    %   flowTime - (1 x 1 semi-positive real number) [systemObj.flowTime]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [systemObj.jumpCount]
    %       Current jump count value.
    %
    % OUTPUTS:
    %   stateDot - (nStates x 1 real number)
    %       Updated state derivatives.
    %
    %   setPriority - ('flow','jump', or 'random') 
    %       Sets the priority to what takes place if the state is in both
    %       the flow set and the jump set.
    %
    %---------------------------------------------------------------------------
    [stateDot,setPriority] = flowMap(systemObj,time,state,input,flowTime,jumpCount)
    
    % The "jumpMap" method sets the discrete time dynamics of the system.
    %
    % SYNTAX:
    %   [statePlus,timePlus,setPriority] = systemObj.jumpMap()
    %   ...
    %   [statePlus,timePlus,setPriority] = systemObj.jumpMap(time,state,input,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number) [systemObj.time]
    %       Current time.
    %
    %   state - (nStates x 1 number) [systemObj.state]
    %       Current state.
    %
    %   input - (nInputs x 1 number) [systemObj.input]
    %       Current input value.
    %
    %   flowTime - (1 x 1 semi-positive real number) [systemObj.flowTime]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [systemObj.jumpCount]
    %       Current jump count value.
    %
    % OUTPUTS:
    %   statePlus - (nStates x 1 real number)
    %       Updated states.
    %
    %   timePlus - (1 x 1 real number)
    %       Updated time.
    %
    %   setPriority - ('flow','jump', or 'random') 
    %       Sets the priority to what takes place if the state is in both
    %       the flow set and the jump set.
    %
    %---------------------------------------------------------------------------
    [statePlus,timePlus,setPriority] = jumpMap(systemObj,time,state,input,flowTime,jumpCount)
    
    % The "flowSet" method sets the set where continuous time dynamics take
    % place.
    %
    % SYNTAX:
    %   flowSetValue = systemObj.flowSet()
    %   ...
    %   flowSetValue = systemObj.flowSet(time,state,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number) [systemObj.time]
    %       Current time.
    %
    %   state - (nStates x 1 number) [systemObj.state]
    %       Current state.
    %
    %   flowTime - (1 x 1 semi-positive real number) [systemObj.flowTime]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [systemObj.jumpCount]
    %       Current jump count value.
    %
    % OUTPUTS:
    %   flowSetValue - (1 x 1 number)
    %      A value that defining if the system is in the flow set.
    %      Positive values are in the set and negative values are outside
    %      the set.
    %
    %---------------------------------------------------------------------------
    flowSetValue = flowSet(systemObj,time,state,flowTime,jumpCount)
    
	% The "jumpSet" method sets the set where discrete time dynamics take
    % place.
    %
    % SYNTAX:
    %   jumpSetValue = systemObj.jumpSet()
    %   ...
    %   jumpSetValue = systemObj.jumpSet(time,state,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number) [systemObj.time]
    %       Current time.
    %
    %   state - (nStates x 1 number) [systemObj.state]
    %       Current state.
    %
    %   flowTime - (1 x 1 semi-positive real number) [systemObj.flowTime]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [systemObj.jumpCount]
    %       Current jump count value.
    %
    % OUTPUTS:
    %   jumpSetValue - (1 x 1 real number)
    %      A value that defining if the system is in the jump set.
    %      Positive values are in the set and negative values are outside
    %      the set.
    %
    %---------------------------------------------------------------------------
    jumpSetValue = jumpSet(systemObj,time,state,flowTime,jumpCount)
    
    % The "controller" method will produce input values given the current
    % time and state of the system.
    %
    % SYNTAX:
    %   input = systemObj.controller()
    %   ...
    %   input = systemObj.controller(time,state,input,output,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 PACKAGE_NAME_D_SYSTEM_NAME)
    %       An instance of the "PACKAGE_NAME_D_SYSTEM_NAME" class.
    %
    %   time - (1 x 1 real number) [systemObj.time]
    %       Current time.
    %
    %   state - (nStates x 1 number) [systemObj.state]
    %       Current state.
    %
    %   input - (nInputs x 1 number) [systemObj.input]
    %       Current input value.
    %
    %   output - (nOuputs x 1 number) [systemObj.output]
    %       Output values for the plant.
    %
    %   flowTime - (1 x 1 semi-positive real number) [systemObj.flowTime]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [systemObj.jumpCount]
    %       Current jump count value.
    %
    % OUTPUTS:
    %   input - (nInputs x 1 real number)
    %       Input values for the plant.
    %
    %---------------------------------------------------------------------------
    input = controller(systemObj,time,state,input,output,flowTime,jumpCount)
    
    % The "observer" method will produce estimates of the state values
    % given the current time, state, and input of the system.
    %
    % SYNTAX:
    %   stateHat = systemObj.observer()
    %   ...
    %   stateHat = systemObj.observer(time,state,input,output,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number) [systemObj.time]
    %       Current time.
    %
    %   state - (nStates x 1 number) [systemObj.state]
    %       Current state.
    %
    %   input - (nInputs x 1 number) [systemObj.input]
    %       Current input value.
    %
    %   output - (nOutputs x 1 number) [systemObj.output]
    %       Output values for the plant.
    %
    %   flowTime - (1 x 1 semi-positive real number) [systemObj.flowTime]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [systemObj.jumpCount]
    %       Current jump count value.
    %
    % OUTPUTS:
    %   stateHat - (nStates x 1 number)
    %       Estimates of the states of the system.
    %
    %---------------------------------------------------------------------------
    output = observer(systemObj,time,state,input,output,flowTime,jumpCount)
    
    % The "sensor" method will produce output values given the current
    % time and state of the system.
    %
    % SYNTAX:
    %   output = systemObj.sensor()
    %   ...   
    %   output = systemObj.sensor(time,state,input,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number) [systemObj.time]
    %       Current time.
    %
    %   state - (nStates x 1 number) [systemObj.state]
    %       Current state.
    %
    %   input - (nInputs x 1 number) [systemObj.input]
    %       Current input value.
    %
    %   flowTime - (1 x 1 semi-positive real number) [systemObj.flowTime]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [systemObj.jumpCount]
    %       Current jump count value.
    %
    % OUTPUTS:
    %   output - (nOutputs x 1 real number)
    %       Output values for the plant.
    %
    %---------------------------------------------------------------------------
    output = sensor(systemObj,time,state,input,flowTime,jumpCount)
    
    % The "cost" method will produce cost values given the current
    % time and state of the system.
    %
    % SYNTAX:
    %   cost = systemObj.cost(time)
    %   ...
    %   cost = systemObj.cost(time,state,input,output,flowtime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number) [systemObj.time]
    %       Current time.
    %
    %   state - (NSTATES x 1 number) [systemObj.state]
    %       Current state.
    %
    %   input - (NINPUTS x 1 number) [systemObj.input]
    %       Current input value.
    %
    %   output - (NOUTPUTS x 1 number) [systemObj.output]
    %       Output values for the plant.
    %
    %   flowTime - (1 x 1 semi-positive real number) [systemObj.flowTime]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [systemObj.jumpCount]
    %       Current jump count value.
    %
    %   timeBar - (1 x 1 real number) [systemObj.time]
    %       Reference time value.
    %
    %   stateBar - (NSTATES x 1 number) [systemObj.state]
    %       Reference state value
    %
    %   inputBar - (NINPUTS x 1 number) [systemObj.input]
    %       Reference input value.
    %
    %   outputBar - (NOUTPUTS x 1 number) [systemObj.output]
    %       Reference output value.
    %
    % OUTPUTS:
    %   cost - (nCosts x 1 real number)
    %       Cost values for the system.
    %
    %---------------------------------------------------------------------------
    cost = cost(systemObj,time,state,input,output,flowtime,jumpCount,...
        timeBar,stateBar,inputBar,outputBar)
    
    % The "evaluate" method is execute at each time step.
    %
    % SYNTAX:
    %   systemObj.evaluate(time)
    %   ...
    %   evaluate(systemObj,time,state,input,output,...
    %       instantaneousCost,cumulativeCost,flowtime,jumpCount,...
    %       timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape)
    %   
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number) [systemObj.time]
    %       Current time.
    %
    %   state - (nStates x 1 number) [systemObj.state]
    %       Current state.
    %
    %   input - (nInputs x 1 number) [systemObj.input]
    %       Current input value from previous time to current time. Not the
    %       input that will be applied from the current time to the next time.
    %
    %   output - (nOutputs x 1 number) [systemObj.output]
    %       Output values for the plant.
    %
    %   flowTime - (1 x 1 semi-positive real number) [systemObj.flowTime]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [systemObj.jumpCount]
    %       Current jump count value.
    %
    %   timeTapeC - (1 x ? number) [systemObj.timeTapeC]
    %       Current record of continuous times.
    %
    %   stateTape - (nStates x ? number) [systemObj.timeTapeC]
    %       Current record of continuous states.
    %
    %   timeTapeD - (1 x ? number) [systemObj.timeTapeD]
    %       Current record of discrete times.
    %
    %   inputTape - (nInputs x ? number) [systemObj.inputTape]
    %       Current record of discrete inputs.
    %
    %   outputTape - (nOutputs x ? number) [systemObj.outputTape]
    %       Current record of discrete outputs.
    %
    %   instantaneousCostTape - (nCosts x ? number) [systemObj.instantaneousCostTape]
    %       Current record of discrete instantaneous costs.
    %
    %   cumulativeCostTape - (nCosts x ? number) [systemObj.cumulativeCostTape]
    %       Current record of discrete comulative costs.
    %
    %   TODO
    %
    % OUTPUTS:
    %
    %---------------------------------------------------------------------------
    evaluate(systemObj,time,state,input,output,...
        instantaneousCost,cumulativeCost,flowtime,jumpCount,...
        timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape)
    
    
    % The "linearize" method outputs the system's linearize matrices
    % evaluated at the the given operating point.
	%
    % SYNTAX:
    %   [A,B,C,D] = systemObj.linearize(stateOP,inputOP)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   stateOP - (nStates x 1 number)
    %       State operating point. Must be a "systemObj.nStates" x 1
    %       vector.
    %
    %   inputOP - (nInputs x 1 number)
    %       Input operating point. Must be a "systemObj.nInputs" x 1
    %       vector. 
    %
    % OUTPUTS:
    %   A - (nStates x nStates real number)
    %       Linearized A matrix (i.e. df/dx).
    %
    %   B - (nStates x nInputs real number)
    %       Linearized B matrix (i.e. df/du).
    %
    %   C - (nOutputs x nStates real number)
    %       Linearized C matrix (i.e. dh/dx).
    %
    %   D - (nOutputs x nInputs real number)
    %       Linearized D matrix (i.e. dh/du).
    %
    %---------------------------------------------------------------------------
    [A,B,C,D] = linearize(systemObj,stateOP,inputOP)
    
    % The "inputConstraints" method constrains the input values for the
    % system.
    %
    % SYNTAX:
    %   inputOut = systemObj.inputConstraints(inputIn)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   inputIn - (nInputs x 1 real number)
    %       Current input value. Must be a "systemObj.nInputs" x 1 vector.
    %
    % OUTPUTS:
    %   inputOut - (nInputs x 1 number)
    %       Constrained input values. A "systemObj.nInputs" x 1 vector.
    %
    %---------------------------------------------------------------------------
    inputOut = inputConstraints(systemObj,inputIn)
    
    % The "sketch" is called by the "plotSketch" method and will draw
    % the system at a given time and state in the sketch axis or create a
    % new axis if it doesn't have one.
    %
    % SYNTAX:
    %   systemObj.sketch()
    %   systemObj.sketch(state)
    %   systemObj.sketch(state,stateTape,time,timeTape)
    %   systemObj.sketch(. . .,'PropertyName',PropertyValue,. . .)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   state - (nStates x 1 real number) [systemObj.state]
    %       The state that the system will be drawn in.
    %
    %   stateTape - (nStates x ? number) []
    %       The state tape used for plotting.
    %
    %   time - (1 x 1 real number) [systemObj.time]
    %       The time that the system will be drawn at.
    %
    %   timeTape - (1 x ? real number) []
    %       The time tape used for plotting the state path.
    %
    % PROPERTIES:
    %
    % NOTES:
    %
    %---------------------------------------------------------------------------
    sketch(systemObj,state,stateTape,time,timeTape,varargin)
    
end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = protected)
    input = policy(systemObj,time,state,input,output,flowTime,jumpCount)
    cumulativeCost = sumCost(systemObj,cumulativeCost,instantaneousCost)
    plotState(systemObj,time,state,timeTapeC,stateTape,varargin)
    plotInput(systemObj,time,timeTapeD,inputTape,varargin)
    plotOutput(systemObj,time,timeTapeD,outputTape,varargin)
    plotInstantaneousCost(systemObj,time,timeTapeD,instantaneousCostTape,varargin)
    plotCumulativeCost(systemObj,time,timeTapeD,cumulativeCostTape,varargin)
    plotPhase(systemObj,time,state,timeTapeC,stateTape,varargin)
    plotSketch(systemObj,state,stateTape,time,timeTape,varargin)
end

methods (Access = public)
    [timeTapeC,stateTape,timeTapeD,inputTape,outputTape,instantaneousCostTape,cumulativeCostTape,flowTimeTape,jumpCountTape,stopFlag] = ...
        simulate(systemObj,timeInterval,initialState,initialCost,initialFlowTime,initialJumpCount,varargin)
    run(systemObj,duration,varargin)
    plot(systemObj,varargin)
    replay(systemObj,varargin)
end

methods (Static = true)
    createNew(systemName,systemLocation,varargin);
end
%-------------------------------------------------------------------------------

%% Method for tracking version of class ----------------------------------------
methods (Static = true)
    function version = currentVersion
        % The "currentVersion" method returns the current version
        % number of the simulate.system class.
        %
        % OUTPUTS:
        %   version - (string)s
        %       Current version of the simulate.system class.
        %
        % SYNTAX:
        %   versionNumber = currentVersionNumber
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        version = '1.7';
    end
end
%------------------------------------------------------------------------------- 
end

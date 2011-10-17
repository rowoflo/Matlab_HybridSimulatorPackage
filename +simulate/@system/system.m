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
%   Rowland O'Flaherty
%
% VERSION: 
%   Created 17-APR-2011
%-------------------------------------------------------------------------------

%% Properties ------------------------------------------------------------------
properties (Access = public)
    name; % (string) Name of the system.
    stateNames % (? x 1 cell array of strings) Names of the state variables. One per state.
    inputNames % (? x 1 cell array of strings) Names of the input variables. One per input.
    outputNames % (? x 1 cell array of strings) Names of the output variables. One per output.
    phaseStatePairs; % (? x 2 positive integer <= nStates) State pairs for the phase plot. One pair per row of the matrix. The first column is the x-axis and the second column is the y-axis.
end

properties (Abstract = true, SetAccess = private)
    type % (string) Type of system.
end

properties (Access = public) % TODO: Add set methods for all of these properties
    % Graphics
    graphicsFlag = false; % (1 x 1 logical) Flag determining if graphics are drawn during simulation.
    legendFlag = true; % (1 x 1 logical) Flag determining if legends are displayed in plots.
    
    plotStateFlag = true; % (1 x 1 logical) Flag determining if the state plot is drawn during the simulation.
    stateFigureHandle = []; % (1 x 1 graphics object) Figure handle to where state tape is plotted.
    stateFigureProperties = {}; % (1 x ? cell array) State plot figure properties to be applied to the plot method. (e.g. {'Color','w'})
    stateAxisHandle = []; % (1 x 1 graphics object) Axis handle to where state tape is plotted.
    stateAxisProperties = {}; % (1 x ? cell array) State plot axis properties to be applied to the plot method. (e.g. {'FontWeight','bold'})
    stateGraphicsHandle = []; % (? x 1 graphics object) Line graphics handle for each state.
    stateTapeGraphicsHandle = []; % (? x 1 graphics object) Line graphics handle for each state tape.
    stateGraphicsProperties = {}; % (1 x ? cell array) State plot graphics properties to be applied to the plot method. (e.g {'LineWidth',2})
    
    plotInputFlag = true; % (1 x 1 logical) Flag determining if the input plot is drawn during the simulation.
    inputFigureHandle = []; % (1 x 1 graphics object) Figure handle to where input tape is plotted.
    inputFigureProperties = {}; % (1 x ? cell array) Input plot figure properties to be applied to the plot method. (e.g. {'Color','w'})
    inputAxisHandle = []; % (1 x 1 graphics object) Axis handle to where input tape is plotted.
    inputAxisProperties = {}; % (1 x ? cell array) Input plot axis properties to be applied to the plot method. (e.g. {'FontWeight','bold'})
    inputTapeGraphicsHandle = []; % (? x 1 graphics object) Line graphics handle for each input tape.
    inputGraphicsProperties = {}; % (1 x ? cell array) Input plot graphics properties to be applied to the plot method. (e.g {'LineWidth',2})
    
    plotOutputFlag = true; % (1 x 1 logical) Flag determining if the output plot is drawn during the simulation.
    outputFigureHandle = []; % (1 x 1 graphics object) Figure handle to where output tape is plotted.
    outputFigureProperties = {}; % (1 x ? cell array) Output plot figure properties to be applied to the plot method. (e.g. {'Color','w'})
    outputAxisHandle = []; % (1 x 1 graphics object) Axis handle to where output tape is plotted.
    outputAxisProperties = {}; % (1 x ? cell array) Output plot axis properties to be applied to the plot method. (e.g. {'FontWeight','bold'})
    outputTapeGraphicsHandle = []; % (? x 1 graphics object) Line graphics handle for each output tape.
    outputGraphicsProperties = {}; % (1 x ? cell array) Output plot graphics properties to be applied to the plot method. (e.g {'LineWidth',2})
    
    plotPhaseFlag = false; % (1 x 1 logical) Flag determining if the phase plot is drawn during the simulation.
    phaseFigureHandle = []; % (1 x 1 graphics object) Figure handle to where the system phase plot is drawn.
    phaseFigureProperties = {}; % (1 x ? cell array) Phase plot figure properties to be applied to the phase method. (e.g. {'Color','w'})
    phaseAxisHandle = []; % (1 x 1 graphics handle) Axis handle to where the system phase plot is drawn.
    phaseAxisProperties = {}; % (1 x ? cell array) Phase axis properties to be applied to the phase method. (e.g. {'FontWeight','bold'})
    phaseGraphicsHandle = []; % (? x 1 graphics handle) Object handles to graphics objects associated with the state in the phase plot.
    phaseTapeGraphicsHandle = [];  % (? x 1 graphics handle) Object handles to graphics objects associated with the state tape in the phase plot.
    phaseGraphicsProperties = {}; % (1 x ? cell array) Phase graphics properties to be applied to the phase method. (e.g {'LineWidth',2})
    
    plotSketchFlag = false; % (1 x 1 logical) Flag determining if the sketch plot is drawn during the simulation.
    sketchFigureHandle = []; % (1 x 1 graphics object) Figure handle to where system animation drawing is done.
    sketchFigureProperties = {}; % (1 x ? cell array) Sketch plot figure properties to be applied to the sketch method. (e.g. {'Color','w'})
    sketchAxisHandle = []; % (1 x 1 graphics handle) Axis handle to where the system animation drawing is done.
    sketchAxisProperties = {}; % (1 x ? cell array) Sketch plot axis properties to be applied to the sketch method. (e.g. {'FontWeight','bold'})
    sketchGraphicsHandles = []; % (? x 1 graphics handle) Object handles to graphics objects associated with the system animation drawing.
    
    setPriority = 'jump'; % ('flow','jump', or 'random') Sets the priority to what takes place if the state is both in the flow set and the jump set.
    maxFlowTime = inf; % (1 x 1 positive number) Maximum flow time for the simulation.
    maxJumpCount = inf; % (1 x 1 positive integer) Maximum jump count for the simulation.
    
    % ODE Solver
    odeSolver = @ode113; % (ODE function handle) ODE solver function handle.
    odeOptions % (ODE options structure) Stores the options of the ODE solver. See "odeset" and "odeget".
    
    % Control Properties
    openLoopControl = false; % (1 x 1 logical) Determines if open-loop control is used or closed loop control.
    openLoopTimeTape = []; % (1 x ? real number) Open-loop control time tape.
    openLoopInputTape = []; % (1 x ? real number) Open-loop control input tape.
    stateOP; % (? x 1 real number) Operating point for the state used in feedback control.
    inputOP; % (? x 1 real number) Operating point for the input used in feedback control.
end

properties (SetAccess = protected)
    timeStep % (1 x 1 positive real number) Sampling time of the system.
    time % (1 x 1 real number) System time.
    state % (? x 1 real number) System state. A "nStates" x 1 vector.
    flowTime = 0; % (1 x 1 semi-positive real number) System current flow time.
    jumpCount = 0; % (1 x 1 semi-positive integer) System current jump count.
    timeTapeC % (1 x ? real number) Recording of past system continuous times.
    timeTapeD % (1 x ? real number) Recording of past system discrete times.
    stateTape % (? x ? real number) Recording of past system states. The length is the same as "timeTapeC".
    inputTape % (? x ? real number) Recording of past system inputs. The length is the same as "timeTapeD".
    outputTape % (? x ? real number) Recording of past system outputs. The length is the same as "timeTapeD".
    flowTimeTape % (1 x ? semi-positive real number) Recording of past flow time. The length is the same as "timeTapeD".
    jumpCountTape % (1 x ? semi-positive integer) Recording of past jump count. The length is the same as "timeTapeD".
end

properties (SetAccess = private)
    nInputs % (1 x 1 semi-positive integer) Number of inputs to the system.
    nOutputs % (1 x 1 semi-positive integer) Number of outputs to the system.
end

properties (Dependent = true)
    nStates % (1 x 1 positive integer) Number of states in the system.
end

%% Constructor -----------------------------------------------------------------
methods
    function systemObj = system(timeStep,initialTime,initialState,nInputs,nOutputs)
        % Constructor function for the "simulate.system" class.
        %
        % SYNTAX:
        %   systemObj = system(timeStep,initialTime,initialState,nInputs,nOutputs)
        %
        % INPUTS:
        %   timeStep - (1 x 1 positive real number) [0.1]
        %       Sets the "systemObj.timeStep" property.
        %
        %   initialTime - (1 x 1 real number) [0]
        %       Initializes the system time.
        %
        %   initialState - (? x 1 number) [0]
        %       Initializes the system state.
        %
        %   nInputs - (1 x 1 semi-positive integer) [0]
        %       Sets the "systemObj.nInputs" property.
        %
        %   nOutputs - (1 x 1 semi-positive integer) [0]
        %       Sets the "systemObj.nOutputs" property.
        %
        %
        % OUTPUTS:
        %   systemObj - (1 x 1 simulate.system) 
        %       A new instance of the "simulate.system" class.
        %
        %-----------------------------------------------------------------------
        
        % Check number of arguments
        error(nargchk(0,5,nargin))
        
        % Apply default values
        if nargin < 1, timeStep = 0.1; end
        if nargin < 2, initialTime = 0; end
        if nargin < 3, initialState = 0; end
        if nargin < 4, nInputs = 0; end
        if nargin < 5, nOutputs = 0; end
        
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
        
        assert(isnumeric(nInputs) && isreal(nInputs) && numel(nInputs) == 1 && mod(nInputs,1) == 0 && nInputs >= 0,...
            'simulate:system:nInputs',...
            'Input argument "nInputs" must be a 1 x 1 semi-positive integer.')
        
        assert(isnumeric(nOutputs) && isreal(nOutputs) && numel(nOutputs) == 1 && mod(nOutputs,1) == 0 && nOutputs >= 0,...
            'simulate:system:nOutputs',...
            'Input argument "nOutputs" must be a 1 x 1 semi-positive integer.')
        
        % Assign properties
        systemObj.nInputs = nInputs;
        systemObj.nOutputs = nOutputs;
        systemObj.timeStep = timeStep;
        systemObj.time = initialTime;
        systemObj.state = initialState;
        systemObj.timeTapeC = zeros(1,0);
        systemObj.timeTapeD = zeros(1,0);
        systemObj.stateTape = zeros(length(initialState),0);
        systemObj.inputTape = zeros(nInputs,0);
        systemObj.outputTape = zeros(nOutputs,0);
        systemObj.flowTimeTape = zeros(1,0);
        systemObj.jumpCountTape = zeros(1,0);
        
        systemObj.setDefaultStateNames;
        systemObj.setDefaultInputNames;
        systemObj.setDefaultOutputNames;
        
        systemObj.stateOP = zeros(systemObj.nStates,1);
        systemObj.inputOP = zeros(systemObj.nInputs,1);
        
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
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(iscellstr(stateNames),...
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
        % NOTES:
        %
        %---------------------------------------------------------------------
        assert(iscellstr(inputNames),...
            'simulate:system:set:inputNames',...
            'Property "inputNames" must be a cell array of strings.')
        inputNames = inputNames(:);

        systemObj.inputNames = inputNames;
    end
    
    function set.phaseStatePairs(systemObj,phaseStatePairs)
        % Overloaded assignment operator function for the "phaseStatePairs" property.
        %
        % SYNTAX:
        %   systemObj.phaseStatePairs = phaseStatePairs
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
    
    function set.setPriority(systemObj,setPriority)
        % Overloaded assignment operator function for the "setPriority" property.
        %
        % SYNTAX:
        %   systemObj.setPriority = setPriority
        %
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(ischar(setPriority) && ismember(setPriority,{'flow','jump','random'}),...
            'simulate:system:set:setPriority',...
            'Property "setPriority" must be either ''flow'', ''jump'', or ''random''.')

        systemObj.setPriority = setPriority;
    end

    function set.maxFlowTime(systemObj,maxFlowTime)
        % Overloaded assignment operator function for the "maxFlowTime" property.
        %
        % SYNTAX:
        %   systemObj.maxFlowTime = maxFlowTime
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
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(isnumeric(maxJumpCount) && isreal(maxJumpCount) && numel(maxJumpCount) == 1 && maxJumpCount > 0 && (mod(maxJumpCount,1) == 0 || maxJumpCount == inf),...
            'simulate:system:set:maxJumpCount',...
            'Property "maxJumpCount" must be a 1 x 1 positive integer or "inf".')

        systemObj.maxJumpCount = maxJumpCount;
    end
    
    function set.stateAxisHandle(systemObj,stateAxisHandle)
        % Overloaded assignment operator function for the "stateAxisHandle" property.
        %
        % SYNTAX:
        %   systemObj.stateAxisHandle = stateAxisHandle
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
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(all(ishghandle(outputAxisHandle)) && length(outputAxisHandle) == 1 && strcmp(get(outputAxisHandle,'Type'),'axes'),...
            'simulate:system:set:outputAxisHandle',...
            'Property "outputAxisHandle" must be a 1 x 1 axis handle.')

        systemObj.outputAxisHandle = outputAxisHandle;
        systemObj.outputFigureHandle = get(systemObj.outputAxisHandle,'Parent');
    end
    
    function set.phaseAxisHandle(systemObj,phaseAxisHandle)
        % Overloaded assignment operator function for the "phaseAxisHandle" property.
        %
        % SYNTAX:
        %   systemObj.phaseAxisHandle = phaseAxisHandle
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
        % NOTES:
        %
        %-----------------------------------------------------------------------
        assert(all(ishghandle(sketchAxisHandle)) && length(sketchAxisHandle) == 1 && strcmp(get(sketchAxisHandle,'Type'),'axes'),...
            'simulate:system:set:sketchAxisHandle',...
            'Property "sketchAxisHandle" must be a 1 x 1 axis handle.')

        systemObj.sketchAxisHandle = sketchAxisHandle;
        systemObj.sketchFigureHandle = get(systemObj.sketchAxisHandle,'Parent');
    end
    
    function nStates = get.nStates(systemObj)
        %   Overloaded query operator function for the "nStates" property.
        %
        % SYNTAX:
        %	  nStates = systemObj.nStates
        %
        %---------------------------------------------------------------------

        nStates = length(systemObj.state);
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
        error(nargchk(2,2,nargin))
        
        % Check arguments for errors
        assert(isnumeric(time) && isreal(time) && isequal(size(time),[1,1]),...
            'simulate:system:setTime:time',...
            'Input argument "time" must be a 1 x 1 real number.')
        
        systemObj.timeTapeC = [systemObj.timeTapeC systemObj.time];
        systemObj.timeTapeD = [systemObj.timeTapeD systemObj.time];
        systemObj.stateTape = [systemObj.stateTape systemObj.state];
        systemObj.inputTape = [systemObj.inputTape nan(systemObj.nInputs,1)];
        systemObj.outputTape = [systemObj.outputTape nan(systemObj.nOutputs,1)];
        systemObj.flowTimeTape = [systemObj.flowTimeTape systemObj.flowTimeTape];
        systemObj.jumpCountTape = [systemObj.jumpCountTape systemObj.jumpCountTape];
        
        systemObj.time = time;
        
    end
    
    function setState(systemObj,state)
        % The "setTime" method is used to set the state property of the
        % system.
        %
        % SYNTAX:
        %   systemObj = systemObj.setTime(state)
        %
        % INPUTS:
        %   systemObj - (1 x 1 simulate.system)
        %       An instance of the "simulate.system" class.
        %
        %   state - (? x 1 number) 
        %       The system is set to this state.  Must be a
        %       "systemObj.nStates" x 1 vector.
        %
        % NOTES:
        %   This is used instead of the property method because it also
        %   adds to the tape properties. Accessing other properties should
        %   not be done in the property methods.
        %
        %-----------------------------------------------------------------------

        % Check number of arguments
        error(nargchk(2,2,nargin))
        
        % Check arguments for errors
        assert(isnumeric(state) && isequal(size(state),[systemObj.nStates,1]),...
            'simulate:system:setstate:state',...
            'Input argument "state" must be a %d x 1 real number.',systemObj.nStates)
        
        systemObj.timeTapeC = [systemObj.timeTapeC systemObj.time];
        systemObj.timeTapeD = [systemObj.timeTapeD systemObj.time];
        systemObj.stateTape = [systemObj.stateTape systemObj.state];
        systemObj.inputTape = [systemObj.inputTape nan(systemObj.nInputs,1)];
        systemObj.outputTape = [systemObj.outputTape nan(systemObj.nOutputs,1)];
        systemObj.flowTimeTape = [systemObj.flowTimeTape systemObj.flowTimeTape];
        systemObj.jumpCountTape = [systemObj.jumpCountTape systemObj.jumpCountTape];
        
        systemObj.state = state;
        
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
        error(nargchk(1,1,nargin))
        
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
        error(nargchk(1,1,nargin))
        
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
        error(nargchk(1,1,nargin))
        
        for iName = 1:systemObj.nOutputs
            systemObj.outputNames{iName} = ['output' num2str(iName)];
        end
    end
end

%-------------------------------------------------------------------------------

%% Abstract methods ------------------------------------------------------------
methods (Abstract = true)
    % The "flowMap" method sets the continuous time dynamics of the system.
    %
    % SYNTAX:
    %   dStates = systemObj.flowMap(time,state,input)
    %   dStates = systemObj.flowMap(time,state,input,flowTime)
    %   dStates = systemObj.flowMap(time,state,input,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number)
    %       Current time.
    %
    %   state - (? x 1 real number)
    %       Current state. Must be a "systemObj.nStates" x 1 vector.
    %
    %   input - (? x 1 real number)
    %       Current input value. Must be a "systemObj.nInputs" x 1 vector.
    %
    %   flowTime - (1 x 1 semi-positive real number) [0]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [0] 
    %       Current jump count value.
    %
    % OUTPUTS:
    %   stateDot - (? x 1 number)
    %       Updated state derivatives. A "systemObj.nStates" x 1 vector.
    %
    %---------------------------------------------------------------------------
    stateDot = flowMap(systemObj,time,state,input,flowTime,jumpCount)
    
    % The "jumpMap" method sets the discrete time dynamics of the system.
    %
    % SYNTAX:
    %   statePlus = systemObj.jumpMap(time,state,input)
    %   statePlus = systemObj.jumpMap(time,state,input,flowTime)
    %   statePlus = systemObj.jumpMap(time,state,input,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number)
    %       Current time.
    %
    %   state - (? x 1 real number)
    %       Current state. Must be a "systemObj.nStates" x 1 vector.
    %
    %   input - (? x 1 real number)
    %       Current input value. Must be a "systemObj.nInputs" x 1 vector.
    %
    %   flowTime - (1 x 1 semi-positive real number) [0]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [0] 
    %       Current jump count value.
    %
    % OUTPUTS:
    %   statePlus - (? x 1 number)
    %       Updated states. A "systemObj.nStates" x 1 vector.
    %
    %---------------------------------------------------------------------------
    statePlus = jumpMap(systemObj,time,state,input,flowTime,jumpCount)
    
    % The "flowSet" method sets the set where continuous time dynamics take
    % place.
    %
    % SYNTAX:
    %   flowSetValue = systemObj.flowSet(time,state)
    %   flowSetValue = systemObj.flowSet(time,state,flowTime)
    %   flowSetValue = systemObj.flowSet(time,state,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number)
    %       Current time.
    %
    %   state - (? x 1 real number)
    %       Current state. Must be a "systemObj.nStates" x 1 vector.
    %
    %   flowTime - (1 x 1 semi-positive real number) [0]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [0] 
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
    %   jumpSetValue = systemObj.jumpSet(time,state)
    %   jumpSetValue = systemObj.jumpSet(time,state,flowTime)
    %   jumpSetValue = systemObj.jumpSet(time,state,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number)
    %       Current time.
    %
    %   state - (? x 1 real number)
    %       Current state. Must be a "systemObj.nStates" x 1 vector.
    %
    %   flowTime - (1 x 1 semi-positive real number) [0]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [0] 
    %       Current jump count value.
    %
    % OUTPUTS:
    %   jumpSetValue - (1 x 1 number)
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
    %   input = systemObj.controller(time,state)
    %   input = systemObj.controller(time,state,flowTime)
    %   input = systemObj.controller(time,state,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number)
    %       Current time.
    %
    %   state - (? x 1 real number)
    %       Current state. Must be a "systemObj.nStates" x 1 vector.
    %
    %   flowTime - (1 x 1 semi-positive real number) [0]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [0] 
    %       Current jump count value.
    %
    % OUTPUTS:
    %   input - (? x 1 number)
    %       Input values for the plant. A "systemObj.nInputs" x 1 vector.
    %
    %---------------------------------------------------------------------------
    input = controller(systemObj,time,state,flowTime,jumpCount)
    
    % The "observer" method will produce estimates of the state values
    % given the current time, state, and input of the system.
    %
    % SYNTAX:
    %   stateHat = systemObj.observer(time,state)
    %   stateHat = systemObj.observer(time,state,input,flowTime)
    %   stateHat = systemObj.observer(time,state,input,flowTime,jumpCount)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number)
    %       Current time.
    %
    %   state - (? x 1 real number)
    %       Current state. Must be a "systemObj.nStates" x 1 vector.
    %
    %   input - (? x 1 real number)
    %       Current input. Must be a "systemObj.nInputs" x 1 vector.
    %
    %   flowTime - (1 x 1 semi-positive real number) [0]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [0] 
    %       Current jump count value.
    %
    % OUTPUTS:
    %   stateHat - (? x 1 number)
    %       Estimates of the states of the system. A "systemObj.nStates" x 1 vector.
    %
    %---------------------------------------------------------------------------
    output = observer(systemObj,time,state,input,flowTime,jumpCount)
    
    % The "sensor" method will produce output values given the current
    % time and state of the system.
    %
    % SYNTAX:
    %   output = systemObj.sensor(time,state)
    %   output = systemObj.sensor(time,state,flowTime)
    %   output = systemObj.sensor(time,state,flowTime,jumpCount)
    %
    % INPUTS:
    %   SYSTEM_NAMEObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   time - (1 x 1 real number)
    %       Current time.
    %
    %   state - (? x 1 real number)
    %       Current state. Must be a "systemObj.nStates" x 1 vector.
    %
    %   flowTime - (1 x 1 semi-positive real number) [0]
    %       Current flow time value.
    %
    %   jumpCount - (1 x 1 semi-positive integer) [0] 
    %       Current jump count value.
    %
    % OUTPUTS:
    %   output - (? x 1 number)
    %       Output values for the plant. A "systemObj.nOutputs" x 1 vector.
    %
    %---------------------------------------------------------------------------
    output = sensor(systemObj,time,state,input,flowTime,jumpCount)
    
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
    %   stateOP - (? x 1 number)
    %       State operating point. Must be a "systemObj.nStates" x 1
    %       vector.
    %
    %   inputOP - (? x 1 number)
    %       Input operating point. Must be a "systemObj.nInputs" x 1
    %       vector. 
    %
    % OUTPUTS:
    %   A - (? x ? number)
    %       Linearized A matrix (i.e. df/dx). A "systemObj.nStates" x
    %       "systemObj.nStates" matrix.
    %
    %   B - (? x ? number)
    %       Linearized B matrix (i.e. df/du). A "systemObj.nStates" x 
    %       "systemObj.nInputs" matrix.
    %
    %   C - (? x ? number)
    %       Linearized C matrix (i.e. dh/dx). A "systemObj.nOutputs" x
    %       "systemObj.nStates" matrix.
    %
    %   D - (? x ? number)
    %       Linearized D matrix (i.e. dh/du). A "systemObj.nOutputs" x
    %       "systemObj.nInputs" matrix.
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
    %   SYSTEM_NAMEObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   inputIn - (? x 1 real number)
    %       Current input value. Must be a "systemObj.nInputs" x 1 vector.
    %
    % OUTPUTS:
    %   inputOut - (? x 1 number)
    %       Constrained input values. A "systemObj.nInputs" x 1 vector.
    %
    %---------------------------------------------------------------------------
    inputOut = inputConstraints(systemObj,inputIn)
    
    % The "sketchGraphics" is called by the "plotSketch" method and will draw
    % the system at a given time and state in the sketch axis or create a
    % new axis if it doesn't have one.
    %
    % SYNTAX:
    %   systemObj.sketchGraphics()
    %   systemObj.sketchGraphics(state)
    %   systemObj.sketchGraphics(state,time)
    %   systemObj.sketchGraphics(. . .,'PropertyName',PropertyValue,. . .)
    %
    % INPUTS:
    %   systemObj - (1 x 1 simulate.system)
    %       An instance of the "simulate.system" class.
    %
    %   state - (? x 1 real number) [systemObj.state] 
    %       The state that the system will be drawn in.
    %
    %   time - (1 x 1 real number) [systemObj.time] 
    %       The time that the system will be drawn at.
    %    
    % PROPERTIES:
    %
    % NOTES:
    %
    %---------------------------------------------------------------------------
    sketchGraphics(systemObj,state,time,varargin)
    
end
%-------------------------------------------------------------------------------

%% Methods in separte files ----------------------------------------------------
methods (Access = private)
    plotState(systemObj,time,state,timeTapeC,stateTape,varargin)
    plotInput(systemObj,time,timeTapeD,inputTape,varargin)
    plotOutput(systemObj,time,timeTapeD,outputTape,varargin)
    plotPhase(systemObj,time,state,timeTapeC,stateTape,varargin)
    plotSketch(systemObj,state,time,varargin)
end

methods (Access = protected)
    input = policy(systemObj,time,state,flowTime,jumpCount)
end

methods (Access = public)
    [timeTapeC,stateTape,timeTapeD,inputTape,outputTape,flowTimeTape,jumpCountTape,stopFlag] = ...
        simulate(systemObj,timeInterval,initialState,initialFlowTime,initialJumpCount,varargin)
    run(systemObj,duration,varargin)
    plot(systemObj,time,state,timeTapeC,stateTape,timeTapeD,inputTape,outputTape,varargin)
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
        version = '1.2';
    end
end
%------------------------------------------------------------------------------- 
end

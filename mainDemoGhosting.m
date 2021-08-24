clc;
clear;
close all;

%% Define constants
n_radar = 5;
id_ego = 1;

% export .csv file in folder output with detections
EXPORT_CSV = true;

%% Load scenario and init plot window

% Create the scenario
addpath('scenarios');

% handle for exported driving scenario
scenarioHandle = @demo_ghost_detections;
% scenarioHandle = @demo_ghost_detections_2;
% scenarioHandle = @demo_ghost_highway_ramp;
filename = 'demo_ghost_detections';

% create scenario-obj, ego-vehicle motion and sensor setup
[scenario, egoVehicle, sensors] = helperCreateScenario(scenarioHandle);

numRadar = sum(cellfun(@(s) isa(s, 'radarDataGenerator'), sensors, 'UniformOutput', true));
% sanity check
assert(id_ego==egoVehicle.ActorID, sprintf('Ego vehicle needs ID: %d.', id_ego));
assert(n_radar==numRadar, sprintf('Setup needs a number of sensors: %d.', n_radar));

% Create the display object
display = helperExtendedTargetTrackingDisplay;
% Set this to vehicle ID you want to follow
display.FollowActorID = 2;

% Create the Animation writer to record each frame of the figure for
% animation writing. Set 'RecordGIF' to true to enable GIF writing.
gifWriter = helperGIFWriter('Figure',display.Figure,...
    'RecordGIF',true);

% Create output folder if it does not exist
if ~exist('output', 'dir')
   mkdir('output')
end

%% Running scenario
% Reset the random number generator for repeatable results
seed = 2021;
S = rng(seed);

% Tranformation is necessary for correct plotting
for i = 1:numRadar
        sensors{i}.HasRangeRate = false;
        sensors{i}.DetectionCoordinates = 'Body';
        sensors{i}.TargetReportFormat = 'Detections';
        sensors{i}.HasElevation = false;
end

timeStep = 1;

% Run the scenario
while advance(scenario) && ishghandle(display.Figure)
    % Get the scenario time
    time = scenario.SimulationTime;

    % Collect detections from the ego vehicle sensors
    [detections,isValidTime] = helperDetect(sensors, egoVehicle, time);
   
    % Update the tracker if there are new detections
    if any(isValidTime)
        % Display detections
        display(egoVehicle, sensors, detections);
        drawnow;
        if EXPORT_CSV
            export_sensor_data(scenario, detections, egoVehicle, strcat('output/', filename));
        end
        % Update timeStep
        timeStep = timeStep + 1;

        % Capture frames for animation
        gifWriter();
    end
end

% Write GIF
writeAnimation(gifWriter, strcat('output/', filename));
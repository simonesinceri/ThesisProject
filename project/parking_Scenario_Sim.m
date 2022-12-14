function [allData, scenario, sensor] = parking_Scenario_Sim(state, vel, yaw_a)

% state contiene pti traiettoria e velocità


%parking_Scenario - Returns sensor detections
%    allData = parking_Scenario returns sensor detections in a structure
%    with time for an internally defined scenario and sensor suite.
%
%    [allData, scenario, sensors] = parking_Scenario optionally returns
%    the drivingScenario and detection generator objects.

% Generated by MATLAB(R) 9.12 (R2022a) and Automated Driving Toolbox 3.5 (R2022a).
% Generated on: 07-Aug-2022 00:06:06

% Create the drivingScenario object and ego car
[scenario, egoVehicle] = createDrivingScenario(state, vel, yaw_a);
plot(scenario)

% Create all the sensors
sensor = createSensor(scenario);

allData = struct('Time', {}, 'ActorPoses', {}, 'ObjectDetections', {}, 'LaneDetections', {}, 'PointClouds', {}, 'INSMeasurements', {});
running = true;
while running

    % Generate the target poses of all actors relative to the ego vehicle
    poses = targetPoses(egoVehicle);
    time  = scenario.SimulationTime;

    % Generate the ego vehicle lane boundaries
    if isa(sensor, 'visionDetectionGenerator')
        maxLaneDetectionRange = min(500,sensor.MaxRange);
        lanes = laneBoundaries(egoVehicle, 'XDistance', linspace(-maxLaneDetectionRange, maxLaneDetectionRange, 101));
    end
    % Generate detections for the sensor
    objectDetections = {};
    ptClouds = [];
    insMeas = [];
    [laneDetections, ~, isValidLaneTime] = sensor(poses, lanes, time);

    % Aggregate all detections into a structure for later use
    if isValidLaneTime
        allData(end + 1) = struct( ...
            'Time',       scenario.SimulationTime, ...
            'ActorPoses', actorPoses(scenario), ...
            'ObjectDetections', {objectDetections}, ...
            'LaneDetections', {laneDetections}, ...
            'PointClouds',   {ptClouds}, ... %#ok<AGROW>
            'INSMeasurements',   {insMeas}); %#ok<AGROW>
    end

    % Advance the scenario one time step and exit the loop if the scenario is complete
    running = advance(scenario);
end

% Restart the driving scenario to return the actors to their initial positions.
%restart(scenario);

% Release the sensor object so it can be used again.
release(sensor);

%%%%%%%%%%%%%%%%%%%%
% Helper functions %
%%%%%%%%%%%%%%%%%%%%

% Units used in createSensors and createDrivingScenario
% Distance/Position - meters
% Speed             - meters/second
% Angles            - degrees
% RCS Pattern       - dBsm

function sensor = createSensor(scenario)
% createSensors Returns all sensor objects to generate detections

% Assign into each sensor the physical and radar profiles for all actors
profiles = actorProfiles(scenario);
sensor = visionDetectionGenerator('SensorIndex', 1, ...
    'SensorLocation', [1.9 0], ...
    'DetectorOutput', 'Lanes with occlusion', ...
    'Intrinsics', cameraIntrinsics([600 800],[320 240],[480 640]), ...
    'ActorProfiles', profiles);

function [scenario, egoVehicle] = createDrivingScenario(state, vel, yaw_a)
% createDrivingScenario Returns the drivingScenario defined in the Designer

% Construct a drivingScenario object.
scenario = drivingScenario;

% Add all road segments
roadCenters = [0 0 0;
    25 0 0];
marking = [laneMarking('Solid', 'Color', [0.98 0.86 0.36])
    laneMarking('Dashed')];
laneSpecification = lanespec(1, 'Width', 20, 'Marking', marking);
road(scenario, roadCenters, 'Lanes', laneSpecification, 'Name', 'Road');

% Add the ego vehicle
egoVehicle = vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [3 2 0.01], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car');
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  qui inserisco i
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%  dato di state
waypoints = state;

speed = vel;

% dovrebbe funzionare anche senza yaw
%yaw =  yaw_a;

%trajectory(egoVehicle, waypoints, speed, 'Yaw', yaw);
trajectory(egoVehicle, waypoints, speed);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Add the non-ego actors
vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [23 8.12 0.01], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car1');

vehicle(scenario, ...
    'ClassID', 1, ...
    'Position', [0 7.89 0.01], ...
    'Mesh', driving.scenario.carMesh, ...
    'Name', 'Car2');


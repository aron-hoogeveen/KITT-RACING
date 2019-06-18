function [] = KITTControl(handles, voltage, orientation, startpoint, endpoint, recordArgs, waypoint, obstacles)
%[] = KITTControl(handles, voltage, orientation, startpoint, endpoint, 
%    recordArgs, waypoint, obstacles);
%    KITTControl is the main 
% EPO-4 Group B4
% 29-05-2019
% [] = KITTControl(argsIn) is the main control unit for the final challenge
% Arguments:
%   orientation: -180 to 180 degrees, x-axis is 0;
%   startpoint: [x, y] location of startingpoint
%   endpoint: [x, y] location of endpoint
%   recordArgs: struct with all the input arguments for the function
%     Record_TDOA.
%   waypoint: [x, y] location of waypoint, if nargin < 4: no waypoint
%   obstacles: true/false, if nargin < 5: no obstacles
%
% 180 links: KITTControl(17.18, 0, [200,200], [55,370])
% 90 links: KITTControl(17.18, 0, [200,200], [285,400])

% disp("%%%%%_____ ALL INPUT PARAMETERS OF KITTControl _____%%%%%");
% 
% disp("-----handles-----"); disp(handles);
% disp("-----voltage-----"); disp(voltage);
% disp("-----orientation-----"); disp(orientation);
% disp("-----startpoint-----"); disp(startpoint);
% disp("-----endpoint-----"); disp(endpoint);
% disp("-----recordArgs-----"); disp(recordArgs);
% % disp("-----waypoints-----"); disp(waypoints);
% % disp("-----obstacles-----"); disp(obstacles);
% disp("%%%%%_____ END OF DISPLAYING PARAMETERS _____%%%%%");

testCase = 1; %KITTlocation simulation with a deviated path from ideal
offlineCom = false; %Is KITT connected?
offlineLoc = false; % Location estimation
step2 = true;
challengeA = true; % Default challenge is A

% Check for input errors
disp('(O.O) - Checking input arguments for any errors...');
if (nargin < 6)
    error('(*.*) - Minimum number of input arguments required is four!');
elseif(abs(orientation) > 180)
    error('(*.*) - orientation must be between -180 and 180, with x-axis being theta = 0');
elseif (startpoint(1) < 0 || startpoint(1) > 460 || startpoint(2) < 0 || startpoint(2) > 460)
    error('(*.*) - Startpoint out of bounds');
elseif (endpoint(1) < 0 || endpoint(1) > 460 || endpoint(2) < 0 || endpoint(2) > 460)
    error('(*.*) - Endpoint out of bounds');
elseif (nargin>7 && (waypoint(1) < 0 || waypoint(1) > 460 || waypoint(2) < 0 || waypoint(2) > 460))
    error('(*.*) - Waypoint out of bounds');
elseif (nargin > 7)
    % No waypoint
    challengeA = false; % Do challenge B or C --> one waypoint
elseif (nargin < 9)
    obstacles = false;
end
disp('(^.^) - No input argument errors.');


% Load saved parameters
curves = struct();
load('acc_ploy.mat', 'ydis_acc', 'yspeed_acc'); % Acceleration curve from the midterm challenge
load('brake_ploy_v2.mat', 'ydis_brake', 'yspeed_brake'); % Braking curve from the midterm challenge
curves.ydis_acc = ydis_acc; clear ydis_acc;
curves.yspeed_acc = yspeed_acc; clear yspeed_acc;
curves.ydis_brake = ydis_brake; clear ydis_brake;
curves.yspeed_brake = yspeed_brake; clear yspeed_brake;
curves.brakeEnd = 186.5; % Predefined value. Distance in the braking distance-velocity curve at which the speed becomes zero
% curves.ydis_acc = ydis_acc;
% curves.yspeed_acc = yspeed_acc;
% curves.ydis_brake = ydis_brake;
% curves.yspeed_brake = yspeed_brake;

lastIndex = length(curves.yspeed_acc);
for i=1:20
    curves.yspeed_acc = [curves.yspeed_acc (curves.yspeed_acc(lastIndex) + (curves.yspeed_acc(lastIndex) - curves.yspeed_acc(lastIndex - 1)))];
    curves.ydis_acc = [curves.ydis_acc 800];
end%i=1:20
% plot(ydis_acc, yspeed_acc);

% Set up vectors and parameters
transmitDelay = 45; %ms for the car to react to change in speed command
[v_rot, v_rot_prime, t_radius] = turningParameters();
[d_q, ang_q] = convertAngleMeasurements();


% Read out the current voltage of the car. This voltage will be used to
% adjust the rotation velocity accordingly.
%voltageStr = EPOCom(offlineCom, 'transmit', 'Sv');
%voltage = str2double(voltageStr(6:9)); % Extract the voltage.

% Adjust v_rot_prime according to voltage:
% Nominal voltage: 17.1-17.2 [V]
voltageCorrection = 1;
if (voltage <= 18.00 && voltage > 17.90)
      voltageCorrection = 1.25;
elseif (voltage <= 17.90 && voltage > 17.80)
      voltageCorrection = 1.20;
elseif (voltage <= 17.80 && voltage > 17.70)
      voltageCorrection = 1.15;
elseif (voltage <= 17.70 && voltage > 17.60)
      voltageCorrection = 1.10;
elseif (voltage <= 17.60 && voltage > 17.50)
      voltageCorrection = 1.04;
elseif (voltage <= 17.50 && voltage > 17.40)
      voltageCorrection = 1.03; % verified
elseif (voltage <= 17.40 && voltage > 17.30)
      voltageCorrection = 1.00; % probably verified
elseif (voltage <= 17.30 && voltage > 17.20) 
      voltageCorrection = 0.95; % verified
elseif (voltage <= 17.20 && voltage > 17.10)%nominal voltage
      voltageCorrection = 0.87; % probably ok, fixed value for nominal voltage = (17.2-17.3V)
elseif (voltage <= 17.10 && voltage > 17.00)
      voltageCorrection = 0.84;
elseif (voltage <= 17.00 && voltage > 16.90)
      voltageCorrection = 0.75;
else
    warning('Voltage is out of range! < 16.9 V or > 18.0 V');
end

% Correct the velocity curve with voltageCorrection.
v_rot_prime = voltageCorrection * v_rot_prime; %scaling of the integral has the same result as scaling v_rot


% Clear all existing figures
% clf;

if (challengeA)% Challenge A: no waypoint
    drawMap(handles, startpoint, endpoint, orientation); %initiation of map

    dist = sqrt((endpoint(2)-startpoint(2))^2+(endpoint(1)-startpoint(1))^2);
    alfa_begin = atandWithCompensation(endpoint(2)-startpoint(2),endpoint(1)-startpoint(1));
    if ((abs(alfa_begin - orientation) > 150) && dist < 200) %car is facing other way and distance is small
        %consider driving backwards
    end

    % Calculate the turn (step 1)
    [turntime, direction, turnEndPos, new_orientation, ~] = calculateTurn(handles, startpoint,endpoint,orientation, t_radius, v_rot_prime);
    disp('turning time (ms):');
    disp( turntime);
    disp('[direction (1:left, -1:right), new_orientation] = ');
    disp([direction, new_orientation]);
    disp('turnEndPos (x, y) = ');
    disp( turnEndPos);
    new_dist = sqrt((endpoint(2)-turnEndPos(2))^2+(endpoint(1)-turnEndPos(1))^2);
    plot(handles.LocationPlot,turnEndPos(1), turnEndPos(2), 'b.', 'MarkerSize', 10);

    % % Calculate the variables for step 2:
    % turnEndPos = [x, y] at the end of the turn;
    turnEndSpeed = 1000*v_rot(turntime); % Velocity of KITT at the end of the first turn (in cm/s)
    [drivingTime, ~] = KITTstopV2(new_dist, curves.ydis_brake, curves.yspeed_brake, curves.ydis_acc, curves.yspeed_acc, curves.brakeEnd, turnEndSpeed); % Time the car must drive for step 2 in challenge A in ms (straight line)
    maximumLocalizationTime = 600; %Maximum computation time to receive audio location
    % Compute the amount of location points that can be retrieved in driving time
    pointsAmount = floor((drivingTime-transmitDelay)/maximumLocalizationTime); %45 is transmit delay

    %%%%%%%%%%%%%%%%%%%%%% START DRIVING %%%%%%%%%%%%%%%%%%%%%%%%
    input('Challenge A: Press any key to start driving','s')
    %%% A.STEP 1: Turn KITT
    turnKITT(offlineCom, direction, turntime, transmitDelay, d_q, ang_q);

    if (~step2) % For turning testing purposes, step2 is omitted
        EPOCom(offlineCom, 'transmit', 'M150'); % rollout
        EPOCom(offlineCom, 'transmit', 'D152'); % wheels straight
    else

        %%% A.STEP 2: Accelerate and stop 100cm before point (correct if
        %%% necessary)
        [~, lastTurnPos] = driveKITT(offlineCom, offlineLoc, handles, testCase, maximumLocalizationTime, drivingTime, pointsAmount, turnEndPos, endpoint, transmitDelay, v_rot, t_radius, v_rot_prime, curves, d_q, ang_q, recordArgs); % recursive function (will initiate a turn if necessary)

        %%% A.STEP 3: slowly drive the remaining (small) distance to the endpoint and stop/rollout
        EPOCom(offlineCom, 'transmit', 'M158'); % Slow driving
        finished = 0;
        
        callN = 5;
        distlist = []; %list of distances from the endpoint to KITT's location
        % A failsafe is implemented if KITT is not driving sufficiently close
        % to the endpoint (to prevent it from never stopping)
        failsafeN = 0; %number of times it was found to be driving away from the endpoint
        while (~finished)
            % Continuously retrieve the audio location
            [x, y, callN] = KITTLocation(offlineLoc, lastTurnPos, endpoint, 1, callN, testCase, recordArgs);%the duration of this computation is variable
            plot(handles.LocationPlot, x, y, 'm+',  'MarkerSize', 5, 'linewidth',2); % plot the location point on the map

            dist = sqrt((endpoint(2)-y)^2+(endpoint(1)-x)^2); % distance between KITT and the endpoint
            distlist = [distlist dist]; %append dist to distlist
            mindist = min(distlist); %minimal value of the distance
        
            if (dist < 10)
                finished = 1;
            elseif (dist > mindist) % If KITT is driving away from the endpoint
                failsafeN = failsafeN + 1;
                if (failsafeN > 1) % If dist>mindist occurs 3 times, failsafe is activated
                    disp("FAILSAFE STOP: endpoint was not within reach");
                    finished = 1;
                end
            end
        end
        EPOCom(offlineCom, 'transmit', 'M150'); % Rollout (can be changed to a stop)
        disp("Endpoint reached!"); %Destination reached
    end


      
    
    
    
%%%%% OTHER CHALLENGES:



elseif (challengeA ~= true) % Challenge B: one waypoint
    % Drive to the waypoint and wait for an input to drive again
    drawMap(handles, startpoint, endpoint, orientation); %initiation of map
    dist = sqrt((waypoint(2)-startpoint(2))^2+(waypoint(1)-startpoint(1))^2);
    alfa_begin = atandWithCompensation(waypoint(2)-startpoint(2),waypoint(1)-startpoint(1));

    % Calculate the first turn from the startpoint
    [turntime, direction, turnEndPos, new_orientation, ~] = calculateTurn(handles, startpoint,waypoint,orientation, t_radius, v_rot_prime);
    disp('turning time (ms):');
    disp( turntime);
    disp('[direction (1:left, -1:right), new_orientation] = ');
    disp([direction, new_orientation]);
    disp('turnEndPos (x, y) = ');
    disp( turnEndPos);
    new_dist = sqrt((waypoint(2)-turnEndPos(2))^2+(waypoint(1)-turnEndPos(1))^2);
    plot(handles.LocationPlot,turnEndPos(1), turnEndPos(2), 'b.', 'MarkerSize', 10); % plot the endlocation of the turn

    % % Calculate the variables for step 2:
    % turnEndPos = [x, y] at the end of the turn;
    turnEndSpeed = 1000*v_rot(turntime); % Velocity of KITT at the end of the first turn (in cm/s)
    [drivingTime, ~] = KITTstopV2(new_dist, curves.ydis_brake, curves.yspeed_brake, curves.ydis_acc, curves.yspeed_acc, curves.brakeEnd, turnEndSpeed); %Time the car must drive for step 2 in challenge B in ms (straight line)
    maximumLocalizationTime = 210; %Maximum computation time to receive audio location
    % Compute the amount of location points that can be retrieved in driving time
    pointsAmount = floor((drivingTime-transmitDelay)/maximumLocalizationTime); %45 is transmit delay

    %%%%%%%%%%%%%%%%%%%%%% START DRIVING %%%%%%%%%%%%%%%%%%%%%%%%
    input('Challenge B: press any key to start driving','s')
    %%% B.STEP 1: Turn KITT
    turnKITT(offlineCom, direction, turntime, transmitDelay, d_q, ang_q);

    %%% B.STEP 2: Accelerate and stop 100cm before point (correct if necessary)
    [waypoint_orientation, lastTurnPos, optimizeWrongTurn] = driveKITT(offlineCom, offlineLoc, handles, testCase, maximumLocalizationTime, drivingTime, pointsAmount, turnEndPos, waypoint, transmitDelay, v_rot, t_radius, v_rot_prime, curves, d_q, ang_q, recordArgs); % recursive function (will initiate a turn if necessary)
    % FIXME: waypoint_orientation differs if calculateTurn results in a
    % wrong turn
    
    %%% B.STEP 3: slowly drive the remaining (small) distance to the waypoint and stop/rollout
    % FIXME If the waypoint is not exactly reached (no turn found) the car
    % is somewhere near the waypoit, but should not drive further. It
    % should Emmediatly calculate the remaining route to the end point
    if (~optimizeWrongTurn)
        EPOCom(offlineCom, 'transmit', 'M158'); % Slow driving

        finished = 0;

        callN = 5;
        distlist = []; %list of distances from the endpoint to KITT's location
        % A failsafe is implemented if KITT is not driving sufficiently close
        % to the waypoint (to prevent it from never stopping)
        failsafeN = 0; %number of times it was found to be driving away from the endpoint
        while (~finished)
            % Continuously retrieve the audio location
            [x, y, callN] = KITTLocation(offlineLoc, lastTurnPos, waypoint, 1, callN, testCase, recordArgs);% The duration of this computation is variable
            plot(handles.LocationPlot, x, y, 'm+',  'MarkerSize', 5, 'linewidth',2); % Plot the location point on the map

            dist = sqrt((waypoint(2)-y)^2+(waypoint(1)-x)^2); % distance between KITT and the endpoint
            distlist = [distlist dist]; %append dist to distlist
            mindist = min(distlist); %minimal value of the distance

            if (dist < 10)
                finished = 1;
                current_loc = [x, y];
            elseif (dist > mindist) % If KITT is driving away from the endpoint
                failsafeN = failsafeN + 1;
                if (failsafeN > 1) % If dist>mindist occurs 3 times, failsafe is activated
                    disp("FAILSAFE STOP: waypoint was not within reach");
                    finished = 1;
                    current_loc = [x, y];
                end
            end
        end
        EPOCom(offlineCom, 'transmit', 'M150'); % Rollout (can be changed to a stop)
    else
        smoothStop(offlineCom, 158);
    end%if(~optimizeWrongTurn)
    
    disp("Waypoint reached!"); %Waypoint reached
    
    % Retrieve actual location (as this is more accurate than waypoint itself)
%     callN = 14; % Last point in the simulated location vector
%     [x, y] = KITTLocation(offlineLoc, turnEndPos, waypoint, 1, callN, testCase, recordArgs);
%    
%     
    % Calculate the second turn to the startpoint
    [turntime, direction, turnEndPos, new_orientation, ~] = calculateTurn(handles, current_loc, endpoint,waypoint_orientation, t_radius, v_rot_prime);
    disp('turning time (ms):');
    disp( turntime);
    disp('[direction (1:left, -1:right), new_orientation] = ');
    disp([direction, new_orientation]);
    disp('turnEndPos (x, y) = ');
    disp( turnEndPos);
    new_dist = sqrt((endpoint(2)-turnEndPos(2))^2+(endpoint(1)-turnEndPos(1))^2);
    plot(handles.LocationPlot,turnEndPos(1), turnEndPos(2), 'b.', 'MarkerSize', 10); % plot the endlocation of the turn

    % % Calculate the variables for step 4:
    % turnEndPos = [x, y] at the end of the turn;
    turnEndSpeed = 1000*v_rot(turntime); % Velocity of KITT at the end of the first turn (in cm/s)
    [drivingTime, ~] = KITTstopV2(new_dist, curves.ydis_brake, curves.yspeed_brake, curves.ydis_acc, curves.yspeed_acc, curves.brakeEnd, turnEndSpeed); %Time the car must drive for step 4 in challenge B in ms (straight line)
    % Compute the amount of location points that can be retrieved in driving time
    pointsAmount = floor((drivingTime-transmitDelay)/maximumLocalizationTime); %45 is transmit delay

    input('Press enter to continue driving to the endpoint ');

    %%% B.STEP 4: Turn KITT
    turnKITT(offlineCom, direction, turntime, transmitDelay, d_q, ang_q);

    %%% B.STEP 5: Accelerate and stop 100cm before endpoint (correct if necessary)
    [~, lastTurnPos, optimizeWrongTurn] = driveKITT(offlineCom, offlineLoc,handles, testCase, maximumLocalizationTime, drivingTime, pointsAmount, turnEndPos, endpoint, transmitDelay, v_rot, t_radius, v_rot_prime, curves, d_q, ang_q, recordArgs); % recursive function (will initiate a turn if necessary)
    
    if (~optimizeWrongTurn)
        %%% B.STEP 6: slowly drive the remaining (small) distance to the waypoint and stop/rollout
        EPOCom(offlineCom, 'transmit', 'M158'); % Slow driving
        finished = 0;

        callN = 5;
        distlist = []; %list of distances from the endpoint to KITT's location
        % A failsafe is implemented if KITT is not driving sufficiently close
        % to the endpoint (to prevent it from never stopping)
        failsafeN = 0; %number of times it was found to be driving away from the endpoint
        while (~finished)
            % Continuously retrieve the audio location
            [x, y, callN] = KITTLocation(offlineLoc, lastTurnPos, endpoint, 1, callN, testCase, recordArgs);% The duration of this computation is variable
            plot(handles.LocationPlot, x, y, 'm+',  'MarkerSize', 5, 'linewidth',2); % Plot the location point on the map

            dist = sqrt((endpoint(2)-y)^2+(endpoint(1)-x)^2); % distance between KITT and the endpoint
            distlist = [distlist dist]; %append dist to distlist
            mindist = min(distlist); %minimal value of the distance

            if (dist < 10)
                finished = 1;
            elseif (dist > mindist) % If KITT is driving away from the endpoint
                failsafeN = failsafeN + 1;
                if (failsafeN > 1) % If dist>mindist occurs 3 times, failsafe is activated
                    disp("FAILSAFE STOP: endpoint was not within reach");
                    finished = 1;
                end
            end
        end
        EPOCom(offlineCom, 'transmit', 'M150'); % Rollout (can be changed to a stop)
    else
        smoothStop(offlineCom, 158);
    end%if(~optimizeWrongTurn)
    
    disp("Endpoint reached!"); % Endpoint reached
    
    
else %Challenge C: no waypoints, with obstacle
end


end%KITTControl
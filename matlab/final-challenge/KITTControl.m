% EPO-4 Group B4
% 29-05-2019
% [] = KITTControl(argsIn) is the main control unit for the final challenge
function [] = KITTControl(handles, voltage, orientation, startpoint, endpoint, waypoint, obstacles)

% Arguments:
%   orientation: -180 to 180 degrees, x-axis is 0;
%   startpoint: [x, y] location of startingpoint
%   endpoint: [x, y] location of endpoint
%   waypoint: [x, y] location of waypoint, if nargin < 4: no waypoint
%   obstacles: true/false, if nargin < 5: no obstacles
%
% 180 links: KITTControl(17.18, 0, [200,200], [55,370])
% 90 links: KITTControl(17.18, 0, [200,200], [285,400])

offlineCom = true; %Is KITT connected?
offlineLoc = true; % Location estimation
step2 = true;
challengeA = true; % Default challenge is A

% Check for input errors
disp('(O.O) - Checking input arguments for any errors...');
if (nargin < 5)
    error('(*.*) - Minimum number of input arguments required is four!');
elseif(abs(orientation) > 180)
    error('(*.*) - orientation must be between -180 and 180, with x-axis being theta = 0');
elseif (startpoint(1) < 50 || startpoint(1) > 510 || startpoint(2) < 0 || startpoint(2) > 510)
    error('(*.*) - Startpoint out of bounds');
elseif (endpoint(1) < 50 || endpoint(1) > 510 || endpoint(2) < 50 || endpoint(2) > 510)
    error('(*.*) - Endpoint out of bounds');
elseif (nargin>5 && (waypoint(1) < 50 || waypoint(1) > 510 || waypoint(2) < 50 || waypoint(2) > 510))
    error('(*.*) - Waypoint out of bounds');
elseif (nargin > 5)
    % No waypoint
    challengeA = false; % Do challenge B or C --> one waypoint
elseif (nargin < 7)
    obstacles = false;
end
disp('(^.^) - No input argument errors.');


% Load saved parameters
load('acc_ploy.mat', 'ydis_acc', 'yspeed_acc'); % Acceleration curve from the midterm challenge
load('brake_ploy_v2.mat', 'ydis_brake', 'yspeed_brake'); % Braking curve from the midterm challenge
yspeed_acc = [yspeed_acc 156];  % fixes for a too short acceleration for version 1
ydis_acc = [ydis_acc 500]; % fixes for a too short acceleration curve for version 1


% Set up vectors and parameters
transmitDelay = 45; %ms for the car to react to change in speed command
[v_rot, v_rot_prime, t_radius] = turningParameters();
[d_q, ang_q] = convertAngleMeasurements();


% Read out the current voltage of the car. This voltage will be used to
% adjust the rotation velocity accordingly.
%voltageStr = EPOCom(offlineCom, 'transmit', 'Sv');
%voltage = str2double(voltageStr(6:9)); % Extract the voltage.

% Adjust v_rot_prime according to voltage:
% Nominal voltage: 18.1 V
%disp(voltage);
% if (voltage == 18.4)
%     voltageCorrection = 1.2;
% elseif (voltage == 18.3)
%     voltageCorrection = 1.18;
% elseif (voltage == 18.2)
%     voltageCorrection = 1.15;
% elseif (voltage == 18.1)
%     voltageCorrection = 1.10;
% elseif (voltage <= 17.60 &&)
%     voltageCorrection = 1; % no voltage correction: nominal voltage is 18.1V, which corresponds to this actual battery voltage
% elseif (voltage == 17.9)
%     voltageCorrection = 1;
% elseif (voltage <= 17.8 && voltage > 17.6)
%     voltageCorrection = 1;
% else
%     error("The battery voltage deviates a lot from the nominal voltage (18.1V)");
% end
voltageCorrection = 1;

%nominal voltage:
if (voltage <= 17.30 && voltage > 17.20)
      voltageCorrection = 1.00;
      
elseif (voltage <= 17.20 && voltage > 17.10)
      voltageCorrection = 0.83;
end
% if (voltage <= 17.50 && voltage > 17.40)
%      voltageCorrection = 1.00;% verified 2x
% elseif (voltage <= 17.60 && voltage > 17.50)
%      voltageCorrection = 1.03;% verified 2x
% elseif (voltage <= 17.40 && voltage > 17.30)
%      voltageCorrection = 1.04;% verified 2x
% elseif (voltage <= 17.30 && voltage > 17.20)
%      voltageCorrection = 1.11;% Unpredictable
% elseif (voltage <= 17.20 && voltage > 17.10)
%      voltageCorrection = 1.20;% Unpredictable
% elseif (voltage <= 17.10 && voltage > 17.00)
%      voltageCorrection = 1.10;% Unpredictable
% end

% TODO: correct for slightly incorrect acceleration curve.
% Additional voltageCorrection for different angles


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
    [turntime, direction, turnEndPos, new_orientation] = calculateTurn(handles, startpoint,endpoint,orientation, t_radius, v_rot_prime);
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
    [drivingTime, ~] = KITTstopV2(new_dist, ydis_brake,yspeed_brake,ydis_acc,yspeed_acc,186.5,turnEndSpeed); % FIXME, %Time the car must drive for step 2 in challenge A in ms (straight line)
    maximumLocalizationTime = 210; %Maximum computation time to receive audio location
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
        driveKITT(offlineCom, handles, maximumLocalizationTime, drivingTime, pointsAmount, turnEndPos, endpoint, transmitDelay, v_rot, t_radius, v_rot_prime, ydis_brake,yspeed_brake,ydis_acc,yspeed_acc, d_q, ang_q); % recursive function (will initiate a turn if necessary)

        %%% A.STEP 3: slowly drive the remaining (small) distance to the endpoint and stop/rollout
        EPOCom(offlineCom, 'transmit', 'M158'); % Slow driving
        finished = 0;
        
        % FIXME DEBUG TODO
        callN = 5;
        while (~finished)
            % Continuously retrieve the audio location
            [x, y, callN] = KITTLocation(offlineLoc, turnEndPos, endpoint, 1, callN, 0);%the duration of this computation is variable
            plot(handles.LocationPlot, x, y, 'm+',  'MarkerSize', 5, 'linewidth',2); % plot the location point on the map

            dist = sqrt((endpoint(2)-y)^2+(endpoint(1)-x)^2); % distance between KITT and the endpoint
            if (dist < 10)
                finished = 1;
            end
        end
        EPOCom(offlineCom, 'transmit', 'M150'); % Rollout (can be changed to a stop)
        disp("Destination reached!"); %Destination reached
    end


      
    
    
    
%%%%% OTHER CHALLENGES:



elseif (challengeA ~= true) % Challenge B: one waypoint
    % Drive to the waypoint and wait for an input to drive again
    drawMap(handles, startpoint, endpoint, orientation); %initiation of map
    dist = sqrt((waypoint(2)-startpoint(2))^2+(waypoint(1)-startpoint(1))^2);
    alfa_begin = atandWithCompensation(waypoint(2)-startpoint(2),waypoint(1)-startpoint(1));

    % Calculate the first turn from the startpoint
    [turntime, direction, turnEndPos, new_orientation] = calculateTurn(handles, startpoint,waypoint,orientation, t_radius, v_rot_prime);
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
    [drivingTime, ~] = KITTstopV2(new_dist, ydis_brake,yspeed_brake,ydis_acc,yspeed_acc,186.5,turnEndSpeed); %Time the car must drive for step 2 in challenge B in ms (straight line)
    maximumLocalizationTime = 210; %Maximum computation time to receive audio location
    % Compute the amount of location points that can be retrieved in driving time
    pointsAmount = floor((drivingTime-transmitDelay)/maximumLocalizationTime); %45 is transmit delay

    %%%%%%%%%%%%%%%%%%%%%% START DRIVING %%%%%%%%%%%%%%%%%%%%%%%%
    input('Challenge B: press any key to start driving','s')
    %%% B.STEP 1: Turn KITT
    turnKITT(offlineCom, direction, turntime, transmitDelay, d_q, ang_q);

    %%% B.STEP 2: Accelerate and stop 100cm before point (correct if necessary)
    waypoint_orientation = driveKITT(offlineCom, handles, maximumLocalizationTime, drivingTime, pointsAmount, turnEndPos, waypoint, transmitDelay, v_rot, t_radius, v_rot_prime, ydis_brake,yspeed_brake,ydis_acc,yspeed_acc, d_q, ang_q); % recursive function (will initiate a turn if necessary)

    %%% B.STEP 3: slowly drive the remaining (small) distance to the waypoint and stop/rollout
    EPOCom(offlineCom, 'transmit', 'M158'); % Slow driving
    finished = 0;

    callN = 5;
    while (~finished)
        % Continuously retrieve the audio location
        [x, y, callN] = KITTLocation(offlineLoc, turnEndPos, waypoint, 1, callN, 0);% The duration of this computation is variable
        plot(handles.LocationPlot, x, y, 'm+',  'MarkerSize', 5, 'linewidth',2); % Plot the location point on the map

        dist = sqrt((waypoint(2)-y)^2+(waypoint(1)-x)^2); % distance between KITT and the endpoint
        if (dist < 10)
            finished = 1;
        end
    end
    EPOCom(offlineCom, 'transmit', 'M150'); % Rollout (can be changed to a stop)
    disp("Waypoint reached!"); %Waypoint reached
    
    % Retrieve actual location (as this is more accurate than waypoint itself)
    current_loc = KITTLocation(offlineLoc, turnEndPos, waypoint, 1, callN, 0);
    current_loc = waypoint; % Remove this later
    
    
    % Calculate the second turn to the startpoint
    [turntime, direction, turnEndPos, new_orientation] = calculateTurn(handles, current_loc, endpoint,waypoint_orientation, t_radius, v_rot_prime);
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
    [drivingTime, ~] = KITTstopV2(new_dist, ydis_brake,yspeed_brake,ydis_acc,yspeed_acc,186.5,turnEndSpeed); %Time the car must drive for step 4 in challenge B in ms (straight line)
    % Compute the amount of location points that can be retrieved in driving time
    pointsAmount = floor((drivingTime-transmitDelay)/maximumLocalizationTime); %45 is transmit delay

    input('Press enter to continue driving to the endpoint ');
    
    %%% B.STEP 4: Turn KITT
    turnKITT(offlineCom, direction, turntime, transmitDelay, d_q, ang_q);

    %%% B.STEP 5: Accelerate and stop 100cm before endpoint (correct if necessary)
    driveKITT(offlineCom, handles, maximumLocalizationTime, drivingTime, pointsAmount, turnEndPos, endpoint, transmitDelay, v_rot, t_radius, v_rot_prime, ydis_brake,yspeed_brake,ydis_acc,yspeed_acc, d_q, ang_q); % recursive function (will initiate a turn if necessary)

    %%% B.STEP 6: slowly drive the remaining (small) distance to the waypoint and stop/rollout
    EPOCom(offlineCom, 'transmit', 'M158'); % Slow driving
    finished = 0;
    
    callN = 5;
    while (~finished)
        % Continuously retrieve the audio location
        [x, y, callN] = KITTLocation(offlineLoc, turnEndPos, endpoint, 1, callN, 0);% The duration of this computation is variable
        plot(handles.LocationPlot, x, y, 'm+',  'MarkerSize', 5, 'linewidth',2); % Plot the location point on the map

        dist = sqrt((endpoint(2)-y)^2+(endpoint(1)-x)^2); % distance between KITT and the endpoint
        if (dist < 10)
            finished = 1;
        end
    end
    EPOCom(offlineCom, 'transmit', 'M150'); % Rollout (can be changed to a stop)
    disp("Endpoint reached!"); %Waypoint reached
    
    
else %Challenge C: no waypoints, with obstacle
end


end%KITTControl
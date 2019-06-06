% EPO-4 Group B4
% 29-05-2019
% [] = KITTControl(argsIn) is the main control unit for the final challenge
function [] = KITTControl(orientation, startpoint, endpoint, waypoint, obstacles)
% Arguments:
%   orientation: -180 to 180 degrees, x-axis is 0;
%   startpoint: [x, y] location of startingpoint
%   endpoint: [x, y] location of endpoint
%   waypoint: [x, y] location of waypoint, if nargin < 4: no waypoint
%   obstacles: true/false, if nargin < 5: no obstacles

offline = true; %Is KITT connected?
step2 = true;

% Default challenge is A
challengeA = true;

% Check for input errors
disp('(O.O) - Checking input arguments for any errors...');
if (nargin < 3)
    error('(*.*) - Minimum number of input arguments required is three!');
elseif(abs(orientation) > 180)
    error('(*.*) - orientation must be between -180 and 180, with x-axis being theta = 0');
elseif (startpoint(1) < 50 || startpoint(1) > 510 || startpoint(2) < 0 || startpoint(2) > 510)
    error('(*.*) - Startpoint out of bounds');
elseif (endpoint(1) < 50 || endpoint(1) > 510 || endpoint(2) < 50 || endpoint(2) > 510)
    error('(*.*) - Endpoint out of bounds');
elseif (nargin>3 && (waypoint(1) < 50 || waypoint(1) > 510 || waypoint(2) < 50 || waypoint(2) > 510))
    error('(*.*) - Waypoint out of bounds');
elseif (nargin > 3)
    % No waypoint
    challengeA = false; % Do challenge B or C --> one waypoint
elseif (nargin < 5)
    obstacles = false;
end
disp('(^.^) - No input argument errors.');


% Set up vectors and parameters
transmitDelay = 45; %ms for the car to react to change in speed command
[v_rot_prime, t_radius] = turningParameters();
[d_q, ang_q] = convertAngleMeasurements();

% Read out the current voltage of the car. This voltage will be used to
% adjust the rotation velocity accordingly.
voltageStr = EPOCom(offline, 'transmit', 'Sv');
voltage = str2double(voltageStr(6:10)); % Extract the voltage.

% Adjust v_rot_prime according to voltage:
% Nominal voltage: 18.1 V
if (voltage <= 18.4 && voltage > 18.2)
    voltageCorrection = 1.2;
elseif (voltage <= 18.2 && voltage > 18.0)
    voltageCorrection = 1; % no voltage correction: nominal voltage is 18.1V
elseif (voltage <= 18.0 && voltage > 17.8)
    voltageCorrection = 0.9;
elseif (voltage <= 17.8 && voltage > 17.6)
    voltageCorrection = 0.7;
else
    disp("The battery voltage deviates a lot from the nominal voltage (18.1V)");
end
% Correct the velocity curve with voltageCorrection. 
v_rot_prime = voltageCorrection * v_rot_prime; %scaling of the integral has the same result as scaling v_rot


% Clear all existing figures
clf;

if (challengeA)% Challenge A: no waypoint
    drawMap(startpoint, endpoint, orientation); %initiation of map

    dist = sqrt((endpoint(2)-startpoint(2))^2+(endpoint(1)-startpoint(1))^2);
    alfa_begin = atandWithCompensation(endpoint(2)-startpoint(2),endpoint(1)-startpoint(1));
    if ((abs(alfa_begin - orientation) > 150) && dist < 200) %car is facing other way and distance is small
        %consider driving backwards
    end

    % Calculate the turn
    [turntime, direction, turnEndPos, new_orientation] = calculateTurn(startpoint,endpoint,orientation, t_radius, v_rot_prime);
    disp('turning time (ms):');
    disp( turntime);
    disp('[direction (1:left, -1:right), new_orientation] = ');
    disp([direction, new_orientation]);
    disp('turnEndPos (x, y) = ');
    disp( turnEndPos);
    new_dist = sqrt((endpoint(2)-turnEndPos(2))^2+(endpoint(1)-turnEndPos(1))^2);
    plot(turnEndPos(1), turnEndPos(2), 'b.', 'MarkerSize', 10);
    hold on;

    % Calculate the variables for step 2:
    % turnEndPos = [x, y] at the end of the turn;
    turnEndSpeed = v_rot_prime(turntime);
    drivingTime = KITTstopV2(); % FIXME, %Time the car must drive for step 2 in challenge A in ms (straight line)
    maximumLocalizationTime = 200; %Maximum computation time to receive audio location
    x_points = []; % empty array for the points
    y_points = []; % empty array for the points

    % compute the amount of location points that can be retrieved in driving time
    pointsAmount = floor((drivingTime-45)/maximumLocalizationTime); %45 is transmit delay
    
 
        
        
    input('Press any key to start driving','s')

    %%%%%%%%%%%%%%%%%%%%%% START DRIVING %%%%%%%%%%%%%%%%%%%%%%%%
    %%% A.STEP 1: Turn KITT

        if (direction == 1)
            steering =  sprintf('%s%d', 'D' ,angleToCommand(25, 'left', d_q, ang_q));
        else
            steering =  sprintf('%s%d', 'D' ,angleToCommand(25, 'right', d_q, ang_q));
        end
        KITTspeed = 'M160';

        EPOCom(offline, 'transmit', steering);
        tic
        EPOCom(offline, 'transmit', KITTspeed);
        toc
        pause(turntime/1000 - transmitDelay/1000);  %let the car drive for calculated time
        if (~step2)
            EPOCom(offline, 'transmit', 'M150'); % rollout
            EPOCom(offline, 'transmit', 'D152'); % wheels straight
        else      
        
    %%% A.STEP 2: Accelerate and stop 100cm before point

        % EPOCommunications('transmit', KITTspeed);
            EPOCom(offline, 'transmit', 'D152'); % wheels straight
            doPause = true; % pause for drivingTime - time it takes for audio
            t_loc_start = tic;
            for i=1:pointsAmount
                [x, y] = retrieveAudioLocationFIXME_exlacmationmark;%FIXMEthe duration of this computation is variable
                x_points = [x_points x]; %append the x coordinate to array
                y_points = [y_points y]; %append the y coordinate to array
                if(length(x_points) > floor(pointsAmount/2)) % Dit moet aangepast worden aan de hand van de lengte van het stuk met pointsAmount
                    % make a trend and calculate the angle
                    prms = polyfit(x_points,y_points,1);
                    rico = prms(1);
                    phi = atand(rico);
                    if (x_points(end)-x_points(1) < 0 && y_points(end)-y_points(1) < 0)
                        actual_orientation = phi - 180;
                    elseif(x_points(end)-x_points(1) < 0 && y_points(end)-y_points(1) > 0)
                        actual_orientation = phi+180;
                    elseif(x_points(end)-x_points(1) > 0 && y_points(end)-y_points(1) < 0)
                        actual_orientation = phi;
                    else
                        actual_orientation = phi;
                    end
                    desired_orientation = atandWithCompensation(endpoint(2)-y_points(end),endpoint(1)-x_points(end));
                    angle_diff = actual_orientation - desired_orientation;
                    % lijn doortrekken met y = rico*x + b;
                    % nearest distance endpoint and line;
                    % if difference > 10cm: stoppen en bijsturen
                    %   nieuw punt ophalen
                    %   weer orientation bepalen (recursive functie ergens)
                    %   weer desired_orientation uitrekenen
                    %   weer angle_diff uitrekenen
                    %   calculateTurn([x_points(end), y_points(end],endpoint,actual_orientation, t_radius, v_rot_prime);
                    %   weer stap 1 uitvoeren
                    %   helemaal stoppen nu
                    %   KITTstop toepassen en iets stoppen voor eindpunt
                    %   (30cm indien mogelijk)
                    doPause = false;
                end
            end
            t_loc_elapsed = toc(t_loc_start);
            if (doPause)
                pause((drivingTime - 45)/1000 - t_loc_elapsed);
                smoothstop; %FIXME
            end
            % heel rustig rijden en stoppen op het eindpunt met
            % locatiebepaling: functie voor rustig rijden
            % BESTEMMING BEREIKT
        end

elseif (challengeA ~= true) % Challenge B: one waypoint
else %Challenge C: complete chaos
end

end%KITTControl

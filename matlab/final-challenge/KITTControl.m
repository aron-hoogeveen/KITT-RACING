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
voltage = str2double(voltageStr(9:13)); % Extract the voltage

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
        EPOCom(offline, 'transmit', 'M150'); % rollout
        EPOCom(offline, 'transmit', 'D152'); % wheels straight
        % remove this later:

    %%% A.STEP 2: Accelerate and stop 100cm before point
        KITTspeed = 160;
        % EPOCommunications('transmit', KITTspeed);


    %%% A.STEP 3: Turn KITT again using actual orientation by audio beacon and
    %actual location


elseif (challengeA ~= true) % Challenge B: one waypoint
else %Challenge C: complete chaos
end

end%KITTControl

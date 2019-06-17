function [] = testTurn(voltage, orientation, startpoint, endpoint, waypoint, obstacles)

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

offlineCom = false; %Is KITT connected?
offlineLoc = true; % Location estimation
step2 = true;
challengeA = true; % Default challenge is A

% Check for input errors
disp('(O.O) - Checking input arguments for any errors...');
if (nargin < 4)
    error('(*.*) - Minimum number of input arguments required is four!');
elseif(abs(orientation) > 180)
    error('(*.*) - orientation must be between -180 and 180, with x-axis being theta = 0');
elseif (startpoint(1) < 50 || startpoint(1) > 510 || startpoint(2) < 0 || startpoint(2) > 510)
    error('(*.*) - Startpoint out of bounds');
elseif (endpoint(1) < 50 || endpoint(1) > 510 || endpoint(2) < 50 || endpoint(2) > 510)
    error('(*.*) - Endpoint out of bounds');
elseif (nargin>4 && (waypoint(1) < 50 || waypoint(1) > 510 || waypoint(2) < 50 || waypoint(2) > 510))
    error('(*.*) - Waypoint out of bounds');
elseif (nargin > 4)
    % No waypoint
    challengeA = false; % Do challenge B or C --> one waypoint
elseif (nargin < 6)
    obstacles = false;
end
disp('(^.^) - No input argument errors.');


% Set up vectors and parameters
transmitDelay = 45; %ms for the car to react to change in speed command
[v_rot, v_rot_prime, t_radius] = turningParameters();
[d_q, ang_q] = convertAngleMeasurements();

voltageCorrection = 1;
if     (voltage <= 18.60 && voltage > 18.50)
      voltageCorrection = 0.83;
elseif (voltage <= 18.50 && voltage > 18.40)
      voltageCorrection = 0.83;
elseif (voltage <= 18.40 && voltage > 18.30)
      voltageCorrection = 0.83;
elseif (voltage <= 18.30 && voltage > 18.20)
      voltageCorrection = 0.83;
elseif (voltage <= 18.20 && voltage > 18.10)
      voltageCorrection = 0.83;
elseif (voltage <= 18.10 && voltage > 18.00)
      voltageCorrection = 0.83;
elseif (voltage <= 18.00 && voltage > 17.90)
      voltageCorrection = 0.83;
elseif (voltage <= 17.90 && voltage > 17.80)
      voltageCorrection = 0.83;
elseif (voltage <= 17.80 && voltage > 17.70)
      voltageCorrection = 0.83;
elseif (voltage <= 17.70 && voltage > 17.60)
      voltageCorrection = 0.83;
elseif (voltage <= 17.60 && voltage > 17.50)
      voltageCorrection = 0.83;
elseif (voltage <= 17.50 && voltage > 17.40)
      voltageCorrection = 0.83;
elseif (voltage <= 17.40 && voltage > 17.30)
      voltageCorrection = 1;
elseif (voltage <= 17.30 && voltage > 17.20) %nominal voltage
      voltageCorrection = 1.00; % fixed value for nominal voltage = (17.2-17.3V)
elseif (voltage <= 17.20 && voltage > 17.10)
      voltageCorrection = 0.83;
elseif (voltage <= 17.10 && voltage > 17.00)
      voltageCorrection = 0.83;
elseif (voltage <= 17.00 && voltage > 16.90)
      voltageCorrection = 0.83;
elseif (voltage <= 16.90 && voltage > 16.80)
      voltageCorrection = 0.83;
elseif (voltage <= 16.80 && voltage > 16.70)
      voltageCorrection = 0.83;
elseif (voltage <= 16.70 && voltage > 16.60)
      voltageCorrection = 0.83;
else
    warning('Voltage is out of range! < 16.6 V or > 18.6 V');
end

% Correct the velocity curve with voltageCorrection.
v_rot_prime = voltageCorrection * v_rot_prime; %scaling of the integral has the same result as scaling v_rot

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
end
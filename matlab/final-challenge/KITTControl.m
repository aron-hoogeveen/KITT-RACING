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

% Default challenge is A
challengeA = true;

% Check for input errors
disp('(O.O) - Checking input arguments for any errors...');
if (nargin < 3)
    error('(*.*) - Minimum number of input arguments required is three!');
elseif(abs(orientation) > 180)
    error('(*.*) - orientation must be between -180 and 180, with x-axis being theta = 0');
elseif (startpoint(1) < 50 || startpoint(1) > 650 || startpoint(2) < 0 || startpoint(2) > 650)
    error('(*.*) - Startpoint out of bounds');
elseif (endpoint(1) < 50 || endpoint(1) > 650 || endpoint(2) < 50 || endpoint(2) > 650)
    error('(*.*) - Endpoint out of bounds');
elseif (nargin>3 && (waypoint(1) < 50 || waypoint(1) > 650 || waypoint(2) < 50 || waypoint(2) > 650))
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
[v_rot, t_radius] = turningParameters();
[d_q, ang_q] = convertAngleMeasurements(); % Returns steering commands and accompanying steering angles


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
    [turntime, direction, turnEndPos, new_orientation] = calculateTurn(startpoint,endpoint,orientation, t_radius, v_rot);
    disp('turning time (ms):');
    disp( turntime);
    disp('[direction (1:left, -1:right), new_orientation] = ');
    disp([direction, new_orientation]);
    disp('turnEndPos (x, y) = ');
    disp( turnEndPos);
    new_dist = sqrt((endpoint(2)-turnEndPos(2))^2+(endpoint(1)-turnEndPos(1))^2);
    plot(turnEndPos(1), turnEndPos(2), 'b.', 'MarkerSize', 10);
    hold on;

    %input('Press any key to start driving','s')

    %%%%%%%%%%%%%%%%%%%%%% START DRIVING %%%%%%%%%%%%%%%%%%%%%%%%
    %%% A.STEP 1: Turn KITT
        
        if (direction == 1)
            steering =  sprintf('%s%d', 'D' ,angleToCommand(20, 'left', d_q, ang_q));
        else
            steering =  sprintf('%s%d', 'D' ,angleToCommand(20, 'right', d_q, ang_q));
        end
        
    
        % EPOCommunications('transmit', steering);
        % EPOCommunications('transmit', KITTspeed);
        pause(turntime/1000 - transmitDelay/1000);  %let the car drive for calculated time
        % EPOCommunications('transmit', 'D152'); % wheels straight
        % remove this later:
        % EPOCommunications('transmit', 'M150'); % rollout
    
    %%% A.STEP 2: Accelerate and stop 100cm before point
        KITTspeed = 160;
        % EPOCommunications('transmit', KITTspeed);
        
    
    %%% A.STEP 3: Turn KITT again using actual orientation by audio beacon and
    %actual location
    
    
elseif (challengeA ~= true) % Challenge B: one waypoint
else %Challenge C: complete chaos
end

end%KITTControl
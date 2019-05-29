% EPO-4 Group B4
% 29-05-2019
%[] = KITTControl(argsIn) is the main control unit for the final challenge
function [] = KITTControl(orientation, startpoint, endpoint, waypoint, obstacles)
% Arguments:
%   orientation: -180 to 180 degrees, x-axis is 0;
%   startpoint: [x, y] location of startingpoint
%   endpoint: [x, y] location of endpoint
%   waypoint: [x, y] location of waypoint, if waypoint = 0: no waypoint
%   obstacles: true/false

% Check for input errors
if(abs(orientation) > 180)
    error('orientation must be between -180 and 180, with x-axis being theta = 0');
elseif (startpoint(1) < 50 || startpoint(1) > 650 || startpoint(2) < 0 || startpoint(2) > 650)
    error('Startpoint out of bounds');
elseif (endpoint(1) < 50 || endpoint(1) > 650 || endpoint(2) < 50 || endpoint(2) > 650)
    error('Endpoint out of bounds');
elseif (nargin>3 && (waypoint(1) < 50 || waypoint(1) > 650 || waypoint(2) < 50 || waypoint(2) > 650))
    error('Waypoint out of bounds');
end


% Set up vectors
run convertAngleMeasurements.m
clf;

if (nargin <4)% Challenge A: no waypoint
    drawMap(startpoint, endpoint, orientation); %initiation of map
    
    dist = sqrt((endpoint(2)-startpoint(2))^2+(endpoint(1)-startpoint(1))^2);
    alfa_begin = atandWithCompensation(endpoint(2)-startpoint(2),endpoint(1)-startpoint(1));
    if ((abs(alfa_begin - orientation) >150) && dist < 200) %car is facing other way and distance is small
        %consider driving backwards
    end
    
    % Calculate the turn
    [turntime, direction, turnEndPos, new_orientation] = calculateTurn(startpoint,endpoint,orientation);
    disp('[turntime, direction, new_orientation] = ');
    disp([turntime, direction, new_orientation]);
    disp('turnEndPos (x, y) = ');
    disp( turnEndPos);
    new_dist = sqrt((endpoint(2)-turnEndPos(2))^2+(endpoint(1)-turnEndPos(1))^2);
    plot(turnEndPos(1), turnEndPos(2), 'b.', 'MarkerSize', 10);
    hold on;

    %input('Press any key to start driving','s')

    %%%%%%%%%%%%%%%%%%%%%% START DRIVING %%%%%%%%%%%%%%%%%%%%%%%%
    %A.STEP 1: Turn KITT
    
    %A.STEP 2: Accelerate and stop 50cm before point
    
    %A.STEP 3: Turn KITT again using actual orientation by audio beacon and
    %actual location
    
    
else if (nargin <5) % Challenge B: one waypoint
else %Challenge C: complete chaos
end

end%KITTControl
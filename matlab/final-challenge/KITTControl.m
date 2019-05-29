function [] = KITTControl(orientation,startpoint, endpoint, waypoint, obstacles)
%[] = KITTControl(argsIn) is the main control unit for the final challenge
%    for KITT.
% Version: 0.2 (27-05-2019)
% Group: B.04

% Arguments:
%   orientation: -180 to 180 degrees, x-axis is 0;
%   startpoint: [x, y] location of startingpoint
%   endpoint: [x, y] location of endpoint
%   waypoint: [x, y] location of waypoint, if waypoint = 0: no waypoint
%   obstacles: true/false
clf;
if (nargin <4)% Challenge A: no waypoint
    drawMap(startpoint, endpoint, orientation);
    [turntime, direction, turnEndPos, new_orientation] = calculateTurn(startpoint,endpoint,0)
    plot(turnEndPos(1), turnEndPos(2), 'b.', 'MarkerSize', 10);
    hold on;

    
    dist = sqrt((endpoint(2)-startpoint(2))^2+(endpoint(1)-startpoint(1))^2);
    alfa_begin = tandWithCompensation(endpoint(2)-startpoint(2),endpoint(1)-startpoint(1));
    if ((abs(alfa_begin - orientation) >150) && dist < 200) %car is facing other way and distance is small
        %consider driving backwards
    end
    
    
else if (nargin <5) % Challenge B: one waypoint
else %Challenge C: complete chaos
end



global map_points;
map_points = zeros(600,600);
map_points(startpoint) = 1;
map_points(endpoint) = 3;

 
end%KITTControl
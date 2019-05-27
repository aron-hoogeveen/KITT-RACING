function [] = KITTControl(startpoint, endpoint, waypoint, obstacles)
%[] = KITTControl(argsIn) is the main control unit for the final challenge
%    for KITT.
% Version: 0.2 (27-05-2019)
% Group: B.04

% Arguments:
%   startpoint: [x, y] location of startingpoint
%   endpoint: [x, y] location of endpoint
%   waypoint: [x, y] location of waypoint, if waypoint = 0: no waypoint
%   obstacles: true/false

if (nargin <3)% Challenge A: no waypoint
    drawMap(startpoint, endpoint);
    
    
    
else if (nargin <4) % Challenge B: one waypoint
else %Challenge C: complete chaos
end



global map_points;
map_points = zeros(600,600);
map_points(startpoint) = 1;
map_points(endpoint) = 3;

 
end%KITTControl
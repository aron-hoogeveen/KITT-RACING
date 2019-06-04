maximumLocalizationTime = 300; %Maximum computation time to receive audio location
drivingTime = 3000; %Time the car must drive for step 2 in challenge A in ms (straight line)
x_points = []; % empty array for the points
y_points = []; % empty array for the points

% compute the amount of location points that can be retrieved in driving time
pointsAmount = floor((drivingTime-45)/maximumLocalizationTime); %45 is transmit delay

%%%% EPOCommunications('transmit', KITTspeed); %initiate the driving command
tic
t_loc_start = tic;
for i=1:pointsAmount
    [x, y] = testLocalization;%the duration of this computation is variable
    x_points = [x_points x]; %append the x coordinate to array
    y_points = [y_points y]; %append the y coordinate to array
end
t_loc_elapsed = toc(t_loc_start);
pause((drivingTime - 45)/1000 - t_loc_elapsed);
toc % equal to drivingTime - transmitDelay(= 45)
%%%% stop the car (using smoothstop?)


%%%% Compute the actual orientation and location
% the new location is now:
[x_stop, y_stop] = [x_points(end), y_points(end)];
% We now trek a trend line through the points to calculate the angle



% Test function for Audio location retrieval (simulation)
function [x, y] = testLocalization()
 x = rand(1)*460;
 y = rand(1)*460;
 
 pause(rand(1)/5+0.1); % random compution time betwen 100 and 300 ms

end
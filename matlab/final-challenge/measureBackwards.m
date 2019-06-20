% EPO-4 Group B4
% 19-06-2019
% Measure the distance KITT travels backwards for a certain time

measure = 0; % if measuring is enabled, send the driving commands
time = 500; %ms,  duration KITT drives
transmitDelay = 45; %ms, command send delay

% Driving commands
if (measure) % send the driving commands
    EPOCommunications('transmit', 'M142');
    pause(time-transmitDelay);
    EPOCommunications('transmit', 'M150');
else % construct the interpolated curve
    t_points = [500, 1000, 1500, 2000, 2500, 3000];
    d_points = [8, 38, 91, 149, 223, 259];
    t_samp = 1:10000;
    p = polyfit(t_points, d_points, 2);
    f = polyval(p,t_samp);
end

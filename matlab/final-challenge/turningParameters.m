% EPO-4 Group B4
% 29-05-2019
% Converts measurements into velocity vector for rotation
global v_rot;

%%%% Measurements %%%%%%%%
% For our chosen angle (x degrees):
t_radius = 50;
v_rot_max = 60; % Maximal speed in cm/s
max_speed_time = 200; % Time (ms) after which KITT has reached constant speed


%%%%% Velocity curve fitting %%%%%

% Fit these to polynomial: ax^2 +bx;
% -b/2a = max_speed_time;
% a*max_speed_time^2 + b*max_speed_time = v_rot_max;
b = 2*v_rot_max/max_speed_time;
a = -1*b /(2*max_speed_time);

%10000ms = 10s turning
t = 1:1:10000; 
v_rot = a.*t.^2+b.*t;
v_rot(max_speed_time+1:10000) = v_rot_max;


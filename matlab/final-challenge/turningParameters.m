% EPO-4 Group B4
% 29-05-2019
% Converts measurements into velocity vector for rotation
function [v_rot_prime, t_radius] = turningParameters()

    %%%% Measurements %%%%%%%%
    % For our chosen angle (25 degrees):
    t_radius = 85; % Turning radius (cm)
    v_rot_max =  101.4454; % Maximal speed in cm/s
    max_speed_time = 3200; % Time (ms) after which KITT has reached constant speed


    v_rot_max_ms = v_rot_max/1000; %Maximal speed in cm / ms;
    
    %%%%% Velocity curve fitting %%%%%  
    % Fiting the parameters to to polynomial: at^2 +bt;
  
    % -b/2a = max_speed_time;
    % a*max_speed_time^2 + b*max_speed_time = v_rot_max_ms;
    b = 2*(v_rot_max_ms)/max_speed_time;
    a = -1*b /(2*max_speed_time);
    %10000ms = 10s turning
    t = 1:1:10000; 
    v_rot = a.*t.^2+b.*t;
    v_rot(max_speed_time+1:10000) = v_rot_max_ms;
    
    % To get the distance traveled for time t, we need to integrate v_rot
    for t = 1:10000
        if (t < max_speed_time + 1)
            v_rot_prime(t) = (a/3)*t^3+(b/2)*t^2; % For the polynominal part
        else % For the linear part:
            v_rot_prime(t) = (a/3)*max_speed_time^3+(b/2)*max_speed_time^2 + (v_rot_max_ms)*(t-max_speed_time); 
        end
    end
   
end


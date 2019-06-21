% EPO-4 Group B4
% 07-06-2019
% Convert the turning measurements into parameters for calculateTurn()

function [v_rot, v_rot_prime, t_radius] = turningParameters()
% turningParameters converts measurements into velocity vector for rotation
%
%    [v_rot, v_rot_prime, t_radius] = turningParameters() returns the
%    turning radius <t_radius> of KITT, along with the speed <v_rot> and 
%    distance <t_rot_prime> in the turn.
%

    %%%% Measurements %%%%
    % For our chosen angle (25 degrees):
    t_radius = 85; % Turning radius (cm)
    v_rot_max =  52.3918; %At M158, 101.4454 previously % Maximal speed in cm/s at 17.1-17.2 [V]
    max_speed_time = 1800; % Time (ms) after which KITT has reached constant speed

    v_rot_max_ms = v_rot_max/1000; %Maximal speed in cm / ms;
    
    %%%%% Velocity curve fitting %%%%%  
    % Fiting the parameters to to polynomial: at^2 +bt;
  
    % -b/2a = max_speed_time;
    % a*max_speed_time^2 + b*max_speed_time = v_rot_max_ms;
    b = 2*(v_rot_max_ms)/max_speed_time;
    a = -1*b /(2*max_speed_time);
    %10000ms = 10s turning
    t = 1:1:15000; 
    v_rot = a.*t.^2+b.*t;
    v_rot(max_speed_time+1:15000) = v_rot_max_ms;
    
    % To get the distance traveled for time t, we need to integrate v_rot
    for t = 1:15000
        if (t < max_speed_time + 1)
            v_rot_prime(t) = (a/3)*t^3+(b/2)*t^2; % For the polynominal part
        else % For the linear part:
            v_rot_prime(t) = (a/3)*max_speed_time^3+(b/2)*max_speed_time^2 + (v_rot_max_ms)*(t-max_speed_time); 
        end
    end
   
end


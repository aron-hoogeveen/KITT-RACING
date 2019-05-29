function [turntime, direction, turnEndPos, new_orientation] = calculateTurn(startpoint, destination, orientation)
    % For our chosen angle(20 degrees):
    t_radius = 40;%cm
    v_rot = 60; %speed when rotating in cm per second, assuming constant for now
   
    alfa_begin = tandWithCompensation(destination(2)-startpoint(2),destination(1)-startpoint(1));
    angle_diff = alfa_begin - orientation;
    if (abs(angle_diff) > 180)
        angle_diff = -1*sign(angle_diff)*(360 - abs(angle_diff));
    elseif (angle_diff == 0)
        angle_diff = 1; %otherwise erros will occur, might change this
    end
    direction = sign(angle_diff); % 1 is left, -1 is right
    
    %ride along a circle until both new location and new angle match for t
    found = 0;
    t = 0;
    while found == 0      %5000 ms = 5sec
        t = t+1;
        t_sec = t*0.001;

        theta = orientation+180*direction*t_sec*v_rot/(pi*t_radius);
        x_incr = startpoint(1)+ t_radius*(cosd(theta)-cosd(orientation));
        y_incr = startpoint(2)+ t_radius*(sind(theta)-sind(orientation));
    
        alfa_new = tandWithCompensation((destination(2)-y_incr),(destination(1)-x_incr));
        
        if (abs(theta - alfa_new) < 0.1) %if the angles match
            found = 1;
        end
    end
    
    turntime = t; %ms
    turnEndPos = [x_incr, y_incr];
    new_orientation = theta;
end%turningTime
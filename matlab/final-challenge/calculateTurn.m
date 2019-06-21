% EPO-4 Group B4
% 21-06-2019
% calculateTurn() is used to calculate the turning time at a given speed
% curve and turning radius in order to directly face a destination
function [turntime, direction, turnEndPos, new_orientation, optimizeWrongTurn, outOfField] = calculateTurn(handles, startpoint, destination, orientation, t_radius, v_rot_prime)
% calculateTurn Calculate the turning time for a given speed curve and
% turning radius
%
%    [turntime, direction, turnEndPos, new_orientation, optimizeWrongTurn, outOfField] = calculateTurn(handles, startpoint, destination, orientation, t_radius, v_rot_prime)
%    returns the turning parameters that are needed for KITT to face a
%    <destination> point.
%
%    <t_radius> is given in centimeters
%    <v_rot> is the speed in centimeters per second
    
    outOfField = false; % Will become true if the calculated turn is out of the field 
    reverseChecked = false;
    reverseTwiceChecked = false;
    
    % Calculate the angle of the points and compare to orientation to
    % determine the best turning direction
    alfa_begin = atandWithCompensation(destination(2)-startpoint(2),destination(1)-startpoint(1));
    angle_diff = alfa_begin - orientation;
    if (abs(angle_diff) > 180)
        angle_diff = -1*sign(angle_diff)*(360 - abs(angle_diff));
    elseif (angle_diff == 0)
        angle_diff = 0.1; %otherwise erros will occur, might change this
    end
    direction = sign(angle_diff); % 1 is left, -1 is right
    
    % Track along a circle until both new location and new theta match for t
    optimizeWrongTurn = false;
    found = 0;
    t = 1;
    while found == 0
        t_sec = t*0.001;

        % Formulas for the new orientation and position  
        theta = orientation + 180*direction*v_rot_prime(t)/(pi*t_radius); % The new angle of KITT
        displ_ang = -1*direction*90+orientation; % Displacement angle for driving along a circle
        x_incr = startpoint(1)+ t_radius*(cosd(theta-orientation+displ_ang)-cosd(displ_ang)); % Calculating the new x
        y_incr = startpoint(2)+ t_radius*(sind(theta-orientation+displ_ang)-sind(displ_ang)); % Calculating the new y

        if (abs(theta) > 180)
            theta_lim = theta-sign(theta)*360; %limit theta to -180:180 degrees
        else
            theta_lim = theta;
        end
        
        
        if (optimizeWrongTurn)
           dist = sqrt((x_incr-destination(1))^2 + (y_incr-destination(2))^2);
           if (dist < minDist(1))
               minDist = [dist, t, x_incr, y_incr, theta_lim];
           elseif (dist > minDist(1) + 40)
               t = minDist(2);
               x_incr = minDist(3);
               y_incr = minDist(4);
               theta_lim = minDist(5);
               found = 1;
           end
        end
        

        % Drawing points of the turning trajectory for debugging
        if (~mod(t,200))
                plot(handles.LocationPlot, x_incr, y_incr, 'b.', 'MarkerSize', 5);
        end
        
        % Calculate the new alfa for the change position
        alfa_new = atandWithCompensation((destination(2)-y_incr),(destination(1)-x_incr)); 
        
        if (x_incr > 460-25 || x_incr < 0+25 || y_incr > 460-25 || y_incr < 0+25) % Can occur when turning at waypoint
            outOfField = true;

            if (~reverseChecked)
                % Check if other direction might be possible
                t = 0; % resest the time
                direction = -1*direction;% reverse turn direction
                reverseChecked = true;
            else
                if (~reverseTwiceChecked) % return to original turn (even if wrong)
                    % Check if other direction might be possible
                    t = 0; % resest the time
                    direction = -1*direction;% reverse turn direction
                    reverseTwiceChecked = true;
                end
            end
        end
        dist = sqrt((x_incr-destination(1))^2 + (y_incr-destination(2))^2);
        maximumAngleDifference = acosd(1-100/(2*dist^2)); 
        % If the angles match, stop the turning
        if (abs(theta_lim - alfa_new) < 0.1 || (abs(theta_lim - alfa_new) < maximumAngleDifference && optimizeWrongTurn))
            found = 1;
        end
        
        if (t>14999 && ~optimizeWrongTurn)    
            warning('A suitable turn could not be found (t>10s). Perhaps the start and destination are too close.');           
            disp("A turn as close as possible to the endpoint will now be performed");
            optimizeWrongTurn = true;
            minDist = [1000, 0]; % initialize minDist with big distance
            t = 0; % reset the time
        end
        t = t+1;
    end
    
    % Return variables (direction was determined earlier)
    turntime = t; %ms
    turnEndPos = [x_incr, y_incr];
    new_orientation = theta_lim;
end
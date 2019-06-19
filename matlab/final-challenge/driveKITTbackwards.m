function [] = driveKITTbackwards(offlineCom, offlineLoc, handles, transmitDelay, startpoint, endpoint,orientation, t_radius, v_rot_prime, recordArgs)
% driveKITTbackwards Drives KITT backwards until a turn inside the field
%    can be made.
%
%    [] = driveKITTbackwards(offlineCom, offlineLoc, handles, 
%    transmitDelay, startpoint, endpoint,orientation, t_radius, 
%    v_rot_prime, recordArgs)
%
%    EPO-4 Group B4
%    <insert date of last modification>

    outOfField = true; %initially the turn is out of the field
    velocity = 30;% cm/s    average backwards driving speed
    x_current = startpoint(1);
    y_current = startpoint(2); 
    
    
    while (outOfField) % while the calculated turn is not within the field
        %%%1. CALCULATE TIMINGS
        % Calculate the available space for driving backwards
        Dtop = 460-25-y_current;    % distance from top of field from current position
        Dbottom = y_current-25;     % distance from bottom of field from current position
        Dleft = x_current-25;       % distance from left of field from current position
        Dright = 460-25-x_current;  % distance from right of field from current position
        back_orientation = orientation -180; %backwards orientation
        if(orientation >= 0 && orientation <= 90) %There are two possibilities: The line intersects the bottom first, or the line intersects the left first.
            availableDist = min(abs(Dbottom/sind(back_orientation)),abs(Dleft/cosd(back_orientation)));
        elseif (orientation >= -90 && orientation <= 0) %There are two possibilities: The line intersects the top first, or the line intersects the left first.
            availableDist = min(abs(Dtop/sind(back_orientation)),abs(Dleft/cosd(back_orientation)));
        elseif (orientation >= 90 && orientation <= 180) %There are two possibilities: The line intersects the bottom first, or the line intersects the right first.
            availableDist = min(abs(Dbottom/sind(back_orientation)),abs(Dright/cosd(back_orientation)));
        elseif (orientation >= -180 && orientation <= -90) %There are two possibilities: The line intersects the top first, or the line intersects the right first.
            availableDist = min(abs(Dtop/sind(back_orientation)),abs(Dright/cosd(back_orientation)));
        end
        if (availableDist < 15)
            break % There is no point in driving backwards when there is barely any space
        end

        % Calculate the needed backwards distance to make the turn succeed
        d = 0;
        leftCircleIn = false;
        rightCircleIn = false;
        while (~leftCircleIn && ~rightCircleIn)% while neither of the circles are within the field
            x_moved = x_current + cosd(back_orientation)*d;
            y_moved = y_current + sind(back_orientation)*d;
            midpointCircleLeft = [x_moved+t_radius*cosd(orientation+90), y_moved+t_radius*sind(orientation+90)];
            midpointCircleRight = [x_moved+t_radius*cosd(orientation-90), y_moved+t_radius*sind(orientation-90)];
            
            leftCircleIn = midpointCircleLeft(1) < 460-25-t_radius && midpointCircleLeft(1) > 25+t_radius && midpointCircleLeft(2) < 460-25-t_radius && midpointCircleLeft(2) > 25+t_radius;
            rightCircleIn = midpointCircleRight(1) < 460-25-t_radius && midpointCircleRight(1) > 25+t_radius && midpointCircleRight(2) < 460-25-t_radius && midpointCircleRight(2) > 25+t_radius;
            d = d + 1;
        end
        
        neededDist = d %cm

        % Calculate the distance that will be driven backwards
        % (backwardDistance) in cm
        if (floor(availableDist/2) > neededDist)
            backwardDistance = (availableDist/2);
            if (backwardDistance > neededDist*2) % if backwardDistance is too much
                backwardDistance = neededDist + neededDist/2; % reduce to 1m more than needed
            end
        else
            backwardDistance = neededDist + (availableDist-neededDist)/3; %drive neededDist and a little part of what's left
        end
        disp("KITT will drive backwards with distance:");
        disp(backwardDistance);

        % Calculate backwardTime
        backwardTime = 1000*backwardDistance/velocity %ms
        
        % Calculate predicted end of driving backwards point (backEndPos);
        backEndPos(1) = x_current - backwardDistance*cosd(orientation);
        backEndPos(2) = y_current - backwardDistance*sind(orientation)
        
        %%%2.  DRIVE KITT BACKWARDS for backwardTime;
        EPOCom(offlineCom, 'transmit', 'M142');
        pause(backwardTime/1000 - transmitDelay/1000); % drive for backwardTime
        EPOCom(offlineCom, 'transmit', 'M150');
        pause(backwardTime/4000); % pause for 1/4th of the drivingTime to come to  a stop
        
        %%%3.  REQUEST LOCATION
        x_points = [];
        y_points = [];
        callN = 1;
        i = 1;
        while i < 6
           [x, y, callN] = KITTLocation(offlineLoc, recordArgs, callN);
           
           % Check for validity 
           distToEndPos = sqrt((x-backEndPos(1))^2+(y-backEndPos(2))^2);
           if(distToEndPos < 150)
            x_points = [x_points x];
            y_points = [y_points y];
            disp('added');
            i = i +1;
            plot(handles.LocationPlot, x, y, 'm+',  'MarkerSize', 5, 'linewidth',2); % plot the location point on the map
           else  
               disp('Incorrect location, will request again');
               plot(handles.LocationPlot, x, y, 'k+',  'MarkerSize', 5, 'linewidth',2); % plot the wrong location point on the map
           end
        end
        [x_current, y_current] = averageLocation(x_points, y_points); % store correct actual location in averaged vector
        disp("Current loc:");
                
        %%%4.  Check if new turn can be found
        [~, ~, ~, ~, ~, outOfField] = calculateTurn(handles, [x_current, y_current], endpoint, orientation, t_radius, v_rot_prime);
        % While loop will continue if outOfField is still true
    end%while
end


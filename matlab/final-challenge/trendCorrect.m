function [pathIsGood, turntime, direction, turnEndPos, new_orientation, optimizeWrongTurn] = trendCorrect(handles, x_averaged, y_averaged, endpoint,  t_radius, v_rot_prime, v_rot)
% trendCorrect Creates and plots a trend created from KITT location points
%
%    [pathIsGood, turntime, direction, turnEndPos, new_orientation, optimizeWrongTurn] = trendCorrect(handles, x_averaged, y_averaged, endpoint,  t_radius, v_rot_prime, v_rot)
%    
%    EPO-4 Group B4
%    <insert date of last modification>
    pathIsGood = true; % Assume that current path is right initially
    % Create a trend through last two points
    x_last = [x_averaged(end-1), x_averaged(end)];
    y_last = [y_averaged(end-1), y_averaged(end)];
    
    prms = polyfit(x_last,y_last,1);
    rico = prms(1); % Richtingscoëfficient
    b = prms(2); %intersection of y-axis (y = mx +b)
    phi = atand(rico);
    if (x_averaged(end)-x_averaged(end-1) < 0 && y_averaged(end)-y_averaged(end-1) < 0) %x decreasing, y decreasing
        actual_orientation = phi - 180;
    elseif(x_averaged(end)-x_averaged(end-1) < 0 && y_averaged(end)-y_averaged(end-1) > 0) %x decreasing, y increasing
        actual_orientation = phi+180;
    elseif(x_averaged(end)-x_averaged(end-1) > 0 && y_averaged(end)-y_averaged(end-1) < 0) %x increasing, y decreasing
        actual_orientation = phi;
    else % x increasing, y increasing
        actual_orientation = phi;
    end

    x_samp = [1:460];
    % Extend the trend line with y = rico*x + b to calculate the endpoint difference
    extended_trend = rico*x_samp  +b;
    % The distance from a point (x_p,y_p) to a line m*x +b is |m*x_p - y_p + b|/sqrt(m^2 + 1)
    end_dist_difference = abs(rico*endpoint(1) - endpoint(2) + b)/sqrt(rico^2+1); % distance between endpoint and trend
    
    alfa = atandWithCompensation(endpoint(2)-y_averaged(end),endpoint(1)-x_averaged(end));
    angle_diff = abs(alfa - actual_orientation);
    
    if (end_dist_difference > 10 || angle_diff > 90) %then: calculate a new turn
        pathIsGood = false; % Path deviates from the ideal path: make a corrective turn
        plot(handles.LocationPlot,x_samp, x_samp*rico+b, '--m'); % plot the trend line

        % Calculate a new turn;
        [turntime, direction, turnEndPos, new_orientation, optimizeWrongTurn, ~] = calculateTurn(handles, [x_averaged(end), y_averaged(end)],endpoint,actual_orientation, t_radius, v_rot_prime);
        turnEndSpeed = v_rot(turntime); % Velocity of KITT at the end of the new turn
        
        % Display values
        disp('turning time (ms):');
        disp( turntime);
        disp('[direction (1:left, -1:right), new_orientation] = ');
        disp([direction, new_orientation]);
        disp('turnEndPos (x, y) = ');
        disp( turnEndPos);

    else
        disp('path is good!');
        plot(handles.LocationPlot,x_samp, x_samp*rico+b, '--c');
        turntime = -1;
        direction = -1;
        turnEndPos = -1;
        new_orientation = actual_orientation;
        optimizeWrongTurn = false;
    end
                    

end


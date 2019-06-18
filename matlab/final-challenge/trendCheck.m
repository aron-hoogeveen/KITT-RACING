function [pathIsGood, turntime, direction, turnEndPos, new_orientation] = trendCorrect(handles, x_averaged, y_averaged, endPoint,  t_radius, v_rot_prime);
    prms = polyfit(x_averaged,y_averaged,1);
    rico = prms(1); % Richtingsco�fficient
    b = prms(2); %intersection of y-axis (y = mx +b)
    phi = atand(rico);
    if (x_points(end)-x_points(1) < 0 && y_points(end)-y_points(1) < 0) %x decreasing, y decreasing
        actual_orientation = phi - 180;
    elseif(x_points(end)-x_points(1) < 0 && y_points(end)-y_points(1) > 0) %x decreasing, y increasing
        actual_orientation = phi+180;
    elseif(x_points(end)-x_points(1) > 0 && y_points(end)-y_points(1) < 0) %x increasing, y decreasing
        actual_orientation = phi;
    else % x increasing, y increasing
        actual_orientation = phi;
    end

    x_samp = [1:460];
    % Extend the trend line with y = rico*x + b to calculate the endpoint difference
    extended_trend = rico*x_samp  +b;
    % The distance from a point (x_p,y_p) to a line m*x +b is |m*x_p - y_p + b|/sqrt(m^2 + 1)
    end_dist_difference = abs(rico*endpoint(1) - endpoint(2) + b)/sqrt(rico^2+1); % distance between endpoint and trend

    dist = sqrt((y-endpoint(2))^2+(x-endpoint(1))^2); %distance from endpoint at current location

end


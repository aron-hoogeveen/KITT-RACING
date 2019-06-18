function [x_averaged, y_averaged] = evaluateLocation(offlineLoc, handles, current_orientation, x_averaged, y_averaged, drivingDistance, recordArgs)

    % Compute expected point
    x_expected = x_averaged(end) + cosd(current_orientation)*drivingDistance;
    y_expected = y_averaged(end) + sind(current_orientation)*drivingDistance;
    
 
    % Request 5 new location points
    x_points = [];
    y_points = [];
    for i = 1:5
       [x, y] = KITTlocation(offlineLoc, recordArgs);

       % Check for validity 
       distToLastAveragedPoint = sqrt((x-x_averaged(end))^2+(y-y_averaged(end))^2);
       distToExpectedPoint = sqrt((x-x_expected)^2+(y-y_expected)^2);
       if(distToLastAveragedPoint < drivingDistance + 25)
           if (distToExpectedPoint < 50)
                x_points = [x_points x];
                y_points = [y_points y];
           end
       else 
           i = i -1;
       end
       if (i > 100)
          disp("KITTlocation doesn't give valid points!");
       end
    end   
    % Return the new averaged point
    [x_averaged(end+1), y_averaged(end+1)] = averageLocation(x_points, y_points);
end


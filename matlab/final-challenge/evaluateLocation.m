function [x_averaged, y_averaged] = evaluateLocation(offlineLoc, current_orientation, x_averaged, y_averaged, drivingDistance, recordArgs)

    % Request 5 new location points
    x_points = [];
    y_points = [];
    for i = 1:5
       [x, y] = KITTlocation(offlineLoc, recordArgs);

       % Check for validity 
       distToLastAveragedPoint = sqrt((x-x_averaged(end))^2+(y-y_averaged(end))^2);
       if(distToLastAveragedPoint < drivingDistance + 50)
        
           x_points = [x_points x];
           y_points = [y_points y];
       else 
           i = i -1;
       end
       if (i > 100)
          disp("KITTlocation doesn't give valid points!");
       end
    end     
end


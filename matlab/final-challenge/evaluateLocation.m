function [x_averaged, y_averaged] = evaluateLocation(offlineLoc, handles, current_orientation, x_averaged, y_averaged, drivingDistance, recordArgs, doATurn, turnEndPos)

    % Compute expected point
    if (~doATurn)
        x_expected = x_averaged(end) + cosd(current_orientation)*drivingDistance;
        y_expected = y_averaged(end) + sind(current_orientation)*drivingDistance;
    else
        x_expected = turnEndPos(1);
        y_expected = turnEndPos(2);
    end
    disp('Expected loc:');
    disp(string(x_expected) + " and " + string(y_expected));
 
    % Request 5 new location points
    x_points = [];
    y_points = [];
    i = 1;
    callN = 1; % Initialization of <callN> that is used in KITTLocation when offline mode is used.
    
    if(~doATurn)
        while i < 6
           [x, y, callN] = KITTLocation(offlineLoc, recordArgs, callN);

           % Check for validity 
           distToLastAveragedPoint = sqrt((x-x_averaged(end))^2+(y-y_averaged(end))^2);
           distToExpectedPoint = sqrt((x-x_expected)^2+(y-y_expected)^2);
           if(distToLastAveragedPoint < drivingDistance + 40 && distToExpectedPoint < 50)

                    x_points = [x_points x];
                    y_points = [y_points y];
                    plot(handles.LocationPlot, x, y, 'm+',  'MarkerSize', 5, 'linewidth',2); % plot the location point on the map
                    i = i +1;
           else
                    disp('Incorrect location, will request again');
                    plot(handles.LocationPlot, x, y, 'k+',  'MarkerSize', 5, 'linewidth',2); % plot the wrong location point on the map

           end
           if (i > 100)
              disp("KITTLocation doesn't give valid points!");
           end
        end%while
    else
         while i < 6
           [x, y, callN] = KITTLocation(offlineLoc, recordArgs, callN);
           
           % Check for validity 
           distToTurnEndPos = sqrt((x-turnEndPos(1))^2+(y-turnEndPos(2))^2);
           if(distToTurnEndPos < 85)
            x_points = [x_points x];
            y_points = [y_points y];
            disp('added');
            i = i +1;
            plot(handles.LocationPlot, x, y, 'm+',  'MarkerSize', 5, 'linewidth',2); % plot the location point on the map
           else  
               disp('Incorrect location, will request again');
               plot(handles.LocationPlot, x, y, 'k+',  'MarkerSize', 5, 'linewidth',2); % plot the wrong location point on the map
           end
         end%while
    end
    
    % Return the new averaged point
    [x_averaged(end+1), y_averaged(end+1)] = averageLocation(x_points, y_points);
end


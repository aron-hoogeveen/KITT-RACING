function [x, y, callN] = KITTLocation(offline, turnEndPos, endpoint, rep, callN, testCase, recordArgs, Fs)
%[] = retrieveAudioLocationFIXME_exlacmationmark(argin) returns an x and y
%    coordinate. When <offline>==true then the function will return sample
%    data. If <offline>==false than this function calls the function that
%    requests the real time location of the car.

% Input error checking
if (nargin < 1)
    error('Not enough input arguments!');
elseif (nargin < 2)
    if (offline)
        error('turnEndPos needed for offline mode');
    end
elseif (nargin < 3)
    rep = 1; % Number of repitions of requesting the location
elseif (nargin > 2)
    if (rep < 0)
        error ('Number of repititions need to be larger than zero!');
    end
end
if (offline)
    if (nargin < 6)
        testCase = 0;
    end
end
if (offline)
    %TODO read out sample data from a file and output the next coordinates
    % everytime the function is called. 
    if (testCase == 0)
        % The car drives at a constant speed in a straight line to the
        % endpoint.
        if (floor(turnEndPos(1)) < endpoint(1))
            x_samp = [floor(turnEndPos(1)):(abs(floor(turnEndPos(1))-endpoint(1))/14):endpoint(1)];
            %disp("[floor(turnEndPos(1)):(abs(floor(turnEndPos(1))-endpoint(1))/14)-1:endpoint(1)]" + newline +...
            %    "[" + string(floor(turnEndPos(1))) + ":" + string(abs(floor(turnEndPos(1))-endpoint(1))/14) + ":" +...
            %    string(endpoint(1)) + "]");
        else
            x_samp = fliplr([floor(endpoint(1)):(abs(floor(endpoint(1))-turnEndPos(1))/14):turnEndPos(1)]);
        end
        if (floor(turnEndPos(2) < endpoint(2)))
            y_samp = [floor(turnEndPos(2)):(abs(floor(turnEndPos(2))-endpoint(2))/14):endpoint(2)];
        else
            y_samp = fliplr([floor(endpoint(2)):(abs(floor(endpoint(2))-turnEndPos(2))/14):turnEndPos(2)]);
        end
        
        pause(0.1) % simulate duration of computation time
        
%         x = x_samp(callN);
%         y = y_samp(callN);
    elseif (testCase == 1)
        % The car does not have the right angle after comming out of the
        % turn. KITTControl should act on this info and correct the angle.
        % Since this case will only be performed offline, it is not
        % necessary to let the orientation of the car at the end of the
        % turn and the next orientation be the same. So if the orientation
        % after the turn is right (0 degrees) and in the following
        % datapoints it is more to the north (90 degrees) it is no problem.

        % The distance between the trajectory of the car and the endpoint
        % should be greater than 10 cm to trigger a steering correction. 
        % Set the deviation to 15 cm and calculate the new end point using
        % Pythagoras
        dist  = sqrt((endpoint(1)-turnEndPos(1))^2 + (endpoint(2)-turnEndPos(2))^2);
        deviation = dist/10;

        if (dist < 100) 
            deviation = 0;
        end
        fakeendpoint = [endpoint(1)-deviation, endpoint(2)]; %the endpoint deviation is dependent on the distance from the endpoint
        endpoint = fakeendpoint;
        if (floor(turnEndPos(1)) < endpoint(1))
            x_samp = [floor(turnEndPos(1)):(abs(floor(turnEndPos(1))-endpoint(1))/14):endpoint(1)];
            %disp("[floor(turnEndPos(1)):(abs(floor(turnEndPos(1))-endpoint(1))/14)-1:endpoint(1)]" + newline +...
            %    "[" + string(floor(turnEndPos(1))) + ":" + string(abs(floor(turnEndPos(1))-endpoint(1))/14) + ":" +...
            %    string(endpoint(1)) + "]");
        else
            x_samp = fliplr([floor(endpoint(1)):(abs(floor(endpoint(1))-turnEndPos(1))/14):turnEndPos(1)]);
        end
        if (floor(turnEndPos(2) < endpoint(2)))
            y_samp = [floor(turnEndPos(2)):(abs(floor(turnEndPos(2))-endpoint(2))/14):endpoint(2)];
        else
            y_samp = fliplr([floor(endpoint(2)):(abs(floor(endpoint(2))-turnEndPos(2))/14):turnEndPos(2)]);
        end
    else
        error('Invalid <testCase> option!');
    end%testCase
    
    if (callN < length(x_samp))
        x = x_samp(callN);
        y = y_samp(callN);
    else
        x = x_samp(end);
        y = y_samp(end);
    end
    
    callN = callN+1;
    pause(0.1) % simulate duration of computation time
    
    
else
    % Online
%     warning("The real time location function has not been added yet!" + newline +...
%         "    The value of the returned <x> and <y> is NaN.");
%     x = NaN; y = NaN;
%     callN = callN + 1;
    % Retrieve the coordinates of the KITT car
    
    [coord, ~] = Record_TDOA(recordArgs.ref, recordArgs.peakperc, recordArgs.mic, recordArgs.d, recordArgs.peakn, Fs);
    x = coord(1);
    y = coord(2);
    callN = callN;
    pause(0.1) % simulate duration of computation time
end

end%KITTLocation
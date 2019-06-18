function [x, y, callN] = KITTLocation(offline, turnEndPos, endpoint, rep, callN, testCase, recordArgs)
%[] = KITTLocation(argin) returns an x and y
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

        turnMoreLeft = true; % KITT's turns end in a path left to the endpoint, if false: KITT is headed more to the right of endpoint
        
        % The distance between the trajectory of the car and the endpoint
        % should be greater than 10 cm to trigger a steering correction. 
        dist  = sqrt((endpoint(1)-turnEndPos(1))^2 + (endpoint(2)-turnEndPos(2))^2); %Distance between KITT and endpoint
        deviation = dist/8; %The deviation of the endpoint of the simulated path is dependent on the distance
        
        % shifts a lot with small changes in x, due to a high value of m in y = mx+b
        % Calculate at what location the deviated endpoint must be to be perpendicular to the start-end line
        prms = polyfit([turnEndPos(1), endpoint(1)],[turnEndPos(2), endpoint(2)],1);
        rico = prms(1); % Richtingscoëfficient
        m = (-1/rico); % m_idealpath * m_perpendicular = -1 (m = m_perpendicular on this line)
        b = endpoint(2) - m * endpoint(1); % follows from y = mx+b
        
        % The calculation that leads to these equations for the A*X^2 + BX + C
        % formula can be found in the report
        A = m^2 + 1;
        B = (2*b*m - 2*endpoint(1)-2*endpoint(2)*m);
        C = b^2 + -2*b*endpoint(2) + endpoint(1)^2 + endpoint(2)^2 - deviation^2;
        D = B^2 - 4*A*C;
         
        % The fake endpoint can be located on two sides of the actual endpoint:
        if (turnMoreLeft)
         x_deviation = (-B - sqrt(D))/(2*A); %new fake endpoint (X)
        else
         x_deviation = (-B + sqrt(D))/(2*A); %new fake endpoint (X)
        end
        y_deviation = floor(m*x_deviation+b); %new fake endpoint (Y)
        x_deviation = floor(x_deviation);
             
        fakeendpoint = [x_deviation, y_deviation];
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
    
    if (callN <= length(x_samp))
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
    
    [coord, ~] = Record_TDOA(recordArgs.ref, recordArgs.peakperc, recordArgs.mic, recordArgs.d, recordArgs.peakn, recordArgs.Fs);
    x = coord(1);
    y = coord(2);
    callN = callN;
end

end%KITTLocation
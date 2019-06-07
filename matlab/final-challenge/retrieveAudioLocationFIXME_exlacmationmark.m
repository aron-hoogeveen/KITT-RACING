function [x, y, callN] = retrieveAudioLocationFIXME_exlacmationmark(offline, turnEndPos, endpoint, rep, callN)
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
    %TODO read out sample data from a file and output the next coordinates
    % everytime the function is called. 
    % For the time being this function only returns a static [x, y] value
    % in offline mode
    if (floor(turnEndPos(1)) < endpoint(1))
        x_samp = [floor(turnEndPos(1)):(abs(floor(turnEndPos(1))-endpoint(1))/14):endpoint(1)];
        disp("[floor(turnEndPos(1)):(abs(floor(turnEndPos(1))-endpoint(1))/14)-1:endpoint(1)]" + newline +...
            "[" + string(floor(turnEndPos(1))) + ":" + string(abs(floor(turnEndPos(1))-endpoint(1))/14) + ":" +...
            string(endpoint(1)) + "]");
    else
        x_samp = fliplr([floor(endpoint(1)):(abs(floor(endpoint(1))-turnEndPos(1))/14):turnEndPos(1)]);
    end
    if (floor(turnEndPos(2) < endpoint(2)))
        y_samp = [floor(turnEndPos(2)):(abs(floor(turnEndPos(2))-endpoint(2))/14):endpoint(2)];
    else
        y_samp = fliplr([floor(endpoint(2)):(abs(floor(endpoint(2))-turnEndPos(2))/14):turnEndPos(2)]);
    end
    
    if (callN < length(x_samp))
        x = x_samp(callN);
        y = y_samp(callN);
    else
        x = x_samp(end);
        y = y_samp(end);
    end
    
    callN = callN+1;
    
    
else
    % Online
    warning("The real time location function has not been added yet!" + newline +...
        "    The value of the returned <x> and <y> is NaN.");
    x = NaN; y = NaN;
end

end%retrieveAudioLocationFIXME_exlacmationmark
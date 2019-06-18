function [x, y, callN] = KITTLocation(offline, turnEndPos, endpoint, rep, callN, testCase, recordArgs, pointsAmount)
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
    % Ask the user to supply a location
    user_input = input('Please enter a new location: [x, y]=');

    x = user_input(1);
    y = user_input(2);
    callN = callN; % FIXME: <callN> can be removed. It is no longer in use
    pause(0.2) % simulate duration of computation time
else
    % Online
%     warning("The real time location function has not been added yet!" + newline +...
%         "    The value of the returned <x> and <y> is NaN.");
%     x = NaN; y = NaN;
%     callN = callN + 1;
    % Retrieve the coordinates of the KITT car
    
    [coord, ~] = Record_TDOA(recordArgs.ref, recordArgs.peakperc, recordArgs.mic, recordArgs.d, recordArgs.peakn, recordArgs.Fs, recordArgs.Fbit, recordArgs.RepCount, recordArgs.RecTime);
    x = coord(1);
    y = coord(2);
    callN = callN;
end

end%KITTLocation
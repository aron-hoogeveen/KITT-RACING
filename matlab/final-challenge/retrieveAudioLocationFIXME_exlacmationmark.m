function [x, y] = retrieveAudioLocationFIXME_exlacmationmark(offline, rep)
%[] = retrieveAudioLocationFIXME_exlacmationmark(argin) returns an x and y
%    coordinate. When <offline>==true then the function will return sample
%    data. If <offline>==false than this function calls the function that
%    requests the real time location of the car.

% Input error checking
if (nargin < 1)
    error('Not enough input arguments!');
elseif (nargin < 2)
    rep = 1; % Number of repitions of requesting the location
elseif (nargin > 1)
    if (rep < 0)
        error ('Number of repititions need to be larger than zero!');
    end
end

if (offline)
    %TODO read out sample data from a file and output the next coordinates
    % everytime the function is called. 
    % For the time being this function only returns a static [x, y] value
    % in offline mode
    x = 50+460*rand(1); y = 50+460*rand(1);
else
    % Online
    warning("The real time location function has not been added yet!" + newline +...
        "    The value of the returned <x> and <y> is NaN.");
    x = NaN; y = NaN;
end

end%retrieveAudioLocationFIXME_exlacmationmark
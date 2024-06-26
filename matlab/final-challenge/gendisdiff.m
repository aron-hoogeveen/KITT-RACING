% gendisdiff
% Author: Rik van der Hoorn - 4571150
% Last modified: 18-06-19
% Status: complete, commented and tested
%
% Generates the range differences between microphones and the
% audio beacon of the car in 3d (heigth audio beacon = 24.8cm)
% with possibility of adding a simulated measurement error.
% Coordinates and distances are in cm!
%
% function: disdiff = gendisdiff(mic,loc,error)
% Inputs:   mic = coordinates of the microphones
%           loc = location of audio beacon of the car [x y z]
%           error = uniformly distributed random error between -error and
%                   error added to the distance between mic(i) and car
% Output:   disdiff = range differences between microphones and car,
% (for 5 microphones: [r12; r13; r14; r15; r23; r24; r25; r34; r35; r45])

function disdiff = gendisdiff(mic,loc,error)
[nmic,~] = size(mic);                   % number of microphones

dis = zeros(nmic,1);
for i = 1:nmic
    dis(i) = norm(mic(i,:)-loc);        % distance (range) between mic(i) and car
end

diserror = -error + 2*error*rand(nmic,1);   % uniformly distributed random numbers between -error and error
dis = dis + diserror;                   % error added to simulate measurement errors

neq = sum(1:nmic-1);                    % number of range differences pairs
disdiff = zeros(neq,1);                 % create empty vector
g = 1;
for n = 1:nmic-1
    for k = n+1:nmic
        disdiff(g) = dis(k)-dis(n);     % range differences between microphones and car
        g = g + 1;
    end
end
end
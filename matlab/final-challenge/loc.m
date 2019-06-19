% loc
% Author: Rik van der Hoorn - 4571150
% Last modified: 05-06-19
% Status: complete, commented and tested

% Estimation of the location of the car, done with range difference
% between microphones and car using least squares algorithm.
% Works both for 4 and 5 microphones and can do 2D and 3D estimation
% Coordinates and distances are in cm!

% Inputs:   mic = coordinates of the microphones
%           disdiff = range difference between microphones and car
%           d = 2 for 2D estimation or 3 for 3D estimation
% Output:   coord = coordinates of car

function coord = loc(mic,disdiff,d)
mic = mic(:,1:d);           % selects 2D or 3D coordinates of the microphones
[nmic,~] = size(mic);       % determine number of microphones
neq = sum(1:nmic-1);        % determine number of expected range difference pairs

%% checks if number of range difference pairs matches number of microphones used
if neq ~= length(disdiff)
    errordlg('Incorrect number of microphones or range difference pairs')
end

%% calculation of A matrix
micdisdiff = zeros(neq,d);  % calculate first 'd' columns of matrix A
g = 1;
for n = 1:nmic-1
    for t = n+1:nmic
        micdisdiff(g,:) = mic(t,:)-mic(n,:);    % distance between mic(k) and mic(n)
        g = g + 1;
    end
end

Amat = zeros(neq,d+nmic-1);         % generate an empty matrix A
Amat(:,1:d) = micdisdiff;           % fill in first 'd' columns

r = 1;
for t = 1:nmic-1
    for v = t+1:nmic
        Amat(r,d+v-1) = -disdiff(r);    % fill in range difference between microphones and car
        r = r + 1;
    end 
end

Amat = 2*Amat;

%% calculation of b vector
disdiffsq = disdiff.^2;         % range difference between microphones and car squared

micdissq = zeros(nmic,1);
for i = 1:nmic
micdissq(i) = norm(mic(i,:))^2;     % distance microphone from [0 0 0] squared
end

bvec = zeros(neq,1);        % generate empty vector b
r = 1;
for t = 1:nmic-1
    for v = t+1:nmic
        bvec(r) = disdiffsq(r)-micdissq(t)+micdissq(v);    % fill in vector b
        r = r + 1;
    end 
end

%% calculation of y vector

Amatinv = pinv(Amat);               % pseudo-inverse of A
yvec = Amatinv*bvec;                % calculate y vector
coord = yvec(1:d);                  % extract coordinates
end
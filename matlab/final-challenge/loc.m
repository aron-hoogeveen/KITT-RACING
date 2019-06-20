% loc
% Author: Rik van der Hoorn - 4571150
% Last modified: 18-06-19
% Status: complete, commented and tested
%
% Estimation of the location of the car, done with range differences
% between microphones and car using least squares algorithm.
% Works both for 4 and 5 microphones and can do 2D and 3D estimation.
% The systematic error that is introduced when using 2D estimation
% with 5 microphones in the predetermined EPO-4 setup can be corrected.
% Coordinates and distances are in cm!
%
% function: coord = loc(mic,disdiff,d,transmap,check)
% Inputs:   mic = coordinates of the microphones
%           disdiff = range differences between microphones and car
%           d = 2 for 2D estimation or 3 for 3D estimation
%           transmap = translation map used to correct the estimated location,
%                      if transmap = 0, there will be no correction done
%           check = if check is nonzero, plots figures to debug
% Output:   coord = coordinate of car with possible correction

function coord = loc(mic,disdiff,d,transmap,check)
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

Amat = zeros(neq,d+nmic-1);             % generate an empty matrix A
Amat(:,1:d) = micdisdiff;               % fill in first 'd' columns

r = 1;
for t = 1:nmic-1
    for v = t+1:nmic
        Amat(r,d+v-1) = -disdiff(r);    % fill in range differences
        r = r + 1;
    end 
end

Amat = 2*Amat;

%% calculation of b vector
disdiffsq = disdiff.^2;         % range differences squared

micdissq = zeros(nmic,1);
for i = 1:nmic
micdissq(i) = norm(mic(i,:))^2; % distance microphone from [0 0 0] squared
end

bvec = zeros(neq,1);            % generate empty vector b
r = 1;
for t = 1:nmic-1
    for v = t+1:nmic
        bvec(r) = disdiffsq(r)-micdissq(t)+micdissq(v);    % fill in vector b
        r = r + 1;
    end 
end

%% calculation of y vector

Amatinv = pinv(Amat);           % pseudo-inverse of A
yvec = Amatinv*bvec;            % calculate y vector
estloc = yvec(1:d);             % extract coordinates of estimated location

%% correction for 2d estimation with 5 microphones
transmaplin = transmap(:);      % convert transmap to column vector  
if d == 2 && nmic == 5 && max(transmaplin) ~= 0 % check if correction is possible
    xmap = estloc(1) - transmap(:,:,1);	% map to determine x coordinate
    ymap = estloc(2) - transmap(:,:,2);	% map to determine y coordinate
    addmap = abs(xmap)+abs(ymap);       % combines optimum x and y coordinate
    addmaplin = addmap(:);              % convert addmap to column vector
    [~,Ind] = min(addmaplin);           % find index of the minimum value
    [coord(2),coord(1)] = ind2sub(size(addmap),Ind); % convert index to row and column
    coord = coord - 1;                  % coordinate of car
else
    coord = estloc';                    % if no correction is possible
end

%% plot figures to debug when requested
if check && d == 2 && nmic == 5 && max(transmaplin) ~= 0
    lim = 25;                       % limit colorbar
    color1 = jet(1000);             % color schemes
    color2 = color1(501:1000,:);

    figure
    imagesc(xmap);                  % plot xmap
    colormap(color1);               % set color scheme of image
    set(gca,'YDir','normal')        % reverse y-axis
    xlabel('X-coordinate field [cm]')
    ylabel('Y-coordinate field [cm]')
    title('Difference between x-coordinate and x-value of translation map [cm]')
    grid on
    colorbar
    caxis([-lim lim])               % limits colorbar

    figure
    imagesc(ymap);                  % plot ymap
    colormap(color1);               % set color scheme of image
    set(gca,'YDir','normal')        % reverse y-axis
    xlabel('X-coordinate field [cm]')
    ylabel('Y-coordinate field [cm]')
    title('Difference between y-coordinate and y-value of translation map [cm]')
    grid on
    colorbar
    caxis([-lim lim])               % limits colorbar

    figure
    imagesc(addmap);                % plot addmap
    colormap(color2);               % set color scheme of image
    set(gca,'YDir','normal')        % reverse y-axis
    xlabel('X-coordinate field [cm]')
    ylabel('Y-coordinate field [cm]')
    title('Absolute differences of x and y-coordinates and translation map [cm]')
    grid on
    colorbar
    caxis([0 lim])                  % limits colorbar
end
end
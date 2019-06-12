% locerrorcor
% Author: Rik van der Hoorn - 4571150
% Last modified: 11-06-19
% Status: in progress

% Corrects for the systematic error that is introduced when using 2d
% estimation with 5 microphones in the predetermined EPO-4 setup

% Inputs:   cormap = correction map used to correct the estimated location
%           estloc = estimated location without location correction
% Output:   coord = coordinates of the corrected location

clear all
close all

%% load microphone locations and specify parameters (in cm!)
load('test1.mat')           % 2d - 5 mic bias location estimation data
load('datamicloc')          % locations microphones
mic = mic([1 2 3 4 5],:);   % select microphones used
d = 2;                      % 2D or 3D location estimation
loccar = [0 230 24.8];    % location audio beacon of the car
lim = 25;                   % limit of colorbar
measerror = 3;              % error added when calculating disdiff
n = 1;

xlocationi = 0;
ylocationi = 0;
coordn = 0;
count = 0;

for i = 1:n

disdiff = gendisdiff(mic,loccar,measerror);   % generate the range difference pairs
coord = loc(mic,disdiff,d);                     % calculate the estimated location

%magcoordmat = vecnorm(coordmat(:,:,[1 2]),2,3);

xtest = coord(1) - coordmat(:,:,1);
ytest = coord(2) - coordmat(:,:,2);
%magtest = norm(coord) - magcoordmat;
xtestabs = abs(xtest);

[Mx,Ix] = min(abs(xtest),[],2);
[My,Iy] = min(abs(ytest),[],1);

% location = 
for i = 1:461
    test = Ix(i);
    if i == Iy(test)
        cross(1) = test-1;
        cross(2) = i-1;
        count = count + 1;
        break
    end
end

coordn = coordn + coord;

xlocationi = xlocationi + cross(1);
ylocationi = ylocationi + cross(2);
end

count
coordavg = coordn'./n
locationavg = [xlocationi ylocationi]./n

%%
% color1 = jet(1000);             % color schemes
% 
% figure
% imagesc(xtest);                % error of x coordinate estimation
% hold on
% plot(Ix,0:460, 'r--')
% colormap(color1);               % set color scheme of image
% set(gca,'YDir','normal')        % reverse y-axis
% xlabel('x-coordinate field')
% ylabel('y-coordinate field')
% colorbar
% caxis([-lim lim])
% 
% figure
% imagesc(ytest);                % error of x coordinate estimation
% hold on
% plot(Iy, 'r--')
% colormap(color1);               % set color scheme of image
% set(gca,'YDir','normal')        % reverse y-axis
% xlabel('x-coordinate field')
% ylabel('y-coordinate field')
% colorbar
% caxis([-lim lim])
% 
% figure
% imagesc(magtest);                % error of x coordinate estimation
% hold on
% plot(Ix,0:460, 'r--')
% plot(Iy, 'r--')
% colormap(color1);               % set color scheme of image
% set(gca,'YDir','normal')        % reverse y-axis
% xlabel('x-coordinate field')
% ylabel('y-coordinate field')
% colorbar
% caxis([-lim lim])

%% 2d 5 mic, bias filter
% to find value in a matrix closed to calculated value:
% substract calculated value from matrix
% [value index] = min(abs(matrix - calculated value),'all')
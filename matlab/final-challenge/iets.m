% iets
% Author: Rik van der Hoorn - 4571150
% Last modified: 08-06-19
% Test file for calculating what the error is in location estimation,
% when calculating the location with a testcase for 2D or 3D estimation
% with possibility to add error using the least squares algorithm

clear all
close all

%% load microphone locations and specify parameters (in cm!)
load('test1.mat')           % 2d - 5 mic bias location estimation data
load('datamicloc')          % locations microphones
mic = mic([1 2 3 4 5],:);   % select microphones used
d = 2;                      % 2D or 3D location estimation
loccar = [430 210 24.8];    % location audio beacon of the car
lim = 25;                   % limit of colorbar
measerror = 0;              % error added when calculating disdiff
n = 1;

xlocationi = 0;
ylocationi = 0;

for i = 1:n

disdiff = gendisdiff(mic,loccar,measerror);   % generate the range difference pairs
coord = loc(mic,disdiff,d);                     % calculate the estimated location

magcoordmat = vecnorm(coordmat(:,:,[1 2]),2,3);

xtest = coord(1) - coordmat(:,:,1);
ytest = coord(2) - coordmat(:,:,2);
magtest = norm(coord) - magcoordmat;
xtestabs = abs(xtest);

[Mx,Ix] = min(abs(xtest),[],2);
[My,Iy] = min(abs(ytest),[],1);

% location = 
reeks = 1:461;
woopx = Ix' - reeks;
[a xlocation] = min(abs(woopx));

woopy = Iy - reeks;
[b ylocation] = min(abs(woopy));

xlocationi = xlocationi + xlocation;
ylocationi = ylocationi + ylocation;
end

locationavg = [xlocationi ylocationi]./n

%%
color1 = jet(1000);             % color schemes

figure
imagesc(xtest);                % error of x coordinate estimation
hold on
plot(Ix,0:460, 'r--')
colormap(color1);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
colorbar
caxis([-lim lim])

figure
imagesc(ytest);                % error of x coordinate estimation
hold on
plot(Iy, 'r--')
colormap(color1);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
colorbar
caxis([-lim lim])

figure
imagesc(magtest);                % error of x coordinate estimation
hold on
plot(Ix,0:460, 'r--')
plot(Iy, 'r--')
colormap(color1);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
colorbar
caxis([-lim lim])

%% 2d 5 mic, bias filter
% to find value in a matrix closed to calculated value:
% substract calculated value from matrix
% [value index] = min(abs(matrix - calculated value),'all')
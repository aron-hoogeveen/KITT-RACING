% testlocerror
% Author: Rik van der Hoorn - 4571150
% Last modified: 08-06-19
% Test file for calculating what the error is in location estimation,
% when calculating the location with a testcase for 2D or 3D estimation
% with possibility to add error using the least squares algorithm

clear all
close all

%% load microphone locations and specify parameters (in cm!)
load('datamicloc')          % locations microphones
mic = mic([1 2 3 4 5],:);   % select microphones used
d = 2;                      % 2D or 3D location estimation
z = 24.8;                   % heigth audio beacon of the car
lim = 25;                   % limit of colorbar
measerror = 3;              % error added when calculating disdiff

%% calcutate the error of the location estimation
coordmat = zeros(460,460,d); % matrix containing the estimated location with 1 cm resolution
locmat = zeros(460,460,d);

for y = 0:460
    for x = 0:460
        location = [x y z];
        disdiff = gendisdiff(mic,location,measerror);   % generate the range difference pairs
        coord = loc(mic,disdiff,d);                     % calculate the estimated location
        coordmat(y+1,x+1,:) = coord;
        locmat(y+1,x+1,:) = location(1:d)';
    end
end

errormat = coordmat - locmat;

xerror = errormat(:,:,1);                      % error of x coordinate estimation
yerror = errormat(:,:,2);                      % error of y coordinate estimation
magerror = vecnorm(errormat(:,:,[1 2]),2,3);   % magnitude of error coordinate estimation

meanxerror = mean(abs(xerror),'all');
meanyerror = mean(abs(yerror),'all');
meanmagerror = mean(magerror,'all')
medianxerror = median(abs(xerror),'all');
medianyerror = median(abs(yerror),'all');
medianmagerror = median(magerror,'all')

%% plot the error of the location estimation
color1 = jet(1000);             % color schemes
color2 = color1(501:1000,:);

figure
imagesc(xerror);                % error of x coordinate estimation
colormap(color1);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
title(sprintf('Error of estimated x-coordinate %dD [cm]',d))
colorbar
caxis([-lim lim])               % limits colorbar

figure
imagesc(yerror);                % error of y coordinate estimation
colormap(color1);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
title(sprintf('Error of estimated y-coordinate %dD [cm]',d))
colorbar
caxis([-lim lim])               % limits colorbar

figure
imagesc(magerror);              % magnitude of error coordinate estimation
colormap(color2);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
title(sprintf('Magnitude of error of estimated coordinate %dD [cm]',d))
colorbar
caxis([0 lim])                  % limits colorbar

%% correction for 2d bias
[nmic,~] = size(mic);

if d == 2 && nmic == 5
xerrornoise = xerror;
yerrornoise = yerror;

load('D:\OneDrive\Studie\EE2\Q4 EE2L21 EPO-4 KITT Autonomous Driving Challenge 18-19\Module 3\test_data\locdata\noiseless2dlocerror.mat')
xerrorbias = xerror;
yerrorbias = yerror;
errorbias(:,:,1) = xerrorbias;
errorbias(:,:,2) = yerrorbias;
magerrorbias = vecnorm(errorbias(:,:,[1 2]),2,3);

meanxerrorbias = mean(abs(xerrorbias),'all');
meanyerrorbias = mean(abs(yerrorbias),'all');
meanmagerrorbias = mean(magerrorbias,'all');
medianxerrorbias = median(abs(xerrorbias),'all');
medianyerrorbias = median(abs(yerrorbias),'all');
medianmagerrorbias = median(magerrorbias,'all');

xerror = xerrornoise - xerrorbias;
yerror = yerrornoise - yerrorbias;
error(:,:,1) = xerror;
error(:,:,2) = yerror;
magerror = vecnorm(error(:,:,[1 2]),2,3);

meanxerrornoise = mean(abs(xerror),'all');
meanyerrornoise = mean(abs(yerror),'all');
meanmagerrornoise = mean(magerror,'all');
medianxerrornoise = median(abs(xerror),'all');
medianyerrornoise = median(abs(yerror),'all');
medianmagerrornoise = median(magerror,'all');

figure
imagesc(xerrorbias);                % error of x coordinate estimation
colormap(color1);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
title(sprintf('Error of estimated x-coordinate %dD [cm]',d))
colorbar
caxis([-lim lim])               % limits colorbar

figure
imagesc(yerrorbias);                % error of y coordinate estimation
colormap(color1);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
title(sprintf('Error of estimated y-coordinate %dD [cm]',d))
colorbar
caxis([-lim lim])               % limits colorbar

figure
imagesc(magerrorbias);              % magnitude of error coordinate estimation
colormap(color2);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
title(sprintf('Magnitude of error of estimated coordinate %dD [cm]',d))
colorbar
caxis([0 lim])                  % limits colorbar

figure
imagesc(xerror);                % error of x coordinate estimation
colormap(color1);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
title(sprintf('Error of estimated x-coordinate %dD [cm]',d))
colorbar
caxis([-lim lim])               % limits colorbar

figure
imagesc(yerror);                % error of y coordinate estimation
colormap(color1);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
title(sprintf('Error of estimated y-coordinate %dD [cm]',d))
colorbar
caxis([-lim lim])               % limits colorbar

figure
imagesc(magerror);              % magnitude of error coordinate estimation
colormap(color2);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('x-coordinate field')
ylabel('y-coordinate field')
title(sprintf('Magnitude of error of estimated coordinate %dD [cm]',d))
colorbar
caxis([0 lim])                  % limits colorbar
end

%% 2d 5 mic, bias filter
% to find value in a matrix closed to calculated value:
% substract calculated value from matrix
% [value index] = min(abs(matrix - calculated value),'all')

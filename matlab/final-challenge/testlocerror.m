% testlocerror
% Author: Rik van der Hoorn - 4571150
% Last modified: 08-06-19
% Test file for calculating what the error is in location estimation 
% for the entire field. With a testcase for 2D and 3D estimation, 
% with possibility to add error, using the least squares algorithm.
% Also correction for the systematic error that is introduced when using
% 2D estimation with 5 microphones can be checked.
% Coordinates and distances are in cm!

clear all
close all

%% load data and specify parameters (in cm!)
load('transmap.mat')        % translation map for 2D with 5 microphones
transmap = 0;               % uncomment to prevent correction
load('datamicloc')          % coordinates of the microphones
mic = mic([1 2 3 4 5],:);   % select microphones used
z = 24.8;                   % heigth of audio beacon of the car
measerror = 0;              % random error added when calculating disdiff
d = 2;                      % 2 for 2D estimation or 3 for 3D estimation

%% calcutate the error of the location estimation
estlocmat = zeros(460,460,d);   % contains the estimated locations
actlocmat = zeros(460,460,d);   % contains the actual locations

for y = 0:460
    for x = 0:460
        location = [x y z];     % location of audio beacon of the car [x y z]
        disdiff = gendisdiff(mic,location,measerror);	% generates the range differences
        coord = loc(mic,disdiff,d,transmap,0);	% calculate the estimated location
        estlocmat(y+1,x+1,:) = coord;
        actlocmat(y+1,x+1,:) = location(1:d);
    end    
end
errormat = estlocmat - actlocmat;   % error of the estimated location

%% data analysis
xerror = errormat(:,:,1);                   % error of x-coordinate estimation
yerror = errormat(:,:,2);                   % error of y-coordinate estimation
magerror = vecnorm(errormat(:,:,[1 2]),2,3);% magnitude of error of the estimation

% calculate the mean
meanxerror = mean(xerror,'all');
meanyerror = mean(yerror,'all');
meanmagerror = mean(magerror,'all');
% calculate the median
medianxerror = median(xerror,'all');
medianyerror = median(yerror,'all');
medianmagerror = median(magerror,'all');
% calculate the standard deviation
stdxerror = std(xerror,0,'all');
stdyerror = std(yerror,0,'all');
stdmagerror = std(magerror,0,'all');

%% plot the error of the location estimation
collim = 25;                    % limit colorbar
color1 = jet(1000);             % color schemes
color2 = color1(501:1000,:);

figure
imagesc(xerror);                % error of x-coordinate estimation
colormap(color1);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('X-coordinate field [cm]')
ylabel('Y-coordinate field [cm]')
title(sprintf('Error of estimated x-coordinate %dD [cm]',d))
grid on
colorbar
caxis([-collim collim])         % limits colorbar

figure
imagesc(yerror);                % error of y-coordinate estimation
colormap(color1);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('X-coordinate field [cm]')
ylabel('Y-coordinate field [cm]')
title(sprintf('Error of estimated y-coordinate %dD [cm]',d))
grid on
colorbar
caxis([-collim collim])         % limits colorbar

figure
imagesc(magerror);              % magnitude of error of the estimation
colormap(color2);               % set color scheme of image
set(gca,'YDir','normal')        % reverse y-axis
xlabel('X-coordinate field [cm]')
ylabel('Y-coordinate field [cm]')
title(sprintf('Magnitude of error of estimated coordinate %dD [cm]',d))
grid on
colorbar
caxis([0 collim])               % limits colorbar

%% plot the distributions of the errors
dislim = 20;                    % limit distribution
disstep = 0.25;                 % step size distribution

figure
histogram(xerror,-dislim:disstep:dislim,'Normalization','probability')
xlabel('Error of x-coordinate estimation [cm]')
ylabel('Probability')
title(sprintf('Distribution of error x-coordinate estimation %dD',d))
grid on
xlim([-dislim dislim])

figure
histogram(yerror,-dislim:disstep:dislim,'Normalization','probability')
xlabel('Error of y-coordinate estimation [cm]')
ylabel('Probability')
title(sprintf('Distribution of error y-coordinate estimation %dD',d))
grid on
xlim([-dislim dislim])

figure
histogram(magerror,0:disstep:1.4*dislim,'Normalization','probability')
xlabel('Magnitude error of the estimation [cm]')
ylabel('Probability')
title(sprintf('Distribution of magnitude error of the estimation %dD',d))
grid on
xlim([0 1.4*dislim])
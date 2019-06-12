% testtdoa
% Author: Rik van der Hoorn - 4571150
% Last modified: 01-06-19
% Feeds test data to the tdoa function

clear all
close all

%% getting recorded data
measurement = 10;                % select measurement file
load(['D:\OneDrive\Studie\EE2\Q4 EE2L21 EPO-4 KITT Autonomous Driving Challenge 18-19\Module 3\test_data\audiomeas_b4\audiomeas' num2str(measurement) '.mat'])
load('datarefsig.mat')
ref = ref2;                     % select reference signal

peakperc = 40;

%% selecting 1 recorded pulse by hand
llim = 1;
rlim = 14400;
micdata = Acq_data(llim:rlim,1:5);

%% plot figures in time domain
% figure
% hold on
% plot(micdata)
% title('Microphone recording')
% xlabel('Sample number')
% ylabel('Amplitude')

tic
disdiffprac = tdoa(micdata,ref,peakperc,Fs);
t = toc;

disdiff = 100*disdiffprac;
load('datamicloc')
d = 2;
coord = loc(mic,disdiff,d)

% load(['D:\OneDrive\Studie\EE2\Q4 EE2L21 EPO-4 KITT Autonomous Driving Challenge 18-19\Location\Test data\Locdata' num2str(measurement) '.mat'], 'disdiff')
% error = disdiffprac' - disdiff;
% erroravg = mean(abs(error))

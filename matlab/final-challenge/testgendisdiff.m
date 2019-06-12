% testgendisdiff
% Author: Rik van der Hoorn - 4571150
% Last modified: 08-06-19
% Test file for gendisdiff.m

clear all
close all

%% load microphone locations and data
load('datamicloc.mat')      % microphone locations
mic = mic([1 2 3 4 5],:);   % select microphones used
loc = [80 135 24.8];           % location of the audio beacon of the car (z = 24.8)
error = 0;                  % maximum error added to distance between mic(i) and car

%% run function and save output
disdiff = gendisdiff(mic,loc,error);

% save('locdata10','disdiff')

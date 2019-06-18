% testloc
% Author: Rik van der Hoorn - 4571150
% Last modified: 18-06-19
% Test file for loc.m

clear all
close all

%% load microphone locations and specify parameters (in cm!)
load('transmap.mat')        % translation map for 2D with 5 microphones
% transmap = 0;               % uncomment to prevent correction
load('datamicloc')          % coordinates of the microphones
mic = mic([1 2 3 4 5],:);   % select microphones used
loccar = [314 57 24.8];     % location of audio beacon of the car [x y z]
measerror = 0;              % random error added when calculating disdiff
d = 2;                      % 2 for 2D estimation or 3 for 3D estimation
check = 1;                  % if check is nonzero, plots figures to debug

%% 2D or 3D location estimation
disdiff = gendisdiff(mic,loccar,measerror); % calculate range differences
coord = loc(mic,disdiff,d,transmap,check);  % coordinate of car

% testloc
% Author: Rik van der Hoorn - 4571150
% Last modified: 05-06-19
% Test file for loc.m

clear all
close all

%% load microphone locations and data
load('datamicloc.mat')          % microphone locations
mic = mic([1 2 3 4 5],:);       % select microphones used
dataset = 8;                    % select test dataset
load(['D:\OneDrive\Studie\EE2\Q4 EE2L21 EPO-4 KITT Autonomous Driving Challenge 18-19\Module 3\test_data\locdata\locdata' num2str(dataset) '.mat'])
% disdiff = disdiff([1 2 3 5 6 8]);   % select correct pairs according to selected microphones

%% 2D or 3D location estimation
d = 3;                          % dimension location estimation
coord = loc(mic,disdiff,d)

% testtdoa
% Author: Rik van der Hoorn - 4571150
% Last modified: 20-06-19
% Test file for tdoa.m

clear all
close all

%% getting data
measurement = 3;                % select measurement file
% load measurement data
load(['D:\OneDrive\Studie\EE2\Q4 EE2L21 EPO-4 KITT Autonomous Driving Challenge 18-19\Final Rik\Module 3\test_data\audiomeas_final\audiomeas' num2str(measurement) '.mat'])
micrec = Acq_data(1:end,:);     % select part of recording
F = str2double(F(2:end));       % carrier frequency
B = str2double(B(2:end));       % bit frequency
R = str2double(R(2:end));       % repetition count
% load reference signals
load('D:\OneDrive\Studie\EE2\Q4 EE2L21 EPO-4 KITT Autonomous Driving Challenge 18-19\Final Rik\Module 3\test_data\audiomeas_final\datarefsig.mat')
ref = ref3;                     % select reference signal
peakperc = 40;                  % threshold peak detection [%]
check = 1;                      % if check is nonzero, plots figures to debug

%% TDOA calculations
disdiff = tdoa(micrec,ref,Fs,B,R,peakperc,check); % calculate range differences

load('datamicloc')          % coordinates of the microphones
d = 2;                      % 2 for 2D estimation or 3 for 3D estimation
load('transmap.mat')        % translation map for 2D with 5 microphones
loccar = [383 307 24.8];    % location of audio beacon of the car [x y z]
disdiffgen = gendisdiff(mic,loccar,0);  % generated range differences
errordisdiff = disdiff - disdiffgen;    % error in detected range differences

%% location calculation
coord = loc(mic,disdiff,d,transmap,0)   % location of the car based on recording

%% plot selected recording
if check
figure
plot(micrec)
xlabel('Sample number')
ylabel('Amplitude')
title('Microphone recordings')
legend('Microphone 1','Microphone 2','Microphone 3','Microphone 4','Microphone 5')
xlim([0 length(micrec(:,1))])
end
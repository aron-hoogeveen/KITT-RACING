% refsignal
% Author: Rik van der Hoorn - 4571150
% Last modified: 20-06-19
% Generates multiple reference signals:
% - Complete pulse
% - Until 5% max amplitude
% - Until 25% max amplitude

clear all
close all

% load recording
load('D:\OneDrive\Studie\EE2\Q4 EE2L21 EPO-4 KITT Autonomous Driving Challenge 18-19\Final Rik\Module 3\test_data\audiomeas_final\audiomeas1.mat')

%% create reference signals
ref = Acq_data(:,5);                % get recording of a microphone
ref1 = ref(19423:38622);            % a complete pulse, signal length = 19200 -> R/B*Fs
ref2 = ref(19423:22002);            % until 5% of max amplitude
ref3 = ref(19423:19976);            % until 25% of max amplitude

%% reference lines
peaksig = max(ref1);                % generate reference lines for trimming ref2 and ref3
refline25 = 0.25*peaksig;
reflinemin25 = -1*refline25;
refline10 = 0.05*peaksig;
reflinemin10 = -1*refline10;

%% plot for checking
figure
hold on
% plot reference signals
plot(ref1)
plot(ref2)
plot(ref3)
% plot reference lines
yline(refline25);
yline(reflinemin25);
yline(refline10);
yline(reflinemin10);

xlabel('Sample number')
ylabel('Amplitude')
title('Reference signals')
legend('Complete pulse','Until 5% max amplitude','Until 25% max amplitude')
xlim([0 length(ref1)])
% save('datarefsig','ref1','ref2','ref3') % save data
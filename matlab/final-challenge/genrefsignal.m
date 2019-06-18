% refsignal
% Author: Rik van der Hoorn - 4571150
% Last modified: 01-06-19
%
% Generate multiple reference signals:
% complete pulse, 10% max amplitude and 25% max amplitude

clear all
close all

load('D:\OneDrive\Studie\EE2\Q4 EE2L21 EPO-4 KITT Autonomous Driving Challenge 18-19\TDOA\Test data\DataMeas_B4\DataMeas1.mat')

%% create reference signals
ref = Acq_data(:,1);                  % get recording of microphone 1
ref1 = ref(104673:119072);            % a complete pulse, signal length = 14400 -> 1500/5000*48000
ref2 = ref(104673:105244);            % until 10% of max amplitude
ref3 = ref(104673:105093);            % until 25% of max amplitude

%% reference lines
peaksig = max(ref1);                  % generate reference lines for trimming ref2 and ref3
refline25 = 0.25*peaksig;
reflinemin25 = -1*refline25;
refline10 = 0.1*peaksig;
reflinemin10 = -1*refline10;

%% plot for checking
figure
hold on
plot(ref1)
plot(ref2)
plot(ref3)

yline(refline25);
yline(reflinemin25);
yline(refline10);
yline(reflinemin10);
% save('refsig','ref1','ref2','ref3') % save data in refsig.mat
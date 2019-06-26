clear all;
% close all;
pRMS_array = [];
Begin_plot = 1;
Max_plots = 8;
n_colors = Max_plots-Begin_plot +3;
colors = distinguishable_colors(n_colors);
i = Begin_plot;

% figure
% load FCarrier_5khz.mat;
% 
% mic5 = y(:,5);
% PSDen = fft(mic5);                              % Fast fourier transform to frequency domain
% PSDen = PSDen(1:length(mic5)/2+1);              % 
% PSDen(2:end-1) = 2*PSDen(2:end-1);
% PSDen = 1/(length(mic5)*Fs)*abs(PSDen).^2;
% freq = [0:Fs/length(mic5):Fs/2];
% pRMS = rms(mic5)^2;
% pRMS_array = [pRMS_array pRMS];
% hold on;
% plot(freq,10*log10(PSDen), 'Color', colors(1,:));
% title('Power spectral density of audio beacon measurements with different carrier frequencies');
% xlabel('Frequency in Hz');
% ylabel('Power in dB');
% 
% load FCarrier_7khz.mat;
% 
% mic5 = y(:,5);
% PSDen = fft(mic5);                              % Fast fourier transform to frequency domain
% PSDen = PSDen(1:length(mic5)/2+1);              % 
% PSDen(2:end-1) = 2*PSDen(2:end-1);
% PSDen = 1/(length(mic5)*Fs)*abs(PSDen).^2;
% freq = [0:Fs/length(mic5):Fs/2];
% pRMS = rms(mic5)^2;
% pRMS_array = [pRMS_array pRMS];
% hold on;
% plot(freq,10*log10(PSDen), 'Color', colors(2,:));


while (i<=Max_plots)
data = strcat('FBit_', string(i), 'khz.mat'); 
    load(data);

t = [0:1/Fs:1-1/Fs];
mic5 = y(:,5);

PSDen = fft(mic5);                              % Fast fourier transform to frequency domain
PSDen = PSDen(1:length(mic5)/2+1);              % 
PSDen(2:end-1) = 2*PSDen(2:end-1);
PSDen = 1/(length(mic5)*Fs)*abs(PSDen).^2;
freq = [0:Fs/length(mic5):Fs/2];
pRMS = rms(mic5)^2;
pRMS_array = [pRMS_array pRMS];
hold on;
plot(freq,10*log10(PSDen),'Color', colors(i,:));
grid on;
i = i+1;
end



legend('F5','F7','F9','F10','F11','F12','F13','F14','F15','F16','F17','F18','F19','F20');
%legend('F1','F2','F3','F4','F5','F6','F7','F8');
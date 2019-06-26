clear all;
%close all;

pRMS_array = [];
i = 1;
Begin_plot = 1;
Max_plots = 8;
n_colors = Max_plots-Begin_plot +3;
colors = distinguishable_colors(n_colors);

 while (i<=8)
    data = strcat('FBit_', string(i), 'khz.mat'); 
        load(data);
mic5 = y(:,5);
PSDen = fft(mic5);  
PSDen = PSDen(1:40000);% Fast fourier transform to frequency domain
freqHz = (0:1:(length(PSDen)-1))*Fs/length(mic5);
freqHz = freqHz(1:40000);
pRMS = rms(mic5)^2;
pRMS_array = [pRMS_array pRMS];
hold on;
plot(freqHz,abs(PSDen), 'Color', colors(i,:));
title('Amplitude plot in the frequency domain of the different bit frequencies settings');
xlabel('Frequency in Hz');
ylabel('Amplitude of the recorded audio beacon signal');
i = i+1;
 end

legend('F1','F2','F3','F4','F5','F6','F7','F8');

% peakdet
% Author: Rik van der Hoorn - 4571150
% Last modified: 01-06-19
% Detection of the first significant peak
% based on the peak height relative to the maximum peak

function sampn = peakdet(h,peakperc)
hsq = h.^2;                             % signal squared for suppression of small signals
peakboun = peakperc*max(hsq)/100;       % signal power threshold
[pksh,locsh] = findpeaks(hsq,'MinPeakHeight',peakboun,'Npeaks',1);    % finds the first peak which is above the signal power threshold
sampn = locsh(1);

figure()
hold on
plot(hsq)
yline(peakboun,'b--');
stem(locsh,pksh);
xlim([0 length(hsq)])
legend('Channel estimation squared',sprintf('%d%% Peak power', peakperc),'Peaks')
title('Channel estimation squared')
xlabel('Sample number')
ylabel('Amplitude^2')
end
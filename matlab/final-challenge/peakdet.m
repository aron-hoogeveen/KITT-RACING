% peakdet
% Author: Rik van der Hoorn - 4571150
% Last modified: 20-06-19
% Status: complete, commented and tested
%
% Detection of the first significant peak
% based on the peak height relative to the maximum peak
%
% function  sampn = peakdet(h,peakperc,pulselength,npulse,check)
% Inputs:	h = estimated channel
%           peakperc = threshold peak detection [%]
%           pulselength = length of a single pulse
%           npulse = max number of expected pulses
%           check = if check is nonzero, plots figures to debug
% Output:   sampn = sample numbers of detected peaks

function sampn = peakdet(h,peakperc,pulselength,npulse,check)
hsq = h.^2;                         % signal squared for suppression of small signals
peakboun = peakperc*max(hsq)/100;  	% signal power threshold
[pksh,locsh] = findpeaks(hsq,'MinPeakHeight',peakboun);	% finds peaks above threshold
npeak = length(locsh);              % number of detected peaks
pulsenumber = floor(locsh./pulselength)+1;  % vector containing the corresponding pulse number

sampn = zeros(1,npulse);            % sample numbers of first peak for each pulse
heigthn = zeros(1,npulse);          % corresponding heigth of the first peaks
g = 1;
for i = 1:npeak
    if pulsenumber(i) == g          % extract the first peaks for each pulse
        sampn(g) = locsh(i);
        heigthn(g) = pksh(i);
        g = g + 1;
    end
end

if check                            % figure for debuging
    figure()
    hold on
    plot(hsq)
    yline(peakboun,'b--');
    stem(sampn,heigthn);
    xlim([0 length(hsq)])
    legend('Channel estimation squared',sprintf('%d%% threshold', peakperc),'First peaks')
    title('Channel estimation squared')
    xlabel('Sample number')
    ylabel('Amplitude^2')
end
end
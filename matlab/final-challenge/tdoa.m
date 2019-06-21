% tdoa
% Author: Rik van der Hoorn - 4571150
% Last modified: 20-06-19
% Status: complete, commented and tested
%
% Calculates the Time Difference Of Arrival (TDOA) between al the
% microphones and converts it to range differences. This is done by a 
% channel estimation using deconvolution in the frequency domain. With
% detection of the first significant peak, the TDOA's are determined.
% Outlier detection is added for more robust performance if the recording
% contains multiple pulses.
%
% function  disdiff = tdoa(micrec,ref,Fs,B,R,peakperc,check)
% Inputs:	micrec = recording of the microphones
%           ref = reference recording
%           Fs = sample frequency recording
%           B = bit frequency
%           R = repetition count
%           peakperc = threshold peak detection [%]
%           check = if check is nonzero, plots figures to debug
% Output:   disdiff = range differences between microphones and car,
% (for 5 microphones: [r12; r13; r14; r15; r23; r24; r25; r34; r35; r45])

function disdiff = tdoa(micrec,ref,Fs,B,R,peakperc,check)
%% calculate sample number of first significant peak
e = 4;                          % threshold channel estimation [%]
[nsamp,nmic] = size(micrec);    % number of microphones and length recording
pulselength = R/B*Fs;           % length of a pulse
npulse = ceil(nsamp/pulselength);   % max number of expected pulses
peakmat = zeros(nmic,npulse);   % matrix with sample numbers of detected peaks

for i = 1:nmic      % channel estimation and peak detection for all microphones
h = chanest(ref,micrec(:,i),e,check);
peakmat(i,:) = peakdet(h,peakperc,pulselength,npulse,check);
end


%% calculate the difference in sample number
neq = sum(1:nmic-1);            % number of TDOA pairs
peakdiff = zeros(10,npulse);    % TDOA pairs for all pulses

g = 1;
for n = 1:nmic-1                
    for k = n+1:nmic
    peakdiff(g,:) = peakmat(k,:) - peakmat(n,:);    % calculate all the TDOA's
    peakdiff(g,:) = filloutliers(peakdiff(g,:),'linear','median');  % replace outliers with linear interpolation
    g = g + 1;
    end
end

avgpeakdiff = mean(peakdiff,2); % average the TDOA's of all the pulses
vsound = 34400;                 % speed of sound [cm/s]
disdiff = avgpeakdiff./Fs.*vsound;  % range differences between microphones and car
end
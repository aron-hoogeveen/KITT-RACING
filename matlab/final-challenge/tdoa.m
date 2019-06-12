% tdoa
% Author: Rik van der Hoorn - 4571150
% Last modified: 01-06-19
% Time difference of arrival

function disdiff = tdoa(micdata,ref,peakperc,Fs,B,R)
%% first peak 
reclength = R/B*Fs;
mindis = 0.8*reclength;
minheigth = 0.5*max(micdata(:,1));
[pksh,locsh] = findpeaks(micdata(:,1),'MinPeakHeight',minheigth,'Npeaks',2,'MinPeakDistance',mindis);    % finds the first peak which is above the signal power threshold
llim = locsh(2) - 1/3*reclength;
rlim = locsh(2) + 2/3*reclength;
micdata = micdata(llim:rlim,1:5);

%% calculate sample number of first significant peak
[~,nmic] = size(micdata);

for i = 1:nmic
e = 4;                       % threshold [%]
h = chanest(ref,micdata(:,i),e);
sampn(i) = peakdet(h,peakperc);
end

%% calculate the difference in sample number
g = 1;
for n = 1:nmic-1
    for k = n+1:nmic
    sampdiff(g) = sampn(k) - sampn(n);
    g = g + 1;
    end
end
vsound = 340;
disdiff = sampdiff./Fs.*vsound;
end
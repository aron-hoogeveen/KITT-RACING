% tdoa
% Author: Rik van der Hoorn - 4571150
% Last modified: 01-06-19
% Time difference of arrival

function disdiff = tdoa(micdata,ref,peakperc,Fs)
%% calculate sample number of first significant peak
[~,nmic] = size(micdata);
i = 2;
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
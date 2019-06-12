% locerrorcor
% Author: Rik van der Hoorn - 4571150
% Last modified: 11-06-19
% Status: in progress

% Corrects for the systematic error that is introduced when using 2d
% estimation with 5 microphones in the predetermined EPO-4 setup

% Inputs:   cormap = correction map used to correct the estimated location
%           estloc = estimated location without location correction
% Output:   coord = coordinates of the corrected location

function coord = locerrorcor(cormap,estloc)
xtest = estloc(1) - cormap(:,:,1);
ytest = estloc(2) - cormap(:,:,2);

[Mx,Ix] = min(abs(xtest),[],2);
[My,Iy] = min(abs(ytest),[],1);

for i = 1:461
    test = Ix(i);
    if i == Iy(test)
        coord(1) = test-1;
        coord(2) = i-1;
        break
    end
end
end
function [x, v] = MetingToCurve(sensorL, sensorR)
d1 = sensorL;
d2 = sensorR;
% Converts measurements to curves:
for i = 1:length(d1)
    distComb(i) = (d1(i) + d2(i))/2;
end

%Flip the distance (as lowering of sensorvalues indicates more distance
%traveled)
Xcomb = distComb(1)-distComb;

% smooth Xcomb data:
for i = 1:3330
    Xcomb = smooth(smooth(smooth(Xcomb)));
end
        
Vcomb = diff(Xcomb);
Vcomb(length(Xcomb)) = Vcomb(length(Xcomb)-1);

%Save brake curve
x = Xcomb;
v = Vcomb;

plot(x, v);
xlabel('x');
ylabel('v');
end
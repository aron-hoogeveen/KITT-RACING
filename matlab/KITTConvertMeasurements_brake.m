% Converts measurements to matrices of brake with battery voltage:   18.4-18.6V
clear distComb;
for i = 1:length(stopL)
    distComb(i) = (stopL(i) + stopR(i))/2;
end

%Flip the distance (as lowering of sensorvalues indicates more distance
%traveled)
Xcomb = distComb(1)-distComb;

% smooth Xcomb data:
Xcomb = smooth(smooth(smooth(smooth(Xcomb))));
        
Vcomb = diff(Xcomb);
Vcomb(length(Xcomb)) = Vcomb(length(Xcomb)-1);

%Save brake curve
x_brake145 = Xcomb;
v_brake145 = Vcomb;

% Determine rollout end point for shifting
x_brake145_end = 126;

plot(x_brake145, v_brake145);
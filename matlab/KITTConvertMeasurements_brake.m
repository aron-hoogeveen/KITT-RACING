% Converts measurements to matrices of brake with battery voltage:   18.4-18.6V

clear distComb;
clear Vcomb;
clear Xcomb;
for i = 1:length(stopL)
    distComb(i) = (stopL(i) + stopR(i))/2;
end

%Flip the distance (as lowering of sensorvalues indicates more distance
%traveled)
Xcomb = distComb(1)-distComb;

% smooth Xcomb data:
Xcomb = smooth(smooth(smooth(Xcomb)));
        
Vcomb = diff(Xcomb);
Vcomb(length(Xcomb)) = Vcomb(length(Xcomb)-1);

%Save brake curve
x_brake165 = Xcomb;
v_brake165 = Vcomb;

% Determine rollout end point for shifting
x_brake165_end = 120;
plot(distComb);
figure
plot(x_brake165, v_brake165);
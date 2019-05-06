% Converts measurements to matrices with velocities and positions
% With battery voltage:   18.8-19V
% Inputs: distL, distR vectors (unit: cm)
% Determine velocity curve for determined speed setting and battery
% level

% There are 9 speedsettings :157-165
speedsetting = 4; % This is changed for every measurement

%Only once:
%x_acc = zeros(9,40);
%v_acc = zeros(9,40);
clear distComb;

for i = 1:length(d1)
    distComb(i) = (d1(i) + d2(i))/2;
end

%Flip the distance (as lowering of sensorvalues indicates more distance
%traveled)
Xcomb = distComb(1)-distComb;

% smooth Xcomb data:
Xcomb = smooth(smooth(smooth(Xcomb)));
        
Vcomb = diff(Xcomb);
Vcomb(length(Xcomb)) = Vcomb(length(Xcomb)-1);

% Vectors will be extended to 40, assuming constant speed is achieved.
last3average = (Vcomb(length(Vcomb))+Vcomb(length(Vcomb)-1)+Vcomb(length(Vcomb)-2))/3;
for i = length(Vcomb):40
    Vcomb(i) = last3average;
    Xcomb(i) = Xcomb(i-1)+Xcomb(length(Xcomb))-Xcomb(length(Xcomb)-1);
end

%Save accelation or deceleration curve per speedsetting
x_acc(speedsetting, :) = Xcomb;
v_acc(speedsetting, :) = Vcomb;

plot(x_acc(speedsetting, :), v_acc(speedsetting,:))
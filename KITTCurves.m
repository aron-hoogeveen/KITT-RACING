% This code was used to measure the acceleration and deceleration curves
% with battery voltage:   -V
% Inputs: distL, distR vectors
% Determine velocity curve for determined speed setting and battery
% level

truncation = 400;

%Only once:
x_acc = zeros(8,truncation);
x_brake = zeros(8, truncation);
v_acc = zeros(8,truncation);
v_brake = zeros(8, truncation);

accel = 0; % 1 is acceleration, 0 is braking
speedsetting = 8;

%Flip the distance (as lowering of sensorvalues indicates more distance
%traveled)
sensorL = distL(1)-distL;
sensorR = distR(1)-distR;

TimeInterval = 0; %Time interval for sensor readings

% Create t vector for sensor readings
t = 1:length(sensorL);

for i = 1:length(sensorL)
    Xcomb(i) = (sensorL(i) + sensorR(i))/2;
end

Vcomb = 100*diff(Xcomb);
Vcomb(length(Xcomb)) = Vcomb(length(Xcomb)-1);

%Save accelation or deceleration curve per speedsetting
if (accel)
    x_acc(speedsetting, :) = Xcomb(1:truncation);
    v_acc(speedsetting, :) = Vcomb(1:truncation);
else
    x_brake(speedsetting, :) = Xcomb(1:truncation);
    v_brake(speedsetting, :) = Vcomb(1:truncation);
    brakeEndings(speedsetting, :) = 2; % break end point for shifting
end



% This code was used to measure the acceleration and deceleration curves
% with battery voltage:   -V
% Inputs: distL, distR vectors (unit: cm)
% Determine velocity curve for determined speed setting and battery
% level

truncation = 27;

%Only once:
x_acc = zeros(8,truncation);
v_acc = zeros(8,truncation);

accel = 1; % 1 is acceleration, 0 is letting the car roll out (only one measurement)
speedsetting = 8;

for i = 1:length(distL)
    distComb(i) = (distL(i) + distR(i))/2;
end

%Flip the distance (as lowering of sensorvalues indicates more distance
%traveled)
Xcomb = distComb(1)-distComb;

% smooth Xcomb data:
Xcomb = smooth(smooth(Xcomb));
        
Vcomb = diff(Xcomb);
Vcomb(length(Xcomb)) = Vcomb(length(Xcomb)-1);

%Save accelation or deceleration curve per speedsetting
if (accel)
    x_acc(speedsetting, :) = Xcomb(1:truncation);
    v_acc(speedsetting, :) = Vcomb(1:truncation);
else
    x_rollout = Xcomb(1:truncation);
    v_rollout = Vcomb(1:truncation);
    % Determine rollout end point for shifting
end


% Remove dit
plot(Xcomb, Vcomb)
hold on;
plot(x_rollout, v_rollout)


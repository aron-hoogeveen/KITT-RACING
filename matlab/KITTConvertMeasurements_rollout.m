% Converts measurements to matrices of rollout with battery voltage:
% 18.4-18.6V

for i = 1:length(rollL)
    distComb(i) = (rollL(i) + rollR(i))/2;
end

%Flip the distance (as lowering of sensorvalues indicates more distance
%traveled)
Xcomb = distComb(1)-distComb;

% smooth Xcomb data:
Xcomb = smooth(smooth(Xcomb));
        
Vcomb = diff(Xcomb);
Vcomb(length(Xcomb)) = Vcomb(length(Xcomb)-1);

%Save brake curve
x_roll158 = Xcomb;
v_roll158 = Vcomb;

% Determine rollout end point for shifting
x_roll158_end = 93;

plot(x_roll158, v_roll158);
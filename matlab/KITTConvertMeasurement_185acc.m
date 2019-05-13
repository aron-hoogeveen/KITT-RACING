% Converts measurements to matrices of rollout with battery voltage:
% 18.4-18.6V
clear distComb;
for i = 1:length(d1)
    distComb(i) = (d1(i) + d2(i))/2;
end

%Flip the distance (as lowering of sensorvalues indicates more distance
%traveled)
Xcomb = distComb(1)-distComb;

% smooth Xcomb data:
for i = 1:100
    Xcomb = smooth(Xcomb);
end      
Vcomb = diff(Xcomb);
Vcomb(length(Xcomb)) = Vcomb(length(Xcomb)-1);

% Vectors will be extended to 50, assuming constant speed is achieved.
last3average = (Vcomb(length(Vcomb))+Vcomb(length(Vcomb)-1)+Vcomb(length(Vcomb)-2))/3;
for i = length(Vcomb):50
    Vcomb(i) = last3average;
    Xcomb(i) = Xcomb(i-1)+Xcomb(length(Xcomb))-Xcomb(length(Xcomb)-1);
end


%Save brake curve
x_acc185 = Xcomb;
v_acc185 = Vcomb;

% Determine rollout end point for shifting

plot(x_acc185, v_acc185);
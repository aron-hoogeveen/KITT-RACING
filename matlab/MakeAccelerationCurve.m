% truncate sensors
begin = 1;
%ending = length(sensorL);
ending = 36;

d1 = sensorL(begin:ending);
d2 = sensorR(begin:ending);

% Converts measurements to curves:
for i = 1:length(d1)
    distComb(i) = (d1(i) + d2(i))/2;
end

figure(1);

%Flip the distance (as lowering of sensorvalues indicates more distance
%traveled)
Xcomb = distComb(1)-distComb;

plot(Xcomb);
title('Xcomb');
% polynom Xcomb data:
samples = [begin:ending];
p = polyfit(samples, Xcomb, 2);
P = polyval(p, samples);
X_poly = P;
hold on;
plot(X_poly);

figure(2);
V_poly = diff(X_poly);
V_poly(length(X_poly)) = V_poly(length(X_poly)-1);
plot(V_poly);
title("vpolty");

%Save brake curve
x_acc = X_poly;
v_acc = V_poly;

figure(3);
plot(x_acc, v_acc);
xlabel('x');
ylabel('v');
close all
clear distComb;
clear Xcomb;
clear V_poly;
clear X_poly;
% Braking curve will be generated by specifying constant speed of the car
const_speed = 18.5;

%plot(sensorR); hold on; plot(sensorL);
% truncate sensors (vanaf moment van remmen)
begin = 41;
ending = 78;

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

% Fit the curve to polynominal corresponding to constant speed and stop
% distance
% f = ax^2 +bx +c;
% f'(0) = 18.5;
% f'(27) = 0;
% f(0) = 0;

poly_samples = 0:(ending-begin);
a = -18.5/70;
b = 18.5;
% (poly) Braking part
ft = fittype(@(c, x) a*x.^2+b*x+c);
FO = fit(poly_samples',Xcomb',ft);

figure(1) % plot the curve fitting
plot(Xcomb);
hold on;
plot(FO);

figure(2) % plot the curve fitting
x_brake = FO(poly_samples);
v_brake = diff(x_brake);
x_brake = x_brake(1:length(x_brake)-1);
plot(x_brake, v_brake);





% truncate sensors
begin = 1;
%ending = length(sensorL);
ending = 21;

d1 = distParL(begin:ending);
d2 = distParR(begin:ending);

% Converts measurements to curves:
for i = 1:length(d1)
    distComb(i) = (d1(i) + d2(i))/2;
end

figure(1);

%Flip the distance (as lowering of sensorvalues indicates more distance
%traveled)
Xcomb = distComb(1)-distComb;
lengte = length(Xcomb);
samples = [begin:ending];

aplusb = 18.5/(42);
c = 0;
ft = fittype(@(b, x) (aplusb-b/52)*x.^2+b*x+c);
FO = fit(samples',Xcomb',ft);
x_short = FO(1:21);
fx = differentiate(FO, samples);
plot(FO(1:21), fx);

figure
plot(Xcomb);
hold on;
plot(FO);
title('Xcomb');
% polynom Xcomb data:
%p = polyfit(samples, Xcomb, 2);
%P = polyval(p, samples);
%X_poly = P;
%hold on;
%plot(X_poly);

%figure(2);
%V_poly = diff(X_poly);
%V_poly(length(X_poly)) = V_poly(length(X_poly)-1);
%plot(V_poly);
%title("vpolty");

%V_FO = diff(FO);
%plot(V_FO);

%Save brake curve
%x_acc = X_poly;
%v_acc = V_poly;

%v_kilo = 10^-2*3.6*v_acc/0.037;
%figure(3);
%plot(x_acc, v_kilo);
%xlabel('position');
%ylabel('velocity (km/u)');
%title('Acceleraton curve');



% Convert the measured data into 
% clear all;
warning('I AM NOT GOING TO CLEAR ALL');
load('quarterCircleV2.mat')
close all


plot(quarterCircle1, '.', 'MarkerSize', 12);
hold on;
plot(quarterCircle2, '.', 'MarkerSize', 12);
plot(quarterCircle3, '.','MarkerSize', 12);
xlabel('Quarter circles');
ylabel('Time per quadrant (s)');

%We observe that KITT drives constant after 4 quadrants (full circle)
% We will estimate the time for KITT to drive a quarter circle by taking a
% horizontal line
cons_data1 = quarterCircle1(4:end);
cons_data2 = quarterCircle2(4:end);
cons_data3 = quarterCircle3(4:end);
trend_cons_data1 = average(cons_data1);
trend_cons_data2 = average(cons_data2);
trend_cons_data3 = average(cons_data3);
begin_data1 = quarterCircle1(1:3);
begin_data2 = quarterCircle2(1:3);
begin_data3 = quarterCircle3(1:3);



samples = transpose([1:3]);
p = polyfit(samples, begin_data2, 2);
P = polyval(p, [1:0.1:4]);
figure;
plot([1:0.1:4],P);
hold on;
lijntje(1:5) = trend_cons_data2;
plot(lijntje); 

%trend_cons_data1 = -b^2/4a+c;
% (poly) Braking part
%ft = fittype(@(a, b, c, x) a*x.^2+b*x+c);
%FO = fit(poly_samples',X_combpoly',ft);
%poly_part = polyfitB(samples, Xcomb(17:45), 2, 153.127450980392);
%X_poly = polyval(poly_part, samples);

radius = 85;
average_constant_speed = pi*2*radius/(4*average([trend_cons_data1, trend_cons_data2, trend_cons_data3]))

function ave = average(x) % x is a vector
    sum = 0;
    for i = 1:length(x)
        sum = sum + x(i);
    end
    ave = sum/length(x);
end
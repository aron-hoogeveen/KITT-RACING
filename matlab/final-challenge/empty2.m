x_points = [10 30 50 70 90 110];
y_points = fliplr([9 35 42 60 85 115]);
plot(x_points, y_points, '.', 'MarkerSize', 12);
hold on;


prms = polyfit(x_points,y_points,1);
rico = prms(1);
b = prms(2);
phi = atand(rico);
if (x_points(end)-x_points(1) < 0 && y_points(end)-y_points(1) < 0)
    actual_orientation = phi - 180;
elseif(x_points(end)-x_points(1) < 0 && y_points(end)-y_points(1) > 0)
    actual_orientation = phi+180;
elseif(x_points(end)-x_points(1) > 0 && y_points(end)-y_points(1) < 0)
    actual_orientation = phi;
else
    actual_orientation = phi;
end

x_samp = [1:460];

endpoint = [100, 100];
plot(endpoint(1), endpoint(2), '.', 'MarkerSize', 12);
plot(0.02*x_samp+99.7);


extended_trend = rico*x_samp  +b;
plot(extended_trend);
% The distance from a point (x_p,y_p) to a line m*x +b is
% |m*x_p-y_p+b|/sqrt(m^2 + 1)
end_dist_difference = abs(rico*endpoint(1) - endpoint(2) + b)/sqrt(rico^2+1);


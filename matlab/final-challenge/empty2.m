x_points = [10 30 50 70 90 110];
y_points = fliplr([9 35 42 60 85 115]);
plot(x_points, y_points, '.', 'MarkerSize', 12);


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
    

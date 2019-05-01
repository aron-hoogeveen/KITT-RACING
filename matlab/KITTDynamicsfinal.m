run KITTParameters.m
% Desired distance:
d = 40;

% Accerlating
Fa = Fa_max;
Fb = 0;
sim KITTRacing
x_acc = x.signals.values;
v_acc = v.signals.values;

plot(x_acc, v_acc);
hold on; % Braking curve:
Fb = Fb_max;
Fa = 0;
v0 = 40; % dont change this
sim KITTRacing
x_brake = x.signals.values;
v_brake = v.signals.values;
shift_x = shift(d); % Shift the braking curve to match distance
plot(x.signals.values - shift_x, v.signals.values)
ylabel('v (m/s)');
xlabel('x (m)');
title('Acclerating and braking');
legend('Acceleration', 'Braking');
xlim ([0, max(x.signals.values)]);

% Intersection point (m)
Braking_Point = intersectCurves(x.signals.values - shift_x, v.signals.values, x_acc, v_acc, shift_x)


function brakeStart = intersectCurves(x_brak, v_brak, x_acc, v_acc, shift_x)
    brakeStart = polyxpoly(x_brak, v_brak, x_acc, v_acc)
end 

function shift_x = shift(d) %Determine the start velocity to shift it to the right end distance
 shift_x = 76.8 - d;
end



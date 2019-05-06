% EPO-4 Group B4
% 30-04-2019
% This generates the acceleration and braking curves of the car and shifts the breaking curve to make the car reach a desired distance (with v=0) in the least time possible.

run KITTParameters.m
% Desired distance:
d = 40;

% Accelerating (v0 = 0)
Fa = Fa_max;
Fb = 0;
sim KITTRacing
x_acc = x.signals.values;
v_acc = v.signals.values;

plot(x_acc, v_acc);
hold on; % Braking curve:
Fb = Fb_max;
Fa = 0;
v0 = 40; % sufficiently high v0
sim KITTRacing
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
	shift_x = 76.8 - d; %76.8 was determined from the plot as the standard breaking end (at v0 = 40)
end

% End of code


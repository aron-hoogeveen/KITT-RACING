% KITTdriver: implementation of racing driver
run KITTParameters.m
sim KITTRacing % Velocity initial condition set to 0

% Plot car dynamics
subplot(211)
plot(v.time,v.signals.values)
ylabel('v [m/s] / x [m]');
xlabel('t [s]');
hold on;
plot(x.time,x.signals.values, 'k')
title('Speed and position of car');
legend('v', 'x');
subplot(212)
plot(a.time,a.signals.values, 'r')
ylabel('a [m/s^2]');
xlabel('t [s]');
title('Acceleration of car');
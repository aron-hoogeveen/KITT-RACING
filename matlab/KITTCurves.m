% Plot the curves

figure(1)
for i = 1:9
    plot(x_acc(i, :), v_acc(i, :));
    hold on;
end
plot(x_roll160, v_roll160);
hold on;
plot(x_brake160, v_brake160, '--');
plot(x_brake165, v_brake165, '--');
legend("M:157, 19V", "M:158, 19V", "M159, 19V", "M160, 18.9V", "M161, 18.9V", "M162, 18.9V", "M163, 18.8V", "M164, 18.8V", "M165, 18.8V", "Rollout (M:160)", "Brake(M:160, 18.5V)", "Brake(M:165, 18.5V)");
title('Velocity-position curves for several speedsettings and battery levels');
xlabel('Position (cm)');
ylabel('Velocity (cm/sample)');
grid on;

figure(2)
plot(x_acc185, v_acc185);
hold on;
plot(x_brake160, v_brake160, '--');
plot(x_brake165, v_brake165, '--');
legend("M:160, 18.5V", "Brake(M:160, 18.5V)", "Brake(M:165, 18.5V)");


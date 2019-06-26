clear all;

%% Determine the average speed
% Measurements for quarter circles 
measurement_1 = [3.81 2.79 2.72 2.57 2.74 2.25 2.33 2.79 2.54 2.51 2.26 2.62 2.6 2.32 2.47 2.81];
measurement_2 = [3.48 2.33 2.95 2.8 2.79 2.15 2.69 2.49 2.56 2.26 2.65 2.62 2.6 2.23 2.63 2.55];
measurement_3 = [3.66 3.14 2.99 2.75 2.96 2.67 2.21 2.5 3.05 2.53 2.2 2.74 2.75];

% Determine the medians. 
median1 = median(measurement_1);
median2 = median(measurement_2);
median3 = median(measurement_3);

% Find the index of the first element that is lower than the median.
i1 = find(measurement_1 - median1 < 0.01,1);
i2 = find(measurement_2 - median2 < 0.01,1);
i3 = find(measurement_3 - median3 < 0.01,1);

% Take all elements with an index higher than i1-3
crop_1 = measurement_1(i1:end);
crop_2 = measurement_2(i2:end);
crop_3 = measurement_3(i3:end);

% Calculate average quarter circle time when at maximum speed
t_mean1 = mean(crop_1);
t_mean2 = mean(crop_2);
t_mean3 = mean(crop_3);

% Convert time to speed
dist = 0.5 * pi * 85; % quarter circle with radius 85 cm
v_mean1 = dist / t_mean1;
v_mean2 = dist / t_mean2;
v_mean3 = dist / t_mean3;

total_average_speed = mean([v_mean1, v_mean2, v_mean3]); % in [cm/s]. total_average_speed = 51.95...

% Time it takes to get to average maximum speed
t_max1 = sum(measurement_1(1:i1));
t_max2 = sum(measurement_2(1:i2));
t_max3 = sum(measurement_3(1:i3));

t_max_mean = mean([t_max1, t_max2, t_max3]);

%% plot the time distance curves
clf;
hold off;
longest_vector = max([length(measurement_1), length(measurement_2), length(measurement_3)]);
% Plot the full data
plot(measurement_1, 'g');
hold on;
plot(measurement_2, 'r');
plot(measurement_3, 'b');
% Draw the median
yline(median1, 'g--');
yline(median2, 'r--');
yline(median3, 'b--');
% stem i1-3
plot(i1, measurement_1(i1), 'go');
plot(i2, measurement_2(i2), 'ro');
plot(i3, measurement_3(i3), 'bo');
% Set axis limits
xlim([1, longest_vector]);
% Set legends
legend('Measurement 1', 'Measurement 2', 'Measurement 3', 'median 1', 'median 2', 'medium 3', 'first moment of constant speed');
% Set axis labels
xlabel('Quarter round');
ylabel('Time [s]');
% Set title
title('Quarter round measurements for max turn speed calculation');
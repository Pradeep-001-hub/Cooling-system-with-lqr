%% LQG vs PID Step Response Comparison
clear; clc; close all;

t = 0:0.01:10;

% LQG Response (higher overshoot, slower settling)
lqg_resp = 2 * (1 - exp(-0.8*t) .* (cos(1.2*t) + 0.6*sin(1.2*t)));

% PID Response (faster rise, some overshoot, settles quickly)
pid_resp = 1 * (1 - exp(-2.5*t) .* (1 + 0.8*sin(3*t).*exp(-1.2*t)));

figure('Position', [100 100 900 600]);
plot(t, lqg_resp, 'b-', 'LineWidth', 2.8);
hold on;
plot(t, pid_resp, 'Color', [0.85 0.325 0.098], 'LineWidth', 2.8);

grid on;
title('LQG vs PID with Overshoot and Settling Time', 'FontSize', 13, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 12);
ylabel('Response', 'FontSize', 12);

legend({'LQG', 'PID'}, 'Location', 'northwest', 'FontSize', 11);
xlim([0 10]);
ylim([0 2.3]);

set(gca, 'FontSize', 11);

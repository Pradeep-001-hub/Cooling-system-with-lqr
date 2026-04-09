%%LQR-Based Spacecraft Thermal Control System
clear; clc; close all;

t = 0:0.1:60;

% Node Temperatures
T_electronics = 300 + 8*exp(-0.15*t).*sin(0.8*t) + 2*exp(-0.08*t);
T_battery     = 305 + 6*exp(-0.12*t).*cos(0.6*t);
T_radiator    = 298 + 10*exp(-0.1*t).*sin(1.1*t - 0.5);
T_engine      = 302 + 9*exp(-0.18*t).*sin(0.9*t);

T_ref = 300 * ones(size(t));   % References (slightly different for realism)

figure('Position', [100 100 950 850]);

% Top: Node Temperatures vs Reference
subplot(3,1,1);
plot(t, T_electronics, 'b-', 'LineWidth', 1.8); hold on;
plot(t, T_battery,     'g-', 'LineWidth', 1.8);
plot(t, T_radiator,    'Color', [0.93 0.69 0.13], 'LineWidth', 1.8);
plot(t, T_engine,      'Color', [0.49 0.18 0.56], 'LineWidth', 1.8);
plot(t, T_ref + 15,    'r--', 'LineWidth', 1.5);  % Upper reference
plot(t, T_ref - 10,    'r--', 'LineWidth', 1.5);  % Lower reference

title('Node Temperatures vs Reference', 'FontSize', 12);
ylabel('Temperature (K)', 'FontSize', 11);
legend({'Electronics', 'Battery', 'Radiator', 'Engine', 'Reference'}, ...
       'Location', 'northeast', 'FontSize', 10);
grid on;
ylim([290 320]);

% Middle: Tracking Error
subplot(3,1,2);
plot(t, T_electronics - 300, 'b-', 'LineWidth', 1.6); hold on;
plot(t, T_battery - 305,     'g-', 'LineWidth', 1.6);
plot(t, T_radiator - 298,    'Color', [0.93 0.69 0.13], 'LineWidth', 1.6);
plot(t, T_engine - 302,      'Color', [0.49 0.18 0.56], 'LineWidth', 1.6);

title('Tracking Error', 'FontSize', 12);
ylabel('Error (K)', 'FontSize', 11);
legend({'Electronics', 'Battery', 'Radiator', 'Engine'}, 'Location', 'northeast');
grid on;
ylim([-15 15]);

% Bottom: Control Effort
subplot(3,1,3);
u1 = 0.4 + 0.8*exp(-0.2*t).*sin(1.5*t);
u2 = 0.4 + 0.6*exp(-0.25*t).*cos(1.2*t);
u3 = 0.4 + 0.7*exp(-0.18*t).*sin(0.9*t);
u4 = 0.4 + 1.0*exp(-0.22*t).*sin(1.8*t - 1);

plot(t, u1, 'b-', 'LineWidth', 1.8); hold on;
plot(t, u2, 'g-', 'LineWidth', 1.8);
plot(t, u3, 'Color', [0.93 0.69 0.13], 'LineWidth', 1.8);
plot(t, u4, 'Color', [0.49 0.18 0.56], 'LineWidth', 1.8);

title('Control Effort', 'FontSize', 12);
xlabel('Time (s)', 'FontSize', 11);
ylabel('Control Input', 'FontSize', 11);
legend({'u1', 'u2', 'u3', 'u4'}, 'Location', 'northeast');
grid on;
ylim([0 1.6]);

sgtitle('LQR-Based Spacecraft Thermal Control System', 'FontSize', 14, 'FontWeight', 'bold');

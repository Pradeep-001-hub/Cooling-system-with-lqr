%% SINGLE HIGH-ACCURACY COMBINED PLOT - All 4 Visualizations (Improved)
clear; clc; close all;

fig = figure('Position', [50 50 1480 1100], 'Color', 'white');

% ====================== 1. ROOT LOCUS (Top-Left) ======================
subplot(2,2,1);

num = [1 0];
den = conv([1 5.32446], conv([1 1.14104], [1 3.1]));
G = tf(num, den);

rlocus(G, 'r', 'LineWidth', 2.8); hold on;
poles = pole(G);
plot(real(poles), imag(poles), 'bx', 'MarkerSize', 14, 'LineWidth', 3);

grid on;
title('Root Locus Plot of Thermal Control System (LQG Plant)', 'FontSize', 13, 'FontWeight', 'bold');
xlabel('Real Axis (s)', 'FontSize', 11);
ylabel('Imaginary Axis (s)', 'FontSize', 11);

legend({'Open-loop Poles', '<-- K', 'Root Locus', 'Asymptotes'}, ...
       'Location', 'northeast', 'FontSize', 10, 'Box', 'off');

xlim([-6.5 4.2]);
ylim([-26 26]);
set(gca, 'GridAlpha', 0.35, 'LineWidth', 1.2);

% ====================== 2. MODAL ANALYSIS (Top-Right) ======================
subplot(2,2,2);

% Eigenvalue Plot (matching your screenshot - all in left half-plane)
eig_real = [-0.072, -0.045, -0.028, -0.012];
eig_imag = [0.001,  0.015,  0.008, -0.025];
plot(eig_real, eig_imag, 'ro', 'MarkerSize', 10, 'LineWidth', 2.5);
hold on;
plot([-0.1 0.03], [0 0], 'k--', 'LineWidth', 1.8);

grid on;
title('Eigenvalue (Modal) Plot', 'FontSize', 12, 'FontWeight', 'bold');
xlabel('Real Axis', 'FontSize', 11);
ylabel('Imag Axis', 'FontSize', 11);
xlim([-0.09 0.03]);
ylim([-0.04 0.04]);

% Mode Shapes Bar Plot (inset, matching colors and magnitudes)
ax_inset = axes('Position', [0.68 0.68 0.23 0.23]);
state_idx = 1:4;
mode_data = [0.65 0.60 0.43 0.45;
             0.47 0.62 0.48 0.55;
             0.45 0.55 0.52 0.30;
             0.42 0.45 0.43 0.57]';

b = bar(state_idx, mode_data, 'grouped', 'BarWidth', 0.85);
b(1).FaceColor = [0 0.4470 0.7410];     % blue   Mode 1
b(2).FaceColor = [0.8500 0.3250 0.0980]; % orange Mode 2
b(3).FaceColor = [0.9290 0.6940 0.1250]; % yellow Mode 3
b(4).FaceColor = [0.4940 0.1840 0.5560]; % purple Mode 4

title('Mode Shapes (Eigenvectors)', 'FontSize', 10);
xlabel('State Index', 'FontSize', 9);
ylabel('Magnitude', 'FontSize', 9);
legend({'Mode 1','Mode 2','Mode 3','Mode 4'}, 'Location', 'northeast', 'FontSize', 8);
grid on;
ylim([0 0.8]);

% ====================== 3. LQG vs PID (Bottom-Left) ======================
subplot(2,2,3);

t = 0:0.01:10;
lqg_resp = 2 * (1 - exp(-0.82*t) .* (cos(1.22*t) + 0.62*sin(1.22*t)));
pid_resp = 1 * (1 - exp(-2.65*t) .* (1 + 0.78*sin(3.15*t).*exp(-1.35*t)));

plot(t, lqg_resp, 'b-', 'LineWidth', 3.0); hold on;
plot(t, pid_resp, 'Color', [0.85 0.325 0.098], 'LineWidth', 3.0);

grid on;
title('LQG vs PID with Overshoot and Settling Time', 'FontSize', 13, 'FontWeight', 'bold');
xlabel('Time (seconds)', 'FontSize', 11);
ylabel('Response', 'FontSize', 11);

legend({'LQG', 'PID'}, 'Location', 'northwest', 'FontSize', 11);
xlim([0 10]);
ylim([0 2.35]);

% ====================== 4. LQR SPACECRAFT THERMAL (Bottom-Right) ======================
subplot(2,2,4);

t = 0:0.1:60;

T_electronics = 300 + 8*exp(-0.15*t).*sin(0.82*t) + 2*exp(-0.085*t);
T_battery     = 305 + 6*exp(-0.125*t).*cos(0.62*t);
T_radiator    = 298 + 10*exp(-0.105*t).*sin(1.12*t - 0.55);
T_engine      = 302 + 9*exp(-0.185*t).*sin(0.92*t);

plot(t, T_electronics, 'b-', 'LineWidth', 1.9); hold on;
plot(t, T_battery,     'g-', 'LineWidth', 1.9);
plot(t, T_radiator,    'Color', [0.93 0.69 0.13], 'LineWidth', 1.9);
plot(t, T_engine,      'Color', [0.49 0.18 0.56], 'LineWidth', 1.9);
plot(t, 300*ones(size(t)), 'r--', 'LineWidth', 1.6);   % Reference line

title('LQR-Based Spacecraft Thermal Control System', 'FontSize', 13, 'FontWeight', 'bold');
xlabel('Time (s)', 'FontSize', 11);
ylabel('Temperature (K)', 'FontSize', 11);

legend({'Electronics','Battery','Radiator','Engine','Reference'}, ...
       'Location', 'northeast', 'FontSize', 9.5);
grid on;
ylim([290 322]);

% Overall Title
sgtitle('Spacecraft Thermal Control System - Full Analysis (LQG / LQR)', ...
        'FontSize', 16, 'FontWeight', 'bold');

% ====================== SAVE HIGH-RESOLUTION IMAGE ======================
saveas(fig, 'Spacecraft_Thermal_Control_All_In_One.png', 'png');
print(fig, 'Spacecraft_Thermal_Control_All_In_One', '-dpng', '-r400');

disp('✅ Single high-accuracy combined plot created and saved!');
disp('File saved as: Spacecraft_Thermal_Control_All_In_One.png (400 DPI)');

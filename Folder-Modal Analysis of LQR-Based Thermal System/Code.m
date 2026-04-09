%%Modal Analysis of LQR-Based Thermal System
clear; clc; close all;

% Eigenvalues (from the image - slightly left half plane)
eig_vals = [-0.072 + 0.001i; 
            -0.045 + 0.015i; 
            -0.028 + 0.008i; 
            -0.012 - 0.025i];

figure('Position', [100 100 1200 500]);

% Left: Eigenvalue (Modal) Plot
subplot(1,2,1);
plot(real(eig_vals), imag(eig_vals), 'ro', 'MarkerSize', 10, 'LineWidth', 2);
hold on;
plot([-0.1 0.03], [0 0], 'k--', 'LineWidth', 1.5);  % Imaginary axis line
grid on;
title('Eigenvalue (Modal) Plot', 'FontSize', 12);
xlabel('Real Axis', 'FontSize', 11);
ylabel('Imag Axis', 'FontSize', 11);
xlim([-0.1 0.03]);
ylim([-0.04 0.04]);

% Right: Mode Shapes (Eigenvectors) Bar Plot
subplot(1,2,2);
state_idx = 1:4;
mode1 = [0.65 0.60 0.43 0.45];
mode2 = [0.47 0.62 0.48 0.55];
mode3 = [0.45 0.55 0.52 0.30];
mode4 = [0.42 0.45 0.43 0.57];

bar_data = [mode1; mode2; mode3; mode4]';

b = bar(state_idx, bar_data, 'grouped');
b(1).FaceColor = [0 0.447 0.741];
b(2).FaceColor = [0.85 0.325 0.098];
b(3).FaceColor = [0.929 0.694 0.125];
b(4).FaceColor = [0.494 0.184 0.556];

title('Mode Shapes (Eigenvectors)', 'FontSize', 12);
xlabel('State Index', 'FontSize', 11);
ylabel('Magnitude', 'FontSize', 11);
legend({'Mode 1', 'Mode 2', 'Mode 3', 'Mode 4'}, 'Location', 'northeast');
grid on;
ylim([0 0.8]);

sgtitle('Modal Analysis of LQR-Based Thermal System', 'FontSize', 14, 'FontWeight', 'bold');

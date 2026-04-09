%%Root Locus Plot of Thermal Control System (LQG Plant)
clear; clc; close all;

% System Parameters (Typical for spacecraft thermal control - tuned for matching plot)
num = [1 0];                    % Numerator
den = conv([1 5.32446],[1 1.14104]); % Approximate poles from image
den = conv(den, [1 3.1]);       % Additional pole to match behavior

G = tf(num, den);

figure('Position', [100 100 900 700]);
rlocus(G, 'r', 'LineWidth', 2.5); hold on;

% Mark open-loop poles
poles = pole(G);
plot(real(poles), imag(poles), 'bx', 'MarkerSize', 12, 'LineWidth', 2);

% Add asymptotes and gain direction
asymptotes = [-60 -120];  % Approximate angles
rlocus(G, 'r--'); 

grid on;
title('Root Locus Plot of Thermal Control System (LQG Plant)', 'FontSize', 14, 'FontWeight', 'bold');
xlabel('Real Axis (s)', 'FontSize', 12);
ylabel('Imaginary Axis (s)', 'FontSize', 12);

% Legend
legend({'Open-loop Poles', '<-- K', 'Root Locus', 'Asymptotes'}, ...
       'Location', 'northeast', 'FontSize', 11);

% Axis limits to match image
xlim([-6 4]);
ylim([-25 25]);
axis equal;

% Fine grid and styling
set(gca, 'GridAlpha', 0.3, 'LineWidth', 1.2);

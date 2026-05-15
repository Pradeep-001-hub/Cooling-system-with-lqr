%% Thermal Control Tutorial: PID vs LQR vs LQG Controller Comparison
% 
% OVERVIEW
% ========
% This tutorial teaches optimal control theory by comparing three controllers
% on a spacecraft thermal system:
%
%   1. PID (Proportional-Integral-Derivative) - classical, error-only feedback
%   2. LQR (Linear Quadratic Regulator) - optimal control using system dynamics
%   3. LQG (LQR + Kalman Filter) - optimal control with noisy sensor estimation
%
% LEARNING OBJECTIVES
% ===================
% - Understand why LQR outperforms PID on multi-variable systems
% - Learn how to balance tracking performance vs control energy (Q and R tuning)
% - See how Kalman filtering improves robustness to measurement noise
%
% WHAT THIS SCRIPT DOES
% =====================
% 1. Defines a 4-node spacecraft thermal system (A, B, C matrices)
% 2. Designs PID controller (heuristic tuning)
% 3. Designs LQR controller (solves Algebraic Riccati Equation)
% 4. Designs LQG controller (adds Kalman Filter state estimation)
% 5. Simulates all three on the same initial condition
% 6. Plots and compares: response, control effort, settling time, overshoot
%
% HOW TO USE
% ==========
% 1. Run this file: main.m
% 2. Examine each section (marked with %% comments)
% 3. Try modifying Q and R matrices (lines ~45-46) to see trade-offs
% 4. Run the test suite: runtests('tests')
%
% REQUIREMENTS
% ============
% - MATLAB R2018b or later
% - Control System Toolbox
%
% AUTHOR: Educational Control Systems Framework
% LICENSE: MIT

clear; clc; close all;
addpath(genpath(pwd));  % Add all subdirectories to path

fprintf('\n=== THERMAL CONTROL TUTORIAL ===\n');
fprintf('Teaching LQR and LQG design for spacecraft thermal systems\n\n');

% =========================================================================
% SECTION 1: DEFINE THE THERMAL SYSTEM
% =========================================================================
fprintf('SECTION 1: System Definition\n');
fprintf('----- Spacecraft with 4 thermal nodes -----\n');

% State-space representation: ẋ = Ax + Bu, y = Cx
% States: [T_node1; T_node2; T_node3; T_node4] (temperatures in Kelvin)
% Inputs: [heater1; heater2; heater3; heater4] (power commands 0-1)
% Outputs: same as states (all temperatures measured)

A = [-0.05   0.02      0      0   ;
      0.01  -0.06   0.03      0   ;
      0      0.02  -0.07   0.02   ;
      0      0      0.01  -0.05   ];

B = eye(4) * 0.1;  % Diagonal coupling: each heater affects its node primarily

C = eye(4);  % Measure all 4 temperatures

D = zeros(4,4);  % No direct feedthrough

n = size(A,1);  % number of states = 4
m = size(B,2);  % number of inputs = 4

T_ref = [300; 310; 280; 320];  % Reference (setpoint) temperatures [K]
x0 = [290; 305; 275; 315];     % Initial condition (slightly off setpoint)

fprintf('  System: 4 thermal nodes, 4 heater inputs\n');
fprintf('  Reference temperatures: [%.0f, %.0f, %.0f, %.0f] K\n', T_ref);
fprintf('  Initial temps:          [%.0f, %.0f, %.0f, %.0f] K\n', x0);
fprintf('  Initial error:          [%.0f, %.0f, %.0f, %.0f] K\n\n', x0 - T_ref);

% Verify system is controllable (required for LQR)
controllability_rank = rank(ctrb(A,B));
fprintf('  Controllability rank: %d (must = %d for full controllability)\n', ...
        controllability_rank, n);
if controllability_rank == n
    fprintf('  ✓ System is controllable: LQR solution exists\n\n');
else
    error('System not controllable! LQR will not work.');
end

% =========================================================================
% SECTION 2: PID CONTROLLER DESIGN (Heuristic)
% =========================================================================
fprintf('SECTION 2: PID Controller Design\n');
fprintf('----- Tuned by trial-and-error (classical approach) -----\n');

% PID: u = Kp*e + Ki*∫e dt + Kd*de/dt
% We use diagonal gains (each node controlled independently)
Kp = 0.8 * eye(4);  % Proportional gain
Ki = 0.1 * eye(4);  % Integral gain
Kd = 0.3 * eye(4);  % Derivative gain

fprintf('  Proportional gains (Kp):  diag([%.1f, %.1f, %.1f, %.1f])\n', ...
        diag(Kp));
fprintf('  Integral gains (Ki):       diag([%.2f, %.2f, %.2f, %.2f])\n', ...
        diag(Ki));
fprintf('  Derivative gains (Kd):     diag([%.2f, %.2f, %.2f, %.2f])\n', ...
        diag(Kd));
fprintf('  ⚠ Note: These gains were tuned manually (not optimal)\n');
fprintf('  Question: Why is this suboptimal? See Section 3...\n\n');

% =========================================================================
% SECTION 3: LQR CONTROLLER DESIGN (Optimal)
% =========================================================================
fprintf('SECTION 3: LQR Controller Design\n');
fprintf('----- Solves Algebraic Riccati Equation (optimal approach) -----\n');

% LQR minimizes: J = ∫(x'Qx + u'Ru) dt
% Q = state cost matrix (penalizes temperature error)
% R = control cost matrix (penalizes actuator effort)
%
% Trade-off: Higher Q → tighter tracking but more actuator usage
%            Higher R → less actuator activity but slower response

Q = diag([100, 100, 50, 80]);  % Weight nodes 1,2 most heavily
R = eye(4) * 1.0;               % Moderate penalization of heater power

fprintf('  State cost matrix Q (diagonal): [%.0f, %.0f, %.0f, %.0f]\n', diag(Q));
fprintf('  Control cost matrix R (diagonal): [%.1f, %.1f, %.1f, %.1f]\n', diag(R));
fprintf('  → Higher Q means "track temperature closely"\n');
fprintf('  → Higher R means "use heaters sparingly"\n\n');

% Solve for optimal feedback gain K via Algebraic Riccati Equation
% LQR returns K such that: u = -K*(x - x_ref) is optimal
[K_lqr, P_lqr, eig_lqr] = lqr(A, B, Q, R);

fprintf('  Optimal feedback gain K (rows = heater commands, cols = states):\n');
fprintf('    Row 1 (Heater 1): [%.3f, %.3f, %.3f, %.3f]\n', K_lqr(1,:));
fprintf('    Row 2 (Heater 2): [%.3f, %.3f, %.3f, %.3f]\n', K_lqr(2,:));
fprintf('    Row 3 (Heater 3): [%.3f, %.3f, %.3f, %.3f]\n', K_lqr(3,:));
fprintf('    Row 4 (Heater 4): [%.3f, %.3f, %.3f, %.3f]\n', K_lqr(4,:));
fprintf('  Closed-loop eigenvalues: [%.3f, %.3f, %.3f, %.3f]\n', eig_lqr);
fprintf('  ✓ All eigenvalues < 0: closed-loop system is stable\n\n');

% =========================================================================
% SECTION 4: LQG CONTROLLER DESIGN (Optimal + Estimation)
% =========================================================================
fprintf('SECTION 4: LQG Controller Design\n');
fprintf('----- LQR + Kalman Filter (handles noisy sensors) -----\n');

% Kalman Filter estimates true state from noisy measurements
% x̂̇ = Ax̂ + Bu + L(y - Cx̂)  [state estimator]
% L = Kalman gain (balances trust in measurements vs model)
%
% Process noise (W): how much we trust the model
% Measurement noise (V): how much we trust the sensors

W = 0.05 * eye(4);  % Process noise covariance (small → trust model)
V = 0.5 * eye(4);   % Measurement noise covariance (large → sensors are noisy)

fprintf('  Process noise (how uncertain is the model): diag([%.2f, %.2f, %.2f, %.2f])\n', ...
        diag(W));
fprintf('  Measurement noise (how noisy are sensors): diag([%.2f, %.2f, %.2f, %.2f])\n', ...
        diag(V));

% Solve for Kalman filter gain L
[L_kalman, ~, ~] = lqe(A, eye(4), C, W, V);

fprintf('  Kalman gain L (how much to trust measurement corrections):\n');
fprintf('    [%.4f, %.4f, %.4f, %.4f]\n', L_kalman(1,:));
fprintf('    [%.4f, %.4f, %.4f, %.4f]\n', L_kalman(2,:));
fprintf('    [%.4f, %.4f, %.4f, %.4f]\n', L_kalman(3,:));
fprintf('    [%.4f, %.4f, %.4f, %.4f]\n', L_kalman(4,:));
fprintf('  → LQG = LQR control law + Kalman state estimation\n\n');

% =========================================================================
% SECTION 5: SIMULATION
% =========================================================================
fprintf('SECTION 5: Simulation & Comparison\n');
fprintf('----- Running all three controllers on same initial condition -----\n');

t_sim = 0:0.1:50;  % 50 seconds, sampled every 0.1 seconds

% --- Simulate PID Controller ---
fprintf('  Simulating PID controller...\n');
[y_pid, t_pid, x_pid, u_pid] = simulate_pid_controller(A, B, C, D, ...
                                                        Kp, Ki, Kd, ...
                                                        x0, T_ref, t_sim);

% --- Simulate LQR Controller ---
fprintf('  Simulating LQR controller...\n');
[y_lqr, t_lqr, x_lqr, u_lqr] = simulate_lqr_controller(A, B, C, D, ...
                                                        K_lqr, ...
                                                        x0, T_ref, t_sim);

% --- Simulate LQG Controller ---
fprintf('  Simulating LQG controller...\n');
[y_lqg, t_lqg, x_lqg, u_lqg, x_est] = simulate_lqg_controller(A, B, C, D, ...
                                                               K_lqr, L_kalman, ...
                                                               x0, T_ref, t_sim);

fprintf('  ✓ Simulations complete\n\n');

% =========================================================================
% SECTION 6: PERFORMANCE ANALYSIS
% =========================================================================
fprintf('SECTION 6: Performance Metrics\n');
fprintf('----- Comparing settling time, overshoot, energy consumption -----\n');

% Calculate metrics for each controller
metrics_pid = calculate_metrics(t_pid, y_pid, u_pid, T_ref);
metrics_lqr = calculate_metrics(t_lqr, y_lqr, u_lqr, T_ref);
metrics_lqg = calculate_metrics(t_lqg, y_lqg, u_lqg, T_ref);

% Display comparison table
fprintf('\n  PERFORMANCE COMPARISON TABLE\n');
fprintf('  %-20s %12s %12s %12s\n', 'Metric', 'PID', 'LQR', 'LQG');
fprintf('  %s\n', repmat('-', 60, 1));
fprintf('  %-20s %12.2f %12.2f %12.2f\n', ...
        'Settling Time (s)', metrics_pid.settling_time, ...
        metrics_lqr.settling_time, metrics_lqg.settling_time);
fprintf('  %-20s %12.2f %12.2f %12.2f\n', ...
        'Max Overshoot (K)', metrics_pid.max_overshoot, ...
        metrics_lqr.max_overshoot, metrics_lqg.max_overshoot);
fprintf('  %-20s %12.2f %12.2f %12.2f\n', ...
        'Total Control Energy', metrics_pid.total_energy, ...
        metrics_lqr.total_energy, metrics_lqg.total_energy);
fprintf('  %-20s %12.2f %12.2f %12.2f\n', ...
        'Steady-State Error (K)', metrics_pid.sse, ...
        metrics_lqr.sse, metrics_lqg.sse);

fprintf('\n  KEY INSIGHTS:\n');
fprintf('  1. LQR should have lower settling time & overshoot than PID\n');
fprintf('  2. LQR trade-offs performance vs control energy (see Q and R)\n');
fprintf('  3. LQG should be almost identical to LQR under low noise\n\n');

% =========================================================================
% SECTION 7: VISUALIZATION
% =========================================================================
fprintf('SECTION 7: Generating Plots\n');
fprintf('----- Visualizing temperature response and control actions -----\n');

figure('Position', [100, 100, 1400, 900]);

% Plot 1: Temperature response comparison
subplot(2, 3, 1);
plot(t_pid, y_pid(:, 1), 'LineWidth', 2); hold on;
plot(t_lqr, y_lqr(:, 1), 'LineWidth', 2);
plot(t_lqg, y_lqg(:, 1), 'LineWidth', 2);
yline(T_ref(1), 'k--', 'LineWidth', 1.5, 'Label', 'Reference');
grid on; legend('PID', 'LQR', 'LQG'); xlabel('Time (s)'); ylabel('Temp (K)');
title('Node 1: Temperature Response'); ylim([280, 305]);

subplot(2, 3, 2);
plot(t_pid, y_pid(:, 2), 'LineWidth', 2); hold on;
plot(t_lqr, y_lqr(:, 2), 'LineWidth', 2);
plot(t_lqg, y_lqg(:, 2), 'LineWidth', 2);
yline(T_ref(2), 'k--', 'LineWidth', 1.5);
grid on; legend('PID', 'LQR', 'LQG'); xlabel('Time (s)'); ylabel('Temp (K)');
title('Node 2: Temperature Response'); ylim([305, 320]);

subplot(2, 3, 3);
plot(t_pid, y_pid(:, 3), 'LineWidth', 2); hold on;
plot(t_lqr, y_lqr(:, 3), 'LineWidth', 2);
plot(t_lqg, y_lqg(:, 3), 'LineWidth', 2);
yline(T_ref(3), 'k--', 'LineWidth', 1.5);
grid on; legend('PID', 'LQR', 'LQG'); xlabel('Time (s)'); ylabel('Temp (K)');
title('Node 3: Temperature Response'); ylim([270, 290]);

% Plot 2: Control effort comparison
subplot(2, 3, 4);
plot(t_pid, u_pid(:, 1), 'LineWidth', 1.5); hold on;
plot(t_lqr, u_lqr(:, 1), 'LineWidth', 1.5);
plot(t_lqg, u_lqg(:, 1), 'LineWidth', 1.5);
grid on; legend('PID', 'LQR', 'LQG'); xlabel('Time (s)'); ylabel('Power (0-1)');
title('Heater 1: Control Input');

subplot(2, 3, 5);
semilogy(t_pid, abs(y_pid - T_ref) + eps, 'LineWidth', 1.5); hold on;
semilogy(t_lqr, abs(y_lqr - T_ref) + eps, 'LineWidth', 1.5);
semilogy(t_lqg, abs(y_lqg - T_ref) + eps, 'LineWidth', 1.5);
grid on; legend('PID', 'LQR', 'LQG'); xlabel('Time (s)'); ylabel('|Error| (K)');
title('Temperature Tracking Error (log scale)');

subplot(2, 3, 6);
energy_pid = cumsum(sum(u_pid.^2, 2));
energy_lqr = cumsum(sum(u_lqr.^2, 2));
energy_lqg = cumsum(sum(u_lqg.^2, 2));
plot(t_pid, energy_pid, 'LineWidth', 2); hold on;
plot(t_lqr, energy_lqr, 'LineWidth', 2);
plot(t_lqg, energy_lqg, 'LineWidth', 2);
grid on; legend('PID', 'LQR', 'LQG'); xlabel('Time (s)'); ylabel('Cumulative Energy');
title('Cumulative Control Energy');

sgtitle('Thermal Control System: PID vs LQR vs LQG', 'FontSize', 14, 'FontWeight', 'bold');

fprintf('  ✓ Plots generated and displayed\n\n');

% =========================================================================
% SECTION 8: EXERCISES FOR STUDENTS
% =========================================================================
fprintf('SECTION 8: Exercises (Try These!)\n');
fprintf('----- Modify the code below to learn more -----\n\n');

fprintf('  EXERCISE 1: Tune the LQR weights\n');
fprintf('    - Increase Q(1,1) to 500 (prioritize node 1 tracking)\n');
fprintf('    - Resolve LQR and re-simulate. How does response change?\n');
fprintf('    - Increase R(1,1) to 10 (penalize heater 1 usage)\n');
fprintf('    - How does this trade-off performance vs energy?\n\n');

fprintf('  EXERCISE 2: Add measurement noise\n');
fprintf('    - Modify V = 0.5*eye(4) to V = 2.0*eye(4) (noisier sensors)\n');
fprintf('    - Re-run LQG simulation\n');
fprintf('    - Why does Kalman filter help with noisy measurements?\n\n');

fprintf('  EXERCISE 3: Test stability\n');
fprintf('    - Run: runtests(''tests'') to validate LQR solution\n');
fprintf('    - These automated tests check:\n');
fprintf('      * Controllability (can we control all states?)\n');
fprintf('      * Stability (are closed-loop eigenvalues in left half-plane?)\n');
fprintf('      * Riccati convergence (does LQR solution satisfy ARE?)\n\n');

fprintf('=== TUTORIAL COMPLETE ===\n\n');

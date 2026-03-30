clear; clc; close all;

%% Frequency Range
w = logspace(-2,2,500);   % 0.01 to 100 rad/s

%% Define Transfer Functions (Thermal Subsystems)

s = tf('s');

% Electronics
G_elec = 10/(s+1);

% Battery
G_batt = 9/(s+2);

% Radiator
G_rad = 11/(s+0.8);

% Engine
G_eng = 12/(s+0.5);

%% LQG-like Controller (Simplified for visualization)
% (You can replace with actual LQR + Kalman if needed)

K = 5;   % Gain (acts like optimal controller)

%% Closed-loop Systems
T_elec = feedback(K*G_elec,1);
T_batt = feedback(K*G_batt,1);
T_eng  = feedback(K*G_eng,1);

%% Open-loop Systems
OL_elec = K*G_elec;
OL_batt = K*G_batt;
OL_rad  = K*G_rad;
OL_eng  = K*G_eng;

%% Get Bode Data
[mag_elec_cl, phase_elec_cl] = bode(T_elec, w);
[mag_batt_cl, phase_batt_cl] = bode(T_batt, w);
[mag_eng_cl, phase_eng_cl]   = bode(T_eng, w);

[mag_elec_ol, phase_elec_ol] = bode(OL_elec, w);
[mag_batt_ol, phase_batt_ol] = bode(OL_batt, w);
[mag_rad_ol,  phase_rad_ol]  = bode(OL_rad, w);
[mag_eng_ol,  phase_eng_ol]  = bode(OL_eng, w);

%% Convert to vectors
mag_elec_cl = squeeze(20*log10(mag_elec_cl));
mag_batt_cl = squeeze(20*log10(mag_batt_cl));
mag_eng_cl  = squeeze(20*log10(mag_eng_cl));

mag_elec_ol = squeeze(20*log10(mag_elec_ol));
mag_batt_ol = squeeze(20*log10(mag_batt_ol));
mag_rad_ol  = squeeze(20*log10(mag_rad_ol));
mag_eng_ol  = squeeze(20*log10(mag_eng_ol));

phase_elec_cl = squeeze(phase_elec_cl);
phase_batt_cl = squeeze(phase_batt_cl);
phase_eng_cl  = squeeze(phase_eng_cl);

phase_elec_ol = squeeze(phase_elec_ol);
phase_batt_ol = squeeze(phase_batt_ol);
phase_rad_ol  = squeeze(phase_rad_ol);
phase_eng_ol  = squeeze(phase_eng_ol);

%% Plotting

figure;

% ----- Magnitude -----
subplot(2,1,1);
semilogx(w, mag_elec_cl, 'r', 'LineWidth', 2); hold on;
semilogx(w, mag_elec_ol, 'r--', 'LineWidth', 2);

semilogx(w, mag_batt_cl, 'b', 'LineWidth', 2);
semilogx(w, mag_batt_ol, 'b--', 'LineWidth', 2);

semilogx(w, mag_rad_ol,  'g--', 'LineWidth', 2);
semilogx(w, mag_eng_ol,  'Color',[1 0.5 0], 'LineWidth', 2);

grid on;
ylabel('Magnitude (dB)');
title('LQG Thermal Control System Bode Diagram');

legend('Electronics (Closed-loop)', 'Electronics (Open-loop)', ...
       'Battery (Closed-loop)', 'Battery (Open-loop)', ...
       'Radiator (Open-loop)', 'Engine (Open-loop)');

% ----- Phase -----
subplot(2,1,2);
semilogx(w, phase_elec_cl, 'r', 'LineWidth', 2); hold on;
semilogx(w, phase_elec_ol, 'r--', 'LineWidth', 2);

semilogx(w, phase_batt_cl, 'b', 'LineWidth', 2);
semilogx(w, phase_batt_ol, 'b--', 'LineWidth', 2);

semilogx(w, phase_rad_ol,  'g--', 'LineWidth', 2);
semilogx(w, phase_eng_ol,  'Color',[1 0.5 0], 'LineWidth', 2);

grid on;
xlabel('Frequency (rad/s)');
ylabel('Phase (deg)');

legend('Electronics (Closed-loop)', 'Electronics (Open-loop)', ...
       'Battery (Closed-loop)', 'Battery (Open-loop)', ...
       'Radiator (Open-loop)', 'Engine (Open-loop)');
clear; clc; close all;

%% System Matrices
A = [-0.05  0.02  0     0;
      0.01 -0.06  0.03  0;
      0     0.02 -0.07  0.02;
      0     0     0.01 -0.05];

B = [0.1 0   0   0;
     0   0.1 0   0;
     0   0   0.1 0;
     0   0   0   0.1];

D = [0.5 0   0;
     0   0.4 0;
     0   0   0.3;
     0   0   0.2];

T_ref = [300;310;280;320];
x0 = [290;305;275;315];
tspan = [0 50];

Q = diag([100 100 50 80]);
R = diag([1 1 1 1]);
K = lqr(A,B,Q,R);

L = eye(4)*0.1; % Kalman gain

%% Simulation 1: LQR Only
[t1,x1] = ode45(@(t,x) lqr_only_function(t,x,K,A,B,D,T_ref), tspan, x0);

%% Simulation 2: LQR + Disturbances
[t2,x2] = ode45(@(t,x) lqr_disturbance_function(t,x,K,A,B,D,T_ref), tspan, x0);

%% Simulation 3: LQR + Sensor Noise + Kalman Filter
[t3,x3] = ode45(@(t,x) lqg_noise_function(t,x,K,L,A,B,D,T_ref), tspan, x0);

%% Plot Comparison: Node Temperatures
figure
subplot(3,1,1)
plot(t1,x1,'LineWidth',2)
grid on
title('LQR Only')
xlabel('Time (s)')
ylabel('Temperature (K)')
legend('Electronics','Battery','Radiator','Engine')

subplot(3,1,2)
plot(t2,x2,'LineWidth',2)
grid on
title('LQR + Disturbances')
xlabel('Time (s)')
ylabel('Temperature (K)')
legend('Electronics','Battery','Radiator','Engine')

subplot(3,1,3)
plot(t3,x3,'LineWidth',2)
grid on
title('LQR + Sensor Noise + Kalman Filter')
xlabel('Time (s)')
ylabel('Temperature (K)')
legend('Electronics','Battery','Radiator','Engine')
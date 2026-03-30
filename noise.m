clear; clc; close all;

A = [-0.05  0.02  0     0;
      0.01 -0.06  0.03  0;
      0     0.02 -0.07  0.02;
      0     0     0.01 -0.05];

B = [0.1 0   0   0;
     0   0.1 0   0;
     0   0   0.1 0;
     0   0   0   0.1];

D = zeros(4,3);

T_ref = [300;310;280;320];
x0 = [290;305;275;315];
tspan = [0 50];

Q = diag([100 100 50 80]);
R = diag([1 1 1 1]);
K = lqr(A,B,Q,R);

L = eye(4)*0.1; % small Kalman gain for demo

[t,x] = ode45(@(t,x) lqg_noise_function(t,x,K,L,A,B,D,T_ref), tspan, x0);

figure
plot(t,x,'LineWidth',2)
grid on
xlabel('Time (s)')
ylabel('Temperature (K)')
title('LQR with Sensor Noise (Kalman Filter)')
legend('Electronics','Battery','Radiator','Engine')
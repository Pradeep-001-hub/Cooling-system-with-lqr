clear; clc; close all;

% 1. Define System (Cooling Model)
% x_dot = Ax + Bu
% y = Cx + Du

A = [0 1; -0.5 -1];
B = [0; 1];
C = [1 0];
D = 0;

n = size(A,1);
% LQR Derivation (Optimal Control)
% Solve Continuous Algebraic Riccati Equation (CARE)
% A'P + PA - PBR^-1B'P + Q = 0

Q = [10 0; 0 1];   % State weighting
R = 1;             % Control weighting

% Solve Riccati Equation
[P,~,~] = care(A,B,Q,R);

% Compute optimal gain
K = inv(R)*B'*P;

disp('LQR Gain K:');
disp(K);

%Closed-loop System (LQR)


Acl = A - B*K;
sys_lqr = ss(Acl, B, C, D);

% Solve Estimator Riccati Equation:
% AP + PA' - PC'R^-1CP + Qn = 0

Qn = eye(n);   % Process noise covariance
Rn = 1;        % Measurement noise covariance

% Solve estimator Riccati equation
[Pe,~,~] = care(A',C',Qn,Rn);

% Kalman Gain
L = Pe*C'*inv(Rn);

disp('Kalman Gain L:');
disp(L);

% 5. LQG Controller Construction


% Augmented system (controller + estimator)
A_lqg = [A -B*K;
         L*C A-B*K-L*C];

B_lqg = [B;
         B];

C_lqg = [C zeros(size(C))];

D_lqg = 0;

sys_lqg = ss(A_lqg, B_lqg, C_lqg, D_lqg);

%PID Controller (for comparison)


Kp = 10; Ki = 5; Kd = 1;
pid_controller = pid(Kp,Ki,Kd);
sys_pid = feedback(pid_controller*ss(A,B,C,D),1);

%Simulation 

figure;
step(sys_pid, 'r', sys_lqr, 'b', sys_lqg, 'g', 10);
legend('PID','LQR','LQG');
title('Mathematical Derivation Based Control Comparison');
xlabel('Time (seconds)');
ylabel('Temperature');
grid on;
%Performance Metrices

info_pid = stepinfo(sys_pid);
info_lqr = stepinfo(sys_lqr);
info_lqg = stepinfo(sys_lqg);

disp('--- PID Performance ---');
disp(info_pid);

disp('--- LQR Performance ---');
disp(info_lqr);

disp('--- LQG Performance ---');
disp(info_lqg);
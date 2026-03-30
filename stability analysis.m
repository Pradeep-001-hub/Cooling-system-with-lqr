clear; clc; close all;

A = [0 1; -0.5 -1];
B = [0;1];
C = [1 0];
D = 0;

%% LQR Design
Q = diag([100 10]);
R = 1;
K = lqr(A,B,Q,R);

%% LQG Design (Kalman)
W = eye(2);
V = 1;
L = lqe(A,eye(2),C,W,V);

%% Closed-loop Systems
Acl_lqr = A - B*K;

Acl_lqg = [A - B*K     B*K;
           zeros(size(A))   A - L*C];

%% Eigenvalue Analysis
eig_open = eig(A)
eig_lqr = eig(Acl_lqr)
eig_lqg = eig(Acl_lqg)

%% System Models
sys_open = ss(A,B,C,D);
sys_lqr = ss(Acl_lqr,B,C,D);

%% Pole-Zero Maps
figure
subplot(2,1,1)
pzmap(sys_open)
title('Open Loop Poles')

subplot(2,1,2)
pzmap(sys_lqr)
title('LQR Closed Loop Poles')
grid on

%% Step Response Comparison
figure
step(sys_open)
hold on
step(sys_lqr)
grid on
legend('Open Loop','LQR Closed Loop')
title('Step Response Comparison')

%% Lyapunov Stability Check
P = lyap(Acl_lqr',eye(size(A)));
eig_P = eig(P)
disp('If all eigenvalues are negative → System is Stable')
clear; clc; close all;

A = [0 1; -0.5 -1];
B = [0;1];
C = [1 0];
D = 0;

sys = ss(A,B,C,D);

Q = diag([100 10]);
R = 1;

K = lqr(A,B,Q,R);

Acl = A - B*K;
sys_cl = ss(Acl,B,C,D);

t = 0:0.01:10;

figure
step(sys_cl,t)
grid on
title('State Response (Closed Loop)')
xlabel('Time (seconds)')
ylabel('Output')
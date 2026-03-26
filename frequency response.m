clear; clc; close all;

A = [0 1; -0.5 -1];
B = [0;1];
C = [1 0];
D = 0;

Q = diag([100 10]);
R = 1;

K = lqr(A,B,Q,R);

Acl = A - B*K;
sys_cl = ss(Acl,B,C,D);

figure
bode(sys_cl)
grid on
title('Bode Plot (Closed Loop LQR)')
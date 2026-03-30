clear; clc; close all;

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
     0   0.2 0];

C = eye(4);

T_ref = [300; 310; 280; 320];
x0 = [290; 305; 275; 315];
tspan = [0 50];

Q = diag([100 100 50 80]); %lqr controller
R = diag([1 1 1 1]);
K = lqr(A,B,Q,R);

W = 0.05*eye(4);  % kalman filters
V = 0.5*eye(4);
[L,~,~] = lqe(A,eye(4),C,W,V);

save('lqg_system.mat','A','B','D','C','K','L','T_ref','x0','tspan');
clear; clc; close all;

A = [0 1; -0.5 -1];
B = [0;1];

Q = diag([100 10]);
R = 1;

K = lqr(A,B,Q,R);

Acl = A - B*K;

t = 0:0.01:10;
x0 = [5; 0];

[y,t,x] = initial(ss(Acl,B,eye(2),0),x0,t);

figure
plot(t,x(:,1),'LineWidth',2)
hold on
plot(t,x(:,2),'LineWidth',2)
grid on
legend('x1','x2')
title('State Trajectories')
xlabel('Time (seconds)')
ylabel('States')
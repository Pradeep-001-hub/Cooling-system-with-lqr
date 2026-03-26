clear; clc; close all;

A = [0 1; -0.5 -1];
B = [0;1];
C = [1 0];
D = 0;

sys = ss(A,B,C,D);

Q = diag([100 10]);
R = 1;

K = lqr(A,B,Q,R);

Qn = 1*eye(2);
Rn = 1;

[kalmf,L,P] = kalman(sys,Qn,Rn);

Acl_lqg = [A-B*K  B*K;
           zeros(2) A-L*C];

Bcl = [B; zeros(2,1)];
Ccl = [C zeros(1,2)];

sys_lqg = ss(Acl_lqg,Bcl,Ccl,0);

s = tf('s');
G = 1/(s^2 + s + 0.5);

pid_c = pid(10,1,1);
sys_pid = feedback(pid_c*G,1);

t = 0:0.01:10;

[y_lqg,t1] = step(sys_lqg,t);
[y_pid,t2] = step(sys_pid,t);

figure
plot(t1,y_lqg,'LineWidth',2)
hold on
plot(t2,y_pid,'LineWidth',2)
grid on
legend('LQG','PID')
title('LQG vs PID Comparison')
xlabel('Time (seconds)')
ylabel('Response')
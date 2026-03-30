clear; clc; close all;

A = [0 1; -0.5 -1];
B = [0;1];
C = [1 0];
D = 0;

sys = ss(A,B,C,D);

t = 0:0.01:10;

%% PID Controller
Kp = 10;
Ki = 5;
Kd = 1;

pid_controller = pid(Kp,Ki,Kd);

sys_pid = feedback(pid_controller*sys,1);

[y_pid,t_pid] = step(sys_pid,t);

%% LQR Controller
Q = diag([100 10]);
R = 1;

K = lqr(A,B,Q,R);

Acl = A - B*K;
sys_lqr = ss(Acl,B,C,D);

[y_lqr,t_lqr] = step(sys_lqr,t);

%% Plot Comparison
figure
plot(t_pid,y_pid,'LineWidth',2)
hold on
plot(t_lqr,y_lqr,'LineWidth',2)
grid on
xlabel('Time (s)')
ylabel('Output')
title('PID vs LQR Comparison')
legend('PID Controller','LQR Controller')

%% Control Effort Comparison
u_pid = Kp*(1 - y_pid) + Ki*cumtrapz(t_pid,1 - y_pid) + Kd*[0 diff(1 - y_pid)./diff(t_pid)];
u_lqr = -K*(y_lqr');

figure
plot(t_pid,u_pid,'LineWidth',2)
hold on
plot(t_lqr,u_lqr','LineWidth',2)
grid on
xlabel('Time (s)')
ylabel('Control Effort')
title('Control Effort Comparison')
legend('PID','LQR')
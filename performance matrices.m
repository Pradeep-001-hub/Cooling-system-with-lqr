clear; clc; close all;

A = [0 1; -0.5 -1];
B = [0;1];
C = [1 0];
D = 0;

sys = ss(A,B,C,D);

t = 0:0.01:10;

%% PID
Kp = 10; Ki = 5; Kd = 1;
pid_c = pid(Kp,Ki,Kd);
sys_pid = feedback(pid_c*sys,1);
[y_pid,t] = step(sys_pid,t);

%% LQR
Q = diag([100 10]);
R = 1;
K = lqr(A,B,Q,R);
sys_lqr = ss(A-B*K,B,C,D);
[y_lqr,~] = step(sys_lqr,t);

%% Metrics
info_pid = stepinfo(y_pid,t);
info_lqr = stepinfo(y_lqr,t);

disp('PID Performance')
disp(info_pid)

disp('LQR Performance')
disp(info_lqr)

u_pid = Kp*(1 - y_pid) + Ki*cumtrapz(t,1 - y_pid);
u_lqr = -K*(y_lqr');

energy_pid = trapz(t,u_pid.^2);
energy_lqr = trapz(t,u_lqr.^2);

disp(['PID Energy: ',num2str(energy_pid)])
disp(['LQR Energy: ',num2str(energy_lqr)])
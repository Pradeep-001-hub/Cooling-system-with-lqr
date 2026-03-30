clear; clc; close all;

A = [-0.05  0.02  0     0;
      0.01 -0.06  0.03  0;
      0     0.02 -0.07  0.02;
      0     0     0.01 -0.05];

B = [0.1 0   0   0;
     0   0.1 0   0;
     0   0   0.1 0;
     0   0   0   0.1];

C = eye(4);

D = [0.5 0   0;
     0   0.4 0;
     0   0   0.3;
     0   0   0.2];

T_ref = [300;310;280;320];
x0 = [290;305;275;315];
tspan = [0 50];

Q = diag([100 100 50 80]);
R = diag([1 1 1 1]);
K = lqr(A,B,Q,R);

W = 0.05*eye(4);
V = 0.5*eye(4);
[L,~,~] = lqe(A,eye(4),C,W,V);

[t,x] = ode45(@(t,x) lqg_system(t,x,K,L,A,B,C,D,T_ref), tspan, x0);

u = zeros(length(t),4);
for i = 1:length(t)
    y = x(i,:)' + 0.5*randn(4,1);
    x_hat = x(i,:)' + L*(y - x(i,:)');
    u(i,:) = -K*(x_hat - T_ref)';
end

figure

subplot(3,1,1)
plot(t,x(:,1),'LineWidth',2)
hold on
plot(t,x(:,2),'LineWidth',2)
plot(t,x(:,3),'LineWidth',2)
plot(t,x(:,4),'LineWidth',2)
yline(T_ref(1),'--')
yline(T_ref(2),'--')
yline(T_ref(3),'--')
yline(T_ref(4),'--')
grid on
xlabel('Time (s)')
ylabel('Temperature (K)')
title('LQG Temperature Response')
legend('T1 Electronics','T2 Battery','T3 Radiator','T4 Engine','Reference')

subplot(3,1,2)
plot(t,(x(:,1)-T_ref(1)),'LineWidth',2)
hold on
plot(t,(x(:,2)-T_ref(2)),'LineWidth',2)
plot(t,(x(:,3)-T_ref(3)),'LineWidth',2)
plot(t,(x(:,4)-T_ref(4)),'LineWidth',2)
grid on
xlabel('Time (s)')
ylabel('Error (K)')
title('Tracking Error')
legend('Error T1','Error T2','Error T3','Error T4')

subplot(3,1,3)
plot(t,u(:,1),'LineWidth',2)
hold on
plot(t,u(:,2),'LineWidth',2)
plot(t,u(:,3),'LineWidth',2)
plot(t,u(:,4),'LineWidth',2)
grid on
xlabel('Time (s)')
ylabel('Control Input')
title('Control Effort')
legend('u1 Electronics','u2 Battery','u3 Radiator','u4 Engine')

sgtitle('LQG-Based Thermal Control System')